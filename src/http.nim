import std/asyncdispatch, std/asynchttpserver, std/strutils
import debby/sqlite
import jsony

type Error = object
  message: string

proc httpOkJson*[T](req: Request, value: T) {.async, gcsafe.} =
  let headers = {"Content-Type": "application/json"}.newHttpHeaders()
  await req.respond(Http200, value.toJson(), headers)

proc httpErrorJson*(req: Request, message: string) {.async, gcsafe.} =
  let headers = {"Content-Type": "application/json"}.newHttpHeaders()
  await req.respond(Http400, Error(message: message).toJson(), headers)

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
        # TODO: read query params from URL search params
        # list objects
        let result = db.filter(t)
        await req.httpOkJson(result)
      else:
        await req.httpErrorJson("Unsupported method '" & $req.reqMethod & "'")
    else:
      let obj = T()
      let id = typeof(obj.id)(req.url.path[1 ..^ 1].parseInt)
      case req.reqMethod
      of HttpGet:
        let result = db.get(t, id)
        await req.httpOkJson(result)
      of HttpPut:
        # FIXME: exception handling (should not crash on invalid input)
        # TODO: allow partial updates (most importantly, when missing `id`)
        var value = req.body.fromJson(T)
        if value.id.int != 0 and value.id != id:
          await req.httpErrorJson("Id mismatch")
          return
        value.id = id
        db.update(value)
        await req.httpOkJson(nil)
      else:
        await req.httpErrorJson("Unsupported method '" & $req.reqMethod & "'")
