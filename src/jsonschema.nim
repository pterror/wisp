import std/assertions, std/options, std/sequtils, std/tables
import jsonvalue, typeobj

# TODO: Support `enum`s

type
  JsonSchemaKind* = enum
    jskNull
    jskBoolean
    jskInteger
    jskNumber
    jskString
    jskArray
    jskObject
    jskEnum
    jskConst
    jskAnyOf
    jskAllOf
    jskOneOf
    jskNot

  JsonSchema* = object
    # FIXME: `type` conflicts with the (deprecated) operator's name - but this is difficult
    # to change without support for parse-side `renameHook` (which can be implemented!).
    case `type`*: JsonSchemaKind
    of jskInteger, jskNumber:
      multipleOf*: Option[float]
      minimum*: Option[float]
      exclusiveMinimum*: Option[float]
      maximum*: Option[float]
      exclusiveMaximum*: Option[float]
    of jskString:
      minLength*: Option[int]
      maxLength*: Option[int]
      pattern*: Option[string]
    of jskArray:
      items*: Option[ref JsonSchema]
      prefixItems*: Option[seq[JsonSchema]]
      unevaluatedItems*: Option[bool]
    of jskObject:
      properties*: Option[Table[string, JsonSchema]]
      patternProperties*: Option[Table[string, JsonSchema]]
      additionalProperties*: Option[JsonSchemaAdditionalProperties]
    of jskEnum:
      `enum`*: seq[JsonValue]
    of jskConst:
      `const`*: JsonValue
    of jskAnyOf:
      anyOf*: seq[JsonSchema]
    of jskAllOf:
      allOf*: seq[JsonSchema]
    of jskOneOf:
      oneOf*: seq[JsonSchema]
    of jskNot:
      `not`*: ref JsonSchema
    else:
      discard
  
  JsonSchemaAdditionalProperties = object
    properties: ref JsonSchema

func skipHook*[U: Option[auto]](T: typedesc[JsonSchema], v: U, key: string): bool =
  v.isNone

func skipHook*(T: typedesc[JsonSchema], v: JsonSchemaKind, key: string): bool =
  if key != "type":
    return false
  return v == jskAnyOf or v == jskAllOf or v == jskOneOf or v == jskNot

func `$`*(v: JsonSchemaKind): string =
  case v:
  of jskNull: "null"
  of jskBoolean: "boolean"
  of jskInteger: "integer"
  of jskNumber: "number"
  of jskString: "string"
  of jskArray: "array"
  of jskObject: "object"
  of jskEnum: "enum"
  of jskConst: "const"
  # These should never be serialized as the `type` field. See the second `skipHook` overload above.
  of jskAnyOf: "anyOf"
  of jskAllOf: "allOf"
  of jskOneOf: "oneOf"
  of jskNot: "not" 

func toJsonSchema*(typeobj: TypeObj): JsonSchema =
  case typeobj.kind:
  of tkInt, tkInt8, tkInt16, tkInt32, tkInt64, tkUint, tkUint8, tkUint16, tkUint32, tkUint64:
    JsonSchema(type: jskInteger)
  of tkFloat, tkFloat32, tkFloat64:
    JsonSchema(type: jskNumber)
  of tkString:
    JsonSchema(type: jskString)
  of tkDistinct, tkRef:
    typeobj.base[].toJsonSchema
  of tkTuple:
    let prefixItems = typeobj.items.map(
      proc (item: TypeObj): JsonSchema = item.toJsonSchema
    ).some
    JsonSchema(type: jskArray, prefixItems: prefixItems, unevaluatedItems: false.some)
  of tkObject:
    let properties = typeobj.fields.map(
      proc (field: TypeField): (string, JsonSchema) = (field.name, field.type.toJsonSchema)
    ).toTable.some
    JsonSchema(type: jskObject, properties: properties)
  of tkOptional:
    JsonSchema(type: jskAnyOf, anyOf: @[typeobj.inner[].toJsonSchema, JsonSchema(type: jskNull)])
  of tkSeq:
    let items = new JsonSchema
    items[] = typeobj.item[].toJsonSchema
    JsonSchema(type: jskArray, items: items.some)
  of tkTable:
    doAssert typeobj.key[].kind == tkString, "JSON Schema table keys can only be strings"
    let properties = new JsonSchema
    properties[] = typeobj.value[].toJsonSchema
    let additionalProperties = JsonSchemaAdditionalProperties(properties: properties).some
    JsonSchema(type: jskObject, additionalProperties: additionalProperties)
  else:
    # FIXME: error out instead?
    JsonSchema(type: jskNull)

import jsony

proc parseHook*(s: string, i: var int, v: var Option[JsonSchemaAdditionalProperties]) =
  let startI = i
  var maybeFalse = false
  s.parseHook(i, maybeFalse)
  if i != startI:
    v = JsonSchemaAdditionalProperties.none
  else:
    i = startI
    v = JsonSchemaAdditionalProperties.default.some
    s.parseHook(i, v.get)

proc dumpHook*(s: var string, v: Option[JsonSchemaAdditionalProperties]) =
  if v.isSome:
    s.dumpHook v.get
  else:
    s.dumpHook false
