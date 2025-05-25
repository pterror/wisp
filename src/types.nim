import std/json, std/macros

# define `type Foo* = distinct int` and associated `%` operator
macro idType*(name: untyped) =
  name.expectKind nnkIdent
  result = quote("@"):
    type `@ name`* = distinct int
    proc `%`*(n: `@ name`): JsonNode =
      %n.int
  if defined(DEBUG_MACROS):
    echo "idType macro:"
    echo result.repr

# define `type Foo* = distinct string` and associated `%` operator
macro stringType*(name: untyped) =
  name.expectKind nnkIdent
  result = quote("@"):
    type `@ name`* = distinct string
    proc `%`*(u: `@ name`): JsonNode =
      %u.string
  if defined(DEBUG_MACROS):
    echo "stringType macro:"
    echo result.repr

# define `type FooId* = distinct int` and inject as first field to `type Foo`
# supports declaring multiple types per `dbType` invocation.
#
# dbType:
#   type Foo* = ref object
#     foo*: string
#     bar*: int
#
# becomes
#
# type FooId* = distinct int
# type Foo* = ref object
#   id*: FooId
#   foo*: string
#   bar*: int
macro dbTypes*(typs: untyped) =
  var types: seq[NimNode] = @[]
  for section in typs:
    section.expectKind nnkTypeSection
    let typ = section[0]
    typ.expectKind nnkTypeDef
    let name =
      if typ[0].kind == nnkIdent:
        typ[0]
      else:
        typ[0].expectKind nnkPostfix
        typ[0][1]
    name.expectKind nnkIdent
    let refTy = typ[2]
    refTy.expectKind nnkRefTy
    let obj = refTy[0]
    obj.expectKind nnkObjectTy
    let id = ident(name.strVal & "Id")
    let typeSection = nnkTypeSection.newTree(
      nnkTypeDef.newTree(
        typ[0], # name
        typ[1], # generic params
        nnkRefTy.newTree(
          nnkObjectTy.newTree(
            obj[0], # pragmas
            obj[1], # inherits from
            nnkRecList.newTree( # fields
              newIdentDefs(nnkPostfix.newTree(ident("*"), ident("id")), id),
              obj[2], # other fields
            ),
          )
        ),
      )
    )
    let syn = quote:
      idType `id`
      `typeSection`
    types.add(syn)
  result = nnkStmtList.newTree(types)
  if defined(DEBUG_MACROS):
    echo "dbTypes macro:"
    echo result.repr
