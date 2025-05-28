import std/macros

# define `type Foo* = distinct int` and associated `%` operator
macro idType*(name) =
  name.expectKind nnkIdent
  result = quote("@"):
    type `@ name`* = distinct int
    proc `$`*(n: `@ name`): string =
      $`@ name` & "(" & $n.int & ")"
    proc `==`*(a, b: `@ name`): bool {.borrow.}

  if defined(debugMacros):
    echo "(idType macro)"
    echo result.repr

# define `type Foo* = distinct string` and associated `%` operator
macro stringType*(name) =
  name.expectKind nnkIdent
  result = quote("@"):
    type `@ name`* = distinct string
    proc `$`*(n: `@ name`): string =
      $`@ name` & "(" & $n.string & ")"
    proc `==`*(a, b: `@ name`): bool {.borrow.}

  if defined(debugMacros):
    echo "(stringType macro)"
    echo result.repr

# define `type FooId* = distinct int` and inject as first field to `type Foo`
# supports declaring multiple types per `dbType` invocation.
#
# dbTypes(Fizz):
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
# macro registerFizzTypes*(register) =
#   `register`(Foo)
macro dbTypes*(groupName, typs) =
  groupName.expectKind nnkIdent
  var stmts: seq[NimNode] = @[]
  var types: seq[NimNode] = @[]
  var registerStmts: seq[NimNode] = @[]
  for section in typs:
    section.expectKind nnkTypeSection
    for typ in section:
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
      let typeDef = nnkTypeDef.newTree(
        typ[0], # name
        typ[1], # generic params
        nnkRefTy.newTree(
          nnkObjectTy.newTree(
            obj[0], # pragmas
            obj[1], # inherits from
            nnkRecList.newTree( # fields
              newIdentDefs(postfix(ident("id"), "*"), id), obj[2] # other fields
            ),
          )
        ),
      )
      let idStmt = quote:
        idType `id`
      stmts.add(idStmt)
      types.add(typeDef)
      let registerStmt = quote("@"):
        `register`(`@ name`)
      registerStmts.add(registerStmt)
  stmts.add(nnkTypeSection.newTree(types))
  stmts.add(
    nnkMacroDef.newTree(
      postfix(ident("register" & groupName.strVal & "Types"), "*"),
      newEmptyNode(), # {}
      newEmptyNode(), # [] generic params
      nnkFormalParams.newTree( # () params
        newEmptyNode(),
        nnkIdentDefs.newTree(ident("register"), newEmptyNode(), newEmptyNode()),
      ),
      newEmptyNode(),
      newEmptyNode(),
      newCall(ident("quote"), nnkStmtList.newTree(registerStmts)),
    )
  )
  result = nnkStmtList.newTree(stmts)

  if defined(debugMacros):
    echo "(dbTypes macro)"
    echo result.repr
