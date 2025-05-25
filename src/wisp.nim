import std/asynchttpserver, std/asyncdispatch, std/json, std/strutils, std/tables
import debby/sqlite
import chat, http

proc main*() {.async.} =
  let db = openDatabase("chat.db")
  let server = newAsyncHttpServer()

  var serverHandlers =
    Table[string, proc(req: Request): Future[void] {.closure, gcsafe.}]()

  proc serverCb(req: Request) {.async, gcsafe.} =
    let parts = req.url.path.split('/')
    let handler = serverHandlers.getOrDefault(parts[0])
    if handler != nil:
      await handler(req)
    else:
      let headers = {"Content-Type": "application/json"}
      await req.respond(
        Http404,
        $(%*{"error": "Path '" & req.url.path & "' not found"}),
        headers.newHttpHeaders(),
      )

  proc register[T: ref object](t: typedesc[T]) =
    if not db.tableExists(t):
      db.createTable(t)
    serverHandlers[($type(t)).toSnakeCase()] = httpCrud(t, db)

  registerChatTypes(register)

  while true:
    if server.shouldAcceptRequest():
      await server.acceptRequest(serverCb)
    else:
      await sleepAsync(10)

if isMainModule:
  waitFor main()
