import std/asyncdispatch, std/asynchttpserver, std/strutils
import debby/sqlite
import jsony

type Error = object
  message: string

func clone*(req: Request): Request {.gcsafe.} =
  Request(
    client: req.client,
    reqMethod: req.reqMethod,
    headers: req.headers,
    protocol: req.protocol,
    url: req.url,
    hostname: req.hostname,
    body: req.body,
  )

proc httpOkJson*[T](req: Request, value: T) {.async, gcsafe.} =
  let headers = {"Content-Type": "application/json"}.newHttpHeaders
  await req.respond(Http200, value.toJson, headers)

proc httpErrorJson*(req: Request, message: string) {.async, gcsafe.} =
  let headers = {"Content-Type": "application/json"}.newHttpHeaders
  await req.respond(Http400, Error(message: message).toJson, headers)

proc httpCrud*[T: ref object](
    t: typedesc[T], db: Db
): proc(req: Request): Future[void] {.gcsafe.} =
  proc(req: Request) {.async, gcsafe.} =
    if req.url.path == "/":
      case req.reqMethod
      of HttpPost:
        # new object
        db.insert(req.body.fromJson(T))
        await req.httpOkJson(nil)
      of HttpGet:
        # list objects
        # TODO: read query params from URL search params
        let output = db.filter(t)
        await req.httpOkJson(output)
      else:
        await req.httpErrorJson("Unsupported method '" & $req.reqMethod & "'")
    else:
      let obj = T()
      let id = typeof(obj.id)(req.url.path[1 ..^ 1].parseInt)
      case req.reqMethod
      of HttpGet:
        # get object
        let output = db.get(t, id)
        await req.httpOkJson(output)
      of HttpPut:
        # update object
        var value = req.body.fromJson(T)
        if value.id.int != 0 and value.id != id:
          await req.httpErrorJson("Object id must be '" & $id & "'")
          return
        value.id = id
        db.update(value)
        await req.httpOkJson(nil)
      of HttpDelete:
        # delete object
        let affectedRows = db.delete(t, id)
        if affectedRows <= 0:
          await req.httpErrorJson("Object with id '" & $id & "' not found")
          return
        await req.httpOkJson(nil)
      else:
        await req.httpErrorJson("Unsupported method '" & $req.reqMethod & "'")
