import std/options, std/sequtils, std/strutils, std/tables, std/typetraits
import core, types

# TODO: Support `enum`s

type
  TypeKind* = enum
    tkVoid
    tkBool
    tkInt
    tkInt8
    tkInt16
    tkInt32
    tkInt64
    tkUint
    tkUint8
    tkUint16
    tkUint32
    tkUint64
    tkFloat
    tkFloat32
    tkFloat64
    tkString
    tkDistinct
    tkRef
    tkTuple
    tkObject
    tkOptional
    tkSeq
    tkArray
    tkTable

  TypeObj* = object
    case kind*: TypeKind
    of tkDistinct, tkRef:
      base*: ref TypeObj
    of tkTuple:
      items*: seq[TypeObj]
    of tkObject:
      fields*: seq[TypeField]
    of tkOptional:
      inner*: ref TypeObj
    of tkSeq:
      item*: ref TypeObj
    of tkArray:
      len*: int
      arrayItem*: ref TypeObj
    of tkTable:
      key*: ref TypeObj
      value*: ref TypeObj
    else:
      discard

  TypeField* = object
    name*: string
    `type`*: TypeObj

proc keyTypeOfTable[K, V](t: Table[K, V]): K =
  K.default

proc valueTypeOfTable[K, V](t: Table[K, V]): V =
  V.default

func escapeName(name: string): string =
  case name:
  of "type": "`" & name & "`"
  # TODO: also escape names containing symbols
  else: name

func `$`*(v: TypeObj): string =
  case v.kind:
  of tkVoid: "void"
  of tkBool: "bool"
  of tkInt: "int"
  of tkInt8: "int8"
  of tkInt16: "int16"
  of tkInt32: "int32"
  of tkInt64: "int64"
  of tkUint: "uint"
  of tkUint8: "uint8"
  of tkUint16: "uint16"
  of tkUint32: "uint32"
  of tkUint64: "uint64"
  of tkFloat: "float"
  of tkFloat32: "float32"
  of tkFloat64: "float64"
  of tkString: "string"
  of tkDistinct: "distinct " & $v.base[]
  of tkRef: "ref " & $v.base[]
  of tkTuple: "(" & v.items.map(`$`).join(", ") & ")"
  of tkObject:
    let body =
      if v.fields.len == 0:
        "discard"
      else:
        v.fields.map(proc (field: TypeField): string = field.name.escapeName & ": " & $field.type).join("\n\t")
    "object\n\t" & body
  of tkOptional: "Optional[" & $v.inner[] & "]"
  of tkSeq: "seq[" & $v.item[] & "]"
  of tkArray: "array[" & $v.len & ", " & $v.arrayItem[] & "]"
  of tkTable: "Table[" & $v.key[] & ", " & $v.value[] & "]"

func toTypeObj*[T](t: typedesc[T]): TypeObj =
  let value = T.default
  when value is bool:
    TypeObj(kind: tkBool)
  elif value is int:
    TypeObj(kind: tkInt)
  elif value is int8:
    TypeObj(kind: tkInt8)
  elif value is int16:
    TypeObj(kind: tkInt16)
  elif value is int32:
    TypeObj(kind: tkInt32)
  elif value is int64:
    TypeObj(kind: tkInt64)
  elif value is uint:
    TypeObj(kind: tkUint)
  elif value is uint8:
    TypeObj(kind: tkUint8)
  elif value is uint16:
    TypeObj(kind: tkUint16)
  elif value is uint32:
    TypeObj(kind: tkUint32)
  elif value is uint64:
    TypeObj(kind: tkUint64)
  elif value is float:
    TypeObj(kind: tkFloat)
  elif value is float32:
    TypeObj(kind: tkFloat32)
  elif value is float64:
    TypeObj(kind: tkFloat64)
  elif value is string:
    TypeObj(kind: tkString)
  elif value is Option:
    TypeObj(kind: tkOptional, inner: typeof(value.get).toTypeObj.toRef)
  elif value is seq:
    TypeObj(kind: tkSeq, item: typeof(value[0]).toTypeObj.toRef)
  elif value is Table:
    TypeObj(
      kind: tkTable,
      key: typeof(value.keyTypeOfTable).toTypeObj.toRef,
      value: typeof(value.valueTypeOfTable).toTypeObj.toRef
    )
  elif value is distinct:
    TypeObj(kind: tkDistinct, base: t.distinctBase(false).toTypeObj.toRef)
  elif value is ref:
    TypeObj(kind: tkRef, base: typeof(value[]).toTypeObj.toRef)
  elif value is tuple:
    var items: seq[TypeObj] = @[]
    for _, fieldValue in value.fieldPairs:
      items.add(typeof(fieldValue).toTypeObj)
    TypeObj(kind: tkTuple, items: items)
  elif value is array:
    TypeObj(kind: tkArray, len: value.len, arrayItem: typeof(value[0]).toTypeObj.toRef)
  elif value is object:
    var fields: seq[TypeField] = @[]
    for fieldName, fieldValue in value.fieldPairs:
      fields.add(TypeField(name: fieldName, type: typeof(fieldValue).toTypeObj))
    TypeObj(kind: tkObject, fields: fields)
  else:
    # FIXME: error out instead?
    TypeObj(kind: tkVoid)
