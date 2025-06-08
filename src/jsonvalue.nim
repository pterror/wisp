import std/tables

type
  JsonValueKind* = enum
    jvkNull
    jvkBoolean
    jvkNumber
    jvkString
    jvkArray
    jvkObject

  JsonValue* = object
    case kind*: JsonValueKind
    of jvkBoolean:
      boolean*: bool
    of jvkNumber:
      number*: float
    of jvkString:
      string*: string
    of jvkArray:
      array*: seq[JsonValue]
    of jvkObject:
      `object`*: Table[string, JsonValue]
    else:
      discard