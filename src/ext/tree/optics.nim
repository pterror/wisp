import std/macros
import std/jscore
import tree
import ../../js

type
  Lens*[T] = object
    get*: proc(): T {.closure.}
    set*: Setter[T]

func clear*[T](lens: Lens[T]) = lens.set(T.default)

func createLens*[T](): Lens[T] =
  let (get, set) = createSignal(T.default)
  Lens[T](get: get, set: set)

func createLens*[T](default: T): Lens[T] =
  let (get, set) = createSignal(default)
  Lens[T](get: get, set: set)

macro lensField*(obj: typed, prop): untyped =
  obj.expectKind nnkSym
  prop.expectKind nnkIdent
  let propName = prop.strVal
  var t: NimNode
  # get `set` field of lens, unwrap `Setter[T]`, iterate over fields
  for v in obj.getTypeImpl[2][1][1][1].getTypeImpl[2]:
    if v[0].strVal == propName:
      t = v[1]
      break
  quote do:
    Lens[`t`](
      get: proc(): `t` = `obj`.get().`prop`,
      set: Setter(
        proc(value: `t`) =
          var newObj = `obj`.get()
          newObj.`prop` = value
          `obj`.set(newObj)
      ),
    )

# TODO: transparent passthrough for input props
proc StringInput*(value: Lens[string]): Element =
  gui:
    input(`type` = "text", value = cstring(value.get())):
      proc change(event: Event) =
        let newValue = InputElement(event.currentTarget).value
        value.set(if newValue.isNil: "" else: $newValue)

proc StringInput*(value: Lens[cstring]): Element =
  gui:
    input(`type` = "text", value = value.get()):
      proc change(event: Event) =
        let newValue = InputElement(event.currentTarget).value
        value.set(if newValue.isNil: cstring("") else: newValue)

proc NumberInput*[T: float | float32 | float64 | int | int8 | int16 | int32 | int64 | uint | uint8 | uint16 | uint32 | uint64](value: Lens[T]): Element =
  gui:
    input(`type` = "number", value = $value.get()):
      proc change(event: Event) =
        value.set(T(InputElement(event.currentTarget).valueAsNumber))

proc DateInput*(value: Lens[DateTime]): Element =
  gui:
    input(`type` = "date", value = value.get().toString):
      proc change(event: Event) =
        value.set(InputElement(event.currentTarget).valueAsDate.newDate)