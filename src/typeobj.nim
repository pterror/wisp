import std/options, std/tables, std/typetraits

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

func typeobjof*[T](t: typedesc[T]): TypeObj =
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
    var inner = new TypeObj
    inner[] = typeobjof(typeof(value.get))
    TypeObj(kind: tkOptional, inner: inner)
  elif value is seq:
    var item = new TypeObj
    item[] = typeobjof(typeof(value[0]))
    TypeObj(kind: tkSeq, item: typeobjof(typeof(value[0])))
  elif value is Table:
    var key = new TypeObj
    key[] = typeobjof(typeof(value.keyTypeOfTable))
    var valueType = new TypeObj
    valueType[] = typeobjof(typeof(value.valueTypeOfTable))
    TypeObj(kind: tkTable, key: key, value: valueType)
  elif value is distinct:
    var baseType = new TypeObj
    baseType[] = typeobjof(t.distinctBase(false))
    TypeObj(kind: tkDistinct, base: baseType)
  elif value is ref:
    var baseType = new TypeObj
    baseType[] = typeobjof(typeof(value[]))
    TypeObj(kind: tkRef, base: baseType)
  elif value is tuple:
    var items = @[]
    for _, fieldValue in value.fieldPairs:
      items.add(typeobjof(typeof(fieldValue)))
    TypeObj(kind: tkTuple, items: items)
  elif value is object:
    var fields: seq[TypeField] = @[]
    for fieldName, fieldValue in value.fieldPairs:
      fields.add(TypeField(name: fieldName, type: typeobjof(typeof(fieldValue))))
    TypeObj(kind: tkObject, fields: fields)
  else:
    # FIXME: error out instead?
    TypeObj(kind: tkVoid)
