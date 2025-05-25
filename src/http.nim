import std/asyncdispatch, std/asynchttpserver, std/json, std/strutils
import debby/sqlite

proc httpCrud*[T: ref object](
    t: typedesc[T], db: Db
): proc(req: Request): Future[void] {.gcsafe.} =
  proc(req: Request) {.async, gcsafe.} =
    if req.url.path == "/":
      case req.reqMethod
      of HttpPost:
        # new object
        db.insert(parseJson(req.body).to(T))
        let headers = {"Content-Type": "application/json"}.newHttpHeaders()
        await req.respond(Http200, "null", headers)
      of HttpGet:
        # TODO: read query params from URL search params
        # list objects
        let result = db.filter(t)
        let headers = {"Content-Type": "application/json"}.newHttpHeaders()
        await req.respond(Http200, $(%*result), headers)
      else:
        let headers = {"Content-Type": "application/json"}.newHttpHeaders()
        await req.respond(
          Http400,
          $(%*{"error": "Unsupported method '" & $req.reqMethod & "'"}),
          headers,
        )
    else:
      let obj = T()
      let id = typeof(obj.id)(req.url.path[1 ..^ 1].parseInt)
      case req.reqMethod
      of HttpGet:
        let result = db.get(t, id)
        let headers = {"Content-Type": "application/json"}.newHttpHeaders()
        await req.respond(Http200, $(%*result), headers)
      of HttpPut:
        # FIXME: exception handling (should not crash on invalid input)
        # TODO: allow partial updates (most importantly, when missing `id`)
        var value = parseJson(req.body).to(T)
        if value.id.int != 0 and value.id != id:
          let headers = {"Content-Type": "application/json"}.newHttpHeaders()
          await req.respond(Http400, """{"error":"Id mismatch"}""", headers)
          return
        value.id = id
        db.update(value)
        let headers = {"Content-Type": "application/json"}.newHttpHeaders()
        await req.respond(Http200, "null", headers)
      else:
        let headers = {"Content-Type": "application/json"}.newHttpHeaders()
        await req.respond(
          Http400,
          $(%*{"error": "Unsupported method '" & $req.reqMethod & "'"}),
          headers,
        )
