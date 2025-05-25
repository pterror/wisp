import std/json, std/macros

macro idType*(name: untyped) =
  quote("@"):
    type `@ name`* = distinct int
    proc `%`*(n: `@ name`): JsonNode =
      %n.int

macro stringType*(name: untyped) =
  quote("@"):
    type `@ name`* = distinct string
    proc `%`*(u: `@ name`): JsonNode =
      %u.string
