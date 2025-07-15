import std/strutils, std/tables
import mummy
import ./core

type
  PathRouter* = object
    routes = Table[string, proc(req: Request): void {.closure, gcsafe.}]()

  MethodRouter* = object
    methods = Table[string, proc(req: Request): void {.closure, gcsafe.}]()

func newPathRouter*(): PathRouter =
  PathRouter()

func newPathRouter*(routes: Table[string, proc(req: Request): void {.closure, gcsafe.}]): PathRouter =
  PathRouter(routes: routes)

proc register*(router: var PathRouter, route: string, handler: proc(req: Request): void {.closure, gcsafe.}): void =
  router.routes[route] = handler

proc handler*(router: PathRouter): proc (req: Request): void {.gcsafe.} =
  proc (req: Request): void {.gcsafe.} =
    let parts = req.path.split('/')
    let handler = router.routes.getOrDefault(parts[1])
    if handler == nil:
      req.httpErrorJson("Path '" & req.path & "' not found")
      return
    req.path = "/" & parts[2 ..^ 1].join("/")
    handler(req)

func newMethodRouter*(): MethodRouter =
  MethodRouter()

func newMethodRouter*(methods: Table[string, proc(req: Request): void {.closure, gcsafe.}]): MethodRouter =
  MethodRouter(methods: methods)

proc register*(router: var MethodRouter, methodd: string, handler: proc(req: Request): void {.closure, gcsafe.}): void =
  router.methods[methodd] = handler

proc handler*(router: MethodRouter): proc (req: Request): void {.gcsafe.} =
  proc (req: Request): void {.gcsafe.} =
    let handler = router.methods.getOrDefault(req.httpMethod)
    if handler == nil:
      req.httpErrorJson("Method '" & req.httpMethod & "' not found")
      return
    handler(req)
