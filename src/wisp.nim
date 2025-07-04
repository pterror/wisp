import std/json, std/strutils, std/tables
import debby/sqlite
import jsony
import mummy
import services/chat, http, jsonschema, typeobj

proc main*() =
  let db = openDatabase("chat.db")

  var serverHandlers =
    Table[string, proc(req: Request): void {.closure, gcsafe.}]()

  proc register[T: ref object](t: typedesc[T]) =
    if not db.tableExists(t):
      db.createTable(t)
    db.checkTable(t)
    serverHandlers[($type(t)).toSnakeCase] = httpCrud(t, db)

  registerChatTypes(register)

  proc serverCb(req: Request) {.gcsafe.} =
    let parts = req.path.split('/')
    let handler = serverHandlers.getOrDefault(parts[1])
    if handler != nil:
      req.path = "/" & parts[2 ..^ 1].join("/")
      handler(req)
    else:
      req.httpErrorJson("Path '" & req.path & "' not found")

  let server = newServer(serverCb)
  server.serve(Port(8080))

if isMainModule:
  echo Table[string, int].toTypeObj.toJsonSchema.toJson
  # echo Table[string, int].toTypeObj.toJsonSchema.toJson.fromJson(JsonSchema).toTypeObj
  echo $Table[string, int].toTypeObj
  echo array[5, string].toTypeObj.toJsonSchema.toJson
  echo $array[5, string].toTypeObj
  echo $(string, float64, string, int, int32).toTypeObj
  echo $seq[string].toTypeObj
  main()
