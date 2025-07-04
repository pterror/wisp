import std/macros, std/strutils

# define `type Foo* = distinct int` and associated `%` operator
macro idType*(name) =
  name.expectKind nnkIdent
  result = quote("@"):
    type `@ name`* = distinct int
    func `$`*(n: `@ name`): string =
      $`@ name` & "(" & $n.int & ")"
    func `==`*(a, b: `@ name`): bool {.borrow.}

  if defined(debugMacros) or defined(debugMacro_idType):
    echo "(idType macro)"
    echo result.repr

# define `type Foo* = distinct string` and associated `%` operator
macro stringType*(name) =
  name.expectKind nnkIdent
  result = quote("@"):
    type `@ name`* = distinct string
    func `$`*(n: `@ name`): string =
      $`@ name` & "(" & $n.string & ")"
    func `==`*(a, b: `@ name`): bool {.borrow.}

  if defined(debugMacros) or defined(debugMacro_stringType):
    echo "(stringType macro)"
    echo result.repr

# define an enum and its
macro deriveEnumMethods*(enumType: typed) =
  let typ = enumType.getImpl
  typ.expectKind nnkTypeDef
  let name =
    if typ[0].kind == nnkIdent:
      typ[0]
    else:
      typ[0].expectKind nnkPostfix
      typ[0][1]
  let enumSym = typ[2]
  enumSym.expectKind nnkEnumTy

  # Detect the common lowercase prefix from the first enum value
  let firstEnum = $enumSym[1]
  var prefix = ""
  for c in firstEnum:
    if c.isLowerAscii:
      prefix.add(c)
    else:
      break

  if prefix.len == 0:
    error "Could not determine lowercase prefix"

  var x = ident("x")
  var toProcBody = newNimNode(nnkCaseStmt)
  toProcBody.add(x)
  var toStringBody = newNimNode(nnkCaseStmt)
  toStringBody.add(x)

  for identDef in enumSym[1 ..^ 1]:
    let fullName = $identDef
    var rawSuffix = fullName
    rawSuffix.removePrefix prefix
    if rawSuffix.len == fullName.len:
      error("Enum value doesn't have expected prefix: " & fullName)
    let suffix = rawSuffix[0].toLowerAscii & rawSuffix[1 ..^ 1]
    let litSuffix = newLit(suffix)
    toProcBody.add nnkOfBranch.newTree(
      litSuffix, nnkStmtList.newTree(ident(fullName))
    )
    toStringBody.add nnkOfBranch.newTree(ident(fullName), nnkStmtList.newTree(litSuffix))

  toProcBody.add nnkElse.newTree(enumSym[1])

  let toFuncName = ident("to" & $name)

  result = quote("@"):
    func `@ toFuncName`*(`@ x`: string): `@ name` =
      `@ toProcBody`

    func `$`*(`@ x`: `@ name`): string =
      `@ toStringBody`

    proc enumHook*(s: string, v: var `@ name`) =
      v = s.`@ toFuncName`

  if defined(debugMacros) or defined(debugMacro_deriveEnumMethods):
    echo "(deriveEnumMethods macro)"
    echo result.repr

# supports declaring multiple types per `enumTypes` invocation.
macro enumTypes*(types) =
  result = nnkStmtList.newTree
  result.add(types)

  for section in types:
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
      echo "whuh ", $name
      let enm = typ[2]
      enm.expectKind nnkEnumTy

      let deriveEnumMethodsNode = quote:
        deriveEnumMethods(`name`)
      result.add(deriveEnumMethodsNode)

  if defined(debugMacros) or defined(debugMacro_enumTypes):
    echo "(enumTypes macro)"
    echo result.repr

# define `type FooId* = distinct int` and inject as first field to `type Foo`
# supports declaring multiple types per `dbTypes` invocation.
#
# dbTypes(Fizz):
#   type Foo* = ref object
#     foo*: string
#     bar*: int
#
# becomes
#
# type FooId* = distinct int
# func `$`*(n: FooId): string =
#   $FooId & "(" & $n.int & ")"
# func `==`*(a, b: FooId): bool {.borrow.}
#
# type Foo* = ref object
#   id*: FooId
#   foo*: string
#   bar*: int
# macro registerFizzTypes*(register) =
#   `register`(Foo)
macro dbTypes*(groupName, typs) =
  groupName.expectKind nnkIdent
  result = nnkStmtList.newTree
  var sections = nnkTypeSection.newTree
  var registerStmts = nnkStmtList.newTree
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
      let refType = typ[2]
      refType.expectKind nnkRefTy
      let obj = refType[0]
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
      result.add idStmt
      sections.add typeDef
      let registerStmt = quote("@"):
        `register`(`@ name`)
      registerStmts.add registerStmt
  result.add sections
  result.add(
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
      newCall(ident("quote"), registerStmts),
    )
  )

  if defined(debugMacros) or defined(debugMacro_dbTypes):
    echo "(dbTypes macro)"
    echo result.repr
