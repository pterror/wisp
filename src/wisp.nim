import std/tables
import debby/sqlite
import mummy
import services/chat/types, http/crud, http/routers

proc runWisp*() =
  let db = openDatabase("chat.db")
  var router = newPathRouter()
  
  proc register[T: object | ref object](t: typedesc[T]) =
    if not db.tableExists(t):
      db.createTable(t)
    db.checkTable(t)
    router.register(($type(t)).toSnakeCase, httpCrud(t, db))
  registerChatTypes(register)

  newServer(router.handler).serve(Port(8080))

if isMainModule:
  runWisp()
