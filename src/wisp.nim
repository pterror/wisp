import std/asynchttpserver, std/asyncdispatch, std/json, std/strutils, std/tables
import debby/sqlite
import jsony
import services/chat, http, jsonschema, typeobj

proc main*() {.async.} =
  let db = openDatabase("chat.db")
  let server = newAsyncHttpServer()

  var serverHandlers =
    Table[string, proc(req: Request): Future[void] {.closure, gcsafe.}]()

  proc serverCb(req: Request) {.async, gcsafe.} =
    let parts = req.url.path.split('/')
    let handler = serverHandlers.getOrDefault(parts[1])
    if handler != nil:
      var newReq = req.clone()
      newReq.url.path = "/" & parts[2 ..^ 1].join("/")
      await handler(newReq)
    else:
      await req.httpErrorJson("Path '" & req.url.path & "' not found")

  proc register[T: ref object](t: typedesc[T]) =
    if not db.tableExists(t):
      db.createTable(t)
    db.checkTable(t)
    serverHandlers[($type(t)).toSnakeCase()] = httpCrud(t, db)

  registerChatTypes(register)

  server.listen(Port(8080))
  while true:
    if server.shouldAcceptRequest():
      await server.acceptRequest(serverCb)
    else:
      await sleepAsync(10)

if isMainModule:
  echo typeobjof(Server).base[].toJson
  echo typeobjof(Server).toJsonSchema.toJson
  waitFor main()
