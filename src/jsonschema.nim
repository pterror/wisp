import std/options, std/sequtils, std/tables
import jsonvalue, typeobj

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
      `not`: ref JsonSchema
    else:
      discard

proc skipHook*[U: Option[auto]](T: typedesc[JsonSchema], v: U, key: string): bool =
  v.isNone

proc skipHook*(T: typedesc[JsonSchema], v: JsonSchemaKind, key: string): bool =
  if key != "type":
    return false
  return v == jskAnyOf or v == jskAllOf or v == jskOneOf or v == jskNot

proc `$`*(v: JsonSchemaKind): string =
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
  of tkSeq:
    let items = new JsonSchema
    items[] = typeobj.item[].toJsonSchema
    JsonSchema(type: jskArray, items: items.some)
  of tkOptional:
    JsonSchema(type: jskAnyOf, anyOf: @[typeobj.inner[].toJsonSchema, JsonSchema(type: jskNull)])
  else:
    # FIXME: error out instead?
    JsonSchema(type: jskNull)