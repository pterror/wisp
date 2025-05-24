import debby/sqlite

import chat

proc main*() =
  let db = openDatabase("chat.db")

  proc register[T: ref object](t: typedesc[T]) =
    if not db.tableExists(t):
      db.createTable(t)

  registerChatTypes(register)

if isMainModule:
  main()
