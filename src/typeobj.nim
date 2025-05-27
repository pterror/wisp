import std/typetraits

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
    tkString
    tkDistinct
    tkRef
    tkTuple
    tkObject

  TypeObj* = object
    case kind*: TypeKind
    of tkDistinct, tkRef:
      base*: ref TypeObj
    of tkTuple:
      items*: seq[TypeObj]
    of tkObject:
      fields*: seq[TypeField]
    else:
      discard

  TypeField* = object
    name*: string
    typ*: TypeObj

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
  elif value is string:
    TypeObj(kind: tkString)
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
      fields.add(TypeField(name: fieldName, typ: typeobjof(typeof(fieldValue))))
    TypeObj(kind: tkObject, fields: fields)
  else:
    # FIXME: error out instead?
    TypeObj(kind: tkVoid)
