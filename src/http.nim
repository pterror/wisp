import std/strutils
import debby/sqlite
import jsony
import mummy

type Error = object
  message: string

proc httpOkJson*[T](req: Request, value: T) {.gcsafe.} =
  var headers: HttpHeaders
  headers["Content-Type"] = "application/json"
  req.respond(200, headers, value.toJson)

proc httpErrorJson*(req: Request, message: string) {.gcsafe.} =
  var headers: HttpHeaders
  headers["Content-Type"] = "application/json"
  req.respond(400, headers, Error(message: message).toJson)

proc httpCrud*[T: ref object](
    t: typedesc[T], db: Db
): proc(req: Request): void {.gcsafe.} =
  proc(req: Request) {.gcsafe.} =
    if req.path == "/":
      case req.httpMethod
      of "POST":
        # new object
        db.insert(req.body.fromJson(T))
        req.httpOkJson(nil)
      of "GET":
        # list objects
        # TODO: read query params from URL search params
        let output = db.filter(t)
        req.httpOkJson(output)
      else:
        req.httpErrorJson("Unsupported method '" & $req.httpMethod & "'")
    else:
      let obj = T()
      let id = typeof(obj.id)(req.path[1 ..^ 1].parseInt)
      case req.httpMethod
      of "GET":
        # get object
        let output = db.get(t, id)
        req.httpOkJson(output)
      of "PUT":
        # update object
        var value = req.body.fromJson(T)
        if value.id.int != 0 and value.id != id:
          req.httpErrorJson("Object id must be '" & $id & "'")
          return
        value.id = id
        db.update(value)
        req.httpOkJson(nil)
      of "DELETE":
        # delete object
        let affectedRows = db.delete(t, id)
        if affectedRows <= 0:
          req.httpErrorJson("Object with id '" & $id & "' not found")
          return
        req.httpOkJson(nil)
      else:
        req.httpErrorJson("Unsupported method '" & $req.httpMethod & "'")
