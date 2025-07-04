import std/assertions, std/options, std/sequtils, std/tables
import core, jsony, jsonvalue, typeobj, types

# TODO: Support `enum`s

enumTypes:
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

type
  JsonSchema* = object
    unevaluatedProperties*: Option[JsonSchemaOrFalse]
    unevaluatedItems*: Option[JsonSchemaOrFalse]
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
      items*: Option[JsonSchemaOrFalse]
      prefixItems*: Option[seq[JsonSchema]]
      contains*: Option[ref JsonSchema]
      minContains*: Option[int]
      maxContains*: Option[int]
      minItems*: Option[int]
      maxItems*: Option[int]
      uniqueItems*: Option[bool]
    of jskObject:
      properties*: Option[Table[string, JsonSchema]]
      patternProperties*: Option[Table[string, JsonSchema]]
      additionalProperties*: Option[JsonSchemaOrFalse]
      propertyNames*: Option[ref JsonSchema]
      required*: Option[seq[string]]
      minProperties*: Option[int]
      maxProperties*: Option[int]
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
  
  JsonSchemaOrFalse = object
    isFalse: bool
    schema: ref JsonSchema

func falseJsf*(): JsonSchemaOrFalse =
  JsonSchemaOrFalse(isFalse: true)

func newJsf*(schema: JsonSchema): JsonSchemaOrFalse =
  JsonSchemaOrFalse(schema: schema.toRef)

func skipHook*[U: Option[auto]](T: typedesc[JsonSchema], v: U, key: string): bool =
  v.isNone

func skipHook*(T: typedesc[JsonSchema], v: JsonSchemaKind, key: string): bool =
  if key != "type":
    return false
  return v == jskAnyOf or v == jskAllOf or v == jskOneOf or v == jskNot

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
    JsonSchema(type: jskArray, prefixItems: prefixItems, items: falseJsf().some)
  of tkObject:
    let properties = typeobj.fields.map(
      proc (field: TypeField): (string, JsonSchema) = (field.name, field.type.toJsonSchema)
    ).toTable.some
    let required = typeobj.fields.map(proc (field: TypeField): string = field.name).some
    JsonSchema(type: jskObject, properties: properties, additionalProperties: falseJsf().some, required: required)
  of tkOptional:
    JsonSchema(type: jskAnyOf, anyOf: @[typeobj.inner[].toJsonSchema, JsonSchema(type: jskNull)])
  of tkSeq:
    let items = newJsf(typeobj.item[].toJsonSchema).some
    JsonSchema(type: jskArray, items: items)
  of tkArray:
    let items = newJsf(typeobj.arrayItem[].toJsonSchema).some
    JsonSchema(type: jskArray, items: items, minItems: typeobj.len.some, maxItems: typeobj.len.some)
  of tkTable:
    doAssert typeobj.key[].kind == tkString, "JSON Schema table keys can only be strings"
    let additionalProperties = newJsf(typeobj.value[].toJsonSchema).some
    JsonSchema(type: jskObject, additionalProperties: additionalProperties)
  else:
    # FIXME: error out instead?
    JsonSchema(type: jskNull)

# TODO: finish
func toTypeObj*(jsonschema: JsonSchema): TypeObj =
  case jsonschema.type:
  of jskBoolean: TypeObj(kind: tkBool)
  of jskInteger: TypeObj(kind: tkInt)
  of jskNumber: TypeObj(kind: tkFloat)
  of jskString: TypeObj(kind: tkString)
  of jskArray: TypeObj(kind: tkArray)
  of jskObject: TypeObj(kind: tkObject)
  of jskAnyOf:
    if jsonschema.anyOf.len == 2 and jsonschema.anyOf[1].type == jskNull:
      TypeObj(kind: tkOptional)
    else:
      # FIXME: better error handling
      TypeObj(kind: tkVoid)
  of jskNull, jskEnum, jskConst, jskAllOf, jskOneOf, jskNot:
    # FIXME: implement
    TypeObj(kind: tkVoid)

proc parseHook*(s: string, i: var int, v: var JsonSchemaOrFalse) =
  let startI = i
  var maybeFalse = false
  s.parseHook(i, maybeFalse)
  if i != startI:
    v = falseJsf()
  else:
    i = startI
    v = newJsf(JsonSchema())
    s.parseHook(i, v.schema)

proc dumpHook*(s: var string, v: JsonSchemaOrFalse) =
  if v.isFalse:
    s.dumpHook false
  else:
    s.dumpHook v.schema
