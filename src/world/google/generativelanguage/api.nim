
import
  json, options, hashes, uri, strutils, rest

## auto-generated via openapi macro
## title: Generative Language API
## version: v1beta
## termsOfService: (not provided)
## license: (not provided)
## 
## The Gemini API allows developers to build generative AI applications using Gemini models. Gemini is our most capable model, built from the ground up to be multimodal. It can generalize and seamlessly understand, operate across, and combine different types of information including language, images, audio, video, and code. You can use the Gemini API for use cases like reasoning across text and images, content generation, dialogue agents, summarization and classification systems, and more.
## 
## Find more info here.
## https://developers.generativeai.google/api
type
  Scheme* {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (path: JsonNode = nil; query: JsonNode = nil;
                             header: JsonNode = nil; formData: JsonNode = nil;
                             body: JsonNode = nil; content: string = ""): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    makeUrl*: proc (protocol: Scheme; host: string; base: string; route: string;
                    path: JsonNode; query: JsonNode): Uri
  OpenApiRestCall_822083972 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_822083972](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base,
             route: t.route, schemes: t.schemes, validator: t.validator,
             url: t.url)

proc pickScheme(t: OpenApiRestCall_822083972): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low .. Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                       default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js == nil:
    if required:
      if default != nil:
        return validateParameter(default, kind, required = required)
  result = js
  if result == nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind == kind, $kind & " expected; received " & $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string {.used.} =
  proc toString(js: JsonNode): string =
    case js.kind
    of JNull:
      ""
    of JInt:
      $(getInt js)
    of JFloat:
      $(getFloat js)
    of JBool:
      $(getBool js)
    else:
      getStr js

  if query.isNil:
    return ""
  var qs: seq[KeyVal]
  for k, v in query.pairs:
    if not v.isNil and v.kind == JArray:
      if v.len == 0:
        qs.add (key: k, val: "")
      else:
        for v in v.items:
          qs.add (key: k, val: v.toString)
    else:
      qs.add (key: k, val: v.toString)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.
    used.} =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

type
  Call_ListOperationsBy_822084160 = ref object of OpenApiRestCall_822083972
proc url_ListOperationsBy_822084162(protocol: Scheme; host: string;
                                    base: string; route: string; path: JsonNode;
                                    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_ListOperationsBy_822084161(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   filter: JString
  ##         : The standard list filter.
  ##   pageSize: JInt
  ##           : The standard list page size.
  ##   pageToken: JString
  ##            : The standard list page token.
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822084253 = query.getOrDefault("$alt")
  valid_822084253 = validateParameter(valid_822084253, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084253 != nil:
    section.add "$alt", valid_822084253
  var valid_822084254 = query.getOrDefault("$.xgafv")
  valid_822084254 = validateParameter(valid_822084254, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084254 != nil:
    section.add "$.xgafv", valid_822084254
  var valid_822084255 = query.getOrDefault("$callback")
  valid_822084255 = validateParameter(valid_822084255, JString,
                                      required = false, default = nil)
  if valid_822084255 != nil:
    section.add "$callback", valid_822084255
  var valid_822084256 = query.getOrDefault("filter")
  valid_822084256 = validateParameter(valid_822084256, JString,
                                      required = false, default = nil)
  if valid_822084256 != nil:
    section.add "filter", valid_822084256
  var valid_822084257 = query.getOrDefault("pageSize")
  valid_822084257 = validateParameter(valid_822084257, JInt, required = false,
                                      default = nil)
  if valid_822084257 != nil:
    section.add "pageSize", valid_822084257
  var valid_822084258 = query.getOrDefault("pageToken")
  valid_822084258 = validateParameter(valid_822084258, JString,
                                      required = false, default = nil)
  if valid_822084258 != nil:
    section.add "pageToken", valid_822084258
  var valid_822084259 = query.getOrDefault("$prettyPrint")
  valid_822084259 = validateParameter(valid_822084259, JBool, required = false,
                                      default = nil)
  if valid_822084259 != nil:
    section.add "$prettyPrint", valid_822084259
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084271: Call_ListOperationsBy_822084160;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ## 
  let valid = call_822084271.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084271.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084271.makeUrl(scheme.get, call_822084271.host, call_822084271.base,
                                   call_822084271.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084271, uri, valid, content)

proc call*(call_822084320: Call_ListOperationsBy_822084160;
           Alt: string = "json"; Xgafv: string = "1"; Callback: string = "";
           filter: string = ""; pageSize: int = 0; pageToken: string = "";
           PrettyPrint: bool = false): Recallable =
  ## listOperationsBy
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ##   Alt: string
  ##      : Data format for response.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   filter: string
  ##         : The standard list filter.
  ##   pageSize: int
  ##           : The standard list page size.
  ##   pageToken: string
  ##            : The standard list page token.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_822084321 = newJObject()
  add(query_822084321, "$alt", newJString(Alt))
  add(query_822084321, "$.xgafv", newJString(Xgafv))
  add(query_822084321, "$callback", newJString(Callback))
  add(query_822084321, "filter", newJString(filter))
  add(query_822084321, "pageSize", newJInt(pageSize))
  add(query_822084321, "pageToken", newJString(pageToken))
  add(query_822084321, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084320.call(nil, query_822084321, nil, nil, nil)

var listOperationsBy* = Call_ListOperationsBy_822084160(
    name: "listOperationsBy", meth: HttpMethod.HttpGet,
    host: "generativelanguage.googleapis.com", route: "/v1beta/batches",
    validator: validate_ListOperationsBy_822084161, base: "/",
    makeUrl: url_ListOperationsBy_822084162, schemes: {Scheme.Https})
type
  Call_DeleteOperation_822084371 = ref object of OpenApiRestCall_822083972
proc url_DeleteOperation_822084373(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode;
                                   query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "generateContentBatch" in path,
         "`generateContentBatch` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/batches/"),
                 (kind: VariableSegment, value: "generateContentBatch")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DeleteOperation_822084372(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   generateContentBatch: JString (required)
  ##                       : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `generateContentBatch` field"
  var valid_822084374 = path.getOrDefault("generateContentBatch")
  valid_822084374 = validateParameter(valid_822084374, JString, required = true,
                                      default = nil)
  if valid_822084374 != nil:
    section.add "generateContentBatch", valid_822084374
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822084375 = query.getOrDefault("$alt")
  valid_822084375 = validateParameter(valid_822084375, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084375 != nil:
    section.add "$alt", valid_822084375
  var valid_822084376 = query.getOrDefault("$.xgafv")
  valid_822084376 = validateParameter(valid_822084376, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084376 != nil:
    section.add "$.xgafv", valid_822084376
  var valid_822084377 = query.getOrDefault("$callback")
  valid_822084377 = validateParameter(valid_822084377, JString,
                                      required = false, default = nil)
  if valid_822084377 != nil:
    section.add "$callback", valid_822084377
  var valid_822084378 = query.getOrDefault("$prettyPrint")
  valid_822084378 = validateParameter(valid_822084378, JBool, required = false,
                                      default = nil)
  if valid_822084378 != nil:
    section.add "$prettyPrint", valid_822084378
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084379: Call_DeleteOperation_822084371; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ## 
  let valid = call_822084379.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084379.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084379.makeUrl(scheme.get, call_822084379.host, call_822084379.base,
                                   call_822084379.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084379, uri, valid, content)

proc call*(call_822084380: Call_DeleteOperation_822084371;
           generateContentBatch: string; Alt: string = "json";
           Xgafv: string = "1"; Callback: string = ""; PrettyPrint: bool = false): Recallable =
  ## deleteOperation
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ##   generateContentBatch: string (required)
  ##                       : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   Alt: string
  ##      : Data format for response.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822084381 = newJObject()
  var query_822084382 = newJObject()
  add(path_822084381, "generateContentBatch", newJString(generateContentBatch))
  add(query_822084382, "$alt", newJString(Alt))
  add(query_822084382, "$.xgafv", newJString(Xgafv))
  add(query_822084382, "$callback", newJString(Callback))
  add(query_822084382, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084380.call(path_822084381, query_822084382, nil, nil, nil)

var deleteOperation* = Call_DeleteOperation_822084371(name: "deleteOperation",
    meth: HttpMethod.HttpDelete, host: "generativelanguage.googleapis.com",
    route: "/v1beta/batches/{generateContentBatch}",
    validator: validate_DeleteOperation_822084372, base: "/",
    makeUrl: url_DeleteOperation_822084373, schemes: {Scheme.Https})
type
  Call_GetOperationByGenerateContentBatch_822084348 = ref object of OpenApiRestCall_822083972
proc url_GetOperationByGenerateContentBatch_822084350(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "generateContentBatch" in path,
         "`generateContentBatch` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/batches/"),
                 (kind: VariableSegment, value: "generateContentBatch")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GetOperationByGenerateContentBatch_822084349(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode;
    content: string = ""): JsonNode {.nosinks.} =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   generateContentBatch: JString (required)
  ##                       : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `generateContentBatch` field"
  var valid_822084362 = path.getOrDefault("generateContentBatch")
  valid_822084362 = validateParameter(valid_822084362, JString, required = true,
                                      default = nil)
  if valid_822084362 != nil:
    section.add "generateContentBatch", valid_822084362
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822084363 = query.getOrDefault("$alt")
  valid_822084363 = validateParameter(valid_822084363, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084363 != nil:
    section.add "$alt", valid_822084363
  var valid_822084364 = query.getOrDefault("$.xgafv")
  valid_822084364 = validateParameter(valid_822084364, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084364 != nil:
    section.add "$.xgafv", valid_822084364
  var valid_822084365 = query.getOrDefault("$callback")
  valid_822084365 = validateParameter(valid_822084365, JString,
                                      required = false, default = nil)
  if valid_822084365 != nil:
    section.add "$callback", valid_822084365
  var valid_822084366 = query.getOrDefault("$prettyPrint")
  valid_822084366 = validateParameter(valid_822084366, JBool, required = false,
                                      default = nil)
  if valid_822084366 != nil:
    section.add "$prettyPrint", valid_822084366
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084367: Call_GetOperationByGenerateContentBatch_822084348;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_822084367.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084367.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084367.makeUrl(scheme.get, call_822084367.host, call_822084367.base,
                                   call_822084367.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084367, uri, valid, content)

proc call*(call_822084368: Call_GetOperationByGenerateContentBatch_822084348;
           generateContentBatch: string; Alt: string = "json";
           Xgafv: string = "1"; Callback: string = ""; PrettyPrint: bool = false): Recallable =
  ## getOperationByGenerateContentBatch
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ##   generateContentBatch: string (required)
  ##                       : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   Alt: string
  ##      : Data format for response.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822084369 = newJObject()
  var query_822084370 = newJObject()
  add(path_822084369, "generateContentBatch", newJString(generateContentBatch))
  add(query_822084370, "$alt", newJString(Alt))
  add(query_822084370, "$.xgafv", newJString(Xgafv))
  add(query_822084370, "$callback", newJString(Callback))
  add(query_822084370, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084368.call(path_822084369, query_822084370, nil, nil, nil)

var getOperationByGenerateContentBatch* = Call_GetOperationByGenerateContentBatch_822084348(
    name: "getOperationByGenerateContentBatch", meth: HttpMethod.HttpGet,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/batches/{generateContentBatch}",
    validator: validate_GetOperationByGenerateContentBatch_822084349, base: "/",
    makeUrl: url_GetOperationByGenerateContentBatch_822084350,
    schemes: {Scheme.Https})
type
  Call_CancelOperation_822084383 = ref object of OpenApiRestCall_822083972
proc url_CancelOperation_822084385(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode;
                                   query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "generateContentBatch" in path,
         "`generateContentBatch` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/batches/"),
                 (kind: VariableSegment, value: "generateContentBatch"),
                 (kind: ConstantSegment, value: ":cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CancelOperation_822084384(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Starts asynchronous cancellation on a long-running operation.  The server
  ## makes a best effort to cancel the operation, but success is not
  ## guaranteed.  If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.  Clients can use
  ## Operations.GetOperation or
  ## other methods to check whether the cancellation succeeded or whether the
  ## operation completed despite cancellation. On successful cancellation,
  ## the operation is not deleted; instead, it becomes an operation with
  ## an Operation.error value with a google.rpc.Status.code of `1`,
  ## corresponding to `Code.CANCELLED`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   generateContentBatch: JString (required)
  ##                       : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `generateContentBatch` field"
  var valid_822084386 = path.getOrDefault("generateContentBatch")
  valid_822084386 = validateParameter(valid_822084386, JString, required = true,
                                      default = nil)
  if valid_822084386 != nil:
    section.add "generateContentBatch", valid_822084386
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822084387 = query.getOrDefault("$alt")
  valid_822084387 = validateParameter(valid_822084387, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084387 != nil:
    section.add "$alt", valid_822084387
  var valid_822084388 = query.getOrDefault("$.xgafv")
  valid_822084388 = validateParameter(valid_822084388, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084388 != nil:
    section.add "$.xgafv", valid_822084388
  var valid_822084389 = query.getOrDefault("$callback")
  valid_822084389 = validateParameter(valid_822084389, JString,
                                      required = false, default = nil)
  if valid_822084389 != nil:
    section.add "$callback", valid_822084389
  var valid_822084390 = query.getOrDefault("$prettyPrint")
  valid_822084390 = validateParameter(valid_822084390, JBool, required = false,
                                      default = nil)
  if valid_822084390 != nil:
    section.add "$prettyPrint", valid_822084390
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084391: Call_CancelOperation_822084383; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Starts asynchronous cancellation on a long-running operation.  The server
  ## makes a best effort to cancel the operation, but success is not
  ## guaranteed.  If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.  Clients can use
  ## Operations.GetOperation or
  ## other methods to check whether the cancellation succeeded or whether the
  ## operation completed despite cancellation. On successful cancellation,
  ## the operation is not deleted; instead, it becomes an operation with
  ## an Operation.error value with a google.rpc.Status.code of `1`,
  ## corresponding to `Code.CANCELLED`.
  ## 
  let valid = call_822084391.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084391.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084391.makeUrl(scheme.get, call_822084391.host, call_822084391.base,
                                   call_822084391.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084391, uri, valid, content)

proc call*(call_822084392: Call_CancelOperation_822084383;
           generateContentBatch: string; Alt: string = "json";
           Xgafv: string = "1"; Callback: string = ""; PrettyPrint: bool = false): Recallable =
  ## cancelOperation
  ## Starts asynchronous cancellation on a long-running operation.  The server
  ## makes a best effort to cancel the operation, but success is not
  ## guaranteed.  If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.  Clients can use
  ## Operations.GetOperation or
  ## other methods to check whether the cancellation succeeded or whether the
  ## operation completed despite cancellation. On successful cancellation,
  ## the operation is not deleted; instead, it becomes an operation with
  ## an Operation.error value with a google.rpc.Status.code of `1`,
  ## corresponding to `Code.CANCELLED`.
  ##   generateContentBatch: string (required)
  ##                       : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   Alt: string
  ##      : Data format for response.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822084393 = newJObject()
  var query_822084394 = newJObject()
  add(path_822084393, "generateContentBatch", newJString(generateContentBatch))
  add(query_822084394, "$alt", newJString(Alt))
  add(query_822084394, "$.xgafv", newJString(Xgafv))
  add(query_822084394, "$callback", newJString(Callback))
  add(query_822084394, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084392.call(path_822084393, query_822084394, nil, nil, nil)

var cancelOperation* = Call_CancelOperation_822084383(name: "cancelOperation",
    meth: HttpMethod.HttpPost, host: "generativelanguage.googleapis.com",
    route: "/v1beta/batches/{generateContentBatch}:cancel",
    validator: validate_CancelOperation_822084384, base: "/",
    makeUrl: url_CancelOperation_822084385, schemes: {Scheme.Https})
type
  Call_CreateCachedContent_822084407 = ref object of OpenApiRestCall_822083972
proc url_CreateCachedContent_822084409(protocol: Scheme; host: string;
                                       base: string; route: string;
                                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CreateCachedContent_822084408(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Creates CachedContent resource.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822084420 = query.getOrDefault("$alt")
  valid_822084420 = validateParameter(valid_822084420, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084420 != nil:
    section.add "$alt", valid_822084420
  var valid_822084421 = query.getOrDefault("$.xgafv")
  valid_822084421 = validateParameter(valid_822084421, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084421 != nil:
    section.add "$.xgafv", valid_822084421
  var valid_822084422 = query.getOrDefault("$callback")
  valid_822084422 = validateParameter(valid_822084422, JString,
                                      required = false, default = nil)
  if valid_822084422 != nil:
    section.add "$callback", valid_822084422
  var valid_822084423 = query.getOrDefault("$prettyPrint")
  valid_822084423 = validateParameter(valid_822084423, JBool, required = false,
                                      default = nil)
  if valid_822084423 != nil:
    section.add "$prettyPrint", valid_822084423
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  ##       : Required. The cached content to create.
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822084425: Call_CreateCachedContent_822084407;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Creates CachedContent resource.
  ## 
  let valid = call_822084425.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084425.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084425.makeUrl(scheme.get, call_822084425.host, call_822084425.base,
                                   call_822084425.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084425, uri, valid, content)

proc call*(call_822084426: Call_CreateCachedContent_822084407;
           Alt: string = "json"; body: JsonNode = nil; Xgafv: string = "1";
           Callback: string = ""; PrettyPrint: bool = false): Recallable =
  ## createCachedContent
  ## Creates CachedContent resource.
  ##   Alt: string
  ##      : Data format for response.
  ##   body: JObject
  ##       : Required. The cached content to create.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_822084427 = newJObject()
  var body_822084428 = newJObject()
  add(query_822084427, "$alt", newJString(Alt))
  if body != nil:
    body_822084428 = body
  add(query_822084427, "$.xgafv", newJString(Xgafv))
  add(query_822084427, "$callback", newJString(Callback))
  add(query_822084427, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084426.call(nil, query_822084427, nil, nil, body_822084428)

var createCachedContent* = Call_CreateCachedContent_822084407(
    name: "createCachedContent", meth: HttpMethod.HttpPost,
    host: "generativelanguage.googleapis.com", route: "/v1beta/cachedContents",
    validator: validate_CreateCachedContent_822084408, base: "/",
    makeUrl: url_CreateCachedContent_822084409, schemes: {Scheme.Https})
type
  Call_ListCachedContents_822084395 = ref object of OpenApiRestCall_822083972
proc url_ListCachedContents_822084397(protocol: Scheme; host: string;
                                      base: string; route: string;
                                      path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_ListCachedContents_822084396(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Lists CachedContents.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   pageSize: JInt
  ##           : Optional. The maximum number of cached contents to return. The service may return
  ## fewer than this value.
  ## If unspecified, some default (under maximum) number of items will be
  ## returned.
  ## The maximum value is 1000; values above 1000 will be coerced to 1000.
  ##   pageToken: JString
  ##            : Optional. A page token, received from a previous `ListCachedContents` call.
  ## Provide this to retrieve the subsequent page.
  ## 
  ## When paginating, all other parameters provided to `ListCachedContents` must
  ## match the call that provided the page token.
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822084398 = query.getOrDefault("$alt")
  valid_822084398 = validateParameter(valid_822084398, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084398 != nil:
    section.add "$alt", valid_822084398
  var valid_822084399 = query.getOrDefault("$.xgafv")
  valid_822084399 = validateParameter(valid_822084399, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084399 != nil:
    section.add "$.xgafv", valid_822084399
  var valid_822084400 = query.getOrDefault("$callback")
  valid_822084400 = validateParameter(valid_822084400, JString,
                                      required = false, default = nil)
  if valid_822084400 != nil:
    section.add "$callback", valid_822084400
  var valid_822084401 = query.getOrDefault("pageSize")
  valid_822084401 = validateParameter(valid_822084401, JInt, required = false,
                                      default = nil)
  if valid_822084401 != nil:
    section.add "pageSize", valid_822084401
  var valid_822084402 = query.getOrDefault("pageToken")
  valid_822084402 = validateParameter(valid_822084402, JString,
                                      required = false, default = nil)
  if valid_822084402 != nil:
    section.add "pageToken", valid_822084402
  var valid_822084403 = query.getOrDefault("$prettyPrint")
  valid_822084403 = validateParameter(valid_822084403, JBool, required = false,
                                      default = nil)
  if valid_822084403 != nil:
    section.add "$prettyPrint", valid_822084403
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084404: Call_ListCachedContents_822084395;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Lists CachedContents.
  ## 
  let valid = call_822084404.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084404.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084404.makeUrl(scheme.get, call_822084404.host, call_822084404.base,
                                   call_822084404.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084404, uri, valid, content)

proc call*(call_822084405: Call_ListCachedContents_822084395;
           Alt: string = "json"; Xgafv: string = "1"; Callback: string = "";
           pageSize: int = 0; pageToken: string = ""; PrettyPrint: bool = false): Recallable =
  ## listCachedContents
  ## Lists CachedContents.
  ##   Alt: string
  ##      : Data format for response.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   pageSize: int
  ##           : Optional. The maximum number of cached contents to return. The service may return
  ## fewer than this value.
  ## If unspecified, some default (under maximum) number of items will be
  ## returned.
  ## The maximum value is 1000; values above 1000 will be coerced to 1000.
  ##   pageToken: string
  ##            : Optional. A page token, received from a previous `ListCachedContents` call.
  ## Provide this to retrieve the subsequent page.
  ## 
  ## When paginating, all other parameters provided to `ListCachedContents` must
  ## match the call that provided the page token.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_822084406 = newJObject()
  add(query_822084406, "$alt", newJString(Alt))
  add(query_822084406, "$.xgafv", newJString(Xgafv))
  add(query_822084406, "$callback", newJString(Callback))
  add(query_822084406, "pageSize", newJInt(pageSize))
  add(query_822084406, "pageToken", newJString(pageToken))
  add(query_822084406, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084405.call(nil, query_822084406, nil, nil, nil)

var listCachedContents* = Call_ListCachedContents_822084395(
    name: "listCachedContents", meth: HttpMethod.HttpGet,
    host: "generativelanguage.googleapis.com", route: "/v1beta/cachedContents",
    validator: validate_ListCachedContents_822084396, base: "/",
    makeUrl: url_ListCachedContents_822084397, schemes: {Scheme.Https})
type
  Call_DeleteCachedContent_822084441 = ref object of OpenApiRestCall_822083972
proc url_DeleteCachedContent_822084443(protocol: Scheme; host: string;
                                       base: string; route: string;
                                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/cachedContents/"),
                 (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DeleteCachedContent_822084442(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Deletes CachedContent resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_822084444 = path.getOrDefault("id")
  valid_822084444 = validateParameter(valid_822084444, JString, required = true,
                                      default = nil)
  if valid_822084444 != nil:
    section.add "id", valid_822084444
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822084445 = query.getOrDefault("$alt")
  valid_822084445 = validateParameter(valid_822084445, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084445 != nil:
    section.add "$alt", valid_822084445
  var valid_822084446 = query.getOrDefault("$.xgafv")
  valid_822084446 = validateParameter(valid_822084446, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084446 != nil:
    section.add "$.xgafv", valid_822084446
  var valid_822084447 = query.getOrDefault("$callback")
  valid_822084447 = validateParameter(valid_822084447, JString,
                                      required = false, default = nil)
  if valid_822084447 != nil:
    section.add "$callback", valid_822084447
  var valid_822084448 = query.getOrDefault("$prettyPrint")
  valid_822084448 = validateParameter(valid_822084448, JBool, required = false,
                                      default = nil)
  if valid_822084448 != nil:
    section.add "$prettyPrint", valid_822084448
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084449: Call_DeleteCachedContent_822084441;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Deletes CachedContent resource.
  ## 
  let valid = call_822084449.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084449.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084449.makeUrl(scheme.get, call_822084449.host, call_822084449.base,
                                   call_822084449.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084449, uri, valid, content)

proc call*(call_822084450: Call_DeleteCachedContent_822084441; id: string;
           Alt: string = "json"; Xgafv: string = "1"; Callback: string = "";
           PrettyPrint: bool = false): Recallable =
  ## deleteCachedContent
  ## Deletes CachedContent resource.
  ##   Alt: string
  ##      : Data format for response.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   id: string (required)
  ##     : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822084451 = newJObject()
  var query_822084452 = newJObject()
  add(query_822084452, "$alt", newJString(Alt))
  add(query_822084452, "$.xgafv", newJString(Xgafv))
  add(query_822084452, "$callback", newJString(Callback))
  add(path_822084451, "id", newJString(id))
  add(query_822084452, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084450.call(path_822084451, query_822084452, nil, nil, nil)

var deleteCachedContent* = Call_DeleteCachedContent_822084441(
    name: "deleteCachedContent", meth: HttpMethod.HttpDelete,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/cachedContents/{id}",
    validator: validate_DeleteCachedContent_822084442, base: "/",
    makeUrl: url_DeleteCachedContent_822084443, schemes: {Scheme.Https})
type
  Call_GetCachedContent_822084429 = ref object of OpenApiRestCall_822083972
proc url_GetCachedContent_822084431(protocol: Scheme; host: string;
                                    base: string; route: string; path: JsonNode;
                                    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/cachedContents/"),
                 (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GetCachedContent_822084430(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Reads CachedContent resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_822084432 = path.getOrDefault("id")
  valid_822084432 = validateParameter(valid_822084432, JString, required = true,
                                      default = nil)
  if valid_822084432 != nil:
    section.add "id", valid_822084432
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822084433 = query.getOrDefault("$alt")
  valid_822084433 = validateParameter(valid_822084433, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084433 != nil:
    section.add "$alt", valid_822084433
  var valid_822084434 = query.getOrDefault("$.xgafv")
  valid_822084434 = validateParameter(valid_822084434, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084434 != nil:
    section.add "$.xgafv", valid_822084434
  var valid_822084435 = query.getOrDefault("$callback")
  valid_822084435 = validateParameter(valid_822084435, JString,
                                      required = false, default = nil)
  if valid_822084435 != nil:
    section.add "$callback", valid_822084435
  var valid_822084436 = query.getOrDefault("$prettyPrint")
  valid_822084436 = validateParameter(valid_822084436, JBool, required = false,
                                      default = nil)
  if valid_822084436 != nil:
    section.add "$prettyPrint", valid_822084436
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084437: Call_GetCachedContent_822084429;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Reads CachedContent resource.
  ## 
  let valid = call_822084437.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084437.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084437.makeUrl(scheme.get, call_822084437.host, call_822084437.base,
                                   call_822084437.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084437, uri, valid, content)

proc call*(call_822084438: Call_GetCachedContent_822084429; id: string;
           Alt: string = "json"; Xgafv: string = "1"; Callback: string = "";
           PrettyPrint: bool = false): Recallable =
  ## getCachedContent
  ## Reads CachedContent resource.
  ##   Alt: string
  ##      : Data format for response.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   id: string (required)
  ##     : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822084439 = newJObject()
  var query_822084440 = newJObject()
  add(query_822084440, "$alt", newJString(Alt))
  add(query_822084440, "$.xgafv", newJString(Xgafv))
  add(query_822084440, "$callback", newJString(Callback))
  add(path_822084439, "id", newJString(id))
  add(query_822084440, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084438.call(path_822084439, query_822084440, nil, nil, nil)

var getCachedContent* = Call_GetCachedContent_822084429(
    name: "getCachedContent", meth: HttpMethod.HttpGet,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/cachedContents/{id}", validator: validate_GetCachedContent_822084430,
    base: "/", makeUrl: url_GetCachedContent_822084431, schemes: {Scheme.Https})
type
  Call_UpdateCachedContent_822084453 = ref object of OpenApiRestCall_822083972
proc url_UpdateCachedContent_822084455(protocol: Scheme; host: string;
                                       base: string; route: string;
                                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/cachedContents/"),
                 (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_UpdateCachedContent_822084454(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Updates CachedContent resource (only expiration is updatable).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_822084456 = path.getOrDefault("id")
  valid_822084456 = validateParameter(valid_822084456, JString, required = true,
                                      default = nil)
  if valid_822084456 != nil:
    section.add "id", valid_822084456
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   updateMask: JString
  ##             : The list of fields to update.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822084457 = query.getOrDefault("$alt")
  valid_822084457 = validateParameter(valid_822084457, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084457 != nil:
    section.add "$alt", valid_822084457
  var valid_822084458 = query.getOrDefault("updateMask")
  valid_822084458 = validateParameter(valid_822084458, JString,
                                      required = false, default = nil)
  if valid_822084458 != nil:
    section.add "updateMask", valid_822084458
  var valid_822084459 = query.getOrDefault("$.xgafv")
  valid_822084459 = validateParameter(valid_822084459, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084459 != nil:
    section.add "$.xgafv", valid_822084459
  var valid_822084460 = query.getOrDefault("$callback")
  valid_822084460 = validateParameter(valid_822084460, JString,
                                      required = false, default = nil)
  if valid_822084460 != nil:
    section.add "$callback", valid_822084460
  var valid_822084461 = query.getOrDefault("$prettyPrint")
  valid_822084461 = validateParameter(valid_822084461, JBool, required = false,
                                      default = nil)
  if valid_822084461 != nil:
    section.add "$prettyPrint", valid_822084461
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  ##       : Required. The content cache entry to update
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822084463: Call_UpdateCachedContent_822084453;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Updates CachedContent resource (only expiration is updatable).
  ## 
  let valid = call_822084463.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084463.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084463.makeUrl(scheme.get, call_822084463.host, call_822084463.base,
                                   call_822084463.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084463, uri, valid, content)

proc call*(call_822084464: Call_UpdateCachedContent_822084453; id: string;
           Alt: string = "json"; body: JsonNode = nil; updateMask: string = "";
           Xgafv: string = "1"; Callback: string = ""; PrettyPrint: bool = false): Recallable =
  ## updateCachedContent
  ## Updates CachedContent resource (only expiration is updatable).
  ##   Alt: string
  ##      : Data format for response.
  ##   body: JObject
  ##       : Required. The content cache entry to update
  ##   updateMask: string
  ##             : The list of fields to update.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   id: string (required)
  ##     : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822084465 = newJObject()
  var query_822084466 = newJObject()
  var body_822084467 = newJObject()
  add(query_822084466, "$alt", newJString(Alt))
  if body != nil:
    body_822084467 = body
  add(query_822084466, "updateMask", newJString(updateMask))
  add(query_822084466, "$.xgafv", newJString(Xgafv))
  add(query_822084466, "$callback", newJString(Callback))
  add(path_822084465, "id", newJString(id))
  add(query_822084466, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084464.call(path_822084465, query_822084466, nil, nil, body_822084467)

var updateCachedContent* = Call_UpdateCachedContent_822084453(
    name: "updateCachedContent", meth: HttpMethod.HttpPatch,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/cachedContents/{id}",
    validator: validate_UpdateCachedContent_822084454, base: "/",
    makeUrl: url_UpdateCachedContent_822084455, schemes: {Scheme.Https})
type
  Call_CreateCorpus_822084480 = ref object of OpenApiRestCall_822083972
proc url_CreateCorpus_822084482(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CreateCorpus_822084481(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Creates an empty `Corpus`.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822084483 = query.getOrDefault("$alt")
  valid_822084483 = validateParameter(valid_822084483, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084483 != nil:
    section.add "$alt", valid_822084483
  var valid_822084484 = query.getOrDefault("$.xgafv")
  valid_822084484 = validateParameter(valid_822084484, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084484 != nil:
    section.add "$.xgafv", valid_822084484
  var valid_822084485 = query.getOrDefault("$callback")
  valid_822084485 = validateParameter(valid_822084485, JString,
                                      required = false, default = nil)
  if valid_822084485 != nil:
    section.add "$callback", valid_822084485
  var valid_822084486 = query.getOrDefault("$prettyPrint")
  valid_822084486 = validateParameter(valid_822084486, JBool, required = false,
                                      default = nil)
  if valid_822084486 != nil:
    section.add "$prettyPrint", valid_822084486
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  ##       : Required. The `Corpus` to create.
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822084488: Call_CreateCorpus_822084480; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Creates an empty `Corpus`.
  ## 
  let valid = call_822084488.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084488.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084488.makeUrl(scheme.get, call_822084488.host, call_822084488.base,
                                   call_822084488.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084488, uri, valid, content)

proc call*(call_822084489: Call_CreateCorpus_822084480; Alt: string = "json";
           body: JsonNode = nil; Xgafv: string = "1"; Callback: string = "";
           PrettyPrint: bool = false): Recallable =
  ## createCorpus
  ## Creates an empty `Corpus`.
  ##   Alt: string
  ##      : Data format for response.
  ##   body: JObject
  ##       : Required. The `Corpus` to create.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_822084490 = newJObject()
  var body_822084491 = newJObject()
  add(query_822084490, "$alt", newJString(Alt))
  if body != nil:
    body_822084491 = body
  add(query_822084490, "$.xgafv", newJString(Xgafv))
  add(query_822084490, "$callback", newJString(Callback))
  add(query_822084490, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084489.call(nil, query_822084490, nil, nil, body_822084491)

var createCorpus* = Call_CreateCorpus_822084480(name: "createCorpus",
    meth: HttpMethod.HttpPost, host: "generativelanguage.googleapis.com",
    route: "/v1beta/corpora", validator: validate_CreateCorpus_822084481,
    base: "/", makeUrl: url_CreateCorpus_822084482, schemes: {Scheme.Https})
type
  Call_ListCorpora_822084468 = ref object of OpenApiRestCall_822083972
proc url_ListCorpora_822084470(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_ListCorpora_822084469(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Lists all `Corpora` owned by the user.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   pageSize: JInt
  ##           : Optional. The maximum number of `Corpora` to return (per page).
  ## The service may return fewer `Corpora`.
  ## 
  ## If unspecified, at most 10 `Corpora` will be returned.
  ## The maximum size limit is 20 `Corpora` per page.
  ##   pageToken: JString
  ##            : Optional. A page token, received from a previous `ListCorpora` call.
  ## 
  ## Provide the `next_page_token` returned in the response as an argument to
  ## the next request to retrieve the next page.
  ## 
  ## When paginating, all other parameters provided to `ListCorpora`
  ## must match the call that provided the page token.
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822084471 = query.getOrDefault("$alt")
  valid_822084471 = validateParameter(valid_822084471, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084471 != nil:
    section.add "$alt", valid_822084471
  var valid_822084472 = query.getOrDefault("$.xgafv")
  valid_822084472 = validateParameter(valid_822084472, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084472 != nil:
    section.add "$.xgafv", valid_822084472
  var valid_822084473 = query.getOrDefault("$callback")
  valid_822084473 = validateParameter(valid_822084473, JString,
                                      required = false, default = nil)
  if valid_822084473 != nil:
    section.add "$callback", valid_822084473
  var valid_822084474 = query.getOrDefault("pageSize")
  valid_822084474 = validateParameter(valid_822084474, JInt, required = false,
                                      default = nil)
  if valid_822084474 != nil:
    section.add "pageSize", valid_822084474
  var valid_822084475 = query.getOrDefault("pageToken")
  valid_822084475 = validateParameter(valid_822084475, JString,
                                      required = false, default = nil)
  if valid_822084475 != nil:
    section.add "pageToken", valid_822084475
  var valid_822084476 = query.getOrDefault("$prettyPrint")
  valid_822084476 = validateParameter(valid_822084476, JBool, required = false,
                                      default = nil)
  if valid_822084476 != nil:
    section.add "$prettyPrint", valid_822084476
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084477: Call_ListCorpora_822084468; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Lists all `Corpora` owned by the user.
  ## 
  let valid = call_822084477.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084477.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084477.makeUrl(scheme.get, call_822084477.host, call_822084477.base,
                                   call_822084477.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084477, uri, valid, content)

proc call*(call_822084478: Call_ListCorpora_822084468; Alt: string = "json";
           Xgafv: string = "1"; Callback: string = ""; pageSize: int = 0;
           pageToken: string = ""; PrettyPrint: bool = false): Recallable =
  ## listCorpora
  ## Lists all `Corpora` owned by the user.
  ##   Alt: string
  ##      : Data format for response.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   pageSize: int
  ##           : Optional. The maximum number of `Corpora` to return (per page).
  ## The service may return fewer `Corpora`.
  ## 
  ## If unspecified, at most 10 `Corpora` will be returned.
  ## The maximum size limit is 20 `Corpora` per page.
  ##   pageToken: string
  ##            : Optional. A page token, received from a previous `ListCorpora` call.
  ## 
  ## Provide the `next_page_token` returned in the response as an argument to
  ## the next request to retrieve the next page.
  ## 
  ## When paginating, all other parameters provided to `ListCorpora`
  ## must match the call that provided the page token.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_822084479 = newJObject()
  add(query_822084479, "$alt", newJString(Alt))
  add(query_822084479, "$.xgafv", newJString(Xgafv))
  add(query_822084479, "$callback", newJString(Callback))
  add(query_822084479, "pageSize", newJInt(pageSize))
  add(query_822084479, "pageToken", newJString(pageToken))
  add(query_822084479, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084478.call(nil, query_822084479, nil, nil, nil)

var listCorpora* = Call_ListCorpora_822084468(name: "listCorpora",
    meth: HttpMethod.HttpGet, host: "generativelanguage.googleapis.com",
    route: "/v1beta/corpora", validator: validate_ListCorpora_822084469,
    base: "/", makeUrl: url_ListCorpora_822084470, schemes: {Scheme.Https})
type
  Call_DeleteCorpus_822084504 = ref object of OpenApiRestCall_822083972
proc url_DeleteCorpus_822084506(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "corpus" in path, "`corpus` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/corpora/"),
                 (kind: VariableSegment, value: "corpus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DeleteCorpus_822084505(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Deletes a `Corpus`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   corpus: JString (required)
  ##         : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `corpus` field"
  var valid_822084507 = path.getOrDefault("corpus")
  valid_822084507 = validateParameter(valid_822084507, JString, required = true,
                                      default = nil)
  if valid_822084507 != nil:
    section.add "corpus", valid_822084507
  result.add "path", section
  ## parameters in `query` object:
  ##   force: JBool
  ##        : Optional. If set to true, any `Document`s and objects related to this `Corpus` will
  ## also be deleted.
  ## 
  ## If false (the default), a `FAILED_PRECONDITION` error will be returned if
  ## `Corpus` contains any `Document`s.
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822084508 = query.getOrDefault("force")
  valid_822084508 = validateParameter(valid_822084508, JBool, required = false,
                                      default = nil)
  if valid_822084508 != nil:
    section.add "force", valid_822084508
  var valid_822084509 = query.getOrDefault("$alt")
  valid_822084509 = validateParameter(valid_822084509, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084509 != nil:
    section.add "$alt", valid_822084509
  var valid_822084510 = query.getOrDefault("$.xgafv")
  valid_822084510 = validateParameter(valid_822084510, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084510 != nil:
    section.add "$.xgafv", valid_822084510
  var valid_822084511 = query.getOrDefault("$callback")
  valid_822084511 = validateParameter(valid_822084511, JString,
                                      required = false, default = nil)
  if valid_822084511 != nil:
    section.add "$callback", valid_822084511
  var valid_822084512 = query.getOrDefault("$prettyPrint")
  valid_822084512 = validateParameter(valid_822084512, JBool, required = false,
                                      default = nil)
  if valid_822084512 != nil:
    section.add "$prettyPrint", valid_822084512
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084513: Call_DeleteCorpus_822084504; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Deletes a `Corpus`.
  ## 
  let valid = call_822084513.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084513.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084513.makeUrl(scheme.get, call_822084513.host, call_822084513.base,
                                   call_822084513.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084513, uri, valid, content)

proc call*(call_822084514: Call_DeleteCorpus_822084504; corpus: string;
           force: bool = false; Alt: string = "json"; Xgafv: string = "1";
           Callback: string = ""; PrettyPrint: bool = false): Recallable =
  ## deleteCorpus
  ## Deletes a `Corpus`.
  ##   force: bool
  ##        : Optional. If set to true, any `Document`s and objects related to this `Corpus` will
  ## also be deleted.
  ## 
  ## If false (the default), a `FAILED_PRECONDITION` error will be returned if
  ## `Corpus` contains any `Document`s.
  ##   Alt: string
  ##      : Data format for response.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   corpus: string (required)
  ##         : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822084515 = newJObject()
  var query_822084516 = newJObject()
  add(query_822084516, "force", newJBool(force))
  add(query_822084516, "$alt", newJString(Alt))
  add(query_822084516, "$.xgafv", newJString(Xgafv))
  add(query_822084516, "$callback", newJString(Callback))
  add(path_822084515, "corpus", newJString(corpus))
  add(query_822084516, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084514.call(path_822084515, query_822084516, nil, nil, nil)

var deleteCorpus* = Call_DeleteCorpus_822084504(name: "deleteCorpus",
    meth: HttpMethod.HttpDelete, host: "generativelanguage.googleapis.com",
    route: "/v1beta/corpora/{corpus}", validator: validate_DeleteCorpus_822084505,
    base: "/", makeUrl: url_DeleteCorpus_822084506, schemes: {Scheme.Https})
type
  Call_GetCorpus_822084492 = ref object of OpenApiRestCall_822083972
proc url_GetCorpus_822084494(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "corpus" in path, "`corpus` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/corpora/"),
                 (kind: VariableSegment, value: "corpus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GetCorpus_822084493(path: JsonNode; query: JsonNode;
                                  header: JsonNode; formData: JsonNode;
                                  body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Gets information about a specific `Corpus`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   corpus: JString (required)
  ##         : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `corpus` field"
  var valid_822084495 = path.getOrDefault("corpus")
  valid_822084495 = validateParameter(valid_822084495, JString, required = true,
                                      default = nil)
  if valid_822084495 != nil:
    section.add "corpus", valid_822084495
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822084496 = query.getOrDefault("$alt")
  valid_822084496 = validateParameter(valid_822084496, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084496 != nil:
    section.add "$alt", valid_822084496
  var valid_822084497 = query.getOrDefault("$.xgafv")
  valid_822084497 = validateParameter(valid_822084497, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084497 != nil:
    section.add "$.xgafv", valid_822084497
  var valid_822084498 = query.getOrDefault("$callback")
  valid_822084498 = validateParameter(valid_822084498, JString,
                                      required = false, default = nil)
  if valid_822084498 != nil:
    section.add "$callback", valid_822084498
  var valid_822084499 = query.getOrDefault("$prettyPrint")
  valid_822084499 = validateParameter(valid_822084499, JBool, required = false,
                                      default = nil)
  if valid_822084499 != nil:
    section.add "$prettyPrint", valid_822084499
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084500: Call_GetCorpus_822084492; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Gets information about a specific `Corpus`.
  ## 
  let valid = call_822084500.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084500.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084500.makeUrl(scheme.get, call_822084500.host, call_822084500.base,
                                   call_822084500.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084500, uri, valid, content)

proc call*(call_822084501: Call_GetCorpus_822084492; corpus: string;
           Alt: string = "json"; Xgafv: string = "1"; Callback: string = "";
           PrettyPrint: bool = false): Recallable =
  ## getCorpus
  ## Gets information about a specific `Corpus`.
  ##   Alt: string
  ##      : Data format for response.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   corpus: string (required)
  ##         : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822084502 = newJObject()
  var query_822084503 = newJObject()
  add(query_822084503, "$alt", newJString(Alt))
  add(query_822084503, "$.xgafv", newJString(Xgafv))
  add(query_822084503, "$callback", newJString(Callback))
  add(path_822084502, "corpus", newJString(corpus))
  add(query_822084503, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084501.call(path_822084502, query_822084503, nil, nil, nil)

var getCorpus* = Call_GetCorpus_822084492(name: "getCorpus",
    meth: HttpMethod.HttpGet, host: "generativelanguage.googleapis.com",
    route: "/v1beta/corpora/{corpus}", validator: validate_GetCorpus_822084493,
    base: "/", makeUrl: url_GetCorpus_822084494, schemes: {Scheme.Https})
type
  Call_UpdateCorpus_822084517 = ref object of OpenApiRestCall_822083972
proc url_UpdateCorpus_822084519(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "corpus" in path, "`corpus` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/corpora/"),
                 (kind: VariableSegment, value: "corpus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_UpdateCorpus_822084518(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Updates a `Corpus`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   corpus: JString (required)
  ##         : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `corpus` field"
  var valid_822084520 = path.getOrDefault("corpus")
  valid_822084520 = validateParameter(valid_822084520, JString, required = true,
                                      default = nil)
  if valid_822084520 != nil:
    section.add "corpus", valid_822084520
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   updateMask: JString (required)
  ##             : Required. The list of fields to update.
  ## Currently, this only supports updating `display_name`.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822084521 = query.getOrDefault("$alt")
  valid_822084521 = validateParameter(valid_822084521, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084521 != nil:
    section.add "$alt", valid_822084521
  assert query != nil,
         "query argument is necessary due to required `updateMask` field"
  var valid_822084522 = query.getOrDefault("updateMask")
  valid_822084522 = validateParameter(valid_822084522, JString, required = true,
                                      default = nil)
  if valid_822084522 != nil:
    section.add "updateMask", valid_822084522
  var valid_822084523 = query.getOrDefault("$.xgafv")
  valid_822084523 = validateParameter(valid_822084523, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084523 != nil:
    section.add "$.xgafv", valid_822084523
  var valid_822084524 = query.getOrDefault("$callback")
  valid_822084524 = validateParameter(valid_822084524, JString,
                                      required = false, default = nil)
  if valid_822084524 != nil:
    section.add "$callback", valid_822084524
  var valid_822084525 = query.getOrDefault("$prettyPrint")
  valid_822084525 = validateParameter(valid_822084525, JBool, required = false,
                                      default = nil)
  if valid_822084525 != nil:
    section.add "$prettyPrint", valid_822084525
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  ##       : Required. The `Corpus` to update.
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822084527: Call_UpdateCorpus_822084517; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Updates a `Corpus`.
  ## 
  let valid = call_822084527.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084527.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084527.makeUrl(scheme.get, call_822084527.host, call_822084527.base,
                                   call_822084527.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084527, uri, valid, content)

proc call*(call_822084528: Call_UpdateCorpus_822084517; updateMask: string;
           corpus: string; Alt: string = "json"; body: JsonNode = nil;
           Xgafv: string = "1"; Callback: string = ""; PrettyPrint: bool = false): Recallable =
  ## updateCorpus
  ## Updates a `Corpus`.
  ##   Alt: string
  ##      : Data format for response.
  ##   body: JObject
  ##       : Required. The `Corpus` to update.
  ##   updateMask: string (required)
  ##             : Required. The list of fields to update.
  ## Currently, this only supports updating `display_name`.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   corpus: string (required)
  ##         : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822084529 = newJObject()
  var query_822084530 = newJObject()
  var body_822084531 = newJObject()
  add(query_822084530, "$alt", newJString(Alt))
  if body != nil:
    body_822084531 = body
  add(query_822084530, "updateMask", newJString(updateMask))
  add(query_822084530, "$.xgafv", newJString(Xgafv))
  add(query_822084530, "$callback", newJString(Callback))
  add(path_822084529, "corpus", newJString(corpus))
  add(query_822084530, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084528.call(path_822084529, query_822084530, nil, nil, body_822084531)

var updateCorpus* = Call_UpdateCorpus_822084517(name: "updateCorpus",
    meth: HttpMethod.HttpPatch, host: "generativelanguage.googleapis.com",
    route: "/v1beta/corpora/{corpus}", validator: validate_UpdateCorpus_822084518,
    base: "/", makeUrl: url_UpdateCorpus_822084519, schemes: {Scheme.Https})
type
  Call_CreateDocument_822084546 = ref object of OpenApiRestCall_822083972
proc url_CreateDocument_822084548(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "corpus" in path, "`corpus` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/corpora/"),
                 (kind: VariableSegment, value: "corpus"),
                 (kind: ConstantSegment, value: "/documents")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CreateDocument_822084547(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Creates an empty `Document`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   corpus: JString (required)
  ##         : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `corpus` field"
  var valid_822084549 = path.getOrDefault("corpus")
  valid_822084549 = validateParameter(valid_822084549, JString, required = true,
                                      default = nil)
  if valid_822084549 != nil:
    section.add "corpus", valid_822084549
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822084550 = query.getOrDefault("$alt")
  valid_822084550 = validateParameter(valid_822084550, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084550 != nil:
    section.add "$alt", valid_822084550
  var valid_822084551 = query.getOrDefault("$.xgafv")
  valid_822084551 = validateParameter(valid_822084551, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084551 != nil:
    section.add "$.xgafv", valid_822084551
  var valid_822084552 = query.getOrDefault("$callback")
  valid_822084552 = validateParameter(valid_822084552, JString,
                                      required = false, default = nil)
  if valid_822084552 != nil:
    section.add "$callback", valid_822084552
  var valid_822084553 = query.getOrDefault("$prettyPrint")
  valid_822084553 = validateParameter(valid_822084553, JBool, required = false,
                                      default = nil)
  if valid_822084553 != nil:
    section.add "$prettyPrint", valid_822084553
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  ##       : Required. The `Document` to create.
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822084555: Call_CreateDocument_822084546; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Creates an empty `Document`.
  ## 
  let valid = call_822084555.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084555.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084555.makeUrl(scheme.get, call_822084555.host, call_822084555.base,
                                   call_822084555.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084555, uri, valid, content)

proc call*(call_822084556: Call_CreateDocument_822084546; corpus: string;
           Alt: string = "json"; body: JsonNode = nil; Xgafv: string = "1";
           Callback: string = ""; PrettyPrint: bool = false): Recallable =
  ## createDocument
  ## Creates an empty `Document`.
  ##   Alt: string
  ##      : Data format for response.
  ##   body: JObject
  ##       : Required. The `Document` to create.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   corpus: string (required)
  ##         : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822084557 = newJObject()
  var query_822084558 = newJObject()
  var body_822084559 = newJObject()
  add(query_822084558, "$alt", newJString(Alt))
  if body != nil:
    body_822084559 = body
  add(query_822084558, "$.xgafv", newJString(Xgafv))
  add(query_822084558, "$callback", newJString(Callback))
  add(path_822084557, "corpus", newJString(corpus))
  add(query_822084558, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084556.call(path_822084557, query_822084558, nil, nil, body_822084559)

var createDocument* = Call_CreateDocument_822084546(name: "createDocument",
    meth: HttpMethod.HttpPost, host: "generativelanguage.googleapis.com",
    route: "/v1beta/corpora/{corpus}/documents",
    validator: validate_CreateDocument_822084547, base: "/",
    makeUrl: url_CreateDocument_822084548, schemes: {Scheme.Https})
type
  Call_ListDocuments_822084532 = ref object of OpenApiRestCall_822083972
proc url_ListDocuments_822084534(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "corpus" in path, "`corpus` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/corpora/"),
                 (kind: VariableSegment, value: "corpus"),
                 (kind: ConstantSegment, value: "/documents")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ListDocuments_822084533(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Lists all `Document`s in a `Corpus`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   corpus: JString (required)
  ##         : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `corpus` field"
  var valid_822084535 = path.getOrDefault("corpus")
  valid_822084535 = validateParameter(valid_822084535, JString, required = true,
                                      default = nil)
  if valid_822084535 != nil:
    section.add "corpus", valid_822084535
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   pageSize: JInt
  ##           : Optional. The maximum number of `Document`s to return (per page).
  ## The service may return fewer `Document`s.
  ## 
  ## If unspecified, at most 10 `Document`s will be returned.
  ## The maximum size limit is 20 `Document`s per page.
  ##   pageToken: JString
  ##            : Optional. A page token, received from a previous `ListDocuments` call.
  ## 
  ## Provide the `next_page_token` returned in the response as an argument to
  ## the next request to retrieve the next page.
  ## 
  ## When paginating, all other parameters provided to `ListDocuments`
  ## must match the call that provided the page token.
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822084536 = query.getOrDefault("$alt")
  valid_822084536 = validateParameter(valid_822084536, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084536 != nil:
    section.add "$alt", valid_822084536
  var valid_822084537 = query.getOrDefault("$.xgafv")
  valid_822084537 = validateParameter(valid_822084537, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084537 != nil:
    section.add "$.xgafv", valid_822084537
  var valid_822084538 = query.getOrDefault("$callback")
  valid_822084538 = validateParameter(valid_822084538, JString,
                                      required = false, default = nil)
  if valid_822084538 != nil:
    section.add "$callback", valid_822084538
  var valid_822084539 = query.getOrDefault("pageSize")
  valid_822084539 = validateParameter(valid_822084539, JInt, required = false,
                                      default = nil)
  if valid_822084539 != nil:
    section.add "pageSize", valid_822084539
  var valid_822084540 = query.getOrDefault("pageToken")
  valid_822084540 = validateParameter(valid_822084540, JString,
                                      required = false, default = nil)
  if valid_822084540 != nil:
    section.add "pageToken", valid_822084540
  var valid_822084541 = query.getOrDefault("$prettyPrint")
  valid_822084541 = validateParameter(valid_822084541, JBool, required = false,
                                      default = nil)
  if valid_822084541 != nil:
    section.add "$prettyPrint", valid_822084541
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084542: Call_ListDocuments_822084532; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Lists all `Document`s in a `Corpus`.
  ## 
  let valid = call_822084542.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084542.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084542.makeUrl(scheme.get, call_822084542.host, call_822084542.base,
                                   call_822084542.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084542, uri, valid, content)

proc call*(call_822084543: Call_ListDocuments_822084532; corpus: string;
           Alt: string = "json"; Xgafv: string = "1"; Callback: string = "";
           pageSize: int = 0; pageToken: string = ""; PrettyPrint: bool = false): Recallable =
  ## listDocuments
  ## Lists all `Document`s in a `Corpus`.
  ##   Alt: string
  ##      : Data format for response.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   corpus: string (required)
  ##         : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   pageSize: int
  ##           : Optional. The maximum number of `Document`s to return (per page).
  ## The service may return fewer `Document`s.
  ## 
  ## If unspecified, at most 10 `Document`s will be returned.
  ## The maximum size limit is 20 `Document`s per page.
  ##   pageToken: string
  ##            : Optional. A page token, received from a previous `ListDocuments` call.
  ## 
  ## Provide the `next_page_token` returned in the response as an argument to
  ## the next request to retrieve the next page.
  ## 
  ## When paginating, all other parameters provided to `ListDocuments`
  ## must match the call that provided the page token.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822084544 = newJObject()
  var query_822084545 = newJObject()
  add(query_822084545, "$alt", newJString(Alt))
  add(query_822084545, "$.xgafv", newJString(Xgafv))
  add(query_822084545, "$callback", newJString(Callback))
  add(path_822084544, "corpus", newJString(corpus))
  add(query_822084545, "pageSize", newJInt(pageSize))
  add(query_822084545, "pageToken", newJString(pageToken))
  add(query_822084545, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084543.call(path_822084544, query_822084545, nil, nil, nil)

var listDocuments* = Call_ListDocuments_822084532(name: "listDocuments",
    meth: HttpMethod.HttpGet, host: "generativelanguage.googleapis.com",
    route: "/v1beta/corpora/{corpus}/documents",
    validator: validate_ListDocuments_822084533, base: "/",
    makeUrl: url_ListDocuments_822084534, schemes: {Scheme.Https})
type
  Call_DeleteDocument_822084573 = ref object of OpenApiRestCall_822083972
proc url_DeleteDocument_822084575(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "corpus" in path, "`corpus` is a required path parameter"
  assert "document" in path, "`document` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/corpora/"),
                 (kind: VariableSegment, value: "corpus"),
                 (kind: ConstantSegment, value: "/documents/"),
                 (kind: VariableSegment, value: "document")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DeleteDocument_822084574(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Deletes a `Document`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   document: JString (required)
  ##           : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   corpus: JString (required)
  ##         : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `document` field"
  var valid_822084576 = path.getOrDefault("document")
  valid_822084576 = validateParameter(valid_822084576, JString, required = true,
                                      default = nil)
  if valid_822084576 != nil:
    section.add "document", valid_822084576
  var valid_822084577 = path.getOrDefault("corpus")
  valid_822084577 = validateParameter(valid_822084577, JString, required = true,
                                      default = nil)
  if valid_822084577 != nil:
    section.add "corpus", valid_822084577
  result.add "path", section
  ## parameters in `query` object:
  ##   force: JBool
  ##        : Optional. If set to true, any `Chunk`s and objects related to this `Document` will
  ## also be deleted.
  ## 
  ## If false (the default), a `FAILED_PRECONDITION` error will be returned if
  ## `Document` contains any `Chunk`s.
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822084578 = query.getOrDefault("force")
  valid_822084578 = validateParameter(valid_822084578, JBool, required = false,
                                      default = nil)
  if valid_822084578 != nil:
    section.add "force", valid_822084578
  var valid_822084579 = query.getOrDefault("$alt")
  valid_822084579 = validateParameter(valid_822084579, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084579 != nil:
    section.add "$alt", valid_822084579
  var valid_822084580 = query.getOrDefault("$.xgafv")
  valid_822084580 = validateParameter(valid_822084580, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084580 != nil:
    section.add "$.xgafv", valid_822084580
  var valid_822084581 = query.getOrDefault("$callback")
  valid_822084581 = validateParameter(valid_822084581, JString,
                                      required = false, default = nil)
  if valid_822084581 != nil:
    section.add "$callback", valid_822084581
  var valid_822084582 = query.getOrDefault("$prettyPrint")
  valid_822084582 = validateParameter(valid_822084582, JBool, required = false,
                                      default = nil)
  if valid_822084582 != nil:
    section.add "$prettyPrint", valid_822084582
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084583: Call_DeleteDocument_822084573; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Deletes a `Document`.
  ## 
  let valid = call_822084583.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084583.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084583.makeUrl(scheme.get, call_822084583.host, call_822084583.base,
                                   call_822084583.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084583, uri, valid, content)

proc call*(call_822084584: Call_DeleteDocument_822084573; document: string;
           corpus: string; force: bool = false; Alt: string = "json";
           Xgafv: string = "1"; Callback: string = ""; PrettyPrint: bool = false): Recallable =
  ## deleteDocument
  ## Deletes a `Document`.
  ##   document: string (required)
  ##           : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   force: bool
  ##        : Optional. If set to true, any `Chunk`s and objects related to this `Document` will
  ## also be deleted.
  ## 
  ## If false (the default), a `FAILED_PRECONDITION` error will be returned if
  ## `Document` contains any `Chunk`s.
  ##   Alt: string
  ##      : Data format for response.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   corpus: string (required)
  ##         : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822084585 = newJObject()
  var query_822084586 = newJObject()
  add(path_822084585, "document", newJString(document))
  add(query_822084586, "force", newJBool(force))
  add(query_822084586, "$alt", newJString(Alt))
  add(query_822084586, "$.xgafv", newJString(Xgafv))
  add(query_822084586, "$callback", newJString(Callback))
  add(path_822084585, "corpus", newJString(corpus))
  add(query_822084586, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084584.call(path_822084585, query_822084586, nil, nil, nil)

var deleteDocument* = Call_DeleteDocument_822084573(name: "deleteDocument",
    meth: HttpMethod.HttpDelete, host: "generativelanguage.googleapis.com",
    route: "/v1beta/corpora/{corpus}/documents/{document}",
    validator: validate_DeleteDocument_822084574, base: "/",
    makeUrl: url_DeleteDocument_822084575, schemes: {Scheme.Https})
type
  Call_GetDocument_822084560 = ref object of OpenApiRestCall_822083972
proc url_GetDocument_822084562(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "corpus" in path, "`corpus` is a required path parameter"
  assert "document" in path, "`document` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/corpora/"),
                 (kind: VariableSegment, value: "corpus"),
                 (kind: ConstantSegment, value: "/documents/"),
                 (kind: VariableSegment, value: "document")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GetDocument_822084561(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Gets information about a specific `Document`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   document: JString (required)
  ##           : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   corpus: JString (required)
  ##         : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `document` field"
  var valid_822084563 = path.getOrDefault("document")
  valid_822084563 = validateParameter(valid_822084563, JString, required = true,
                                      default = nil)
  if valid_822084563 != nil:
    section.add "document", valid_822084563
  var valid_822084564 = path.getOrDefault("corpus")
  valid_822084564 = validateParameter(valid_822084564, JString, required = true,
                                      default = nil)
  if valid_822084564 != nil:
    section.add "corpus", valid_822084564
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822084565 = query.getOrDefault("$alt")
  valid_822084565 = validateParameter(valid_822084565, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084565 != nil:
    section.add "$alt", valid_822084565
  var valid_822084566 = query.getOrDefault("$.xgafv")
  valid_822084566 = validateParameter(valid_822084566, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084566 != nil:
    section.add "$.xgafv", valid_822084566
  var valid_822084567 = query.getOrDefault("$callback")
  valid_822084567 = validateParameter(valid_822084567, JString,
                                      required = false, default = nil)
  if valid_822084567 != nil:
    section.add "$callback", valid_822084567
  var valid_822084568 = query.getOrDefault("$prettyPrint")
  valid_822084568 = validateParameter(valid_822084568, JBool, required = false,
                                      default = nil)
  if valid_822084568 != nil:
    section.add "$prettyPrint", valid_822084568
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084569: Call_GetDocument_822084560; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Gets information about a specific `Document`.
  ## 
  let valid = call_822084569.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084569.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084569.makeUrl(scheme.get, call_822084569.host, call_822084569.base,
                                   call_822084569.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084569, uri, valid, content)

proc call*(call_822084570: Call_GetDocument_822084560; document: string;
           corpus: string; Alt: string = "json"; Xgafv: string = "1";
           Callback: string = ""; PrettyPrint: bool = false): Recallable =
  ## getDocument
  ## Gets information about a specific `Document`.
  ##   document: string (required)
  ##           : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   Alt: string
  ##      : Data format for response.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   corpus: string (required)
  ##         : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822084571 = newJObject()
  var query_822084572 = newJObject()
  add(path_822084571, "document", newJString(document))
  add(query_822084572, "$alt", newJString(Alt))
  add(query_822084572, "$.xgafv", newJString(Xgafv))
  add(query_822084572, "$callback", newJString(Callback))
  add(path_822084571, "corpus", newJString(corpus))
  add(query_822084572, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084570.call(path_822084571, query_822084572, nil, nil, nil)

var getDocument* = Call_GetDocument_822084560(name: "getDocument",
    meth: HttpMethod.HttpGet, host: "generativelanguage.googleapis.com",
    route: "/v1beta/corpora/{corpus}/documents/{document}",
    validator: validate_GetDocument_822084561, base: "/",
    makeUrl: url_GetDocument_822084562, schemes: {Scheme.Https})
type
  Call_UpdateDocument_822084587 = ref object of OpenApiRestCall_822083972
proc url_UpdateDocument_822084589(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "corpus" in path, "`corpus` is a required path parameter"
  assert "document" in path, "`document` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/corpora/"),
                 (kind: VariableSegment, value: "corpus"),
                 (kind: ConstantSegment, value: "/documents/"),
                 (kind: VariableSegment, value: "document")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_UpdateDocument_822084588(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Updates a `Document`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   document: JString (required)
  ##           : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   corpus: JString (required)
  ##         : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `document` field"
  var valid_822084590 = path.getOrDefault("document")
  valid_822084590 = validateParameter(valid_822084590, JString, required = true,
                                      default = nil)
  if valid_822084590 != nil:
    section.add "document", valid_822084590
  var valid_822084591 = path.getOrDefault("corpus")
  valid_822084591 = validateParameter(valid_822084591, JString, required = true,
                                      default = nil)
  if valid_822084591 != nil:
    section.add "corpus", valid_822084591
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   updateMask: JString (required)
  ##             : Required. The list of fields to update.
  ## Currently, this only supports updating `display_name` and
  ## `custom_metadata`.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822084592 = query.getOrDefault("$alt")
  valid_822084592 = validateParameter(valid_822084592, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084592 != nil:
    section.add "$alt", valid_822084592
  assert query != nil,
         "query argument is necessary due to required `updateMask` field"
  var valid_822084593 = query.getOrDefault("updateMask")
  valid_822084593 = validateParameter(valid_822084593, JString, required = true,
                                      default = nil)
  if valid_822084593 != nil:
    section.add "updateMask", valid_822084593
  var valid_822084594 = query.getOrDefault("$.xgafv")
  valid_822084594 = validateParameter(valid_822084594, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084594 != nil:
    section.add "$.xgafv", valid_822084594
  var valid_822084595 = query.getOrDefault("$callback")
  valid_822084595 = validateParameter(valid_822084595, JString,
                                      required = false, default = nil)
  if valid_822084595 != nil:
    section.add "$callback", valid_822084595
  var valid_822084596 = query.getOrDefault("$prettyPrint")
  valid_822084596 = validateParameter(valid_822084596, JBool, required = false,
                                      default = nil)
  if valid_822084596 != nil:
    section.add "$prettyPrint", valid_822084596
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  ##       : Required. The `Document` to update.
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822084598: Call_UpdateDocument_822084587; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Updates a `Document`.
  ## 
  let valid = call_822084598.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084598.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084598.makeUrl(scheme.get, call_822084598.host, call_822084598.base,
                                   call_822084598.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084598, uri, valid, content)

proc call*(call_822084599: Call_UpdateDocument_822084587; document: string;
           updateMask: string; corpus: string; Alt: string = "json";
           body: JsonNode = nil; Xgafv: string = "1"; Callback: string = "";
           PrettyPrint: bool = false): Recallable =
  ## updateDocument
  ## Updates a `Document`.
  ##   document: string (required)
  ##           : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   Alt: string
  ##      : Data format for response.
  ##   body: JObject
  ##       : Required. The `Document` to update.
  ##   updateMask: string (required)
  ##             : Required. The list of fields to update.
  ## Currently, this only supports updating `display_name` and
  ## `custom_metadata`.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   corpus: string (required)
  ##         : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822084600 = newJObject()
  var query_822084601 = newJObject()
  var body_822084602 = newJObject()
  add(path_822084600, "document", newJString(document))
  add(query_822084601, "$alt", newJString(Alt))
  if body != nil:
    body_822084602 = body
  add(query_822084601, "updateMask", newJString(updateMask))
  add(query_822084601, "$.xgafv", newJString(Xgafv))
  add(query_822084601, "$callback", newJString(Callback))
  add(path_822084600, "corpus", newJString(corpus))
  add(query_822084601, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084599.call(path_822084600, query_822084601, nil, nil, body_822084602)

var updateDocument* = Call_UpdateDocument_822084587(name: "updateDocument",
    meth: HttpMethod.HttpPatch, host: "generativelanguage.googleapis.com",
    route: "/v1beta/corpora/{corpus}/documents/{document}",
    validator: validate_UpdateDocument_822084588, base: "/",
    makeUrl: url_UpdateDocument_822084589, schemes: {Scheme.Https})
type
  Call_CreateChunk_822084618 = ref object of OpenApiRestCall_822083972
proc url_CreateChunk_822084620(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "corpus" in path, "`corpus` is a required path parameter"
  assert "document" in path, "`document` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/corpora/"),
                 (kind: VariableSegment, value: "corpus"),
                 (kind: ConstantSegment, value: "/documents/"),
                 (kind: VariableSegment, value: "document"),
                 (kind: ConstantSegment, value: "/chunks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CreateChunk_822084619(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Creates a `Chunk`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   document: JString (required)
  ##           : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   corpus: JString (required)
  ##         : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `document` field"
  var valid_822084621 = path.getOrDefault("document")
  valid_822084621 = validateParameter(valid_822084621, JString, required = true,
                                      default = nil)
  if valid_822084621 != nil:
    section.add "document", valid_822084621
  var valid_822084622 = path.getOrDefault("corpus")
  valid_822084622 = validateParameter(valid_822084622, JString, required = true,
                                      default = nil)
  if valid_822084622 != nil:
    section.add "corpus", valid_822084622
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822084623 = query.getOrDefault("$alt")
  valid_822084623 = validateParameter(valid_822084623, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084623 != nil:
    section.add "$alt", valid_822084623
  var valid_822084624 = query.getOrDefault("$.xgafv")
  valid_822084624 = validateParameter(valid_822084624, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084624 != nil:
    section.add "$.xgafv", valid_822084624
  var valid_822084625 = query.getOrDefault("$callback")
  valid_822084625 = validateParameter(valid_822084625, JString,
                                      required = false, default = nil)
  if valid_822084625 != nil:
    section.add "$callback", valid_822084625
  var valid_822084626 = query.getOrDefault("$prettyPrint")
  valid_822084626 = validateParameter(valid_822084626, JBool, required = false,
                                      default = nil)
  if valid_822084626 != nil:
    section.add "$prettyPrint", valid_822084626
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  ##       : Required. The `Chunk` to create.
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822084628: Call_CreateChunk_822084618; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Creates a `Chunk`.
  ## 
  let valid = call_822084628.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084628.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084628.makeUrl(scheme.get, call_822084628.host, call_822084628.base,
                                   call_822084628.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084628, uri, valid, content)

proc call*(call_822084629: Call_CreateChunk_822084618; document: string;
           corpus: string; Alt: string = "json"; body: JsonNode = nil;
           Xgafv: string = "1"; Callback: string = ""; PrettyPrint: bool = false): Recallable =
  ## createChunk
  ## Creates a `Chunk`.
  ##   document: string (required)
  ##           : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   Alt: string
  ##      : Data format for response.
  ##   body: JObject
  ##       : Required. The `Chunk` to create.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   corpus: string (required)
  ##         : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822084630 = newJObject()
  var query_822084631 = newJObject()
  var body_822084632 = newJObject()
  add(path_822084630, "document", newJString(document))
  add(query_822084631, "$alt", newJString(Alt))
  if body != nil:
    body_822084632 = body
  add(query_822084631, "$.xgafv", newJString(Xgafv))
  add(query_822084631, "$callback", newJString(Callback))
  add(path_822084630, "corpus", newJString(corpus))
  add(query_822084631, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084629.call(path_822084630, query_822084631, nil, nil, body_822084632)

var createChunk* = Call_CreateChunk_822084618(name: "createChunk",
    meth: HttpMethod.HttpPost, host: "generativelanguage.googleapis.com",
    route: "/v1beta/corpora/{corpus}/documents/{document}/chunks",
    validator: validate_CreateChunk_822084619, base: "/",
    makeUrl: url_CreateChunk_822084620, schemes: {Scheme.Https})
type
  Call_ListChunks_822084603 = ref object of OpenApiRestCall_822083972
proc url_ListChunks_822084605(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "corpus" in path, "`corpus` is a required path parameter"
  assert "document" in path, "`document` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/corpora/"),
                 (kind: VariableSegment, value: "corpus"),
                 (kind: ConstantSegment, value: "/documents/"),
                 (kind: VariableSegment, value: "document"),
                 (kind: ConstantSegment, value: "/chunks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ListChunks_822084604(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Lists all `Chunk`s in a `Document`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   document: JString (required)
  ##           : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   corpus: JString (required)
  ##         : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `document` field"
  var valid_822084606 = path.getOrDefault("document")
  valid_822084606 = validateParameter(valid_822084606, JString, required = true,
                                      default = nil)
  if valid_822084606 != nil:
    section.add "document", valid_822084606
  var valid_822084607 = path.getOrDefault("corpus")
  valid_822084607 = validateParameter(valid_822084607, JString, required = true,
                                      default = nil)
  if valid_822084607 != nil:
    section.add "corpus", valid_822084607
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   pageSize: JInt
  ##           : Optional. The maximum number of `Chunk`s to return (per page).
  ## The service may return fewer `Chunk`s.
  ## 
  ## If unspecified, at most 10 `Chunk`s will be returned.
  ## The maximum size limit is 100 `Chunk`s per page.
  ##   pageToken: JString
  ##            : Optional. A page token, received from a previous `ListChunks` call.
  ## 
  ## Provide the `next_page_token` returned in the response as an argument to
  ## the next request to retrieve the next page.
  ## 
  ## When paginating, all other parameters provided to `ListChunks`
  ## must match the call that provided the page token.
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822084608 = query.getOrDefault("$alt")
  valid_822084608 = validateParameter(valid_822084608, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084608 != nil:
    section.add "$alt", valid_822084608
  var valid_822084609 = query.getOrDefault("$.xgafv")
  valid_822084609 = validateParameter(valid_822084609, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084609 != nil:
    section.add "$.xgafv", valid_822084609
  var valid_822084610 = query.getOrDefault("$callback")
  valid_822084610 = validateParameter(valid_822084610, JString,
                                      required = false, default = nil)
  if valid_822084610 != nil:
    section.add "$callback", valid_822084610
  var valid_822084611 = query.getOrDefault("pageSize")
  valid_822084611 = validateParameter(valid_822084611, JInt, required = false,
                                      default = nil)
  if valid_822084611 != nil:
    section.add "pageSize", valid_822084611
  var valid_822084612 = query.getOrDefault("pageToken")
  valid_822084612 = validateParameter(valid_822084612, JString,
                                      required = false, default = nil)
  if valid_822084612 != nil:
    section.add "pageToken", valid_822084612
  var valid_822084613 = query.getOrDefault("$prettyPrint")
  valid_822084613 = validateParameter(valid_822084613, JBool, required = false,
                                      default = nil)
  if valid_822084613 != nil:
    section.add "$prettyPrint", valid_822084613
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084614: Call_ListChunks_822084603; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Lists all `Chunk`s in a `Document`.
  ## 
  let valid = call_822084614.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084614.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084614.makeUrl(scheme.get, call_822084614.host, call_822084614.base,
                                   call_822084614.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084614, uri, valid, content)

proc call*(call_822084615: Call_ListChunks_822084603; document: string;
           corpus: string; Alt: string = "json"; Xgafv: string = "1";
           Callback: string = ""; pageSize: int = 0; pageToken: string = "";
           PrettyPrint: bool = false): Recallable =
  ## listChunks
  ## Lists all `Chunk`s in a `Document`.
  ##   document: string (required)
  ##           : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   Alt: string
  ##      : Data format for response.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   corpus: string (required)
  ##         : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   pageSize: int
  ##           : Optional. The maximum number of `Chunk`s to return (per page).
  ## The service may return fewer `Chunk`s.
  ## 
  ## If unspecified, at most 10 `Chunk`s will be returned.
  ## The maximum size limit is 100 `Chunk`s per page.
  ##   pageToken: string
  ##            : Optional. A page token, received from a previous `ListChunks` call.
  ## 
  ## Provide the `next_page_token` returned in the response as an argument to
  ## the next request to retrieve the next page.
  ## 
  ## When paginating, all other parameters provided to `ListChunks`
  ## must match the call that provided the page token.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822084616 = newJObject()
  var query_822084617 = newJObject()
  add(path_822084616, "document", newJString(document))
  add(query_822084617, "$alt", newJString(Alt))
  add(query_822084617, "$.xgafv", newJString(Xgafv))
  add(query_822084617, "$callback", newJString(Callback))
  add(path_822084616, "corpus", newJString(corpus))
  add(query_822084617, "pageSize", newJInt(pageSize))
  add(query_822084617, "pageToken", newJString(pageToken))
  add(query_822084617, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084615.call(path_822084616, query_822084617, nil, nil, nil)

var listChunks* = Call_ListChunks_822084603(name: "listChunks",
    meth: HttpMethod.HttpGet, host: "generativelanguage.googleapis.com",
    route: "/v1beta/corpora/{corpus}/documents/{document}/chunks",
    validator: validate_ListChunks_822084604, base: "/",
    makeUrl: url_ListChunks_822084605, schemes: {Scheme.Https})
type
  Call_DeleteChunk_822084647 = ref object of OpenApiRestCall_822083972
proc url_DeleteChunk_822084649(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "corpus" in path, "`corpus` is a required path parameter"
  assert "document" in path, "`document` is a required path parameter"
  assert "chunk" in path, "`chunk` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/corpora/"),
                 (kind: VariableSegment, value: "corpus"),
                 (kind: ConstantSegment, value: "/documents/"),
                 (kind: VariableSegment, value: "document"),
                 (kind: ConstantSegment, value: "/chunks/"),
                 (kind: VariableSegment, value: "chunk")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DeleteChunk_822084648(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Deletes a `Chunk`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   document: JString (required)
  ##           : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   corpus: JString (required)
  ##         : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   chunk: JString (required)
  ##        : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `document` field"
  var valid_822084650 = path.getOrDefault("document")
  valid_822084650 = validateParameter(valid_822084650, JString, required = true,
                                      default = nil)
  if valid_822084650 != nil:
    section.add "document", valid_822084650
  var valid_822084651 = path.getOrDefault("corpus")
  valid_822084651 = validateParameter(valid_822084651, JString, required = true,
                                      default = nil)
  if valid_822084651 != nil:
    section.add "corpus", valid_822084651
  var valid_822084652 = path.getOrDefault("chunk")
  valid_822084652 = validateParameter(valid_822084652, JString, required = true,
                                      default = nil)
  if valid_822084652 != nil:
    section.add "chunk", valid_822084652
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822084653 = query.getOrDefault("$alt")
  valid_822084653 = validateParameter(valid_822084653, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084653 != nil:
    section.add "$alt", valid_822084653
  var valid_822084654 = query.getOrDefault("$.xgafv")
  valid_822084654 = validateParameter(valid_822084654, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084654 != nil:
    section.add "$.xgafv", valid_822084654
  var valid_822084655 = query.getOrDefault("$callback")
  valid_822084655 = validateParameter(valid_822084655, JString,
                                      required = false, default = nil)
  if valid_822084655 != nil:
    section.add "$callback", valid_822084655
  var valid_822084656 = query.getOrDefault("$prettyPrint")
  valid_822084656 = validateParameter(valid_822084656, JBool, required = false,
                                      default = nil)
  if valid_822084656 != nil:
    section.add "$prettyPrint", valid_822084656
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084657: Call_DeleteChunk_822084647; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Deletes a `Chunk`.
  ## 
  let valid = call_822084657.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084657.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084657.makeUrl(scheme.get, call_822084657.host, call_822084657.base,
                                   call_822084657.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084657, uri, valid, content)

proc call*(call_822084658: Call_DeleteChunk_822084647; document: string;
           corpus: string; chunk: string; Alt: string = "json";
           Xgafv: string = "1"; Callback: string = ""; PrettyPrint: bool = false): Recallable =
  ## deleteChunk
  ## Deletes a `Chunk`.
  ##   document: string (required)
  ##           : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   Alt: string
  ##      : Data format for response.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   corpus: string (required)
  ##         : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   chunk: string (required)
  ##        : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822084659 = newJObject()
  var query_822084660 = newJObject()
  add(path_822084659, "document", newJString(document))
  add(query_822084660, "$alt", newJString(Alt))
  add(query_822084660, "$.xgafv", newJString(Xgafv))
  add(query_822084660, "$callback", newJString(Callback))
  add(path_822084659, "corpus", newJString(corpus))
  add(path_822084659, "chunk", newJString(chunk))
  add(query_822084660, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084658.call(path_822084659, query_822084660, nil, nil, nil)

var deleteChunk* = Call_DeleteChunk_822084647(name: "deleteChunk",
    meth: HttpMethod.HttpDelete, host: "generativelanguage.googleapis.com",
    route: "/v1beta/corpora/{corpus}/documents/{document}/chunks/{chunk}",
    validator: validate_DeleteChunk_822084648, base: "/",
    makeUrl: url_DeleteChunk_822084649, schemes: {Scheme.Https})
type
  Call_GetChunk_822084633 = ref object of OpenApiRestCall_822083972
proc url_GetChunk_822084635(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "corpus" in path, "`corpus` is a required path parameter"
  assert "document" in path, "`document` is a required path parameter"
  assert "chunk" in path, "`chunk` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/corpora/"),
                 (kind: VariableSegment, value: "corpus"),
                 (kind: ConstantSegment, value: "/documents/"),
                 (kind: VariableSegment, value: "document"),
                 (kind: ConstantSegment, value: "/chunks/"),
                 (kind: VariableSegment, value: "chunk")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GetChunk_822084634(path: JsonNode; query: JsonNode;
                                 header: JsonNode; formData: JsonNode;
                                 body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Gets information about a specific `Chunk`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   document: JString (required)
  ##           : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   corpus: JString (required)
  ##         : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   chunk: JString (required)
  ##        : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `document` field"
  var valid_822084636 = path.getOrDefault("document")
  valid_822084636 = validateParameter(valid_822084636, JString, required = true,
                                      default = nil)
  if valid_822084636 != nil:
    section.add "document", valid_822084636
  var valid_822084637 = path.getOrDefault("corpus")
  valid_822084637 = validateParameter(valid_822084637, JString, required = true,
                                      default = nil)
  if valid_822084637 != nil:
    section.add "corpus", valid_822084637
  var valid_822084638 = path.getOrDefault("chunk")
  valid_822084638 = validateParameter(valid_822084638, JString, required = true,
                                      default = nil)
  if valid_822084638 != nil:
    section.add "chunk", valid_822084638
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822084639 = query.getOrDefault("$alt")
  valid_822084639 = validateParameter(valid_822084639, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084639 != nil:
    section.add "$alt", valid_822084639
  var valid_822084640 = query.getOrDefault("$.xgafv")
  valid_822084640 = validateParameter(valid_822084640, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084640 != nil:
    section.add "$.xgafv", valid_822084640
  var valid_822084641 = query.getOrDefault("$callback")
  valid_822084641 = validateParameter(valid_822084641, JString,
                                      required = false, default = nil)
  if valid_822084641 != nil:
    section.add "$callback", valid_822084641
  var valid_822084642 = query.getOrDefault("$prettyPrint")
  valid_822084642 = validateParameter(valid_822084642, JBool, required = false,
                                      default = nil)
  if valid_822084642 != nil:
    section.add "$prettyPrint", valid_822084642
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084643: Call_GetChunk_822084633; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Gets information about a specific `Chunk`.
  ## 
  let valid = call_822084643.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084643.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084643.makeUrl(scheme.get, call_822084643.host, call_822084643.base,
                                   call_822084643.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084643, uri, valid, content)

proc call*(call_822084644: Call_GetChunk_822084633; document: string;
           corpus: string; chunk: string; Alt: string = "json";
           Xgafv: string = "1"; Callback: string = ""; PrettyPrint: bool = false): Recallable =
  ## getChunk
  ## Gets information about a specific `Chunk`.
  ##   document: string (required)
  ##           : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   Alt: string
  ##      : Data format for response.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   corpus: string (required)
  ##         : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   chunk: string (required)
  ##        : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822084645 = newJObject()
  var query_822084646 = newJObject()
  add(path_822084645, "document", newJString(document))
  add(query_822084646, "$alt", newJString(Alt))
  add(query_822084646, "$.xgafv", newJString(Xgafv))
  add(query_822084646, "$callback", newJString(Callback))
  add(path_822084645, "corpus", newJString(corpus))
  add(path_822084645, "chunk", newJString(chunk))
  add(query_822084646, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084644.call(path_822084645, query_822084646, nil, nil, nil)

var getChunk* = Call_GetChunk_822084633(name: "getChunk",
                                        meth: HttpMethod.HttpGet, host: "generativelanguage.googleapis.com", route: "/v1beta/corpora/{corpus}/documents/{document}/chunks/{chunk}",
                                        validator: validate_GetChunk_822084634,
                                        base: "/", makeUrl: url_GetChunk_822084635,
                                        schemes: {Scheme.Https})
type
  Call_UpdateChunk_822084661 = ref object of OpenApiRestCall_822083972
proc url_UpdateChunk_822084663(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "corpus" in path, "`corpus` is a required path parameter"
  assert "document" in path, "`document` is a required path parameter"
  assert "chunk" in path, "`chunk` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/corpora/"),
                 (kind: VariableSegment, value: "corpus"),
                 (kind: ConstantSegment, value: "/documents/"),
                 (kind: VariableSegment, value: "document"),
                 (kind: ConstantSegment, value: "/chunks/"),
                 (kind: VariableSegment, value: "chunk")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_UpdateChunk_822084662(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Updates a `Chunk`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   document: JString (required)
  ##           : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   corpus: JString (required)
  ##         : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   chunk: JString (required)
  ##        : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `document` field"
  var valid_822084664 = path.getOrDefault("document")
  valid_822084664 = validateParameter(valid_822084664, JString, required = true,
                                      default = nil)
  if valid_822084664 != nil:
    section.add "document", valid_822084664
  var valid_822084665 = path.getOrDefault("corpus")
  valid_822084665 = validateParameter(valid_822084665, JString, required = true,
                                      default = nil)
  if valid_822084665 != nil:
    section.add "corpus", valid_822084665
  var valid_822084666 = path.getOrDefault("chunk")
  valid_822084666 = validateParameter(valid_822084666, JString, required = true,
                                      default = nil)
  if valid_822084666 != nil:
    section.add "chunk", valid_822084666
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   updateMask: JString (required)
  ##             : Required. The list of fields to update.
  ## Currently, this only supports updating `custom_metadata` and `data`.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822084667 = query.getOrDefault("$alt")
  valid_822084667 = validateParameter(valid_822084667, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084667 != nil:
    section.add "$alt", valid_822084667
  assert query != nil,
         "query argument is necessary due to required `updateMask` field"
  var valid_822084668 = query.getOrDefault("updateMask")
  valid_822084668 = validateParameter(valid_822084668, JString, required = true,
                                      default = nil)
  if valid_822084668 != nil:
    section.add "updateMask", valid_822084668
  var valid_822084669 = query.getOrDefault("$.xgafv")
  valid_822084669 = validateParameter(valid_822084669, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084669 != nil:
    section.add "$.xgafv", valid_822084669
  var valid_822084670 = query.getOrDefault("$callback")
  valid_822084670 = validateParameter(valid_822084670, JString,
                                      required = false, default = nil)
  if valid_822084670 != nil:
    section.add "$callback", valid_822084670
  var valid_822084671 = query.getOrDefault("$prettyPrint")
  valid_822084671 = validateParameter(valid_822084671, JBool, required = false,
                                      default = nil)
  if valid_822084671 != nil:
    section.add "$prettyPrint", valid_822084671
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  ##       : Required. The `Chunk` to update.
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822084673: Call_UpdateChunk_822084661; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Updates a `Chunk`.
  ## 
  let valid = call_822084673.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084673.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084673.makeUrl(scheme.get, call_822084673.host, call_822084673.base,
                                   call_822084673.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084673, uri, valid, content)

proc call*(call_822084674: Call_UpdateChunk_822084661; document: string;
           updateMask: string; corpus: string; chunk: string;
           Alt: string = "json"; body: JsonNode = nil; Xgafv: string = "1";
           Callback: string = ""; PrettyPrint: bool = false): Recallable =
  ## updateChunk
  ## Updates a `Chunk`.
  ##   document: string (required)
  ##           : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   Alt: string
  ##      : Data format for response.
  ##   body: JObject
  ##       : Required. The `Chunk` to update.
  ##   updateMask: string (required)
  ##             : Required. The list of fields to update.
  ## Currently, this only supports updating `custom_metadata` and `data`.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   corpus: string (required)
  ##         : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   chunk: string (required)
  ##        : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822084675 = newJObject()
  var query_822084676 = newJObject()
  var body_822084677 = newJObject()
  add(path_822084675, "document", newJString(document))
  add(query_822084676, "$alt", newJString(Alt))
  if body != nil:
    body_822084677 = body
  add(query_822084676, "updateMask", newJString(updateMask))
  add(query_822084676, "$.xgafv", newJString(Xgafv))
  add(query_822084676, "$callback", newJString(Callback))
  add(path_822084675, "corpus", newJString(corpus))
  add(path_822084675, "chunk", newJString(chunk))
  add(query_822084676, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084674.call(path_822084675, query_822084676, nil, nil, body_822084677)

var updateChunk* = Call_UpdateChunk_822084661(name: "updateChunk",
    meth: HttpMethod.HttpPatch, host: "generativelanguage.googleapis.com",
    route: "/v1beta/corpora/{corpus}/documents/{document}/chunks/{chunk}",
    validator: validate_UpdateChunk_822084662, base: "/",
    makeUrl: url_UpdateChunk_822084663, schemes: {Scheme.Https})
type
  Call_BatchCreateChunks_822084678 = ref object of OpenApiRestCall_822083972
proc url_BatchCreateChunks_822084680(protocol: Scheme; host: string;
                                     base: string; route: string;
                                     path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "corpus" in path, "`corpus` is a required path parameter"
  assert "document" in path, "`document` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/corpora/"),
                 (kind: VariableSegment, value: "corpus"),
                 (kind: ConstantSegment, value: "/documents/"),
                 (kind: VariableSegment, value: "document"),
                 (kind: ConstantSegment, value: "/chunks:batchCreate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BatchCreateChunks_822084679(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Batch create `Chunk`s.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   document: JString (required)
  ##           : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   corpus: JString (required)
  ##         : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `document` field"
  var valid_822084681 = path.getOrDefault("document")
  valid_822084681 = validateParameter(valid_822084681, JString, required = true,
                                      default = nil)
  if valid_822084681 != nil:
    section.add "document", valid_822084681
  var valid_822084682 = path.getOrDefault("corpus")
  valid_822084682 = validateParameter(valid_822084682, JString, required = true,
                                      default = nil)
  if valid_822084682 != nil:
    section.add "corpus", valid_822084682
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822084683 = query.getOrDefault("$alt")
  valid_822084683 = validateParameter(valid_822084683, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084683 != nil:
    section.add "$alt", valid_822084683
  var valid_822084684 = query.getOrDefault("$.xgafv")
  valid_822084684 = validateParameter(valid_822084684, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084684 != nil:
    section.add "$.xgafv", valid_822084684
  var valid_822084685 = query.getOrDefault("$callback")
  valid_822084685 = validateParameter(valid_822084685, JString,
                                      required = false, default = nil)
  if valid_822084685 != nil:
    section.add "$callback", valid_822084685
  var valid_822084686 = query.getOrDefault("$prettyPrint")
  valid_822084686 = validateParameter(valid_822084686, JBool, required = false,
                                      default = nil)
  if valid_822084686 != nil:
    section.add "$prettyPrint", valid_822084686
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  ##       : The request body.
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822084688: Call_BatchCreateChunks_822084678;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Batch create `Chunk`s.
  ## 
  let valid = call_822084688.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084688.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084688.makeUrl(scheme.get, call_822084688.host, call_822084688.base,
                                   call_822084688.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084688, uri, valid, content)

proc call*(call_822084689: Call_BatchCreateChunks_822084678; document: string;
           corpus: string; Alt: string = "json"; body: JsonNode = nil;
           Xgafv: string = "1"; Callback: string = ""; PrettyPrint: bool = false): Recallable =
  ## batchCreateChunks
  ## Batch create `Chunk`s.
  ##   document: string (required)
  ##           : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   Alt: string
  ##      : Data format for response.
  ##   body: JObject
  ##       : The request body.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   corpus: string (required)
  ##         : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822084690 = newJObject()
  var query_822084691 = newJObject()
  var body_822084692 = newJObject()
  add(path_822084690, "document", newJString(document))
  add(query_822084691, "$alt", newJString(Alt))
  if body != nil:
    body_822084692 = body
  add(query_822084691, "$.xgafv", newJString(Xgafv))
  add(query_822084691, "$callback", newJString(Callback))
  add(path_822084690, "corpus", newJString(corpus))
  add(query_822084691, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084689.call(path_822084690, query_822084691, nil, nil, body_822084692)

var batchCreateChunks* = Call_BatchCreateChunks_822084678(
    name: "batchCreateChunks", meth: HttpMethod.HttpPost,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/corpora/{corpus}/documents/{document}/chunks:batchCreate",
    validator: validate_BatchCreateChunks_822084679, base: "/",
    makeUrl: url_BatchCreateChunks_822084680, schemes: {Scheme.Https})
type
  Call_BatchDeleteChunks_822084693 = ref object of OpenApiRestCall_822083972
proc url_BatchDeleteChunks_822084695(protocol: Scheme; host: string;
                                     base: string; route: string;
                                     path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "corpus" in path, "`corpus` is a required path parameter"
  assert "document" in path, "`document` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/corpora/"),
                 (kind: VariableSegment, value: "corpus"),
                 (kind: ConstantSegment, value: "/documents/"),
                 (kind: VariableSegment, value: "document"),
                 (kind: ConstantSegment, value: "/chunks:batchDelete")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BatchDeleteChunks_822084694(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Batch delete `Chunk`s.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   document: JString (required)
  ##           : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   corpus: JString (required)
  ##         : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `document` field"
  var valid_822084696 = path.getOrDefault("document")
  valid_822084696 = validateParameter(valid_822084696, JString, required = true,
                                      default = nil)
  if valid_822084696 != nil:
    section.add "document", valid_822084696
  var valid_822084697 = path.getOrDefault("corpus")
  valid_822084697 = validateParameter(valid_822084697, JString, required = true,
                                      default = nil)
  if valid_822084697 != nil:
    section.add "corpus", valid_822084697
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822084698 = query.getOrDefault("$alt")
  valid_822084698 = validateParameter(valid_822084698, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084698 != nil:
    section.add "$alt", valid_822084698
  var valid_822084699 = query.getOrDefault("$.xgafv")
  valid_822084699 = validateParameter(valid_822084699, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084699 != nil:
    section.add "$.xgafv", valid_822084699
  var valid_822084700 = query.getOrDefault("$callback")
  valid_822084700 = validateParameter(valid_822084700, JString,
                                      required = false, default = nil)
  if valid_822084700 != nil:
    section.add "$callback", valid_822084700
  var valid_822084701 = query.getOrDefault("$prettyPrint")
  valid_822084701 = validateParameter(valid_822084701, JBool, required = false,
                                      default = nil)
  if valid_822084701 != nil:
    section.add "$prettyPrint", valid_822084701
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  ##       : The request body.
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822084703: Call_BatchDeleteChunks_822084693;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Batch delete `Chunk`s.
  ## 
  let valid = call_822084703.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084703.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084703.makeUrl(scheme.get, call_822084703.host, call_822084703.base,
                                   call_822084703.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084703, uri, valid, content)

proc call*(call_822084704: Call_BatchDeleteChunks_822084693; document: string;
           corpus: string; Alt: string = "json"; body: JsonNode = nil;
           Xgafv: string = "1"; Callback: string = ""; PrettyPrint: bool = false): Recallable =
  ## batchDeleteChunks
  ## Batch delete `Chunk`s.
  ##   document: string (required)
  ##           : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   Alt: string
  ##      : Data format for response.
  ##   body: JObject
  ##       : The request body.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   corpus: string (required)
  ##         : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822084705 = newJObject()
  var query_822084706 = newJObject()
  var body_822084707 = newJObject()
  add(path_822084705, "document", newJString(document))
  add(query_822084706, "$alt", newJString(Alt))
  if body != nil:
    body_822084707 = body
  add(query_822084706, "$.xgafv", newJString(Xgafv))
  add(query_822084706, "$callback", newJString(Callback))
  add(path_822084705, "corpus", newJString(corpus))
  add(query_822084706, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084704.call(path_822084705, query_822084706, nil, nil, body_822084707)

var batchDeleteChunks* = Call_BatchDeleteChunks_822084693(
    name: "batchDeleteChunks", meth: HttpMethod.HttpPost,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/corpora/{corpus}/documents/{document}/chunks:batchDelete",
    validator: validate_BatchDeleteChunks_822084694, base: "/",
    makeUrl: url_BatchDeleteChunks_822084695, schemes: {Scheme.Https})
type
  Call_BatchUpdateChunks_822084708 = ref object of OpenApiRestCall_822083972
proc url_BatchUpdateChunks_822084710(protocol: Scheme; host: string;
                                     base: string; route: string;
                                     path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "corpus" in path, "`corpus` is a required path parameter"
  assert "document" in path, "`document` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/corpora/"),
                 (kind: VariableSegment, value: "corpus"),
                 (kind: ConstantSegment, value: "/documents/"),
                 (kind: VariableSegment, value: "document"),
                 (kind: ConstantSegment, value: "/chunks:batchUpdate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BatchUpdateChunks_822084709(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Batch update `Chunk`s.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   document: JString (required)
  ##           : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   corpus: JString (required)
  ##         : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `document` field"
  var valid_822084711 = path.getOrDefault("document")
  valid_822084711 = validateParameter(valid_822084711, JString, required = true,
                                      default = nil)
  if valid_822084711 != nil:
    section.add "document", valid_822084711
  var valid_822084712 = path.getOrDefault("corpus")
  valid_822084712 = validateParameter(valid_822084712, JString, required = true,
                                      default = nil)
  if valid_822084712 != nil:
    section.add "corpus", valid_822084712
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822084713 = query.getOrDefault("$alt")
  valid_822084713 = validateParameter(valid_822084713, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084713 != nil:
    section.add "$alt", valid_822084713
  var valid_822084714 = query.getOrDefault("$.xgafv")
  valid_822084714 = validateParameter(valid_822084714, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084714 != nil:
    section.add "$.xgafv", valid_822084714
  var valid_822084715 = query.getOrDefault("$callback")
  valid_822084715 = validateParameter(valid_822084715, JString,
                                      required = false, default = nil)
  if valid_822084715 != nil:
    section.add "$callback", valid_822084715
  var valid_822084716 = query.getOrDefault("$prettyPrint")
  valid_822084716 = validateParameter(valid_822084716, JBool, required = false,
                                      default = nil)
  if valid_822084716 != nil:
    section.add "$prettyPrint", valid_822084716
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  ##       : The request body.
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822084718: Call_BatchUpdateChunks_822084708;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Batch update `Chunk`s.
  ## 
  let valid = call_822084718.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084718.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084718.makeUrl(scheme.get, call_822084718.host, call_822084718.base,
                                   call_822084718.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084718, uri, valid, content)

proc call*(call_822084719: Call_BatchUpdateChunks_822084708; document: string;
           corpus: string; Alt: string = "json"; body: JsonNode = nil;
           Xgafv: string = "1"; Callback: string = ""; PrettyPrint: bool = false): Recallable =
  ## batchUpdateChunks
  ## Batch update `Chunk`s.
  ##   document: string (required)
  ##           : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   Alt: string
  ##      : Data format for response.
  ##   body: JObject
  ##       : The request body.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   corpus: string (required)
  ##         : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822084720 = newJObject()
  var query_822084721 = newJObject()
  var body_822084722 = newJObject()
  add(path_822084720, "document", newJString(document))
  add(query_822084721, "$alt", newJString(Alt))
  if body != nil:
    body_822084722 = body
  add(query_822084721, "$.xgafv", newJString(Xgafv))
  add(query_822084721, "$callback", newJString(Callback))
  add(path_822084720, "corpus", newJString(corpus))
  add(query_822084721, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084719.call(path_822084720, query_822084721, nil, nil, body_822084722)

var batchUpdateChunks* = Call_BatchUpdateChunks_822084708(
    name: "batchUpdateChunks", meth: HttpMethod.HttpPost,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/corpora/{corpus}/documents/{document}/chunks:batchUpdate",
    validator: validate_BatchUpdateChunks_822084709, base: "/",
    makeUrl: url_BatchUpdateChunks_822084710, schemes: {Scheme.Https})
type
  Call_QueryDocument_822084723 = ref object of OpenApiRestCall_822083972
proc url_QueryDocument_822084725(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "corpus" in path, "`corpus` is a required path parameter"
  assert "document" in path, "`document` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/corpora/"),
                 (kind: VariableSegment, value: "corpus"),
                 (kind: ConstantSegment, value: "/documents/"),
                 (kind: VariableSegment, value: "document"),
                 (kind: ConstantSegment, value: ":query")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_QueryDocument_822084724(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Performs semantic search over a `Document`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   document: JString (required)
  ##           : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   corpus: JString (required)
  ##         : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `document` field"
  var valid_822084726 = path.getOrDefault("document")
  valid_822084726 = validateParameter(valid_822084726, JString, required = true,
                                      default = nil)
  if valid_822084726 != nil:
    section.add "document", valid_822084726
  var valid_822084727 = path.getOrDefault("corpus")
  valid_822084727 = validateParameter(valid_822084727, JString, required = true,
                                      default = nil)
  if valid_822084727 != nil:
    section.add "corpus", valid_822084727
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822084728 = query.getOrDefault("$alt")
  valid_822084728 = validateParameter(valid_822084728, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084728 != nil:
    section.add "$alt", valid_822084728
  var valid_822084729 = query.getOrDefault("$.xgafv")
  valid_822084729 = validateParameter(valid_822084729, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084729 != nil:
    section.add "$.xgafv", valid_822084729
  var valid_822084730 = query.getOrDefault("$callback")
  valid_822084730 = validateParameter(valid_822084730, JString,
                                      required = false, default = nil)
  if valid_822084730 != nil:
    section.add "$callback", valid_822084730
  var valid_822084731 = query.getOrDefault("$prettyPrint")
  valid_822084731 = validateParameter(valid_822084731, JBool, required = false,
                                      default = nil)
  if valid_822084731 != nil:
    section.add "$prettyPrint", valid_822084731
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  ##       : The request body.
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822084733: Call_QueryDocument_822084723; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Performs semantic search over a `Document`.
  ## 
  let valid = call_822084733.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084733.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084733.makeUrl(scheme.get, call_822084733.host, call_822084733.base,
                                   call_822084733.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084733, uri, valid, content)

proc call*(call_822084734: Call_QueryDocument_822084723; document: string;
           corpus: string; Alt: string = "json"; body: JsonNode = nil;
           Xgafv: string = "1"; Callback: string = ""; PrettyPrint: bool = false): Recallable =
  ## queryDocument
  ## Performs semantic search over a `Document`.
  ##   document: string (required)
  ##           : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   Alt: string
  ##      : Data format for response.
  ##   body: JObject
  ##       : The request body.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   corpus: string (required)
  ##         : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822084735 = newJObject()
  var query_822084736 = newJObject()
  var body_822084737 = newJObject()
  add(path_822084735, "document", newJString(document))
  add(query_822084736, "$alt", newJString(Alt))
  if body != nil:
    body_822084737 = body
  add(query_822084736, "$.xgafv", newJString(Xgafv))
  add(query_822084736, "$callback", newJString(Callback))
  add(path_822084735, "corpus", newJString(corpus))
  add(query_822084736, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084734.call(path_822084735, query_822084736, nil, nil, body_822084737)

var queryDocument* = Call_QueryDocument_822084723(name: "queryDocument",
    meth: HttpMethod.HttpPost, host: "generativelanguage.googleapis.com",
    route: "/v1beta/corpora/{corpus}/documents/{document}:query",
    validator: validate_QueryDocument_822084724, base: "/",
    makeUrl: url_QueryDocument_822084725, schemes: {Scheme.Https})
type
  Call_GetOperationByCorpusAndOperation_822084738 = ref object of OpenApiRestCall_822083972
proc url_GetOperationByCorpusAndOperation_822084740(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "corpus" in path, "`corpus` is a required path parameter"
  assert "operation" in path, "`operation` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/corpora/"),
                 (kind: VariableSegment, value: "corpus"),
                 (kind: ConstantSegment, value: "/operations/"),
                 (kind: VariableSegment, value: "operation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GetOperationByCorpusAndOperation_822084739(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode;
    content: string = ""): JsonNode {.nosinks.} =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   corpus: JString (required)
  ##         : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   operation: JString (required)
  ##            : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `corpus` field"
  var valid_822084741 = path.getOrDefault("corpus")
  valid_822084741 = validateParameter(valid_822084741, JString, required = true,
                                      default = nil)
  if valid_822084741 != nil:
    section.add "corpus", valid_822084741
  var valid_822084742 = path.getOrDefault("operation")
  valid_822084742 = validateParameter(valid_822084742, JString, required = true,
                                      default = nil)
  if valid_822084742 != nil:
    section.add "operation", valid_822084742
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822084743 = query.getOrDefault("$alt")
  valid_822084743 = validateParameter(valid_822084743, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084743 != nil:
    section.add "$alt", valid_822084743
  var valid_822084744 = query.getOrDefault("$.xgafv")
  valid_822084744 = validateParameter(valid_822084744, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084744 != nil:
    section.add "$.xgafv", valid_822084744
  var valid_822084745 = query.getOrDefault("$callback")
  valid_822084745 = validateParameter(valid_822084745, JString,
                                      required = false, default = nil)
  if valid_822084745 != nil:
    section.add "$callback", valid_822084745
  var valid_822084746 = query.getOrDefault("$prettyPrint")
  valid_822084746 = validateParameter(valid_822084746, JBool, required = false,
                                      default = nil)
  if valid_822084746 != nil:
    section.add "$prettyPrint", valid_822084746
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084747: Call_GetOperationByCorpusAndOperation_822084738;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_822084747.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084747.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084747.makeUrl(scheme.get, call_822084747.host, call_822084747.base,
                                   call_822084747.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084747, uri, valid, content)

proc call*(call_822084748: Call_GetOperationByCorpusAndOperation_822084738;
           corpus: string; operation: string; Alt: string = "json";
           Xgafv: string = "1"; Callback: string = ""; PrettyPrint: bool = false): Recallable =
  ## getOperationByCorpusAndOperation
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ##   Alt: string
  ##      : Data format for response.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   corpus: string (required)
  ##         : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   operation: string (required)
  ##            : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822084749 = newJObject()
  var query_822084750 = newJObject()
  add(query_822084750, "$alt", newJString(Alt))
  add(query_822084750, "$.xgafv", newJString(Xgafv))
  add(query_822084750, "$callback", newJString(Callback))
  add(path_822084749, "corpus", newJString(corpus))
  add(path_822084749, "operation", newJString(operation))
  add(query_822084750, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084748.call(path_822084749, query_822084750, nil, nil, nil)

var getOperationByCorpusAndOperation* = Call_GetOperationByCorpusAndOperation_822084738(
    name: "getOperationByCorpusAndOperation", meth: HttpMethod.HttpGet,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/corpora/{corpus}/operations/{operation}",
    validator: validate_GetOperationByCorpusAndOperation_822084739, base: "/",
    makeUrl: url_GetOperationByCorpusAndOperation_822084740,
    schemes: {Scheme.Https})
type
  Call_CreatePermissionByCorpus_822084765 = ref object of OpenApiRestCall_822083972
proc url_CreatePermissionByCorpus_822084767(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "corpus" in path, "`corpus` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/corpora/"),
                 (kind: VariableSegment, value: "corpus"),
                 (kind: ConstantSegment, value: "/permissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CreatePermissionByCorpus_822084766(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode;
    content: string = ""): JsonNode {.nosinks.} =
  ## Create a permission to a specific resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   corpus: JString (required)
  ##         : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `corpus` field"
  var valid_822084768 = path.getOrDefault("corpus")
  valid_822084768 = validateParameter(valid_822084768, JString, required = true,
                                      default = nil)
  if valid_822084768 != nil:
    section.add "corpus", valid_822084768
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822084769 = query.getOrDefault("$alt")
  valid_822084769 = validateParameter(valid_822084769, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084769 != nil:
    section.add "$alt", valid_822084769
  var valid_822084770 = query.getOrDefault("$.xgafv")
  valid_822084770 = validateParameter(valid_822084770, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084770 != nil:
    section.add "$.xgafv", valid_822084770
  var valid_822084771 = query.getOrDefault("$callback")
  valid_822084771 = validateParameter(valid_822084771, JString,
                                      required = false, default = nil)
  if valid_822084771 != nil:
    section.add "$callback", valid_822084771
  var valid_822084772 = query.getOrDefault("$prettyPrint")
  valid_822084772 = validateParameter(valid_822084772, JBool, required = false,
                                      default = nil)
  if valid_822084772 != nil:
    section.add "$prettyPrint", valid_822084772
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  ##       : Required. The permission to create.
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822084774: Call_CreatePermissionByCorpus_822084765;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Create a permission to a specific resource.
  ## 
  let valid = call_822084774.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084774.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084774.makeUrl(scheme.get, call_822084774.host, call_822084774.base,
                                   call_822084774.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084774, uri, valid, content)

proc call*(call_822084775: Call_CreatePermissionByCorpus_822084765;
           corpus: string; Alt: string = "json"; body: JsonNode = nil;
           Xgafv: string = "1"; Callback: string = ""; PrettyPrint: bool = false): Recallable =
  ## createPermissionByCorpus
  ## Create a permission to a specific resource.
  ##   Alt: string
  ##      : Data format for response.
  ##   body: JObject
  ##       : Required. The permission to create.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   corpus: string (required)
  ##         : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822084776 = newJObject()
  var query_822084777 = newJObject()
  var body_822084778 = newJObject()
  add(query_822084777, "$alt", newJString(Alt))
  if body != nil:
    body_822084778 = body
  add(query_822084777, "$.xgafv", newJString(Xgafv))
  add(query_822084777, "$callback", newJString(Callback))
  add(path_822084776, "corpus", newJString(corpus))
  add(query_822084777, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084775.call(path_822084776, query_822084777, nil, nil, body_822084778)

var createPermissionByCorpus* = Call_CreatePermissionByCorpus_822084765(
    name: "createPermissionByCorpus", meth: HttpMethod.HttpPost,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/corpora/{corpus}/permissions",
    validator: validate_CreatePermissionByCorpus_822084766, base: "/",
    makeUrl: url_CreatePermissionByCorpus_822084767, schemes: {Scheme.Https})
type
  Call_ListPermissionsByCorpus_822084751 = ref object of OpenApiRestCall_822083972
proc url_ListPermissionsByCorpus_822084753(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "corpus" in path, "`corpus` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/corpora/"),
                 (kind: VariableSegment, value: "corpus"),
                 (kind: ConstantSegment, value: "/permissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ListPermissionsByCorpus_822084752(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Lists permissions for the specific resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   corpus: JString (required)
  ##         : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `corpus` field"
  var valid_822084754 = path.getOrDefault("corpus")
  valid_822084754 = validateParameter(valid_822084754, JString, required = true,
                                      default = nil)
  if valid_822084754 != nil:
    section.add "corpus", valid_822084754
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   pageSize: JInt
  ##           : Optional. The maximum number of `Permission`s to return (per page).
  ## The service may return fewer permissions.
  ## 
  ## If unspecified, at most 10 permissions will be returned.
  ## This method returns at most 1000 permissions per page, even if you pass
  ## larger page_size.
  ##   pageToken: JString
  ##            : Optional. A page token, received from a previous `ListPermissions` call.
  ## 
  ## Provide the `page_token` returned by one request as an argument to the
  ## next request to retrieve the next page.
  ## 
  ## When paginating, all other parameters provided to `ListPermissions`
  ## must match the call that provided the page token.
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822084755 = query.getOrDefault("$alt")
  valid_822084755 = validateParameter(valid_822084755, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084755 != nil:
    section.add "$alt", valid_822084755
  var valid_822084756 = query.getOrDefault("$.xgafv")
  valid_822084756 = validateParameter(valid_822084756, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084756 != nil:
    section.add "$.xgafv", valid_822084756
  var valid_822084757 = query.getOrDefault("$callback")
  valid_822084757 = validateParameter(valid_822084757, JString,
                                      required = false, default = nil)
  if valid_822084757 != nil:
    section.add "$callback", valid_822084757
  var valid_822084758 = query.getOrDefault("pageSize")
  valid_822084758 = validateParameter(valid_822084758, JInt, required = false,
                                      default = nil)
  if valid_822084758 != nil:
    section.add "pageSize", valid_822084758
  var valid_822084759 = query.getOrDefault("pageToken")
  valid_822084759 = validateParameter(valid_822084759, JString,
                                      required = false, default = nil)
  if valid_822084759 != nil:
    section.add "pageToken", valid_822084759
  var valid_822084760 = query.getOrDefault("$prettyPrint")
  valid_822084760 = validateParameter(valid_822084760, JBool, required = false,
                                      default = nil)
  if valid_822084760 != nil:
    section.add "$prettyPrint", valid_822084760
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084761: Call_ListPermissionsByCorpus_822084751;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Lists permissions for the specific resource.
  ## 
  let valid = call_822084761.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084761.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084761.makeUrl(scheme.get, call_822084761.host, call_822084761.base,
                                   call_822084761.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084761, uri, valid, content)

proc call*(call_822084762: Call_ListPermissionsByCorpus_822084751;
           corpus: string; Alt: string = "json"; Xgafv: string = "1";
           Callback: string = ""; pageSize: int = 0; pageToken: string = "";
           PrettyPrint: bool = false): Recallable =
  ## listPermissionsByCorpus
  ## Lists permissions for the specific resource.
  ##   Alt: string
  ##      : Data format for response.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   corpus: string (required)
  ##         : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   pageSize: int
  ##           : Optional. The maximum number of `Permission`s to return (per page).
  ## The service may return fewer permissions.
  ## 
  ## If unspecified, at most 10 permissions will be returned.
  ## This method returns at most 1000 permissions per page, even if you pass
  ## larger page_size.
  ##   pageToken: string
  ##            : Optional. A page token, received from a previous `ListPermissions` call.
  ## 
  ## Provide the `page_token` returned by one request as an argument to the
  ## next request to retrieve the next page.
  ## 
  ## When paginating, all other parameters provided to `ListPermissions`
  ## must match the call that provided the page token.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822084763 = newJObject()
  var query_822084764 = newJObject()
  add(query_822084764, "$alt", newJString(Alt))
  add(query_822084764, "$.xgafv", newJString(Xgafv))
  add(query_822084764, "$callback", newJString(Callback))
  add(path_822084763, "corpus", newJString(corpus))
  add(query_822084764, "pageSize", newJInt(pageSize))
  add(query_822084764, "pageToken", newJString(pageToken))
  add(query_822084764, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084762.call(path_822084763, query_822084764, nil, nil, nil)

var listPermissionsByCorpus* = Call_ListPermissionsByCorpus_822084751(
    name: "listPermissionsByCorpus", meth: HttpMethod.HttpGet,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/corpora/{corpus}/permissions",
    validator: validate_ListPermissionsByCorpus_822084752, base: "/",
    makeUrl: url_ListPermissionsByCorpus_822084753, schemes: {Scheme.Https})
type
  Call_DeletePermissionByCorpusAndPermission_822084792 = ref object of OpenApiRestCall_822083972
proc url_DeletePermissionByCorpusAndPermission_822084794(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "corpus" in path, "`corpus` is a required path parameter"
  assert "permission" in path, "`permission` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/corpora/"),
                 (kind: VariableSegment, value: "corpus"),
                 (kind: ConstantSegment, value: "/permissions/"),
                 (kind: VariableSegment, value: "permission")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DeletePermissionByCorpusAndPermission_822084793(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode;
    content: string = ""): JsonNode {.nosinks.} =
  ## Deletes the permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   permission: JString (required)
  ##             : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   corpus: JString (required)
  ##         : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `permission` field"
  var valid_822084795 = path.getOrDefault("permission")
  valid_822084795 = validateParameter(valid_822084795, JString, required = true,
                                      default = nil)
  if valid_822084795 != nil:
    section.add "permission", valid_822084795
  var valid_822084796 = path.getOrDefault("corpus")
  valid_822084796 = validateParameter(valid_822084796, JString, required = true,
                                      default = nil)
  if valid_822084796 != nil:
    section.add "corpus", valid_822084796
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822084797 = query.getOrDefault("$alt")
  valid_822084797 = validateParameter(valid_822084797, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084797 != nil:
    section.add "$alt", valid_822084797
  var valid_822084798 = query.getOrDefault("$.xgafv")
  valid_822084798 = validateParameter(valid_822084798, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084798 != nil:
    section.add "$.xgafv", valid_822084798
  var valid_822084799 = query.getOrDefault("$callback")
  valid_822084799 = validateParameter(valid_822084799, JString,
                                      required = false, default = nil)
  if valid_822084799 != nil:
    section.add "$callback", valid_822084799
  var valid_822084800 = query.getOrDefault("$prettyPrint")
  valid_822084800 = validateParameter(valid_822084800, JBool, required = false,
                                      default = nil)
  if valid_822084800 != nil:
    section.add "$prettyPrint", valid_822084800
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084801: Call_DeletePermissionByCorpusAndPermission_822084792;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Deletes the permission.
  ## 
  let valid = call_822084801.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084801.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084801.makeUrl(scheme.get, call_822084801.host, call_822084801.base,
                                   call_822084801.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084801, uri, valid, content)

proc call*(call_822084802: Call_DeletePermissionByCorpusAndPermission_822084792;
           permission: string; corpus: string; Alt: string = "json";
           Xgafv: string = "1"; Callback: string = ""; PrettyPrint: bool = false): Recallable =
  ## deletePermissionByCorpusAndPermission
  ## Deletes the permission.
  ##   permission: string (required)
  ##             : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   Alt: string
  ##      : Data format for response.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   corpus: string (required)
  ##         : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822084803 = newJObject()
  var query_822084804 = newJObject()
  add(path_822084803, "permission", newJString(permission))
  add(query_822084804, "$alt", newJString(Alt))
  add(query_822084804, "$.xgafv", newJString(Xgafv))
  add(query_822084804, "$callback", newJString(Callback))
  add(path_822084803, "corpus", newJString(corpus))
  add(query_822084804, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084802.call(path_822084803, query_822084804, nil, nil, nil)

var deletePermissionByCorpusAndPermission* = Call_DeletePermissionByCorpusAndPermission_822084792(
    name: "deletePermissionByCorpusAndPermission", meth: HttpMethod.HttpDelete,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/corpora/{corpus}/permissions/{permission}",
    validator: validate_DeletePermissionByCorpusAndPermission_822084793,
    base: "/", makeUrl: url_DeletePermissionByCorpusAndPermission_822084794,
    schemes: {Scheme.Https})
type
  Call_GetPermissionByCorpusAndPermission_822084779 = ref object of OpenApiRestCall_822083972
proc url_GetPermissionByCorpusAndPermission_822084781(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "corpus" in path, "`corpus` is a required path parameter"
  assert "permission" in path, "`permission` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/corpora/"),
                 (kind: VariableSegment, value: "corpus"),
                 (kind: ConstantSegment, value: "/permissions/"),
                 (kind: VariableSegment, value: "permission")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GetPermissionByCorpusAndPermission_822084780(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode;
    content: string = ""): JsonNode {.nosinks.} =
  ## Gets information about a specific Permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   permission: JString (required)
  ##             : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   corpus: JString (required)
  ##         : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `permission` field"
  var valid_822084782 = path.getOrDefault("permission")
  valid_822084782 = validateParameter(valid_822084782, JString, required = true,
                                      default = nil)
  if valid_822084782 != nil:
    section.add "permission", valid_822084782
  var valid_822084783 = path.getOrDefault("corpus")
  valid_822084783 = validateParameter(valid_822084783, JString, required = true,
                                      default = nil)
  if valid_822084783 != nil:
    section.add "corpus", valid_822084783
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822084784 = query.getOrDefault("$alt")
  valid_822084784 = validateParameter(valid_822084784, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084784 != nil:
    section.add "$alt", valid_822084784
  var valid_822084785 = query.getOrDefault("$.xgafv")
  valid_822084785 = validateParameter(valid_822084785, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084785 != nil:
    section.add "$.xgafv", valid_822084785
  var valid_822084786 = query.getOrDefault("$callback")
  valid_822084786 = validateParameter(valid_822084786, JString,
                                      required = false, default = nil)
  if valid_822084786 != nil:
    section.add "$callback", valid_822084786
  var valid_822084787 = query.getOrDefault("$prettyPrint")
  valid_822084787 = validateParameter(valid_822084787, JBool, required = false,
                                      default = nil)
  if valid_822084787 != nil:
    section.add "$prettyPrint", valid_822084787
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084788: Call_GetPermissionByCorpusAndPermission_822084779;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Gets information about a specific Permission.
  ## 
  let valid = call_822084788.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084788.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084788.makeUrl(scheme.get, call_822084788.host, call_822084788.base,
                                   call_822084788.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084788, uri, valid, content)

proc call*(call_822084789: Call_GetPermissionByCorpusAndPermission_822084779;
           permission: string; corpus: string; Alt: string = "json";
           Xgafv: string = "1"; Callback: string = ""; PrettyPrint: bool = false): Recallable =
  ## getPermissionByCorpusAndPermission
  ## Gets information about a specific Permission.
  ##   permission: string (required)
  ##             : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   Alt: string
  ##      : Data format for response.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   corpus: string (required)
  ##         : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822084790 = newJObject()
  var query_822084791 = newJObject()
  add(path_822084790, "permission", newJString(permission))
  add(query_822084791, "$alt", newJString(Alt))
  add(query_822084791, "$.xgafv", newJString(Xgafv))
  add(query_822084791, "$callback", newJString(Callback))
  add(path_822084790, "corpus", newJString(corpus))
  add(query_822084791, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084789.call(path_822084790, query_822084791, nil, nil, nil)

var getPermissionByCorpusAndPermission* = Call_GetPermissionByCorpusAndPermission_822084779(
    name: "getPermissionByCorpusAndPermission", meth: HttpMethod.HttpGet,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/corpora/{corpus}/permissions/{permission}",
    validator: validate_GetPermissionByCorpusAndPermission_822084780, base: "/",
    makeUrl: url_GetPermissionByCorpusAndPermission_822084781,
    schemes: {Scheme.Https})
type
  Call_UpdatePermissionByCorpusAndPermission_822084805 = ref object of OpenApiRestCall_822083972
proc url_UpdatePermissionByCorpusAndPermission_822084807(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "corpus" in path, "`corpus` is a required path parameter"
  assert "permission" in path, "`permission` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/corpora/"),
                 (kind: VariableSegment, value: "corpus"),
                 (kind: ConstantSegment, value: "/permissions/"),
                 (kind: VariableSegment, value: "permission")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_UpdatePermissionByCorpusAndPermission_822084806(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode;
    content: string = ""): JsonNode {.nosinks.} =
  ## Updates the permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   permission: JString (required)
  ##             : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   corpus: JString (required)
  ##         : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `permission` field"
  var valid_822084808 = path.getOrDefault("permission")
  valid_822084808 = validateParameter(valid_822084808, JString, required = true,
                                      default = nil)
  if valid_822084808 != nil:
    section.add "permission", valid_822084808
  var valid_822084809 = path.getOrDefault("corpus")
  valid_822084809 = validateParameter(valid_822084809, JString, required = true,
                                      default = nil)
  if valid_822084809 != nil:
    section.add "corpus", valid_822084809
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   updateMask: JString (required)
  ##             : Required. The list of fields to update. Accepted ones:
  ##  - role (`Permission.role` field)
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822084810 = query.getOrDefault("$alt")
  valid_822084810 = validateParameter(valid_822084810, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084810 != nil:
    section.add "$alt", valid_822084810
  assert query != nil,
         "query argument is necessary due to required `updateMask` field"
  var valid_822084811 = query.getOrDefault("updateMask")
  valid_822084811 = validateParameter(valid_822084811, JString, required = true,
                                      default = nil)
  if valid_822084811 != nil:
    section.add "updateMask", valid_822084811
  var valid_822084812 = query.getOrDefault("$.xgafv")
  valid_822084812 = validateParameter(valid_822084812, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084812 != nil:
    section.add "$.xgafv", valid_822084812
  var valid_822084813 = query.getOrDefault("$callback")
  valid_822084813 = validateParameter(valid_822084813, JString,
                                      required = false, default = nil)
  if valid_822084813 != nil:
    section.add "$callback", valid_822084813
  var valid_822084814 = query.getOrDefault("$prettyPrint")
  valid_822084814 = validateParameter(valid_822084814, JBool, required = false,
                                      default = nil)
  if valid_822084814 != nil:
    section.add "$prettyPrint", valid_822084814
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  ##       : Required. The permission to update.
  ## 
  ## The permission's `name` field is used to identify the permission to update.
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822084816: Call_UpdatePermissionByCorpusAndPermission_822084805;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Updates the permission.
  ## 
  let valid = call_822084816.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084816.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084816.makeUrl(scheme.get, call_822084816.host, call_822084816.base,
                                   call_822084816.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084816, uri, valid, content)

proc call*(call_822084817: Call_UpdatePermissionByCorpusAndPermission_822084805;
           permission: string; updateMask: string; corpus: string;
           Alt: string = "json"; body: JsonNode = nil; Xgafv: string = "1";
           Callback: string = ""; PrettyPrint: bool = false): Recallable =
  ## updatePermissionByCorpusAndPermission
  ## Updates the permission.
  ##   permission: string (required)
  ##             : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   Alt: string
  ##      : Data format for response.
  ##   body: JObject
  ##       : Required. The permission to update.
  ## 
  ## The permission's `name` field is used to identify the permission to update.
  ##   updateMask: string (required)
  ##             : Required. The list of fields to update. Accepted ones:
  ##  - role (`Permission.role` field)
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   corpus: string (required)
  ##         : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822084818 = newJObject()
  var query_822084819 = newJObject()
  var body_822084820 = newJObject()
  add(path_822084818, "permission", newJString(permission))
  add(query_822084819, "$alt", newJString(Alt))
  if body != nil:
    body_822084820 = body
  add(query_822084819, "updateMask", newJString(updateMask))
  add(query_822084819, "$.xgafv", newJString(Xgafv))
  add(query_822084819, "$callback", newJString(Callback))
  add(path_822084818, "corpus", newJString(corpus))
  add(query_822084819, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084817.call(path_822084818, query_822084819, nil, nil, body_822084820)

var updatePermissionByCorpusAndPermission* = Call_UpdatePermissionByCorpusAndPermission_822084805(
    name: "updatePermissionByCorpusAndPermission", meth: HttpMethod.HttpPatch,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/corpora/{corpus}/permissions/{permission}",
    validator: validate_UpdatePermissionByCorpusAndPermission_822084806,
    base: "/", makeUrl: url_UpdatePermissionByCorpusAndPermission_822084807,
    schemes: {Scheme.Https})
type
  Call_QueryCorpus_822084821 = ref object of OpenApiRestCall_822083972
proc url_QueryCorpus_822084823(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "corpus" in path, "`corpus` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/corpora/"),
                 (kind: VariableSegment, value: "corpus"),
                 (kind: ConstantSegment, value: ":query")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_QueryCorpus_822084822(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Performs semantic search over a `Corpus`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   corpus: JString (required)
  ##         : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `corpus` field"
  var valid_822084824 = path.getOrDefault("corpus")
  valid_822084824 = validateParameter(valid_822084824, JString, required = true,
                                      default = nil)
  if valid_822084824 != nil:
    section.add "corpus", valid_822084824
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822084825 = query.getOrDefault("$alt")
  valid_822084825 = validateParameter(valid_822084825, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084825 != nil:
    section.add "$alt", valid_822084825
  var valid_822084826 = query.getOrDefault("$.xgafv")
  valid_822084826 = validateParameter(valid_822084826, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084826 != nil:
    section.add "$.xgafv", valid_822084826
  var valid_822084827 = query.getOrDefault("$callback")
  valid_822084827 = validateParameter(valid_822084827, JString,
                                      required = false, default = nil)
  if valid_822084827 != nil:
    section.add "$callback", valid_822084827
  var valid_822084828 = query.getOrDefault("$prettyPrint")
  valid_822084828 = validateParameter(valid_822084828, JBool, required = false,
                                      default = nil)
  if valid_822084828 != nil:
    section.add "$prettyPrint", valid_822084828
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  ##       : The request body.
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822084830: Call_QueryCorpus_822084821; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Performs semantic search over a `Corpus`.
  ## 
  let valid = call_822084830.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084830.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084830.makeUrl(scheme.get, call_822084830.host, call_822084830.base,
                                   call_822084830.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084830, uri, valid, content)

proc call*(call_822084831: Call_QueryCorpus_822084821; corpus: string;
           Alt: string = "json"; body: JsonNode = nil; Xgafv: string = "1";
           Callback: string = ""; PrettyPrint: bool = false): Recallable =
  ## queryCorpus
  ## Performs semantic search over a `Corpus`.
  ##   Alt: string
  ##      : Data format for response.
  ##   body: JObject
  ##       : The request body.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   corpus: string (required)
  ##         : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822084832 = newJObject()
  var query_822084833 = newJObject()
  var body_822084834 = newJObject()
  add(query_822084833, "$alt", newJString(Alt))
  if body != nil:
    body_822084834 = body
  add(query_822084833, "$.xgafv", newJString(Xgafv))
  add(query_822084833, "$callback", newJString(Callback))
  add(path_822084832, "corpus", newJString(corpus))
  add(query_822084833, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084831.call(path_822084832, query_822084833, nil, nil, body_822084834)

var queryCorpus* = Call_QueryCorpus_822084821(name: "queryCorpus",
    meth: HttpMethod.HttpPost, host: "generativelanguage.googleapis.com",
    route: "/v1beta/corpora/{corpus}:query", validator: validate_QueryCorpus_822084822,
    base: "/", makeUrl: url_QueryCorpus_822084823, schemes: {Scheme.Https})
type
  Call_GenerateContentByDynamicId_822084835 = ref object of OpenApiRestCall_822083972
proc url_GenerateContentByDynamicId_822084837(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "dynamicId" in path, "`dynamicId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/dynamic/"),
                 (kind: VariableSegment, value: "dynamicId"),
                 (kind: ConstantSegment, value: ":generateContent")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GenerateContentByDynamicId_822084836(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode;
    content: string = ""): JsonNode {.nosinks.} =
  ## Generates a model response given an input `GenerateContentRequest`.
  ## Refer to the [text generation
  ## guide](https://ai.google.dev/gemini-api/docs/text-generation) for detailed
  ## usage information. Input capabilities differ between models, including
  ## tuned models. Refer to the [model
  ## guide](https://ai.google.dev/gemini-api/docs/models/gemini) and [tuning
  ## guide](https://ai.google.dev/gemini-api/docs/model-tuning) for details.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   dynamicId: JString (required)
  ##            : Part of `model`. Required. The name of the `Model` to use for generating the completion.
  ## 
  ## Format: `models/{model}`.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `dynamicId` field"
  var valid_822084838 = path.getOrDefault("dynamicId")
  valid_822084838 = validateParameter(valid_822084838, JString, required = true,
                                      default = nil)
  if valid_822084838 != nil:
    section.add "dynamicId", valid_822084838
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822084839 = query.getOrDefault("$alt")
  valid_822084839 = validateParameter(valid_822084839, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084839 != nil:
    section.add "$alt", valid_822084839
  var valid_822084840 = query.getOrDefault("$.xgafv")
  valid_822084840 = validateParameter(valid_822084840, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084840 != nil:
    section.add "$.xgafv", valid_822084840
  var valid_822084841 = query.getOrDefault("$callback")
  valid_822084841 = validateParameter(valid_822084841, JString,
                                      required = false, default = nil)
  if valid_822084841 != nil:
    section.add "$callback", valid_822084841
  var valid_822084842 = query.getOrDefault("$prettyPrint")
  valid_822084842 = validateParameter(valid_822084842, JBool, required = false,
                                      default = nil)
  if valid_822084842 != nil:
    section.add "$prettyPrint", valid_822084842
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  ##       : The request body.
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822084844: Call_GenerateContentByDynamicId_822084835;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Generates a model response given an input `GenerateContentRequest`.
  ## Refer to the [text generation
  ## guide](https://ai.google.dev/gemini-api/docs/text-generation) for detailed
  ## usage information. Input capabilities differ between models, including
  ## tuned models. Refer to the [model
  ## guide](https://ai.google.dev/gemini-api/docs/models/gemini) and [tuning
  ## guide](https://ai.google.dev/gemini-api/docs/model-tuning) for details.
  ## 
  let valid = call_822084844.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084844.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084844.makeUrl(scheme.get, call_822084844.host, call_822084844.base,
                                   call_822084844.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084844, uri, valid, content)

proc call*(call_822084845: Call_GenerateContentByDynamicId_822084835;
           dynamicId: string; Alt: string = "json"; body: JsonNode = nil;
           Xgafv: string = "1"; Callback: string = ""; PrettyPrint: bool = false): Recallable =
  ## generateContentByDynamicId
  ## Generates a model response given an input `GenerateContentRequest`.
  ## Refer to the [text generation
  ## guide](https://ai.google.dev/gemini-api/docs/text-generation) for detailed
  ## usage information. Input capabilities differ between models, including
  ## tuned models. Refer to the [model
  ## guide](https://ai.google.dev/gemini-api/docs/models/gemini) and [tuning
  ## guide](https://ai.google.dev/gemini-api/docs/model-tuning) for details.
  ##   dynamicId: string (required)
  ##            : Part of `model`. Required. The name of the `Model` to use for generating the completion.
  ## 
  ## Format: `models/{model}`.
  ##   Alt: string
  ##      : Data format for response.
  ##   body: JObject
  ##       : The request body.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822084846 = newJObject()
  var query_822084847 = newJObject()
  var body_822084848 = newJObject()
  add(path_822084846, "dynamicId", newJString(dynamicId))
  add(query_822084847, "$alt", newJString(Alt))
  if body != nil:
    body_822084848 = body
  add(query_822084847, "$.xgafv", newJString(Xgafv))
  add(query_822084847, "$callback", newJString(Callback))
  add(query_822084847, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084845.call(path_822084846, query_822084847, nil, nil, body_822084848)

var generateContentByDynamicId* = Call_GenerateContentByDynamicId_822084835(
    name: "generateContentByDynamicId", meth: HttpMethod.HttpPost,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/dynamic/{dynamicId}:generateContent",
    validator: validate_GenerateContentByDynamicId_822084836, base: "/",
    makeUrl: url_GenerateContentByDynamicId_822084837, schemes: {Scheme.Https})
type
  Call_StreamGenerateContentByDynamicId_822084849 = ref object of OpenApiRestCall_822083972
proc url_StreamGenerateContentByDynamicId_822084851(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "dynamicId" in path, "`dynamicId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/dynamic/"),
                 (kind: VariableSegment, value: "dynamicId"),
                 (kind: ConstantSegment, value: ":streamGenerateContent")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StreamGenerateContentByDynamicId_822084850(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode;
    content: string = ""): JsonNode {.nosinks.} =
  ## Generates a [streamed
  ## response](https://ai.google.dev/gemini-api/docs/text-generation?lang=python#generate-a-text-stream)
  ## from the model given an input `GenerateContentRequest`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   dynamicId: JString (required)
  ##            : Part of `model`. Required. The name of the `Model` to use for generating the completion.
  ## 
  ## Format: `models/{model}`.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `dynamicId` field"
  var valid_822084852 = path.getOrDefault("dynamicId")
  valid_822084852 = validateParameter(valid_822084852, JString, required = true,
                                      default = nil)
  if valid_822084852 != nil:
    section.add "dynamicId", valid_822084852
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822084853 = query.getOrDefault("$alt")
  valid_822084853 = validateParameter(valid_822084853, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084853 != nil:
    section.add "$alt", valid_822084853
  var valid_822084854 = query.getOrDefault("$.xgafv")
  valid_822084854 = validateParameter(valid_822084854, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084854 != nil:
    section.add "$.xgafv", valid_822084854
  var valid_822084855 = query.getOrDefault("$callback")
  valid_822084855 = validateParameter(valid_822084855, JString,
                                      required = false, default = nil)
  if valid_822084855 != nil:
    section.add "$callback", valid_822084855
  var valid_822084856 = query.getOrDefault("$prettyPrint")
  valid_822084856 = validateParameter(valid_822084856, JBool, required = false,
                                      default = nil)
  if valid_822084856 != nil:
    section.add "$prettyPrint", valid_822084856
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  ##       : The request body.
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822084858: Call_StreamGenerateContentByDynamicId_822084849;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Generates a [streamed
  ## response](https://ai.google.dev/gemini-api/docs/text-generation?lang=python#generate-a-text-stream)
  ## from the model given an input `GenerateContentRequest`.
  ## 
  let valid = call_822084858.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084858.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084858.makeUrl(scheme.get, call_822084858.host, call_822084858.base,
                                   call_822084858.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084858, uri, valid, content)

proc call*(call_822084859: Call_StreamGenerateContentByDynamicId_822084849;
           dynamicId: string; Alt: string = "json"; body: JsonNode = nil;
           Xgafv: string = "1"; Callback: string = ""; PrettyPrint: bool = false): Recallable =
  ## streamGenerateContentByDynamicId
  ## Generates a [streamed
  ## response](https://ai.google.dev/gemini-api/docs/text-generation?lang=python#generate-a-text-stream)
  ## from the model given an input `GenerateContentRequest`.
  ##   dynamicId: string (required)
  ##            : Part of `model`. Required. The name of the `Model` to use for generating the completion.
  ## 
  ## Format: `models/{model}`.
  ##   Alt: string
  ##      : Data format for response.
  ##   body: JObject
  ##       : The request body.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822084860 = newJObject()
  var query_822084861 = newJObject()
  var body_822084862 = newJObject()
  add(path_822084860, "dynamicId", newJString(dynamicId))
  add(query_822084861, "$alt", newJString(Alt))
  if body != nil:
    body_822084862 = body
  add(query_822084861, "$.xgafv", newJString(Xgafv))
  add(query_822084861, "$callback", newJString(Callback))
  add(query_822084861, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084859.call(path_822084860, query_822084861, nil, nil, body_822084862)

var streamGenerateContentByDynamicId* = Call_StreamGenerateContentByDynamicId_822084849(
    name: "streamGenerateContentByDynamicId", meth: HttpMethod.HttpPost,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/dynamic/{dynamicId}:streamGenerateContent",
    validator: validate_StreamGenerateContentByDynamicId_822084850, base: "/",
    makeUrl: url_StreamGenerateContentByDynamicId_822084851,
    schemes: {Scheme.Https})
type
  Call_CreateFile_822084875 = ref object of OpenApiRestCall_822083972
proc url_CreateFile_822084877(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CreateFile_822084876(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Creates a `File`.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822084878 = query.getOrDefault("$alt")
  valid_822084878 = validateParameter(valid_822084878, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084878 != nil:
    section.add "$alt", valid_822084878
  var valid_822084879 = query.getOrDefault("$.xgafv")
  valid_822084879 = validateParameter(valid_822084879, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084879 != nil:
    section.add "$.xgafv", valid_822084879
  var valid_822084880 = query.getOrDefault("$callback")
  valid_822084880 = validateParameter(valid_822084880, JString,
                                      required = false, default = nil)
  if valid_822084880 != nil:
    section.add "$callback", valid_822084880
  var valid_822084881 = query.getOrDefault("$prettyPrint")
  valid_822084881 = validateParameter(valid_822084881, JBool, required = false,
                                      default = nil)
  if valid_822084881 != nil:
    section.add "$prettyPrint", valid_822084881
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  ##       : The request body.
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822084883: Call_CreateFile_822084875; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Creates a `File`.
  ## 
  let valid = call_822084883.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084883.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084883.makeUrl(scheme.get, call_822084883.host, call_822084883.base,
                                   call_822084883.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084883, uri, valid, content)

proc call*(call_822084884: Call_CreateFile_822084875; Alt: string = "json";
           body: JsonNode = nil; Xgafv: string = "1"; Callback: string = "";
           PrettyPrint: bool = false): Recallable =
  ## createFile
  ## Creates a `File`.
  ##   Alt: string
  ##      : Data format for response.
  ##   body: JObject
  ##       : The request body.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_822084885 = newJObject()
  var body_822084886 = newJObject()
  add(query_822084885, "$alt", newJString(Alt))
  if body != nil:
    body_822084886 = body
  add(query_822084885, "$.xgafv", newJString(Xgafv))
  add(query_822084885, "$callback", newJString(Callback))
  add(query_822084885, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084884.call(nil, query_822084885, nil, nil, body_822084886)

var createFile* = Call_CreateFile_822084875(name: "createFile",
    meth: HttpMethod.HttpPost, host: "generativelanguage.googleapis.com",
    route: "/v1beta/files", validator: validate_CreateFile_822084876, base: "/",
    makeUrl: url_CreateFile_822084877, schemes: {Scheme.Https})
type
  Call_ListFiles_822084863 = ref object of OpenApiRestCall_822083972
proc url_ListFiles_822084865(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_ListFiles_822084864(path: JsonNode; query: JsonNode;
                                  header: JsonNode; formData: JsonNode;
                                  body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Lists the metadata for `File`s owned by the requesting project.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   pageSize: JInt
  ##           : Optional. Maximum number of `File`s to return per page.
  ## If unspecified, defaults to 10. Maximum `page_size` is 100.
  ##   pageToken: JString
  ##            : Optional. A page token from a previous `ListFiles` call.
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822084866 = query.getOrDefault("$alt")
  valid_822084866 = validateParameter(valid_822084866, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084866 != nil:
    section.add "$alt", valid_822084866
  var valid_822084867 = query.getOrDefault("$.xgafv")
  valid_822084867 = validateParameter(valid_822084867, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084867 != nil:
    section.add "$.xgafv", valid_822084867
  var valid_822084868 = query.getOrDefault("$callback")
  valid_822084868 = validateParameter(valid_822084868, JString,
                                      required = false, default = nil)
  if valid_822084868 != nil:
    section.add "$callback", valid_822084868
  var valid_822084869 = query.getOrDefault("pageSize")
  valid_822084869 = validateParameter(valid_822084869, JInt, required = false,
                                      default = nil)
  if valid_822084869 != nil:
    section.add "pageSize", valid_822084869
  var valid_822084870 = query.getOrDefault("pageToken")
  valid_822084870 = validateParameter(valid_822084870, JString,
                                      required = false, default = nil)
  if valid_822084870 != nil:
    section.add "pageToken", valid_822084870
  var valid_822084871 = query.getOrDefault("$prettyPrint")
  valid_822084871 = validateParameter(valid_822084871, JBool, required = false,
                                      default = nil)
  if valid_822084871 != nil:
    section.add "$prettyPrint", valid_822084871
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084872: Call_ListFiles_822084863; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Lists the metadata for `File`s owned by the requesting project.
  ## 
  let valid = call_822084872.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084872.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084872.makeUrl(scheme.get, call_822084872.host, call_822084872.base,
                                   call_822084872.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084872, uri, valid, content)

proc call*(call_822084873: Call_ListFiles_822084863; Alt: string = "json";
           Xgafv: string = "1"; Callback: string = ""; pageSize: int = 0;
           pageToken: string = ""; PrettyPrint: bool = false): Recallable =
  ## listFiles
  ## Lists the metadata for `File`s owned by the requesting project.
  ##   Alt: string
  ##      : Data format for response.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   pageSize: int
  ##           : Optional. Maximum number of `File`s to return per page.
  ## If unspecified, defaults to 10. Maximum `page_size` is 100.
  ##   pageToken: string
  ##            : Optional. A page token from a previous `ListFiles` call.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_822084874 = newJObject()
  add(query_822084874, "$alt", newJString(Alt))
  add(query_822084874, "$.xgafv", newJString(Xgafv))
  add(query_822084874, "$callback", newJString(Callback))
  add(query_822084874, "pageSize", newJInt(pageSize))
  add(query_822084874, "pageToken", newJString(pageToken))
  add(query_822084874, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084873.call(nil, query_822084874, nil, nil, nil)

var listFiles* = Call_ListFiles_822084863(name: "listFiles",
    meth: HttpMethod.HttpGet, host: "generativelanguage.googleapis.com",
    route: "/v1beta/files", validator: validate_ListFiles_822084864, base: "/",
    makeUrl: url_ListFiles_822084865, schemes: {Scheme.Https})
type
  Call_DeleteFile_822084899 = ref object of OpenApiRestCall_822083972
proc url_DeleteFile_822084901(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "file" in path, "`file` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/files/"),
                 (kind: VariableSegment, value: "file")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DeleteFile_822084900(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Deletes the `File`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   file: JString (required)
  ##       : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `file` field"
  var valid_822084902 = path.getOrDefault("file")
  valid_822084902 = validateParameter(valid_822084902, JString, required = true,
                                      default = nil)
  if valid_822084902 != nil:
    section.add "file", valid_822084902
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822084903 = query.getOrDefault("$alt")
  valid_822084903 = validateParameter(valid_822084903, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084903 != nil:
    section.add "$alt", valid_822084903
  var valid_822084904 = query.getOrDefault("$.xgafv")
  valid_822084904 = validateParameter(valid_822084904, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084904 != nil:
    section.add "$.xgafv", valid_822084904
  var valid_822084905 = query.getOrDefault("$callback")
  valid_822084905 = validateParameter(valid_822084905, JString,
                                      required = false, default = nil)
  if valid_822084905 != nil:
    section.add "$callback", valid_822084905
  var valid_822084906 = query.getOrDefault("$prettyPrint")
  valid_822084906 = validateParameter(valid_822084906, JBool, required = false,
                                      default = nil)
  if valid_822084906 != nil:
    section.add "$prettyPrint", valid_822084906
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084907: Call_DeleteFile_822084899; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Deletes the `File`.
  ## 
  let valid = call_822084907.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084907.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084907.makeUrl(scheme.get, call_822084907.host, call_822084907.base,
                                   call_822084907.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084907, uri, valid, content)

proc call*(call_822084908: Call_DeleteFile_822084899; file: string;
           Alt: string = "json"; Xgafv: string = "1"; Callback: string = "";
           PrettyPrint: bool = false): Recallable =
  ## deleteFile
  ## Deletes the `File`.
  ##   Alt: string
  ##      : Data format for response.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   file: string (required)
  ##       : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822084909 = newJObject()
  var query_822084910 = newJObject()
  add(query_822084910, "$alt", newJString(Alt))
  add(query_822084910, "$.xgafv", newJString(Xgafv))
  add(query_822084910, "$callback", newJString(Callback))
  add(path_822084909, "file", newJString(file))
  add(query_822084910, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084908.call(path_822084909, query_822084910, nil, nil, nil)

var deleteFile* = Call_DeleteFile_822084899(name: "deleteFile",
    meth: HttpMethod.HttpDelete, host: "generativelanguage.googleapis.com",
    route: "/v1beta/files/{file}", validator: validate_DeleteFile_822084900,
    base: "/", makeUrl: url_DeleteFile_822084901, schemes: {Scheme.Https})
type
  Call_GetFile_822084887 = ref object of OpenApiRestCall_822083972
proc url_GetFile_822084889(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "file" in path, "`file` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/files/"),
                 (kind: VariableSegment, value: "file")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GetFile_822084888(path: JsonNode; query: JsonNode;
                                header: JsonNode; formData: JsonNode;
                                body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Gets the metadata for the given `File`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   file: JString (required)
  ##       : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `file` field"
  var valid_822084890 = path.getOrDefault("file")
  valid_822084890 = validateParameter(valid_822084890, JString, required = true,
                                      default = nil)
  if valid_822084890 != nil:
    section.add "file", valid_822084890
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822084891 = query.getOrDefault("$alt")
  valid_822084891 = validateParameter(valid_822084891, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084891 != nil:
    section.add "$alt", valid_822084891
  var valid_822084892 = query.getOrDefault("$.xgafv")
  valid_822084892 = validateParameter(valid_822084892, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084892 != nil:
    section.add "$.xgafv", valid_822084892
  var valid_822084893 = query.getOrDefault("$callback")
  valid_822084893 = validateParameter(valid_822084893, JString,
                                      required = false, default = nil)
  if valid_822084893 != nil:
    section.add "$callback", valid_822084893
  var valid_822084894 = query.getOrDefault("$prettyPrint")
  valid_822084894 = validateParameter(valid_822084894, JBool, required = false,
                                      default = nil)
  if valid_822084894 != nil:
    section.add "$prettyPrint", valid_822084894
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084895: Call_GetFile_822084887; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Gets the metadata for the given `File`.
  ## 
  let valid = call_822084895.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084895.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084895.makeUrl(scheme.get, call_822084895.host, call_822084895.base,
                                   call_822084895.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084895, uri, valid, content)

proc call*(call_822084896: Call_GetFile_822084887; file: string;
           Alt: string = "json"; Xgafv: string = "1"; Callback: string = "";
           PrettyPrint: bool = false): Recallable =
  ## getFile
  ## Gets the metadata for the given `File`.
  ##   Alt: string
  ##      : Data format for response.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   file: string (required)
  ##       : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822084897 = newJObject()
  var query_822084898 = newJObject()
  add(query_822084898, "$alt", newJString(Alt))
  add(query_822084898, "$.xgafv", newJString(Xgafv))
  add(query_822084898, "$callback", newJString(Callback))
  add(path_822084897, "file", newJString(file))
  add(query_822084898, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084896.call(path_822084897, query_822084898, nil, nil, nil)

var getFile* = Call_GetFile_822084887(name: "getFile", meth: HttpMethod.HttpGet, host: "generativelanguage.googleapis.com",
                                      route: "/v1beta/files/{file}",
                                      validator: validate_GetFile_822084888,
                                      base: "/", makeUrl: url_GetFile_822084889,
                                      schemes: {Scheme.Https})
type
  Call_DownloadFile_822084911 = ref object of OpenApiRestCall_822083972
proc url_DownloadFile_822084913(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "file" in path, "`file` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/files/"),
                 (kind: VariableSegment, value: "file"),
                 (kind: ConstantSegment, value: ":download")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DownloadFile_822084912(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Download the `File`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   file: JString (required)
  ##       : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `file` field"
  var valid_822084914 = path.getOrDefault("file")
  valid_822084914 = validateParameter(valid_822084914, JString, required = true,
                                      default = nil)
  if valid_822084914 != nil:
    section.add "file", valid_822084914
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822084915 = query.getOrDefault("$alt")
  valid_822084915 = validateParameter(valid_822084915, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084915 != nil:
    section.add "$alt", valid_822084915
  var valid_822084916 = query.getOrDefault("$.xgafv")
  valid_822084916 = validateParameter(valid_822084916, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084916 != nil:
    section.add "$.xgafv", valid_822084916
  var valid_822084917 = query.getOrDefault("$callback")
  valid_822084917 = validateParameter(valid_822084917, JString,
                                      required = false, default = nil)
  if valid_822084917 != nil:
    section.add "$callback", valid_822084917
  var valid_822084918 = query.getOrDefault("$prettyPrint")
  valid_822084918 = validateParameter(valid_822084918, JBool, required = false,
                                      default = nil)
  if valid_822084918 != nil:
    section.add "$prettyPrint", valid_822084918
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084919: Call_DownloadFile_822084911; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Download the `File`.
  ## 
  let valid = call_822084919.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084919.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084919.makeUrl(scheme.get, call_822084919.host, call_822084919.base,
                                   call_822084919.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084919, uri, valid, content)

proc call*(call_822084920: Call_DownloadFile_822084911; file: string;
           Alt: string = "json"; Xgafv: string = "1"; Callback: string = "";
           PrettyPrint: bool = false): Recallable =
  ## downloadFile
  ## Download the `File`.
  ##   Alt: string
  ##      : Data format for response.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   file: string (required)
  ##       : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822084921 = newJObject()
  var query_822084922 = newJObject()
  add(query_822084922, "$alt", newJString(Alt))
  add(query_822084922, "$.xgafv", newJString(Xgafv))
  add(query_822084922, "$callback", newJString(Callback))
  add(path_822084921, "file", newJString(file))
  add(query_822084922, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084920.call(path_822084921, query_822084922, nil, nil, nil)

var downloadFile* = Call_DownloadFile_822084911(name: "downloadFile",
    meth: HttpMethod.HttpGet, host: "generativelanguage.googleapis.com",
    route: "/v1beta/files/{file}:download", validator: validate_DownloadFile_822084912,
    base: "/", makeUrl: url_DownloadFile_822084913, schemes: {Scheme.Https})
type
  Call_ListGeneratedFiles_822084923 = ref object of OpenApiRestCall_822083972
proc url_ListGeneratedFiles_822084925(protocol: Scheme; host: string;
                                      base: string; route: string;
                                      path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_ListGeneratedFiles_822084924(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Lists the generated files owned by the requesting project.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   pageSize: JInt
  ##           : Optional. Maximum number of `GeneratedFile`s to return per page.
  ## If unspecified, defaults to 10. Maximum `page_size` is 50.
  ##   pageToken: JString
  ##            : Optional. A page token from a previous `ListGeneratedFiles` call.
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822084926 = query.getOrDefault("$alt")
  valid_822084926 = validateParameter(valid_822084926, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084926 != nil:
    section.add "$alt", valid_822084926
  var valid_822084927 = query.getOrDefault("$.xgafv")
  valid_822084927 = validateParameter(valid_822084927, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084927 != nil:
    section.add "$.xgafv", valid_822084927
  var valid_822084928 = query.getOrDefault("$callback")
  valid_822084928 = validateParameter(valid_822084928, JString,
                                      required = false, default = nil)
  if valid_822084928 != nil:
    section.add "$callback", valid_822084928
  var valid_822084929 = query.getOrDefault("pageSize")
  valid_822084929 = validateParameter(valid_822084929, JInt, required = false,
                                      default = nil)
  if valid_822084929 != nil:
    section.add "pageSize", valid_822084929
  var valid_822084930 = query.getOrDefault("pageToken")
  valid_822084930 = validateParameter(valid_822084930, JString,
                                      required = false, default = nil)
  if valid_822084930 != nil:
    section.add "pageToken", valid_822084930
  var valid_822084931 = query.getOrDefault("$prettyPrint")
  valid_822084931 = validateParameter(valid_822084931, JBool, required = false,
                                      default = nil)
  if valid_822084931 != nil:
    section.add "$prettyPrint", valid_822084931
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084932: Call_ListGeneratedFiles_822084923;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Lists the generated files owned by the requesting project.
  ## 
  let valid = call_822084932.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084932.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084932.makeUrl(scheme.get, call_822084932.host, call_822084932.base,
                                   call_822084932.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084932, uri, valid, content)

proc call*(call_822084933: Call_ListGeneratedFiles_822084923;
           Alt: string = "json"; Xgafv: string = "1"; Callback: string = "";
           pageSize: int = 0; pageToken: string = ""; PrettyPrint: bool = false): Recallable =
  ## listGeneratedFiles
  ## Lists the generated files owned by the requesting project.
  ##   Alt: string
  ##      : Data format for response.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   pageSize: int
  ##           : Optional. Maximum number of `GeneratedFile`s to return per page.
  ## If unspecified, defaults to 10. Maximum `page_size` is 50.
  ##   pageToken: string
  ##            : Optional. A page token from a previous `ListGeneratedFiles` call.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_822084934 = newJObject()
  add(query_822084934, "$alt", newJString(Alt))
  add(query_822084934, "$.xgafv", newJString(Xgafv))
  add(query_822084934, "$callback", newJString(Callback))
  add(query_822084934, "pageSize", newJInt(pageSize))
  add(query_822084934, "pageToken", newJString(pageToken))
  add(query_822084934, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084933.call(nil, query_822084934, nil, nil, nil)

var listGeneratedFiles* = Call_ListGeneratedFiles_822084923(
    name: "listGeneratedFiles", meth: HttpMethod.HttpGet,
    host: "generativelanguage.googleapis.com", route: "/v1beta/generatedFiles",
    validator: validate_ListGeneratedFiles_822084924, base: "/",
    makeUrl: url_ListGeneratedFiles_822084925, schemes: {Scheme.Https})
type
  Call_GetGeneratedFile_822084935 = ref object of OpenApiRestCall_822083972
proc url_GetGeneratedFile_822084937(protocol: Scheme; host: string;
                                    base: string; route: string; path: JsonNode;
                                    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "generatedFile" in path, "`generatedFile` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/generatedFiles/"),
                 (kind: VariableSegment, value: "generatedFile")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GetGeneratedFile_822084936(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Gets a generated file. When calling this method via REST, only the metadata
  ## of the generated file is returned. To retrieve the file content via REST,
  ## add alt=media as a query parameter.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   generatedFile: JString (required)
  ##                : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `generatedFile` field"
  var valid_822084938 = path.getOrDefault("generatedFile")
  valid_822084938 = validateParameter(valid_822084938, JString, required = true,
                                      default = nil)
  if valid_822084938 != nil:
    section.add "generatedFile", valid_822084938
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822084939 = query.getOrDefault("$alt")
  valid_822084939 = validateParameter(valid_822084939, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084939 != nil:
    section.add "$alt", valid_822084939
  var valid_822084940 = query.getOrDefault("$.xgafv")
  valid_822084940 = validateParameter(valid_822084940, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084940 != nil:
    section.add "$.xgafv", valid_822084940
  var valid_822084941 = query.getOrDefault("$callback")
  valid_822084941 = validateParameter(valid_822084941, JString,
                                      required = false, default = nil)
  if valid_822084941 != nil:
    section.add "$callback", valid_822084941
  var valid_822084942 = query.getOrDefault("$prettyPrint")
  valid_822084942 = validateParameter(valid_822084942, JBool, required = false,
                                      default = nil)
  if valid_822084942 != nil:
    section.add "$prettyPrint", valid_822084942
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084943: Call_GetGeneratedFile_822084935;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Gets a generated file. When calling this method via REST, only the metadata
  ## of the generated file is returned. To retrieve the file content via REST,
  ## add alt=media as a query parameter.
  ## 
  let valid = call_822084943.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084943.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084943.makeUrl(scheme.get, call_822084943.host, call_822084943.base,
                                   call_822084943.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084943, uri, valid, content)

proc call*(call_822084944: Call_GetGeneratedFile_822084935;
           generatedFile: string; Alt: string = "json"; Xgafv: string = "1";
           Callback: string = ""; PrettyPrint: bool = false): Recallable =
  ## getGeneratedFile
  ## Gets a generated file. When calling this method via REST, only the metadata
  ## of the generated file is returned. To retrieve the file content via REST,
  ## add alt=media as a query parameter.
  ##   generatedFile: string (required)
  ##                : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   Alt: string
  ##      : Data format for response.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822084945 = newJObject()
  var query_822084946 = newJObject()
  add(path_822084945, "generatedFile", newJString(generatedFile))
  add(query_822084946, "$alt", newJString(Alt))
  add(query_822084946, "$.xgafv", newJString(Xgafv))
  add(query_822084946, "$callback", newJString(Callback))
  add(query_822084946, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084944.call(path_822084945, query_822084946, nil, nil, nil)

var getGeneratedFile* = Call_GetGeneratedFile_822084935(
    name: "getGeneratedFile", meth: HttpMethod.HttpGet,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/generatedFiles/{generatedFile}",
    validator: validate_GetGeneratedFile_822084936, base: "/",
    makeUrl: url_GetGeneratedFile_822084937, schemes: {Scheme.Https})
type
  Call_GetOperationByGeneratedFileAndOperation_822084947 = ref object of OpenApiRestCall_822083972
proc url_GetOperationByGeneratedFileAndOperation_822084949(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "generatedFile" in path, "`generatedFile` is a required path parameter"
  assert "operation" in path, "`operation` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/generatedFiles/"),
                 (kind: VariableSegment, value: "generatedFile"),
                 (kind: ConstantSegment, value: "/operations/"),
                 (kind: VariableSegment, value: "operation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GetOperationByGeneratedFileAndOperation_822084948(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode;
    content: string = ""): JsonNode {.nosinks.} =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   generatedFile: JString (required)
  ##                : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   operation: JString (required)
  ##            : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `generatedFile` field"
  var valid_822084950 = path.getOrDefault("generatedFile")
  valid_822084950 = validateParameter(valid_822084950, JString, required = true,
                                      default = nil)
  if valid_822084950 != nil:
    section.add "generatedFile", valid_822084950
  var valid_822084951 = path.getOrDefault("operation")
  valid_822084951 = validateParameter(valid_822084951, JString, required = true,
                                      default = nil)
  if valid_822084951 != nil:
    section.add "operation", valid_822084951
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822084952 = query.getOrDefault("$alt")
  valid_822084952 = validateParameter(valid_822084952, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084952 != nil:
    section.add "$alt", valid_822084952
  var valid_822084953 = query.getOrDefault("$.xgafv")
  valid_822084953 = validateParameter(valid_822084953, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084953 != nil:
    section.add "$.xgafv", valid_822084953
  var valid_822084954 = query.getOrDefault("$callback")
  valid_822084954 = validateParameter(valid_822084954, JString,
                                      required = false, default = nil)
  if valid_822084954 != nil:
    section.add "$callback", valid_822084954
  var valid_822084955 = query.getOrDefault("$prettyPrint")
  valid_822084955 = validateParameter(valid_822084955, JBool, required = false,
                                      default = nil)
  if valid_822084955 != nil:
    section.add "$prettyPrint", valid_822084955
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084956: Call_GetOperationByGeneratedFileAndOperation_822084947;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_822084956.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084956.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084956.makeUrl(scheme.get, call_822084956.host, call_822084956.base,
                                   call_822084956.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084956, uri, valid, content)

proc call*(call_822084957: Call_GetOperationByGeneratedFileAndOperation_822084947;
           generatedFile: string; operation: string; Alt: string = "json";
           Xgafv: string = "1"; Callback: string = ""; PrettyPrint: bool = false): Recallable =
  ## getOperationByGeneratedFileAndOperation
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ##   generatedFile: string (required)
  ##                : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   Alt: string
  ##      : Data format for response.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   operation: string (required)
  ##            : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822084958 = newJObject()
  var query_822084959 = newJObject()
  add(path_822084958, "generatedFile", newJString(generatedFile))
  add(query_822084959, "$alt", newJString(Alt))
  add(query_822084959, "$.xgafv", newJString(Xgafv))
  add(query_822084959, "$callback", newJString(Callback))
  add(path_822084958, "operation", newJString(operation))
  add(query_822084959, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084957.call(path_822084958, query_822084959, nil, nil, nil)

var getOperationByGeneratedFileAndOperation* = Call_GetOperationByGeneratedFileAndOperation_822084947(
    name: "getOperationByGeneratedFileAndOperation", meth: HttpMethod.HttpGet,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/generatedFiles/{generatedFile}/operations/{operation}",
    validator: validate_GetOperationByGeneratedFileAndOperation_822084948,
    base: "/", makeUrl: url_GetOperationByGeneratedFileAndOperation_822084949,
    schemes: {Scheme.Https})
type
  Call_ListModels_822084960 = ref object of OpenApiRestCall_822083972
proc url_ListModels_822084962(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_ListModels_822084961(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Lists the [`Model`s](https://ai.google.dev/gemini-api/docs/models/gemini)
  ## available through the Gemini API.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   pageSize: JInt
  ##           : The maximum number of `Models` to return (per page).
  ## 
  ## If unspecified, 50 models will be returned per page.
  ## This method returns at most 1000 models per page, even if you pass a larger
  ## page_size.
  ##   pageToken: JString
  ##            : A page token, received from a previous `ListModels` call.
  ## 
  ## Provide the `page_token` returned by one request as an argument to the next
  ## request to retrieve the next page.
  ## 
  ## When paginating, all other parameters provided to `ListModels` must match
  ## the call that provided the page token.
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822084963 = query.getOrDefault("$alt")
  valid_822084963 = validateParameter(valid_822084963, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084963 != nil:
    section.add "$alt", valid_822084963
  var valid_822084964 = query.getOrDefault("$.xgafv")
  valid_822084964 = validateParameter(valid_822084964, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084964 != nil:
    section.add "$.xgafv", valid_822084964
  var valid_822084965 = query.getOrDefault("$callback")
  valid_822084965 = validateParameter(valid_822084965, JString,
                                      required = false, default = nil)
  if valid_822084965 != nil:
    section.add "$callback", valid_822084965
  var valid_822084966 = query.getOrDefault("pageSize")
  valid_822084966 = validateParameter(valid_822084966, JInt, required = false,
                                      default = nil)
  if valid_822084966 != nil:
    section.add "pageSize", valid_822084966
  var valid_822084967 = query.getOrDefault("pageToken")
  valid_822084967 = validateParameter(valid_822084967, JString,
                                      required = false, default = nil)
  if valid_822084967 != nil:
    section.add "pageToken", valid_822084967
  var valid_822084968 = query.getOrDefault("$prettyPrint")
  valid_822084968 = validateParameter(valid_822084968, JBool, required = false,
                                      default = nil)
  if valid_822084968 != nil:
    section.add "$prettyPrint", valid_822084968
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084969: Call_ListModels_822084960; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Lists the [`Model`s](https://ai.google.dev/gemini-api/docs/models/gemini)
  ## available through the Gemini API.
  ## 
  let valid = call_822084969.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084969.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084969.makeUrl(scheme.get, call_822084969.host, call_822084969.base,
                                   call_822084969.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084969, uri, valid, content)

proc call*(call_822084970: Call_ListModels_822084960; Alt: string = "json";
           Xgafv: string = "1"; Callback: string = ""; pageSize: int = 0;
           pageToken: string = ""; PrettyPrint: bool = false): Recallable =
  ## listModels
  ## Lists the [`Model`s](https://ai.google.dev/gemini-api/docs/models/gemini)
  ## available through the Gemini API.
  ##   Alt: string
  ##      : Data format for response.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   pageSize: int
  ##           : The maximum number of `Models` to return (per page).
  ## 
  ## If unspecified, 50 models will be returned per page.
  ## This method returns at most 1000 models per page, even if you pass a larger
  ## page_size.
  ##   pageToken: string
  ##            : A page token, received from a previous `ListModels` call.
  ## 
  ## Provide the `page_token` returned by one request as an argument to the next
  ## request to retrieve the next page.
  ## 
  ## When paginating, all other parameters provided to `ListModels` must match
  ## the call that provided the page token.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_822084971 = newJObject()
  add(query_822084971, "$alt", newJString(Alt))
  add(query_822084971, "$.xgafv", newJString(Xgafv))
  add(query_822084971, "$callback", newJString(Callback))
  add(query_822084971, "pageSize", newJInt(pageSize))
  add(query_822084971, "pageToken", newJString(pageToken))
  add(query_822084971, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084970.call(nil, query_822084971, nil, nil, nil)

var listModels* = Call_ListModels_822084960(name: "listModels",
    meth: HttpMethod.HttpGet, host: "generativelanguage.googleapis.com",
    route: "/v1beta/models", validator: validate_ListModels_822084961,
    base: "/", makeUrl: url_ListModels_822084962, schemes: {Scheme.Https})
type
  Call_GetModel_822084972 = ref object of OpenApiRestCall_822083972
proc url_GetModel_822084974(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "model" in path, "`model` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/models/"),
                 (kind: VariableSegment, value: "model")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GetModel_822084973(path: JsonNode; query: JsonNode;
                                 header: JsonNode; formData: JsonNode;
                                 body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Gets information about a specific `Model` such as its version number, token
  ## limits,
  ## [parameters](https://ai.google.dev/gemini-api/docs/models/generative-models#model-parameters)
  ## and other metadata. Refer to the [Gemini models
  ## guide](https://ai.google.dev/gemini-api/docs/models/gemini) for detailed
  ## model information.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   model: JString (required)
  ##        : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `model` field"
  var valid_822084975 = path.getOrDefault("model")
  valid_822084975 = validateParameter(valid_822084975, JString, required = true,
                                      default = nil)
  if valid_822084975 != nil:
    section.add "model", valid_822084975
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822084976 = query.getOrDefault("$alt")
  valid_822084976 = validateParameter(valid_822084976, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084976 != nil:
    section.add "$alt", valid_822084976
  var valid_822084977 = query.getOrDefault("$.xgafv")
  valid_822084977 = validateParameter(valid_822084977, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084977 != nil:
    section.add "$.xgafv", valid_822084977
  var valid_822084978 = query.getOrDefault("$callback")
  valid_822084978 = validateParameter(valid_822084978, JString,
                                      required = false, default = nil)
  if valid_822084978 != nil:
    section.add "$callback", valid_822084978
  var valid_822084979 = query.getOrDefault("$prettyPrint")
  valid_822084979 = validateParameter(valid_822084979, JBool, required = false,
                                      default = nil)
  if valid_822084979 != nil:
    section.add "$prettyPrint", valid_822084979
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084980: Call_GetModel_822084972; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Gets information about a specific `Model` such as its version number, token
  ## limits,
  ## [parameters](https://ai.google.dev/gemini-api/docs/models/generative-models#model-parameters)
  ## and other metadata. Refer to the [Gemini models
  ## guide](https://ai.google.dev/gemini-api/docs/models/gemini) for detailed
  ## model information.
  ## 
  let valid = call_822084980.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084980.makeUrl(scheme.get, call_822084980.host, call_822084980.base,
                                   call_822084980.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084980, uri, valid, content)

proc call*(call_822084981: Call_GetModel_822084972; model: string;
           Alt: string = "json"; Xgafv: string = "1"; Callback: string = "";
           PrettyPrint: bool = false): Recallable =
  ## getModel
  ## Gets information about a specific `Model` such as its version number, token
  ## limits,
  ## [parameters](https://ai.google.dev/gemini-api/docs/models/generative-models#model-parameters)
  ## and other metadata. Refer to the [Gemini models
  ## guide](https://ai.google.dev/gemini-api/docs/models/gemini) for detailed
  ## model information.
  ##   Alt: string
  ##      : Data format for response.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   model: string (required)
  ##        : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822084982 = newJObject()
  var query_822084983 = newJObject()
  add(query_822084983, "$alt", newJString(Alt))
  add(query_822084983, "$.xgafv", newJString(Xgafv))
  add(query_822084983, "$callback", newJString(Callback))
  add(path_822084982, "model", newJString(model))
  add(query_822084983, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084981.call(path_822084982, query_822084983, nil, nil, nil)

var getModel* = Call_GetModel_822084972(name: "getModel",
                                        meth: HttpMethod.HttpGet, host: "generativelanguage.googleapis.com",
                                        route: "/v1beta/models/{model}",
                                        validator: validate_GetModel_822084973,
                                        base: "/", makeUrl: url_GetModel_822084974,
                                        schemes: {Scheme.Https})
type
  Call_ListOperationsByModel_822084984 = ref object of OpenApiRestCall_822083972
proc url_ListOperationsByModel_822084986(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "model" in path, "`model` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/models/"),
                 (kind: VariableSegment, value: "model"),
                 (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ListOperationsByModel_822084985(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   model: JString (required)
  ##        : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `model` field"
  var valid_822084987 = path.getOrDefault("model")
  valid_822084987 = validateParameter(valid_822084987, JString, required = true,
                                      default = nil)
  if valid_822084987 != nil:
    section.add "model", valid_822084987
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   filter: JString
  ##         : The standard list filter.
  ##   pageSize: JInt
  ##           : The standard list page size.
  ##   pageToken: JString
  ##            : The standard list page token.
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822084988 = query.getOrDefault("$alt")
  valid_822084988 = validateParameter(valid_822084988, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084988 != nil:
    section.add "$alt", valid_822084988
  var valid_822084989 = query.getOrDefault("$.xgafv")
  valid_822084989 = validateParameter(valid_822084989, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084989 != nil:
    section.add "$.xgafv", valid_822084989
  var valid_822084990 = query.getOrDefault("$callback")
  valid_822084990 = validateParameter(valid_822084990, JString,
                                      required = false, default = nil)
  if valid_822084990 != nil:
    section.add "$callback", valid_822084990
  var valid_822084991 = query.getOrDefault("filter")
  valid_822084991 = validateParameter(valid_822084991, JString,
                                      required = false, default = nil)
  if valid_822084991 != nil:
    section.add "filter", valid_822084991
  var valid_822084992 = query.getOrDefault("pageSize")
  valid_822084992 = validateParameter(valid_822084992, JInt, required = false,
                                      default = nil)
  if valid_822084992 != nil:
    section.add "pageSize", valid_822084992
  var valid_822084993 = query.getOrDefault("pageToken")
  valid_822084993 = validateParameter(valid_822084993, JString,
                                      required = false, default = nil)
  if valid_822084993 != nil:
    section.add "pageToken", valid_822084993
  var valid_822084994 = query.getOrDefault("$prettyPrint")
  valid_822084994 = validateParameter(valid_822084994, JBool, required = false,
                                      default = nil)
  if valid_822084994 != nil:
    section.add "$prettyPrint", valid_822084994
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084995: Call_ListOperationsByModel_822084984;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ## 
  let valid = call_822084995.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084995.makeUrl(scheme.get, call_822084995.host, call_822084995.base,
                                   call_822084995.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084995, uri, valid, content)

proc call*(call_822084996: Call_ListOperationsByModel_822084984; model: string;
           Alt: string = "json"; Xgafv: string = "1"; Callback: string = "";
           filter: string = ""; pageSize: int = 0; pageToken: string = "";
           PrettyPrint: bool = false): Recallable =
  ## listOperationsByModel
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ##   Alt: string
  ##      : Data format for response.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   filter: string
  ##         : The standard list filter.
  ##   model: string (required)
  ##        : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   pageSize: int
  ##           : The standard list page size.
  ##   pageToken: string
  ##            : The standard list page token.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822084997 = newJObject()
  var query_822084998 = newJObject()
  add(query_822084998, "$alt", newJString(Alt))
  add(query_822084998, "$.xgafv", newJString(Xgafv))
  add(query_822084998, "$callback", newJString(Callback))
  add(query_822084998, "filter", newJString(filter))
  add(path_822084997, "model", newJString(model))
  add(query_822084998, "pageSize", newJInt(pageSize))
  add(query_822084998, "pageToken", newJString(pageToken))
  add(query_822084998, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084996.call(path_822084997, query_822084998, nil, nil, nil)

var listOperationsByModel* = Call_ListOperationsByModel_822084984(
    name: "listOperationsByModel", meth: HttpMethod.HttpGet,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/models/{model}/operations",
    validator: validate_ListOperationsByModel_822084985, base: "/",
    makeUrl: url_ListOperationsByModel_822084986, schemes: {Scheme.Https})
type
  Call_GetOperationByModelAndOperation_822084999 = ref object of OpenApiRestCall_822083972
proc url_GetOperationByModelAndOperation_822085001(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "model" in path, "`model` is a required path parameter"
  assert "operation" in path, "`operation` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/models/"),
                 (kind: VariableSegment, value: "model"),
                 (kind: ConstantSegment, value: "/operations/"),
                 (kind: VariableSegment, value: "operation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GetOperationByModelAndOperation_822085000(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode;
    content: string = ""): JsonNode {.nosinks.} =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   model: JString (required)
  ##        : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   operation: JString (required)
  ##            : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `model` field"
  var valid_822085002 = path.getOrDefault("model")
  valid_822085002 = validateParameter(valid_822085002, JString, required = true,
                                      default = nil)
  if valid_822085002 != nil:
    section.add "model", valid_822085002
  var valid_822085003 = path.getOrDefault("operation")
  valid_822085003 = validateParameter(valid_822085003, JString, required = true,
                                      default = nil)
  if valid_822085003 != nil:
    section.add "operation", valid_822085003
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822085004 = query.getOrDefault("$alt")
  valid_822085004 = validateParameter(valid_822085004, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822085004 != nil:
    section.add "$alt", valid_822085004
  var valid_822085005 = query.getOrDefault("$.xgafv")
  valid_822085005 = validateParameter(valid_822085005, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822085005 != nil:
    section.add "$.xgafv", valid_822085005
  var valid_822085006 = query.getOrDefault("$callback")
  valid_822085006 = validateParameter(valid_822085006, JString,
                                      required = false, default = nil)
  if valid_822085006 != nil:
    section.add "$callback", valid_822085006
  var valid_822085007 = query.getOrDefault("$prettyPrint")
  valid_822085007 = validateParameter(valid_822085007, JBool, required = false,
                                      default = nil)
  if valid_822085007 != nil:
    section.add "$prettyPrint", valid_822085007
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085008: Call_GetOperationByModelAndOperation_822084999;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_822085008.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085008.makeUrl(scheme.get, call_822085008.host, call_822085008.base,
                                   call_822085008.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085008, uri, valid, content)

proc call*(call_822085009: Call_GetOperationByModelAndOperation_822084999;
           model: string; operation: string; Alt: string = "json";
           Xgafv: string = "1"; Callback: string = ""; PrettyPrint: bool = false): Recallable =
  ## getOperationByModelAndOperation
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ##   Alt: string
  ##      : Data format for response.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   model: string (required)
  ##        : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   operation: string (required)
  ##            : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822085010 = newJObject()
  var query_822085011 = newJObject()
  add(query_822085011, "$alt", newJString(Alt))
  add(query_822085011, "$.xgafv", newJString(Xgafv))
  add(query_822085011, "$callback", newJString(Callback))
  add(path_822085010, "model", newJString(model))
  add(path_822085010, "operation", newJString(operation))
  add(query_822085011, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822085009.call(path_822085010, query_822085011, nil, nil, nil)

var getOperationByModelAndOperation* = Call_GetOperationByModelAndOperation_822084999(
    name: "getOperationByModelAndOperation", meth: HttpMethod.HttpGet,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/models/{model}/operations/{operation}",
    validator: validate_GetOperationByModelAndOperation_822085000, base: "/",
    makeUrl: url_GetOperationByModelAndOperation_822085001,
    schemes: {Scheme.Https})
type
  Call_BatchEmbedContents_822085012 = ref object of OpenApiRestCall_822083972
proc url_BatchEmbedContents_822085014(protocol: Scheme; host: string;
                                      base: string; route: string;
                                      path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "model" in path, "`model` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/models/"),
                 (kind: VariableSegment, value: "model"),
                 (kind: ConstantSegment, value: ":batchEmbedContents")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BatchEmbedContents_822085013(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Generates multiple embedding vectors from the input `Content` which
  ## consists of a batch of strings represented as `EmbedContentRequest`
  ## objects.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   model: JString (required)
  ##        : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `model` field"
  var valid_822085015 = path.getOrDefault("model")
  valid_822085015 = validateParameter(valid_822085015, JString, required = true,
                                      default = nil)
  if valid_822085015 != nil:
    section.add "model", valid_822085015
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822085016 = query.getOrDefault("$alt")
  valid_822085016 = validateParameter(valid_822085016, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822085016 != nil:
    section.add "$alt", valid_822085016
  var valid_822085017 = query.getOrDefault("$.xgafv")
  valid_822085017 = validateParameter(valid_822085017, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822085017 != nil:
    section.add "$.xgafv", valid_822085017
  var valid_822085018 = query.getOrDefault("$callback")
  valid_822085018 = validateParameter(valid_822085018, JString,
                                      required = false, default = nil)
  if valid_822085018 != nil:
    section.add "$callback", valid_822085018
  var valid_822085019 = query.getOrDefault("$prettyPrint")
  valid_822085019 = validateParameter(valid_822085019, JBool, required = false,
                                      default = nil)
  if valid_822085019 != nil:
    section.add "$prettyPrint", valid_822085019
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  ##       : The request body.
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085021: Call_BatchEmbedContents_822085012;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Generates multiple embedding vectors from the input `Content` which
  ## consists of a batch of strings represented as `EmbedContentRequest`
  ## objects.
  ## 
  let valid = call_822085021.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085021.makeUrl(scheme.get, call_822085021.host, call_822085021.base,
                                   call_822085021.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085021, uri, valid, content)

proc call*(call_822085022: Call_BatchEmbedContents_822085012; model: string;
           Alt: string = "json"; body: JsonNode = nil; Xgafv: string = "1";
           Callback: string = ""; PrettyPrint: bool = false): Recallable =
  ## batchEmbedContents
  ## Generates multiple embedding vectors from the input `Content` which
  ## consists of a batch of strings represented as `EmbedContentRequest`
  ## objects.
  ##   Alt: string
  ##      : Data format for response.
  ##   body: JObject
  ##       : The request body.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   model: string (required)
  ##        : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822085023 = newJObject()
  var query_822085024 = newJObject()
  var body_822085025 = newJObject()
  add(query_822085024, "$alt", newJString(Alt))
  if body != nil:
    body_822085025 = body
  add(query_822085024, "$.xgafv", newJString(Xgafv))
  add(query_822085024, "$callback", newJString(Callback))
  add(path_822085023, "model", newJString(model))
  add(query_822085024, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822085022.call(path_822085023, query_822085024, nil, nil, body_822085025)

var batchEmbedContents* = Call_BatchEmbedContents_822085012(
    name: "batchEmbedContents", meth: HttpMethod.HttpPost,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/models/{model}:batchEmbedContents",
    validator: validate_BatchEmbedContents_822085013, base: "/",
    makeUrl: url_BatchEmbedContents_822085014, schemes: {Scheme.Https})
type
  Call_BatchEmbedText_822085026 = ref object of OpenApiRestCall_822083972
proc url_BatchEmbedText_822085028(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "model" in path, "`model` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/models/"),
                 (kind: VariableSegment, value: "model"),
                 (kind: ConstantSegment, value: ":batchEmbedText")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BatchEmbedText_822085027(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Generates multiple embeddings from the model given input text in a
  ## synchronous call.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   model: JString (required)
  ##        : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `model` field"
  var valid_822085029 = path.getOrDefault("model")
  valid_822085029 = validateParameter(valid_822085029, JString, required = true,
                                      default = nil)
  if valid_822085029 != nil:
    section.add "model", valid_822085029
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822085030 = query.getOrDefault("$alt")
  valid_822085030 = validateParameter(valid_822085030, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822085030 != nil:
    section.add "$alt", valid_822085030
  var valid_822085031 = query.getOrDefault("$.xgafv")
  valid_822085031 = validateParameter(valid_822085031, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822085031 != nil:
    section.add "$.xgafv", valid_822085031
  var valid_822085032 = query.getOrDefault("$callback")
  valid_822085032 = validateParameter(valid_822085032, JString,
                                      required = false, default = nil)
  if valid_822085032 != nil:
    section.add "$callback", valid_822085032
  var valid_822085033 = query.getOrDefault("$prettyPrint")
  valid_822085033 = validateParameter(valid_822085033, JBool, required = false,
                                      default = nil)
  if valid_822085033 != nil:
    section.add "$prettyPrint", valid_822085033
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  ##       : The request body.
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085035: Call_BatchEmbedText_822085026; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Generates multiple embeddings from the model given input text in a
  ## synchronous call.
  ## 
  let valid = call_822085035.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085035.makeUrl(scheme.get, call_822085035.host, call_822085035.base,
                                   call_822085035.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085035, uri, valid, content)

proc call*(call_822085036: Call_BatchEmbedText_822085026; model: string;
           Alt: string = "json"; body: JsonNode = nil; Xgafv: string = "1";
           Callback: string = ""; PrettyPrint: bool = false): Recallable =
  ## batchEmbedText
  ## Generates multiple embeddings from the model given input text in a
  ## synchronous call.
  ##   Alt: string
  ##      : Data format for response.
  ##   body: JObject
  ##       : The request body.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   model: string (required)
  ##        : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822085037 = newJObject()
  var query_822085038 = newJObject()
  var body_822085039 = newJObject()
  add(query_822085038, "$alt", newJString(Alt))
  if body != nil:
    body_822085039 = body
  add(query_822085038, "$.xgafv", newJString(Xgafv))
  add(query_822085038, "$callback", newJString(Callback))
  add(path_822085037, "model", newJString(model))
  add(query_822085038, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822085036.call(path_822085037, query_822085038, nil, nil, body_822085039)

var batchEmbedText* = Call_BatchEmbedText_822085026(name: "batchEmbedText",
    meth: HttpMethod.HttpPost, host: "generativelanguage.googleapis.com",
    route: "/v1beta/models/{model}:batchEmbedText",
    validator: validate_BatchEmbedText_822085027, base: "/",
    makeUrl: url_BatchEmbedText_822085028, schemes: {Scheme.Https})
type
  Call_CountMessageTokens_822085040 = ref object of OpenApiRestCall_822083972
proc url_CountMessageTokens_822085042(protocol: Scheme; host: string;
                                      base: string; route: string;
                                      path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "model" in path, "`model` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/models/"),
                 (kind: VariableSegment, value: "model"),
                 (kind: ConstantSegment, value: ":countMessageTokens")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CountMessageTokens_822085041(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Runs a model's tokenizer on a string and returns the token count.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   model: JString (required)
  ##        : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `model` field"
  var valid_822085043 = path.getOrDefault("model")
  valid_822085043 = validateParameter(valid_822085043, JString, required = true,
                                      default = nil)
  if valid_822085043 != nil:
    section.add "model", valid_822085043
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822085044 = query.getOrDefault("$alt")
  valid_822085044 = validateParameter(valid_822085044, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822085044 != nil:
    section.add "$alt", valid_822085044
  var valid_822085045 = query.getOrDefault("$.xgafv")
  valid_822085045 = validateParameter(valid_822085045, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822085045 != nil:
    section.add "$.xgafv", valid_822085045
  var valid_822085046 = query.getOrDefault("$callback")
  valid_822085046 = validateParameter(valid_822085046, JString,
                                      required = false, default = nil)
  if valid_822085046 != nil:
    section.add "$callback", valid_822085046
  var valid_822085047 = query.getOrDefault("$prettyPrint")
  valid_822085047 = validateParameter(valid_822085047, JBool, required = false,
                                      default = nil)
  if valid_822085047 != nil:
    section.add "$prettyPrint", valid_822085047
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  ##       : The request body.
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085049: Call_CountMessageTokens_822085040;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Runs a model's tokenizer on a string and returns the token count.
  ## 
  let valid = call_822085049.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085049.makeUrl(scheme.get, call_822085049.host, call_822085049.base,
                                   call_822085049.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085049, uri, valid, content)

proc call*(call_822085050: Call_CountMessageTokens_822085040; model: string;
           Alt: string = "json"; body: JsonNode = nil; Xgafv: string = "1";
           Callback: string = ""; PrettyPrint: bool = false): Recallable =
  ## countMessageTokens
  ## Runs a model's tokenizer on a string and returns the token count.
  ##   Alt: string
  ##      : Data format for response.
  ##   body: JObject
  ##       : The request body.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   model: string (required)
  ##        : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822085051 = newJObject()
  var query_822085052 = newJObject()
  var body_822085053 = newJObject()
  add(query_822085052, "$alt", newJString(Alt))
  if body != nil:
    body_822085053 = body
  add(query_822085052, "$.xgafv", newJString(Xgafv))
  add(query_822085052, "$callback", newJString(Callback))
  add(path_822085051, "model", newJString(model))
  add(query_822085052, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822085050.call(path_822085051, query_822085052, nil, nil, body_822085053)

var countMessageTokens* = Call_CountMessageTokens_822085040(
    name: "countMessageTokens", meth: HttpMethod.HttpPost,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/models/{model}:countMessageTokens",
    validator: validate_CountMessageTokens_822085041, base: "/",
    makeUrl: url_CountMessageTokens_822085042, schemes: {Scheme.Https})
type
  Call_CountTextTokens_822085054 = ref object of OpenApiRestCall_822083972
proc url_CountTextTokens_822085056(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode;
                                   query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "model" in path, "`model` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/models/"),
                 (kind: VariableSegment, value: "model"),
                 (kind: ConstantSegment, value: ":countTextTokens")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CountTextTokens_822085055(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Runs a model's tokenizer on a text and returns the token count.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   model: JString (required)
  ##        : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `model` field"
  var valid_822085057 = path.getOrDefault("model")
  valid_822085057 = validateParameter(valid_822085057, JString, required = true,
                                      default = nil)
  if valid_822085057 != nil:
    section.add "model", valid_822085057
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822085058 = query.getOrDefault("$alt")
  valid_822085058 = validateParameter(valid_822085058, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822085058 != nil:
    section.add "$alt", valid_822085058
  var valid_822085059 = query.getOrDefault("$.xgafv")
  valid_822085059 = validateParameter(valid_822085059, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822085059 != nil:
    section.add "$.xgafv", valid_822085059
  var valid_822085060 = query.getOrDefault("$callback")
  valid_822085060 = validateParameter(valid_822085060, JString,
                                      required = false, default = nil)
  if valid_822085060 != nil:
    section.add "$callback", valid_822085060
  var valid_822085061 = query.getOrDefault("$prettyPrint")
  valid_822085061 = validateParameter(valid_822085061, JBool, required = false,
                                      default = nil)
  if valid_822085061 != nil:
    section.add "$prettyPrint", valid_822085061
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  ##       : The request body.
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085063: Call_CountTextTokens_822085054; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Runs a model's tokenizer on a text and returns the token count.
  ## 
  let valid = call_822085063.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085063.makeUrl(scheme.get, call_822085063.host, call_822085063.base,
                                   call_822085063.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085063, uri, valid, content)

proc call*(call_822085064: Call_CountTextTokens_822085054; model: string;
           Alt: string = "json"; body: JsonNode = nil; Xgafv: string = "1";
           Callback: string = ""; PrettyPrint: bool = false): Recallable =
  ## countTextTokens
  ## Runs a model's tokenizer on a text and returns the token count.
  ##   Alt: string
  ##      : Data format for response.
  ##   body: JObject
  ##       : The request body.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   model: string (required)
  ##        : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822085065 = newJObject()
  var query_822085066 = newJObject()
  var body_822085067 = newJObject()
  add(query_822085066, "$alt", newJString(Alt))
  if body != nil:
    body_822085067 = body
  add(query_822085066, "$.xgafv", newJString(Xgafv))
  add(query_822085066, "$callback", newJString(Callback))
  add(path_822085065, "model", newJString(model))
  add(query_822085066, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822085064.call(path_822085065, query_822085066, nil, nil, body_822085067)

var countTextTokens* = Call_CountTextTokens_822085054(name: "countTextTokens",
    meth: HttpMethod.HttpPost, host: "generativelanguage.googleapis.com",
    route: "/v1beta/models/{model}:countTextTokens",
    validator: validate_CountTextTokens_822085055, base: "/",
    makeUrl: url_CountTextTokens_822085056, schemes: {Scheme.Https})
type
  Call_CountTokens_822085068 = ref object of OpenApiRestCall_822083972
proc url_CountTokens_822085070(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "model" in path, "`model` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/models/"),
                 (kind: VariableSegment, value: "model"),
                 (kind: ConstantSegment, value: ":countTokens")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CountTokens_822085069(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Runs a model's tokenizer on input `Content` and returns the token count.
  ## Refer to the [tokens guide](https://ai.google.dev/gemini-api/docs/tokens)
  ## to learn more about tokens.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   model: JString (required)
  ##        : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `model` field"
  var valid_822085071 = path.getOrDefault("model")
  valid_822085071 = validateParameter(valid_822085071, JString, required = true,
                                      default = nil)
  if valid_822085071 != nil:
    section.add "model", valid_822085071
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822085072 = query.getOrDefault("$alt")
  valid_822085072 = validateParameter(valid_822085072, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822085072 != nil:
    section.add "$alt", valid_822085072
  var valid_822085073 = query.getOrDefault("$.xgafv")
  valid_822085073 = validateParameter(valid_822085073, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822085073 != nil:
    section.add "$.xgafv", valid_822085073
  var valid_822085074 = query.getOrDefault("$callback")
  valid_822085074 = validateParameter(valid_822085074, JString,
                                      required = false, default = nil)
  if valid_822085074 != nil:
    section.add "$callback", valid_822085074
  var valid_822085075 = query.getOrDefault("$prettyPrint")
  valid_822085075 = validateParameter(valid_822085075, JBool, required = false,
                                      default = nil)
  if valid_822085075 != nil:
    section.add "$prettyPrint", valid_822085075
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  ##       : The request body.
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085077: Call_CountTokens_822085068; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Runs a model's tokenizer on input `Content` and returns the token count.
  ## Refer to the [tokens guide](https://ai.google.dev/gemini-api/docs/tokens)
  ## to learn more about tokens.
  ## 
  let valid = call_822085077.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085077.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085077.makeUrl(scheme.get, call_822085077.host, call_822085077.base,
                                   call_822085077.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085077, uri, valid, content)

proc call*(call_822085078: Call_CountTokens_822085068; model: string;
           Alt: string = "json"; body: JsonNode = nil; Xgafv: string = "1";
           Callback: string = ""; PrettyPrint: bool = false): Recallable =
  ## countTokens
  ## Runs a model's tokenizer on input `Content` and returns the token count.
  ## Refer to the [tokens guide](https://ai.google.dev/gemini-api/docs/tokens)
  ## to learn more about tokens.
  ##   Alt: string
  ##      : Data format for response.
  ##   body: JObject
  ##       : The request body.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   model: string (required)
  ##        : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822085079 = newJObject()
  var query_822085080 = newJObject()
  var body_822085081 = newJObject()
  add(query_822085080, "$alt", newJString(Alt))
  if body != nil:
    body_822085081 = body
  add(query_822085080, "$.xgafv", newJString(Xgafv))
  add(query_822085080, "$callback", newJString(Callback))
  add(path_822085079, "model", newJString(model))
  add(query_822085080, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822085078.call(path_822085079, query_822085080, nil, nil, body_822085081)

var countTokens* = Call_CountTokens_822085068(name: "countTokens",
    meth: HttpMethod.HttpPost, host: "generativelanguage.googleapis.com",
    route: "/v1beta/models/{model}:countTokens",
    validator: validate_CountTokens_822085069, base: "/",
    makeUrl: url_CountTokens_822085070, schemes: {Scheme.Https})
type
  Call_EmbedContent_822085082 = ref object of OpenApiRestCall_822083972
proc url_EmbedContent_822085084(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "model" in path, "`model` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/models/"),
                 (kind: VariableSegment, value: "model"),
                 (kind: ConstantSegment, value: ":embedContent")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_EmbedContent_822085083(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Generates a text embedding vector from the input `Content` using the
  ## specified [Gemini Embedding
  ## model](https://ai.google.dev/gemini-api/docs/models/gemini#text-embedding).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   model: JString (required)
  ##        : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `model` field"
  var valid_822085085 = path.getOrDefault("model")
  valid_822085085 = validateParameter(valid_822085085, JString, required = true,
                                      default = nil)
  if valid_822085085 != nil:
    section.add "model", valid_822085085
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822085086 = query.getOrDefault("$alt")
  valid_822085086 = validateParameter(valid_822085086, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822085086 != nil:
    section.add "$alt", valid_822085086
  var valid_822085087 = query.getOrDefault("$.xgafv")
  valid_822085087 = validateParameter(valid_822085087, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822085087 != nil:
    section.add "$.xgafv", valid_822085087
  var valid_822085088 = query.getOrDefault("$callback")
  valid_822085088 = validateParameter(valid_822085088, JString,
                                      required = false, default = nil)
  if valid_822085088 != nil:
    section.add "$callback", valid_822085088
  var valid_822085089 = query.getOrDefault("$prettyPrint")
  valid_822085089 = validateParameter(valid_822085089, JBool, required = false,
                                      default = nil)
  if valid_822085089 != nil:
    section.add "$prettyPrint", valid_822085089
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  ##       : The request body.
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085091: Call_EmbedContent_822085082; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Generates a text embedding vector from the input `Content` using the
  ## specified [Gemini Embedding
  ## model](https://ai.google.dev/gemini-api/docs/models/gemini#text-embedding).
  ## 
  let valid = call_822085091.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085091.makeUrl(scheme.get, call_822085091.host, call_822085091.base,
                                   call_822085091.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085091, uri, valid, content)

proc call*(call_822085092: Call_EmbedContent_822085082; model: string;
           Alt: string = "json"; body: JsonNode = nil; Xgafv: string = "1";
           Callback: string = ""; PrettyPrint: bool = false): Recallable =
  ## embedContent
  ## Generates a text embedding vector from the input `Content` using the
  ## specified [Gemini Embedding
  ## model](https://ai.google.dev/gemini-api/docs/models/gemini#text-embedding).
  ##   Alt: string
  ##      : Data format for response.
  ##   body: JObject
  ##       : The request body.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   model: string (required)
  ##        : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822085093 = newJObject()
  var query_822085094 = newJObject()
  var body_822085095 = newJObject()
  add(query_822085094, "$alt", newJString(Alt))
  if body != nil:
    body_822085095 = body
  add(query_822085094, "$.xgafv", newJString(Xgafv))
  add(query_822085094, "$callback", newJString(Callback))
  add(path_822085093, "model", newJString(model))
  add(query_822085094, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822085092.call(path_822085093, query_822085094, nil, nil, body_822085095)

var embedContent* = Call_EmbedContent_822085082(name: "embedContent",
    meth: HttpMethod.HttpPost, host: "generativelanguage.googleapis.com",
    route: "/v1beta/models/{model}:embedContent",
    validator: validate_EmbedContent_822085083, base: "/",
    makeUrl: url_EmbedContent_822085084, schemes: {Scheme.Https})
type
  Call_EmbedText_822085096 = ref object of OpenApiRestCall_822083972
proc url_EmbedText_822085098(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "model" in path, "`model` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/models/"),
                 (kind: VariableSegment, value: "model"),
                 (kind: ConstantSegment, value: ":embedText")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_EmbedText_822085097(path: JsonNode; query: JsonNode;
                                  header: JsonNode; formData: JsonNode;
                                  body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Generates an embedding from the model given an input message.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   model: JString (required)
  ##        : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `model` field"
  var valid_822085099 = path.getOrDefault("model")
  valid_822085099 = validateParameter(valid_822085099, JString, required = true,
                                      default = nil)
  if valid_822085099 != nil:
    section.add "model", valid_822085099
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822085100 = query.getOrDefault("$alt")
  valid_822085100 = validateParameter(valid_822085100, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822085100 != nil:
    section.add "$alt", valid_822085100
  var valid_822085101 = query.getOrDefault("$.xgafv")
  valid_822085101 = validateParameter(valid_822085101, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822085101 != nil:
    section.add "$.xgafv", valid_822085101
  var valid_822085102 = query.getOrDefault("$callback")
  valid_822085102 = validateParameter(valid_822085102, JString,
                                      required = false, default = nil)
  if valid_822085102 != nil:
    section.add "$callback", valid_822085102
  var valid_822085103 = query.getOrDefault("$prettyPrint")
  valid_822085103 = validateParameter(valid_822085103, JBool, required = false,
                                      default = nil)
  if valid_822085103 != nil:
    section.add "$prettyPrint", valid_822085103
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  ##       : The request body.
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085105: Call_EmbedText_822085096; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Generates an embedding from the model given an input message.
  ## 
  let valid = call_822085105.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085105.makeUrl(scheme.get, call_822085105.host, call_822085105.base,
                                   call_822085105.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085105, uri, valid, content)

proc call*(call_822085106: Call_EmbedText_822085096; model: string;
           Alt: string = "json"; body: JsonNode = nil; Xgafv: string = "1";
           Callback: string = ""; PrettyPrint: bool = false): Recallable =
  ## embedText
  ## Generates an embedding from the model given an input message.
  ##   Alt: string
  ##      : Data format for response.
  ##   body: JObject
  ##       : The request body.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   model: string (required)
  ##        : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822085107 = newJObject()
  var query_822085108 = newJObject()
  var body_822085109 = newJObject()
  add(query_822085108, "$alt", newJString(Alt))
  if body != nil:
    body_822085109 = body
  add(query_822085108, "$.xgafv", newJString(Xgafv))
  add(query_822085108, "$callback", newJString(Callback))
  add(path_822085107, "model", newJString(model))
  add(query_822085108, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822085106.call(path_822085107, query_822085108, nil, nil, body_822085109)

var embedText* = Call_EmbedText_822085096(name: "embedText",
    meth: HttpMethod.HttpPost, host: "generativelanguage.googleapis.com",
    route: "/v1beta/models/{model}:embedText", validator: validate_EmbedText_822085097,
    base: "/", makeUrl: url_EmbedText_822085098, schemes: {Scheme.Https})
type
  Call_GenerateAnswer_822085110 = ref object of OpenApiRestCall_822083972
proc url_GenerateAnswer_822085112(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "model" in path, "`model` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/models/"),
                 (kind: VariableSegment, value: "model"),
                 (kind: ConstantSegment, value: ":generateAnswer")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GenerateAnswer_822085111(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Generates a grounded answer from the model given an input
  ## `GenerateAnswerRequest`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   model: JString (required)
  ##        : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `model` field"
  var valid_822085113 = path.getOrDefault("model")
  valid_822085113 = validateParameter(valid_822085113, JString, required = true,
                                      default = nil)
  if valid_822085113 != nil:
    section.add "model", valid_822085113
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822085114 = query.getOrDefault("$alt")
  valid_822085114 = validateParameter(valid_822085114, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822085114 != nil:
    section.add "$alt", valid_822085114
  var valid_822085115 = query.getOrDefault("$.xgafv")
  valid_822085115 = validateParameter(valid_822085115, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822085115 != nil:
    section.add "$.xgafv", valid_822085115
  var valid_822085116 = query.getOrDefault("$callback")
  valid_822085116 = validateParameter(valid_822085116, JString,
                                      required = false, default = nil)
  if valid_822085116 != nil:
    section.add "$callback", valid_822085116
  var valid_822085117 = query.getOrDefault("$prettyPrint")
  valid_822085117 = validateParameter(valid_822085117, JBool, required = false,
                                      default = nil)
  if valid_822085117 != nil:
    section.add "$prettyPrint", valid_822085117
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  ##       : The request body.
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085119: Call_GenerateAnswer_822085110; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Generates a grounded answer from the model given an input
  ## `GenerateAnswerRequest`.
  ## 
  let valid = call_822085119.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085119.makeUrl(scheme.get, call_822085119.host, call_822085119.base,
                                   call_822085119.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085119, uri, valid, content)

proc call*(call_822085120: Call_GenerateAnswer_822085110; model: string;
           Alt: string = "json"; body: JsonNode = nil; Xgafv: string = "1";
           Callback: string = ""; PrettyPrint: bool = false): Recallable =
  ## generateAnswer
  ## Generates a grounded answer from the model given an input
  ## `GenerateAnswerRequest`.
  ##   Alt: string
  ##      : Data format for response.
  ##   body: JObject
  ##       : The request body.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   model: string (required)
  ##        : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822085121 = newJObject()
  var query_822085122 = newJObject()
  var body_822085123 = newJObject()
  add(query_822085122, "$alt", newJString(Alt))
  if body != nil:
    body_822085123 = body
  add(query_822085122, "$.xgafv", newJString(Xgafv))
  add(query_822085122, "$callback", newJString(Callback))
  add(path_822085121, "model", newJString(model))
  add(query_822085122, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822085120.call(path_822085121, query_822085122, nil, nil, body_822085123)

var generateAnswer* = Call_GenerateAnswer_822085110(name: "generateAnswer",
    meth: HttpMethod.HttpPost, host: "generativelanguage.googleapis.com",
    route: "/v1beta/models/{model}:generateAnswer",
    validator: validate_GenerateAnswer_822085111, base: "/",
    makeUrl: url_GenerateAnswer_822085112, schemes: {Scheme.Https})
type
  Call_GenerateContent_822085124 = ref object of OpenApiRestCall_822083972
proc url_GenerateContent_822085126(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode;
                                   query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "model" in path, "`model` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/models/"),
                 (kind: VariableSegment, value: "model"),
                 (kind: ConstantSegment, value: ":generateContent")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GenerateContent_822085125(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Generates a model response given an input `GenerateContentRequest`.
  ## Refer to the [text generation
  ## guide](https://ai.google.dev/gemini-api/docs/text-generation) for detailed
  ## usage information. Input capabilities differ between models, including
  ## tuned models. Refer to the [model
  ## guide](https://ai.google.dev/gemini-api/docs/models/gemini) and [tuning
  ## guide](https://ai.google.dev/gemini-api/docs/model-tuning) for details.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   model: JString (required)
  ##        : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `model` field"
  var valid_822085127 = path.getOrDefault("model")
  valid_822085127 = validateParameter(valid_822085127, JString, required = true,
                                      default = nil)
  if valid_822085127 != nil:
    section.add "model", valid_822085127
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822085128 = query.getOrDefault("$alt")
  valid_822085128 = validateParameter(valid_822085128, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822085128 != nil:
    section.add "$alt", valid_822085128
  var valid_822085129 = query.getOrDefault("$.xgafv")
  valid_822085129 = validateParameter(valid_822085129, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822085129 != nil:
    section.add "$.xgafv", valid_822085129
  var valid_822085130 = query.getOrDefault("$callback")
  valid_822085130 = validateParameter(valid_822085130, JString,
                                      required = false, default = nil)
  if valid_822085130 != nil:
    section.add "$callback", valid_822085130
  var valid_822085131 = query.getOrDefault("$prettyPrint")
  valid_822085131 = validateParameter(valid_822085131, JBool, required = false,
                                      default = nil)
  if valid_822085131 != nil:
    section.add "$prettyPrint", valid_822085131
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  ##       : The request body.
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085133: Call_GenerateContent_822085124; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Generates a model response given an input `GenerateContentRequest`.
  ## Refer to the [text generation
  ## guide](https://ai.google.dev/gemini-api/docs/text-generation) for detailed
  ## usage information. Input capabilities differ between models, including
  ## tuned models. Refer to the [model
  ## guide](https://ai.google.dev/gemini-api/docs/models/gemini) and [tuning
  ## guide](https://ai.google.dev/gemini-api/docs/model-tuning) for details.
  ## 
  let valid = call_822085133.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085133.makeUrl(scheme.get, call_822085133.host, call_822085133.base,
                                   call_822085133.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085133, uri, valid, content)

proc call*(call_822085134: Call_GenerateContent_822085124; model: string;
           Alt: string = "json"; body: JsonNode = nil; Xgafv: string = "1";
           Callback: string = ""; PrettyPrint: bool = false): Recallable =
  ## generateContent
  ## Generates a model response given an input `GenerateContentRequest`.
  ## Refer to the [text generation
  ## guide](https://ai.google.dev/gemini-api/docs/text-generation) for detailed
  ## usage information. Input capabilities differ between models, including
  ## tuned models. Refer to the [model
  ## guide](https://ai.google.dev/gemini-api/docs/models/gemini) and [tuning
  ## guide](https://ai.google.dev/gemini-api/docs/model-tuning) for details.
  ##   Alt: string
  ##      : Data format for response.
  ##   body: JObject
  ##       : The request body.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   model: string (required)
  ##        : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822085135 = newJObject()
  var query_822085136 = newJObject()
  var body_822085137 = newJObject()
  add(query_822085136, "$alt", newJString(Alt))
  if body != nil:
    body_822085137 = body
  add(query_822085136, "$.xgafv", newJString(Xgafv))
  add(query_822085136, "$callback", newJString(Callback))
  add(path_822085135, "model", newJString(model))
  add(query_822085136, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822085134.call(path_822085135, query_822085136, nil, nil, body_822085137)

var generateContent* = Call_GenerateContent_822085124(name: "generateContent",
    meth: HttpMethod.HttpPost, host: "generativelanguage.googleapis.com",
    route: "/v1beta/models/{model}:generateContent",
    validator: validate_GenerateContent_822085125, base: "/",
    makeUrl: url_GenerateContent_822085126, schemes: {Scheme.Https})
type
  Call_GenerateMessage_822085138 = ref object of OpenApiRestCall_822083972
proc url_GenerateMessage_822085140(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode;
                                   query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "model" in path, "`model` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/models/"),
                 (kind: VariableSegment, value: "model"),
                 (kind: ConstantSegment, value: ":generateMessage")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GenerateMessage_822085139(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Generates a response from the model given an input `MessagePrompt`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   model: JString (required)
  ##        : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `model` field"
  var valid_822085141 = path.getOrDefault("model")
  valid_822085141 = validateParameter(valid_822085141, JString, required = true,
                                      default = nil)
  if valid_822085141 != nil:
    section.add "model", valid_822085141
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822085142 = query.getOrDefault("$alt")
  valid_822085142 = validateParameter(valid_822085142, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822085142 != nil:
    section.add "$alt", valid_822085142
  var valid_822085143 = query.getOrDefault("$.xgafv")
  valid_822085143 = validateParameter(valid_822085143, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822085143 != nil:
    section.add "$.xgafv", valid_822085143
  var valid_822085144 = query.getOrDefault("$callback")
  valid_822085144 = validateParameter(valid_822085144, JString,
                                      required = false, default = nil)
  if valid_822085144 != nil:
    section.add "$callback", valid_822085144
  var valid_822085145 = query.getOrDefault("$prettyPrint")
  valid_822085145 = validateParameter(valid_822085145, JBool, required = false,
                                      default = nil)
  if valid_822085145 != nil:
    section.add "$prettyPrint", valid_822085145
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  ##       : The request body.
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085147: Call_GenerateMessage_822085138; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Generates a response from the model given an input `MessagePrompt`.
  ## 
  let valid = call_822085147.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085147.makeUrl(scheme.get, call_822085147.host, call_822085147.base,
                                   call_822085147.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085147, uri, valid, content)

proc call*(call_822085148: Call_GenerateMessage_822085138; model: string;
           Alt: string = "json"; body: JsonNode = nil; Xgafv: string = "1";
           Callback: string = ""; PrettyPrint: bool = false): Recallable =
  ## generateMessage
  ## Generates a response from the model given an input `MessagePrompt`.
  ##   Alt: string
  ##      : Data format for response.
  ##   body: JObject
  ##       : The request body.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   model: string (required)
  ##        : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822085149 = newJObject()
  var query_822085150 = newJObject()
  var body_822085151 = newJObject()
  add(query_822085150, "$alt", newJString(Alt))
  if body != nil:
    body_822085151 = body
  add(query_822085150, "$.xgafv", newJString(Xgafv))
  add(query_822085150, "$callback", newJString(Callback))
  add(path_822085149, "model", newJString(model))
  add(query_822085150, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822085148.call(path_822085149, query_822085150, nil, nil, body_822085151)

var generateMessage* = Call_GenerateMessage_822085138(name: "generateMessage",
    meth: HttpMethod.HttpPost, host: "generativelanguage.googleapis.com",
    route: "/v1beta/models/{model}:generateMessage",
    validator: validate_GenerateMessage_822085139, base: "/",
    makeUrl: url_GenerateMessage_822085140, schemes: {Scheme.Https})
type
  Call_GenerateText_822085152 = ref object of OpenApiRestCall_822083972
proc url_GenerateText_822085154(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "model" in path, "`model` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/models/"),
                 (kind: VariableSegment, value: "model"),
                 (kind: ConstantSegment, value: ":generateText")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GenerateText_822085153(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Generates a response from the model given an input message.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   model: JString (required)
  ##        : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `model` field"
  var valid_822085155 = path.getOrDefault("model")
  valid_822085155 = validateParameter(valid_822085155, JString, required = true,
                                      default = nil)
  if valid_822085155 != nil:
    section.add "model", valid_822085155
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822085156 = query.getOrDefault("$alt")
  valid_822085156 = validateParameter(valid_822085156, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822085156 != nil:
    section.add "$alt", valid_822085156
  var valid_822085157 = query.getOrDefault("$.xgafv")
  valid_822085157 = validateParameter(valid_822085157, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822085157 != nil:
    section.add "$.xgafv", valid_822085157
  var valid_822085158 = query.getOrDefault("$callback")
  valid_822085158 = validateParameter(valid_822085158, JString,
                                      required = false, default = nil)
  if valid_822085158 != nil:
    section.add "$callback", valid_822085158
  var valid_822085159 = query.getOrDefault("$prettyPrint")
  valid_822085159 = validateParameter(valid_822085159, JBool, required = false,
                                      default = nil)
  if valid_822085159 != nil:
    section.add "$prettyPrint", valid_822085159
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  ##       : The request body.
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085161: Call_GenerateText_822085152; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Generates a response from the model given an input message.
  ## 
  let valid = call_822085161.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085161.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085161.makeUrl(scheme.get, call_822085161.host, call_822085161.base,
                                   call_822085161.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085161, uri, valid, content)

proc call*(call_822085162: Call_GenerateText_822085152; model: string;
           Alt: string = "json"; body: JsonNode = nil; Xgafv: string = "1";
           Callback: string = ""; PrettyPrint: bool = false): Recallable =
  ## generateText
  ## Generates a response from the model given an input message.
  ##   Alt: string
  ##      : Data format for response.
  ##   body: JObject
  ##       : The request body.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   model: string (required)
  ##        : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822085163 = newJObject()
  var query_822085164 = newJObject()
  var body_822085165 = newJObject()
  add(query_822085164, "$alt", newJString(Alt))
  if body != nil:
    body_822085165 = body
  add(query_822085164, "$.xgafv", newJString(Xgafv))
  add(query_822085164, "$callback", newJString(Callback))
  add(path_822085163, "model", newJString(model))
  add(query_822085164, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822085162.call(path_822085163, query_822085164, nil, nil, body_822085165)

var generateText* = Call_GenerateText_822085152(name: "generateText",
    meth: HttpMethod.HttpPost, host: "generativelanguage.googleapis.com",
    route: "/v1beta/models/{model}:generateText",
    validator: validate_GenerateText_822085153, base: "/",
    makeUrl: url_GenerateText_822085154, schemes: {Scheme.Https})
type
  Call_Predict_822085166 = ref object of OpenApiRestCall_822083972
proc url_Predict_822085168(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "model" in path, "`model` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/models/"),
                 (kind: VariableSegment, value: "model"),
                 (kind: ConstantSegment, value: ":predict")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_Predict_822085167(path: JsonNode; query: JsonNode;
                                header: JsonNode; formData: JsonNode;
                                body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Performs a prediction request.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   model: JString (required)
  ##        : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `model` field"
  var valid_822085169 = path.getOrDefault("model")
  valid_822085169 = validateParameter(valid_822085169, JString, required = true,
                                      default = nil)
  if valid_822085169 != nil:
    section.add "model", valid_822085169
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822085170 = query.getOrDefault("$alt")
  valid_822085170 = validateParameter(valid_822085170, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822085170 != nil:
    section.add "$alt", valid_822085170
  var valid_822085171 = query.getOrDefault("$.xgafv")
  valid_822085171 = validateParameter(valid_822085171, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822085171 != nil:
    section.add "$.xgafv", valid_822085171
  var valid_822085172 = query.getOrDefault("$callback")
  valid_822085172 = validateParameter(valid_822085172, JString,
                                      required = false, default = nil)
  if valid_822085172 != nil:
    section.add "$callback", valid_822085172
  var valid_822085173 = query.getOrDefault("$prettyPrint")
  valid_822085173 = validateParameter(valid_822085173, JBool, required = false,
                                      default = nil)
  if valid_822085173 != nil:
    section.add "$prettyPrint", valid_822085173
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  ##       : The request body.
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085175: Call_Predict_822085166; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Performs a prediction request.
  ## 
  let valid = call_822085175.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085175.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085175.makeUrl(scheme.get, call_822085175.host, call_822085175.base,
                                   call_822085175.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085175, uri, valid, content)

proc call*(call_822085176: Call_Predict_822085166; model: string;
           Alt: string = "json"; body: JsonNode = nil; Xgafv: string = "1";
           Callback: string = ""; PrettyPrint: bool = false): Recallable =
  ## predict
  ## Performs a prediction request.
  ##   Alt: string
  ##      : Data format for response.
  ##   body: JObject
  ##       : The request body.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   model: string (required)
  ##        : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822085177 = newJObject()
  var query_822085178 = newJObject()
  var body_822085179 = newJObject()
  add(query_822085178, "$alt", newJString(Alt))
  if body != nil:
    body_822085179 = body
  add(query_822085178, "$.xgafv", newJString(Xgafv))
  add(query_822085178, "$callback", newJString(Callback))
  add(path_822085177, "model", newJString(model))
  add(query_822085178, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822085176.call(path_822085177, query_822085178, nil, nil, body_822085179)

var predict* = Call_Predict_822085166(name: "predict",
                                      meth: HttpMethod.HttpPost, host: "generativelanguage.googleapis.com",
                                      route: "/v1beta/models/{model}:predict",
                                      validator: validate_Predict_822085167,
                                      base: "/", makeUrl: url_Predict_822085168,
                                      schemes: {Scheme.Https})
type
  Call_PredictLongRunning_822085180 = ref object of OpenApiRestCall_822083972
proc url_PredictLongRunning_822085182(protocol: Scheme; host: string;
                                      base: string; route: string;
                                      path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "model" in path, "`model` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/models/"),
                 (kind: VariableSegment, value: "model"),
                 (kind: ConstantSegment, value: ":predictLongRunning")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_PredictLongRunning_822085181(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Same as Predict but returns an LRO.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   model: JString (required)
  ##        : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `model` field"
  var valid_822085183 = path.getOrDefault("model")
  valid_822085183 = validateParameter(valid_822085183, JString, required = true,
                                      default = nil)
  if valid_822085183 != nil:
    section.add "model", valid_822085183
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822085184 = query.getOrDefault("$alt")
  valid_822085184 = validateParameter(valid_822085184, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822085184 != nil:
    section.add "$alt", valid_822085184
  var valid_822085185 = query.getOrDefault("$.xgafv")
  valid_822085185 = validateParameter(valid_822085185, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822085185 != nil:
    section.add "$.xgafv", valid_822085185
  var valid_822085186 = query.getOrDefault("$callback")
  valid_822085186 = validateParameter(valid_822085186, JString,
                                      required = false, default = nil)
  if valid_822085186 != nil:
    section.add "$callback", valid_822085186
  var valid_822085187 = query.getOrDefault("$prettyPrint")
  valid_822085187 = validateParameter(valid_822085187, JBool, required = false,
                                      default = nil)
  if valid_822085187 != nil:
    section.add "$prettyPrint", valid_822085187
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  ##       : The request body.
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085189: Call_PredictLongRunning_822085180;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Same as Predict but returns an LRO.
  ## 
  let valid = call_822085189.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085189.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085189.makeUrl(scheme.get, call_822085189.host, call_822085189.base,
                                   call_822085189.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085189, uri, valid, content)

proc call*(call_822085190: Call_PredictLongRunning_822085180; model: string;
           Alt: string = "json"; body: JsonNode = nil; Xgafv: string = "1";
           Callback: string = ""; PrettyPrint: bool = false): Recallable =
  ## predictLongRunning
  ## Same as Predict but returns an LRO.
  ##   Alt: string
  ##      : Data format for response.
  ##   body: JObject
  ##       : The request body.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   model: string (required)
  ##        : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822085191 = newJObject()
  var query_822085192 = newJObject()
  var body_822085193 = newJObject()
  add(query_822085192, "$alt", newJString(Alt))
  if body != nil:
    body_822085193 = body
  add(query_822085192, "$.xgafv", newJString(Xgafv))
  add(query_822085192, "$callback", newJString(Callback))
  add(path_822085191, "model", newJString(model))
  add(query_822085192, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822085190.call(path_822085191, query_822085192, nil, nil, body_822085193)

var predictLongRunning* = Call_PredictLongRunning_822085180(
    name: "predictLongRunning", meth: HttpMethod.HttpPost,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/models/{model}:predictLongRunning",
    validator: validate_PredictLongRunning_822085181, base: "/",
    makeUrl: url_PredictLongRunning_822085182, schemes: {Scheme.Https})
type
  Call_StreamGenerateContent_822085194 = ref object of OpenApiRestCall_822083972
proc url_StreamGenerateContent_822085196(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "model" in path, "`model` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/models/"),
                 (kind: VariableSegment, value: "model"),
                 (kind: ConstantSegment, value: ":streamGenerateContent")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StreamGenerateContent_822085195(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Generates a [streamed
  ## response](https://ai.google.dev/gemini-api/docs/text-generation?lang=python#generate-a-text-stream)
  ## from the model given an input `GenerateContentRequest`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   model: JString (required)
  ##        : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `model` field"
  var valid_822085197 = path.getOrDefault("model")
  valid_822085197 = validateParameter(valid_822085197, JString, required = true,
                                      default = nil)
  if valid_822085197 != nil:
    section.add "model", valid_822085197
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822085198 = query.getOrDefault("$alt")
  valid_822085198 = validateParameter(valid_822085198, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822085198 != nil:
    section.add "$alt", valid_822085198
  var valid_822085199 = query.getOrDefault("$.xgafv")
  valid_822085199 = validateParameter(valid_822085199, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822085199 != nil:
    section.add "$.xgafv", valid_822085199
  var valid_822085200 = query.getOrDefault("$callback")
  valid_822085200 = validateParameter(valid_822085200, JString,
                                      required = false, default = nil)
  if valid_822085200 != nil:
    section.add "$callback", valid_822085200
  var valid_822085201 = query.getOrDefault("$prettyPrint")
  valid_822085201 = validateParameter(valid_822085201, JBool, required = false,
                                      default = nil)
  if valid_822085201 != nil:
    section.add "$prettyPrint", valid_822085201
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  ##       : The request body.
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085203: Call_StreamGenerateContent_822085194;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Generates a [streamed
  ## response](https://ai.google.dev/gemini-api/docs/text-generation?lang=python#generate-a-text-stream)
  ## from the model given an input `GenerateContentRequest`.
  ## 
  let valid = call_822085203.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085203.makeUrl(scheme.get, call_822085203.host, call_822085203.base,
                                   call_822085203.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085203, uri, valid, content)

proc call*(call_822085204: Call_StreamGenerateContent_822085194; model: string;
           Alt: string = "json"; body: JsonNode = nil; Xgafv: string = "1";
           Callback: string = ""; PrettyPrint: bool = false): Recallable =
  ## streamGenerateContent
  ## Generates a [streamed
  ## response](https://ai.google.dev/gemini-api/docs/text-generation?lang=python#generate-a-text-stream)
  ## from the model given an input `GenerateContentRequest`.
  ##   Alt: string
  ##      : Data format for response.
  ##   body: JObject
  ##       : The request body.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   model: string (required)
  ##        : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822085205 = newJObject()
  var query_822085206 = newJObject()
  var body_822085207 = newJObject()
  add(query_822085206, "$alt", newJString(Alt))
  if body != nil:
    body_822085207 = body
  add(query_822085206, "$.xgafv", newJString(Xgafv))
  add(query_822085206, "$callback", newJString(Callback))
  add(path_822085205, "model", newJString(model))
  add(query_822085206, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822085204.call(path_822085205, query_822085206, nil, nil, body_822085207)

var streamGenerateContent* = Call_StreamGenerateContent_822085194(
    name: "streamGenerateContent", meth: HttpMethod.HttpPost,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/models/{model}:streamGenerateContent",
    validator: validate_StreamGenerateContent_822085195, base: "/",
    makeUrl: url_StreamGenerateContent_822085196, schemes: {Scheme.Https})
type
  Call_CreateTunedModel_822085221 = ref object of OpenApiRestCall_822083972
proc url_CreateTunedModel_822085223(protocol: Scheme; host: string;
                                    base: string; route: string; path: JsonNode;
                                    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CreateTunedModel_822085222(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Creates a tuned model.
  ## Check intermediate tuning progress (if any) through the
  ## [google.longrunning.Operations] service.
  ## 
  ## Access status and results through the Operations service.
  ## Example:
  ##   GET /v1/tunedModels/az2mb0bpw6i/operations/000-111-222
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   tunedModelId: JString
  ##               : Optional. The unique id for the tuned model if specified.
  ## This value should be up to 40 characters, the first character must be a
  ## letter, the last could be a letter or a number. The id must match the
  ## regular expression: `[a-z]([a-z0-9-]{0,38}[a-z0-9])?`.
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822085224 = query.getOrDefault("$alt")
  valid_822085224 = validateParameter(valid_822085224, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822085224 != nil:
    section.add "$alt", valid_822085224
  var valid_822085225 = query.getOrDefault("$.xgafv")
  valid_822085225 = validateParameter(valid_822085225, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822085225 != nil:
    section.add "$.xgafv", valid_822085225
  var valid_822085226 = query.getOrDefault("$callback")
  valid_822085226 = validateParameter(valid_822085226, JString,
                                      required = false, default = nil)
  if valid_822085226 != nil:
    section.add "$callback", valid_822085226
  var valid_822085227 = query.getOrDefault("tunedModelId")
  valid_822085227 = validateParameter(valid_822085227, JString,
                                      required = false, default = nil)
  if valid_822085227 != nil:
    section.add "tunedModelId", valid_822085227
  var valid_822085228 = query.getOrDefault("$prettyPrint")
  valid_822085228 = validateParameter(valid_822085228, JBool, required = false,
                                      default = nil)
  if valid_822085228 != nil:
    section.add "$prettyPrint", valid_822085228
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  ##       : Required. The tuned model to create.
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085230: Call_CreateTunedModel_822085221;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Creates a tuned model.
  ## Check intermediate tuning progress (if any) through the
  ## [google.longrunning.Operations] service.
  ## 
  ## Access status and results through the Operations service.
  ## Example:
  ##   GET /v1/tunedModels/az2mb0bpw6i/operations/000-111-222
  ## 
  let valid = call_822085230.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085230.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085230.makeUrl(scheme.get, call_822085230.host, call_822085230.base,
                                   call_822085230.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085230, uri, valid, content)

proc call*(call_822085231: Call_CreateTunedModel_822085221;
           Alt: string = "json"; body: JsonNode = nil; Xgafv: string = "1";
           Callback: string = ""; tunedModelId: string = "";
           PrettyPrint: bool = false): Recallable =
  ## createTunedModel
  ## Creates a tuned model.
  ## Check intermediate tuning progress (if any) through the
  ## [google.longrunning.Operations] service.
  ## 
  ## Access status and results through the Operations service.
  ## Example:
  ##   GET /v1/tunedModels/az2mb0bpw6i/operations/000-111-222
  ##   Alt: string
  ##      : Data format for response.
  ##   body: JObject
  ##       : Required. The tuned model to create.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   tunedModelId: string
  ##               : Optional. The unique id for the tuned model if specified.
  ## This value should be up to 40 characters, the first character must be a
  ## letter, the last could be a letter or a number. The id must match the
  ## regular expression: `[a-z]([a-z0-9-]{0,38}[a-z0-9])?`.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_822085232 = newJObject()
  var body_822085233 = newJObject()
  add(query_822085232, "$alt", newJString(Alt))
  if body != nil:
    body_822085233 = body
  add(query_822085232, "$.xgafv", newJString(Xgafv))
  add(query_822085232, "$callback", newJString(Callback))
  add(query_822085232, "tunedModelId", newJString(tunedModelId))
  add(query_822085232, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822085231.call(nil, query_822085232, nil, nil, body_822085233)

var createTunedModel* = Call_CreateTunedModel_822085221(
    name: "createTunedModel", meth: HttpMethod.HttpPost,
    host: "generativelanguage.googleapis.com", route: "/v1beta/tunedModels",
    validator: validate_CreateTunedModel_822085222, base: "/",
    makeUrl: url_CreateTunedModel_822085223, schemes: {Scheme.Https})
type
  Call_ListTunedModels_822085208 = ref object of OpenApiRestCall_822083972
proc url_ListTunedModels_822085210(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode;
                                   query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_ListTunedModels_822085209(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Lists created tuned models.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   filter: JString
  ##         : Optional. A filter is a full text search over the tuned model's description and
  ## display name. By default, results will not include tuned models shared
  ## with everyone.
  ## 
  ## Additional operators:
  ##   - owner:me
  ##   - writers:me
  ##   - readers:me
  ##   - readers:everyone
  ## 
  ## Examples:
  ##   "owner:me" returns all tuned models to which caller has owner role
  ##   "readers:me" returns all tuned models to which caller has reader role
  ##   "readers:everyone" returns all tuned models that are shared with everyone
  ##   pageSize: JInt
  ##           : Optional. The maximum number of `TunedModels` to return (per page).
  ## The service may return fewer tuned models.
  ## 
  ## If unspecified, at most 10 tuned models will be returned.
  ## This method returns at most 1000 models per page, even if you pass a larger
  ## page_size.
  ##   pageToken: JString
  ##            : Optional. A page token, received from a previous `ListTunedModels` call.
  ## 
  ## Provide the `page_token` returned by one request as an argument to the next
  ## request to retrieve the next page.
  ## 
  ## When paginating, all other parameters provided to `ListTunedModels`
  ## must match the call that provided the page token.
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822085211 = query.getOrDefault("$alt")
  valid_822085211 = validateParameter(valid_822085211, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822085211 != nil:
    section.add "$alt", valid_822085211
  var valid_822085212 = query.getOrDefault("$.xgafv")
  valid_822085212 = validateParameter(valid_822085212, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822085212 != nil:
    section.add "$.xgafv", valid_822085212
  var valid_822085213 = query.getOrDefault("$callback")
  valid_822085213 = validateParameter(valid_822085213, JString,
                                      required = false, default = nil)
  if valid_822085213 != nil:
    section.add "$callback", valid_822085213
  var valid_822085214 = query.getOrDefault("filter")
  valid_822085214 = validateParameter(valid_822085214, JString,
                                      required = false, default = nil)
  if valid_822085214 != nil:
    section.add "filter", valid_822085214
  var valid_822085215 = query.getOrDefault("pageSize")
  valid_822085215 = validateParameter(valid_822085215, JInt, required = false,
                                      default = nil)
  if valid_822085215 != nil:
    section.add "pageSize", valid_822085215
  var valid_822085216 = query.getOrDefault("pageToken")
  valid_822085216 = validateParameter(valid_822085216, JString,
                                      required = false, default = nil)
  if valid_822085216 != nil:
    section.add "pageToken", valid_822085216
  var valid_822085217 = query.getOrDefault("$prettyPrint")
  valid_822085217 = validateParameter(valid_822085217, JBool, required = false,
                                      default = nil)
  if valid_822085217 != nil:
    section.add "$prettyPrint", valid_822085217
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085218: Call_ListTunedModels_822085208; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Lists created tuned models.
  ## 
  let valid = call_822085218.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085218.makeUrl(scheme.get, call_822085218.host, call_822085218.base,
                                   call_822085218.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085218, uri, valid, content)

proc call*(call_822085219: Call_ListTunedModels_822085208; Alt: string = "json";
           Xgafv: string = "1"; Callback: string = ""; filter: string = "";
           pageSize: int = 0; pageToken: string = ""; PrettyPrint: bool = false): Recallable =
  ## listTunedModels
  ## Lists created tuned models.
  ##   Alt: string
  ##      : Data format for response.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   filter: string
  ##         : Optional. A filter is a full text search over the tuned model's description and
  ## display name. By default, results will not include tuned models shared
  ## with everyone.
  ## 
  ## Additional operators:
  ##   - owner:me
  ##   - writers:me
  ##   - readers:me
  ##   - readers:everyone
  ## 
  ## Examples:
  ##   "owner:me" returns all tuned models to which caller has owner role
  ##   "readers:me" returns all tuned models to which caller has reader role
  ##   "readers:everyone" returns all tuned models that are shared with everyone
  ##   pageSize: int
  ##           : Optional. The maximum number of `TunedModels` to return (per page).
  ## The service may return fewer tuned models.
  ## 
  ## If unspecified, at most 10 tuned models will be returned.
  ## This method returns at most 1000 models per page, even if you pass a larger
  ## page_size.
  ##   pageToken: string
  ##            : Optional. A page token, received from a previous `ListTunedModels` call.
  ## 
  ## Provide the `page_token` returned by one request as an argument to the next
  ## request to retrieve the next page.
  ## 
  ## When paginating, all other parameters provided to `ListTunedModels`
  ## must match the call that provided the page token.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_822085220 = newJObject()
  add(query_822085220, "$alt", newJString(Alt))
  add(query_822085220, "$.xgafv", newJString(Xgafv))
  add(query_822085220, "$callback", newJString(Callback))
  add(query_822085220, "filter", newJString(filter))
  add(query_822085220, "pageSize", newJInt(pageSize))
  add(query_822085220, "pageToken", newJString(pageToken))
  add(query_822085220, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822085219.call(nil, query_822085220, nil, nil, nil)

var listTunedModels* = Call_ListTunedModels_822085208(name: "listTunedModels",
    meth: HttpMethod.HttpGet, host: "generativelanguage.googleapis.com",
    route: "/v1beta/tunedModels", validator: validate_ListTunedModels_822085209,
    base: "/", makeUrl: url_ListTunedModels_822085210, schemes: {Scheme.Https})
type
  Call_DeleteTunedModel_822085246 = ref object of OpenApiRestCall_822083972
proc url_DeleteTunedModel_822085248(protocol: Scheme; host: string;
                                    base: string; route: string; path: JsonNode;
                                    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "tunedModel" in path, "`tunedModel` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/tunedModels/"),
                 (kind: VariableSegment, value: "tunedModel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DeleteTunedModel_822085247(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Deletes a tuned model.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tunedModel: JString (required)
  ##             : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `tunedModel` field"
  var valid_822085249 = path.getOrDefault("tunedModel")
  valid_822085249 = validateParameter(valid_822085249, JString, required = true,
                                      default = nil)
  if valid_822085249 != nil:
    section.add "tunedModel", valid_822085249
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822085250 = query.getOrDefault("$alt")
  valid_822085250 = validateParameter(valid_822085250, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822085250 != nil:
    section.add "$alt", valid_822085250
  var valid_822085251 = query.getOrDefault("$.xgafv")
  valid_822085251 = validateParameter(valid_822085251, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822085251 != nil:
    section.add "$.xgafv", valid_822085251
  var valid_822085252 = query.getOrDefault("$callback")
  valid_822085252 = validateParameter(valid_822085252, JString,
                                      required = false, default = nil)
  if valid_822085252 != nil:
    section.add "$callback", valid_822085252
  var valid_822085253 = query.getOrDefault("$prettyPrint")
  valid_822085253 = validateParameter(valid_822085253, JBool, required = false,
                                      default = nil)
  if valid_822085253 != nil:
    section.add "$prettyPrint", valid_822085253
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085254: Call_DeleteTunedModel_822085246;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Deletes a tuned model.
  ## 
  let valid = call_822085254.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085254.makeUrl(scheme.get, call_822085254.host, call_822085254.base,
                                   call_822085254.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085254, uri, valid, content)

proc call*(call_822085255: Call_DeleteTunedModel_822085246; tunedModel: string;
           Alt: string = "json"; Xgafv: string = "1"; Callback: string = "";
           PrettyPrint: bool = false): Recallable =
  ## deleteTunedModel
  ## Deletes a tuned model.
  ##   tunedModel: string (required)
  ##             : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   Alt: string
  ##      : Data format for response.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822085256 = newJObject()
  var query_822085257 = newJObject()
  add(path_822085256, "tunedModel", newJString(tunedModel))
  add(query_822085257, "$alt", newJString(Alt))
  add(query_822085257, "$.xgafv", newJString(Xgafv))
  add(query_822085257, "$callback", newJString(Callback))
  add(query_822085257, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822085255.call(path_822085256, query_822085257, nil, nil, nil)

var deleteTunedModel* = Call_DeleteTunedModel_822085246(
    name: "deleteTunedModel", meth: HttpMethod.HttpDelete,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/tunedModels/{tunedModel}",
    validator: validate_DeleteTunedModel_822085247, base: "/",
    makeUrl: url_DeleteTunedModel_822085248, schemes: {Scheme.Https})
type
  Call_GetTunedModel_822085234 = ref object of OpenApiRestCall_822083972
proc url_GetTunedModel_822085236(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "tunedModel" in path, "`tunedModel` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/tunedModels/"),
                 (kind: VariableSegment, value: "tunedModel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GetTunedModel_822085235(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Gets information about a specific TunedModel.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tunedModel: JString (required)
  ##             : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `tunedModel` field"
  var valid_822085237 = path.getOrDefault("tunedModel")
  valid_822085237 = validateParameter(valid_822085237, JString, required = true,
                                      default = nil)
  if valid_822085237 != nil:
    section.add "tunedModel", valid_822085237
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822085238 = query.getOrDefault("$alt")
  valid_822085238 = validateParameter(valid_822085238, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822085238 != nil:
    section.add "$alt", valid_822085238
  var valid_822085239 = query.getOrDefault("$.xgafv")
  valid_822085239 = validateParameter(valid_822085239, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822085239 != nil:
    section.add "$.xgafv", valid_822085239
  var valid_822085240 = query.getOrDefault("$callback")
  valid_822085240 = validateParameter(valid_822085240, JString,
                                      required = false, default = nil)
  if valid_822085240 != nil:
    section.add "$callback", valid_822085240
  var valid_822085241 = query.getOrDefault("$prettyPrint")
  valid_822085241 = validateParameter(valid_822085241, JBool, required = false,
                                      default = nil)
  if valid_822085241 != nil:
    section.add "$prettyPrint", valid_822085241
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085242: Call_GetTunedModel_822085234; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Gets information about a specific TunedModel.
  ## 
  let valid = call_822085242.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085242.makeUrl(scheme.get, call_822085242.host, call_822085242.base,
                                   call_822085242.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085242, uri, valid, content)

proc call*(call_822085243: Call_GetTunedModel_822085234; tunedModel: string;
           Alt: string = "json"; Xgafv: string = "1"; Callback: string = "";
           PrettyPrint: bool = false): Recallable =
  ## getTunedModel
  ## Gets information about a specific TunedModel.
  ##   tunedModel: string (required)
  ##             : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   Alt: string
  ##      : Data format for response.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822085244 = newJObject()
  var query_822085245 = newJObject()
  add(path_822085244, "tunedModel", newJString(tunedModel))
  add(query_822085245, "$alt", newJString(Alt))
  add(query_822085245, "$.xgafv", newJString(Xgafv))
  add(query_822085245, "$callback", newJString(Callback))
  add(query_822085245, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822085243.call(path_822085244, query_822085245, nil, nil, nil)

var getTunedModel* = Call_GetTunedModel_822085234(name: "getTunedModel",
    meth: HttpMethod.HttpGet, host: "generativelanguage.googleapis.com",
    route: "/v1beta/tunedModels/{tunedModel}",
    validator: validate_GetTunedModel_822085235, base: "/",
    makeUrl: url_GetTunedModel_822085236, schemes: {Scheme.Https})
type
  Call_UpdateTunedModel_822085258 = ref object of OpenApiRestCall_822083972
proc url_UpdateTunedModel_822085260(protocol: Scheme; host: string;
                                    base: string; route: string; path: JsonNode;
                                    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "tunedModel" in path, "`tunedModel` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/tunedModels/"),
                 (kind: VariableSegment, value: "tunedModel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_UpdateTunedModel_822085259(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Updates a tuned model.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tunedModel: JString (required)
  ##             : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `tunedModel` field"
  var valid_822085261 = path.getOrDefault("tunedModel")
  valid_822085261 = validateParameter(valid_822085261, JString, required = true,
                                      default = nil)
  if valid_822085261 != nil:
    section.add "tunedModel", valid_822085261
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   updateMask: JString
  ##             : Optional. The list of fields to update.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822085262 = query.getOrDefault("$alt")
  valid_822085262 = validateParameter(valid_822085262, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822085262 != nil:
    section.add "$alt", valid_822085262
  var valid_822085263 = query.getOrDefault("updateMask")
  valid_822085263 = validateParameter(valid_822085263, JString,
                                      required = false, default = nil)
  if valid_822085263 != nil:
    section.add "updateMask", valid_822085263
  var valid_822085264 = query.getOrDefault("$.xgafv")
  valid_822085264 = validateParameter(valid_822085264, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822085264 != nil:
    section.add "$.xgafv", valid_822085264
  var valid_822085265 = query.getOrDefault("$callback")
  valid_822085265 = validateParameter(valid_822085265, JString,
                                      required = false, default = nil)
  if valid_822085265 != nil:
    section.add "$callback", valid_822085265
  var valid_822085266 = query.getOrDefault("$prettyPrint")
  valid_822085266 = validateParameter(valid_822085266, JBool, required = false,
                                      default = nil)
  if valid_822085266 != nil:
    section.add "$prettyPrint", valid_822085266
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  ##       : Required. The tuned model to update.
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085268: Call_UpdateTunedModel_822085258;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Updates a tuned model.
  ## 
  let valid = call_822085268.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085268.makeUrl(scheme.get, call_822085268.host, call_822085268.base,
                                   call_822085268.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085268, uri, valid, content)

proc call*(call_822085269: Call_UpdateTunedModel_822085258; tunedModel: string;
           Alt: string = "json"; body: JsonNode = nil; updateMask: string = "";
           Xgafv: string = "1"; Callback: string = ""; PrettyPrint: bool = false): Recallable =
  ## updateTunedModel
  ## Updates a tuned model.
  ##   tunedModel: string (required)
  ##             : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   Alt: string
  ##      : Data format for response.
  ##   body: JObject
  ##       : Required. The tuned model to update.
  ##   updateMask: string
  ##             : Optional. The list of fields to update.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822085270 = newJObject()
  var query_822085271 = newJObject()
  var body_822085272 = newJObject()
  add(path_822085270, "tunedModel", newJString(tunedModel))
  add(query_822085271, "$alt", newJString(Alt))
  if body != nil:
    body_822085272 = body
  add(query_822085271, "updateMask", newJString(updateMask))
  add(query_822085271, "$.xgafv", newJString(Xgafv))
  add(query_822085271, "$callback", newJString(Callback))
  add(query_822085271, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822085269.call(path_822085270, query_822085271, nil, nil, body_822085272)

var updateTunedModel* = Call_UpdateTunedModel_822085258(
    name: "updateTunedModel", meth: HttpMethod.HttpPatch,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/tunedModels/{tunedModel}",
    validator: validate_UpdateTunedModel_822085259, base: "/",
    makeUrl: url_UpdateTunedModel_822085260, schemes: {Scheme.Https})
type
  Call_ListOperations_822085273 = ref object of OpenApiRestCall_822083972
proc url_ListOperations_822085275(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "tunedModel" in path, "`tunedModel` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/tunedModels/"),
                 (kind: VariableSegment, value: "tunedModel"),
                 (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ListOperations_822085274(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tunedModel: JString (required)
  ##             : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `tunedModel` field"
  var valid_822085276 = path.getOrDefault("tunedModel")
  valid_822085276 = validateParameter(valid_822085276, JString, required = true,
                                      default = nil)
  if valid_822085276 != nil:
    section.add "tunedModel", valid_822085276
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   filter: JString
  ##         : The standard list filter.
  ##   pageSize: JInt
  ##           : The standard list page size.
  ##   pageToken: JString
  ##            : The standard list page token.
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822085277 = query.getOrDefault("$alt")
  valid_822085277 = validateParameter(valid_822085277, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822085277 != nil:
    section.add "$alt", valid_822085277
  var valid_822085278 = query.getOrDefault("$.xgafv")
  valid_822085278 = validateParameter(valid_822085278, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822085278 != nil:
    section.add "$.xgafv", valid_822085278
  var valid_822085279 = query.getOrDefault("$callback")
  valid_822085279 = validateParameter(valid_822085279, JString,
                                      required = false, default = nil)
  if valid_822085279 != nil:
    section.add "$callback", valid_822085279
  var valid_822085280 = query.getOrDefault("filter")
  valid_822085280 = validateParameter(valid_822085280, JString,
                                      required = false, default = nil)
  if valid_822085280 != nil:
    section.add "filter", valid_822085280
  var valid_822085281 = query.getOrDefault("pageSize")
  valid_822085281 = validateParameter(valid_822085281, JInt, required = false,
                                      default = nil)
  if valid_822085281 != nil:
    section.add "pageSize", valid_822085281
  var valid_822085282 = query.getOrDefault("pageToken")
  valid_822085282 = validateParameter(valid_822085282, JString,
                                      required = false, default = nil)
  if valid_822085282 != nil:
    section.add "pageToken", valid_822085282
  var valid_822085283 = query.getOrDefault("$prettyPrint")
  valid_822085283 = validateParameter(valid_822085283, JBool, required = false,
                                      default = nil)
  if valid_822085283 != nil:
    section.add "$prettyPrint", valid_822085283
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085284: Call_ListOperations_822085273; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ## 
  let valid = call_822085284.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085284.makeUrl(scheme.get, call_822085284.host, call_822085284.base,
                                   call_822085284.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085284, uri, valid, content)

proc call*(call_822085285: Call_ListOperations_822085273; tunedModel: string;
           Alt: string = "json"; Xgafv: string = "1"; Callback: string = "";
           filter: string = ""; pageSize: int = 0; pageToken: string = "";
           PrettyPrint: bool = false): Recallable =
  ## listOperations
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ##   tunedModel: string (required)
  ##             : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   Alt: string
  ##      : Data format for response.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   filter: string
  ##         : The standard list filter.
  ##   pageSize: int
  ##           : The standard list page size.
  ##   pageToken: string
  ##            : The standard list page token.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822085286 = newJObject()
  var query_822085287 = newJObject()
  add(path_822085286, "tunedModel", newJString(tunedModel))
  add(query_822085287, "$alt", newJString(Alt))
  add(query_822085287, "$.xgafv", newJString(Xgafv))
  add(query_822085287, "$callback", newJString(Callback))
  add(query_822085287, "filter", newJString(filter))
  add(query_822085287, "pageSize", newJInt(pageSize))
  add(query_822085287, "pageToken", newJString(pageToken))
  add(query_822085287, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822085285.call(path_822085286, query_822085287, nil, nil, nil)

var listOperations* = Call_ListOperations_822085273(name: "listOperations",
    meth: HttpMethod.HttpGet, host: "generativelanguage.googleapis.com",
    route: "/v1beta/tunedModels/{tunedModel}/operations",
    validator: validate_ListOperations_822085274, base: "/",
    makeUrl: url_ListOperations_822085275, schemes: {Scheme.Https})
type
  Call_GetOperation_822085288 = ref object of OpenApiRestCall_822083972
proc url_GetOperation_822085290(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "tunedModel" in path, "`tunedModel` is a required path parameter"
  assert "operation" in path, "`operation` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/tunedModels/"),
                 (kind: VariableSegment, value: "tunedModel"),
                 (kind: ConstantSegment, value: "/operations/"),
                 (kind: VariableSegment, value: "operation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GetOperation_822085289(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tunedModel: JString (required)
  ##             : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   operation: JString (required)
  ##            : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `tunedModel` field"
  var valid_822085291 = path.getOrDefault("tunedModel")
  valid_822085291 = validateParameter(valid_822085291, JString, required = true,
                                      default = nil)
  if valid_822085291 != nil:
    section.add "tunedModel", valid_822085291
  var valid_822085292 = path.getOrDefault("operation")
  valid_822085292 = validateParameter(valid_822085292, JString, required = true,
                                      default = nil)
  if valid_822085292 != nil:
    section.add "operation", valid_822085292
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822085293 = query.getOrDefault("$alt")
  valid_822085293 = validateParameter(valid_822085293, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822085293 != nil:
    section.add "$alt", valid_822085293
  var valid_822085294 = query.getOrDefault("$.xgafv")
  valid_822085294 = validateParameter(valid_822085294, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822085294 != nil:
    section.add "$.xgafv", valid_822085294
  var valid_822085295 = query.getOrDefault("$callback")
  valid_822085295 = validateParameter(valid_822085295, JString,
                                      required = false, default = nil)
  if valid_822085295 != nil:
    section.add "$callback", valid_822085295
  var valid_822085296 = query.getOrDefault("$prettyPrint")
  valid_822085296 = validateParameter(valid_822085296, JBool, required = false,
                                      default = nil)
  if valid_822085296 != nil:
    section.add "$prettyPrint", valid_822085296
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085297: Call_GetOperation_822085288; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_822085297.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085297.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085297.makeUrl(scheme.get, call_822085297.host, call_822085297.base,
                                   call_822085297.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085297, uri, valid, content)

proc call*(call_822085298: Call_GetOperation_822085288; tunedModel: string;
           operation: string; Alt: string = "json"; Xgafv: string = "1";
           Callback: string = ""; PrettyPrint: bool = false): Recallable =
  ## getOperation
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ##   tunedModel: string (required)
  ##             : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   Alt: string
  ##      : Data format for response.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   operation: string (required)
  ##            : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822085299 = newJObject()
  var query_822085300 = newJObject()
  add(path_822085299, "tunedModel", newJString(tunedModel))
  add(query_822085300, "$alt", newJString(Alt))
  add(query_822085300, "$.xgafv", newJString(Xgafv))
  add(query_822085300, "$callback", newJString(Callback))
  add(path_822085299, "operation", newJString(operation))
  add(query_822085300, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822085298.call(path_822085299, query_822085300, nil, nil, nil)

var getOperation* = Call_GetOperation_822085288(name: "getOperation",
    meth: HttpMethod.HttpGet, host: "generativelanguage.googleapis.com",
    route: "/v1beta/tunedModels/{tunedModel}/operations/{operation}",
    validator: validate_GetOperation_822085289, base: "/",
    makeUrl: url_GetOperation_822085290, schemes: {Scheme.Https})
type
  Call_CreatePermission_822085315 = ref object of OpenApiRestCall_822083972
proc url_CreatePermission_822085317(protocol: Scheme; host: string;
                                    base: string; route: string; path: JsonNode;
                                    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "tunedModel" in path, "`tunedModel` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/tunedModels/"),
                 (kind: VariableSegment, value: "tunedModel"),
                 (kind: ConstantSegment, value: "/permissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CreatePermission_822085316(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Create a permission to a specific resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tunedModel: JString (required)
  ##             : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `tunedModel` field"
  var valid_822085318 = path.getOrDefault("tunedModel")
  valid_822085318 = validateParameter(valid_822085318, JString, required = true,
                                      default = nil)
  if valid_822085318 != nil:
    section.add "tunedModel", valid_822085318
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822085319 = query.getOrDefault("$alt")
  valid_822085319 = validateParameter(valid_822085319, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822085319 != nil:
    section.add "$alt", valid_822085319
  var valid_822085320 = query.getOrDefault("$.xgafv")
  valid_822085320 = validateParameter(valid_822085320, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822085320 != nil:
    section.add "$.xgafv", valid_822085320
  var valid_822085321 = query.getOrDefault("$callback")
  valid_822085321 = validateParameter(valid_822085321, JString,
                                      required = false, default = nil)
  if valid_822085321 != nil:
    section.add "$callback", valid_822085321
  var valid_822085322 = query.getOrDefault("$prettyPrint")
  valid_822085322 = validateParameter(valid_822085322, JBool, required = false,
                                      default = nil)
  if valid_822085322 != nil:
    section.add "$prettyPrint", valid_822085322
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  ##       : Required. The permission to create.
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085324: Call_CreatePermission_822085315;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Create a permission to a specific resource.
  ## 
  let valid = call_822085324.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085324.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085324.makeUrl(scheme.get, call_822085324.host, call_822085324.base,
                                   call_822085324.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085324, uri, valid, content)

proc call*(call_822085325: Call_CreatePermission_822085315; tunedModel: string;
           Alt: string = "json"; body: JsonNode = nil; Xgafv: string = "1";
           Callback: string = ""; PrettyPrint: bool = false): Recallable =
  ## createPermission
  ## Create a permission to a specific resource.
  ##   tunedModel: string (required)
  ##             : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   Alt: string
  ##      : Data format for response.
  ##   body: JObject
  ##       : Required. The permission to create.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822085326 = newJObject()
  var query_822085327 = newJObject()
  var body_822085328 = newJObject()
  add(path_822085326, "tunedModel", newJString(tunedModel))
  add(query_822085327, "$alt", newJString(Alt))
  if body != nil:
    body_822085328 = body
  add(query_822085327, "$.xgafv", newJString(Xgafv))
  add(query_822085327, "$callback", newJString(Callback))
  add(query_822085327, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822085325.call(path_822085326, query_822085327, nil, nil, body_822085328)

var createPermission* = Call_CreatePermission_822085315(
    name: "createPermission", meth: HttpMethod.HttpPost,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/tunedModels/{tunedModel}/permissions",
    validator: validate_CreatePermission_822085316, base: "/",
    makeUrl: url_CreatePermission_822085317, schemes: {Scheme.Https})
type
  Call_ListPermissions_822085301 = ref object of OpenApiRestCall_822083972
proc url_ListPermissions_822085303(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode;
                                   query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "tunedModel" in path, "`tunedModel` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/tunedModels/"),
                 (kind: VariableSegment, value: "tunedModel"),
                 (kind: ConstantSegment, value: "/permissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ListPermissions_822085302(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Lists permissions for the specific resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tunedModel: JString (required)
  ##             : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `tunedModel` field"
  var valid_822085304 = path.getOrDefault("tunedModel")
  valid_822085304 = validateParameter(valid_822085304, JString, required = true,
                                      default = nil)
  if valid_822085304 != nil:
    section.add "tunedModel", valid_822085304
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   pageSize: JInt
  ##           : Optional. The maximum number of `Permission`s to return (per page).
  ## The service may return fewer permissions.
  ## 
  ## If unspecified, at most 10 permissions will be returned.
  ## This method returns at most 1000 permissions per page, even if you pass
  ## larger page_size.
  ##   pageToken: JString
  ##            : Optional. A page token, received from a previous `ListPermissions` call.
  ## 
  ## Provide the `page_token` returned by one request as an argument to the
  ## next request to retrieve the next page.
  ## 
  ## When paginating, all other parameters provided to `ListPermissions`
  ## must match the call that provided the page token.
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822085305 = query.getOrDefault("$alt")
  valid_822085305 = validateParameter(valid_822085305, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822085305 != nil:
    section.add "$alt", valid_822085305
  var valid_822085306 = query.getOrDefault("$.xgafv")
  valid_822085306 = validateParameter(valid_822085306, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822085306 != nil:
    section.add "$.xgafv", valid_822085306
  var valid_822085307 = query.getOrDefault("$callback")
  valid_822085307 = validateParameter(valid_822085307, JString,
                                      required = false, default = nil)
  if valid_822085307 != nil:
    section.add "$callback", valid_822085307
  var valid_822085308 = query.getOrDefault("pageSize")
  valid_822085308 = validateParameter(valid_822085308, JInt, required = false,
                                      default = nil)
  if valid_822085308 != nil:
    section.add "pageSize", valid_822085308
  var valid_822085309 = query.getOrDefault("pageToken")
  valid_822085309 = validateParameter(valid_822085309, JString,
                                      required = false, default = nil)
  if valid_822085309 != nil:
    section.add "pageToken", valid_822085309
  var valid_822085310 = query.getOrDefault("$prettyPrint")
  valid_822085310 = validateParameter(valid_822085310, JBool, required = false,
                                      default = nil)
  if valid_822085310 != nil:
    section.add "$prettyPrint", valid_822085310
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085311: Call_ListPermissions_822085301; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Lists permissions for the specific resource.
  ## 
  let valid = call_822085311.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085311.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085311.makeUrl(scheme.get, call_822085311.host, call_822085311.base,
                                   call_822085311.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085311, uri, valid, content)

proc call*(call_822085312: Call_ListPermissions_822085301; tunedModel: string;
           Alt: string = "json"; Xgafv: string = "1"; Callback: string = "";
           pageSize: int = 0; pageToken: string = ""; PrettyPrint: bool = false): Recallable =
  ## listPermissions
  ## Lists permissions for the specific resource.
  ##   tunedModel: string (required)
  ##             : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   Alt: string
  ##      : Data format for response.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   pageSize: int
  ##           : Optional. The maximum number of `Permission`s to return (per page).
  ## The service may return fewer permissions.
  ## 
  ## If unspecified, at most 10 permissions will be returned.
  ## This method returns at most 1000 permissions per page, even if you pass
  ## larger page_size.
  ##   pageToken: string
  ##            : Optional. A page token, received from a previous `ListPermissions` call.
  ## 
  ## Provide the `page_token` returned by one request as an argument to the
  ## next request to retrieve the next page.
  ## 
  ## When paginating, all other parameters provided to `ListPermissions`
  ## must match the call that provided the page token.
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822085313 = newJObject()
  var query_822085314 = newJObject()
  add(path_822085313, "tunedModel", newJString(tunedModel))
  add(query_822085314, "$alt", newJString(Alt))
  add(query_822085314, "$.xgafv", newJString(Xgafv))
  add(query_822085314, "$callback", newJString(Callback))
  add(query_822085314, "pageSize", newJInt(pageSize))
  add(query_822085314, "pageToken", newJString(pageToken))
  add(query_822085314, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822085312.call(path_822085313, query_822085314, nil, nil, nil)

var listPermissions* = Call_ListPermissions_822085301(name: "listPermissions",
    meth: HttpMethod.HttpGet, host: "generativelanguage.googleapis.com",
    route: "/v1beta/tunedModels/{tunedModel}/permissions",
    validator: validate_ListPermissions_822085302, base: "/",
    makeUrl: url_ListPermissions_822085303, schemes: {Scheme.Https})
type
  Call_DeletePermission_822085342 = ref object of OpenApiRestCall_822083972
proc url_DeletePermission_822085344(protocol: Scheme; host: string;
                                    base: string; route: string; path: JsonNode;
                                    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "tunedModel" in path, "`tunedModel` is a required path parameter"
  assert "permission" in path, "`permission` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/tunedModels/"),
                 (kind: VariableSegment, value: "tunedModel"),
                 (kind: ConstantSegment, value: "/permissions/"),
                 (kind: VariableSegment, value: "permission")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DeletePermission_822085343(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Deletes the permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   permission: JString (required)
  ##             : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   tunedModel: JString (required)
  ##             : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `permission` field"
  var valid_822085345 = path.getOrDefault("permission")
  valid_822085345 = validateParameter(valid_822085345, JString, required = true,
                                      default = nil)
  if valid_822085345 != nil:
    section.add "permission", valid_822085345
  var valid_822085346 = path.getOrDefault("tunedModel")
  valid_822085346 = validateParameter(valid_822085346, JString, required = true,
                                      default = nil)
  if valid_822085346 != nil:
    section.add "tunedModel", valid_822085346
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822085347 = query.getOrDefault("$alt")
  valid_822085347 = validateParameter(valid_822085347, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822085347 != nil:
    section.add "$alt", valid_822085347
  var valid_822085348 = query.getOrDefault("$.xgafv")
  valid_822085348 = validateParameter(valid_822085348, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822085348 != nil:
    section.add "$.xgafv", valid_822085348
  var valid_822085349 = query.getOrDefault("$callback")
  valid_822085349 = validateParameter(valid_822085349, JString,
                                      required = false, default = nil)
  if valid_822085349 != nil:
    section.add "$callback", valid_822085349
  var valid_822085350 = query.getOrDefault("$prettyPrint")
  valid_822085350 = validateParameter(valid_822085350, JBool, required = false,
                                      default = nil)
  if valid_822085350 != nil:
    section.add "$prettyPrint", valid_822085350
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085351: Call_DeletePermission_822085342;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Deletes the permission.
  ## 
  let valid = call_822085351.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085351.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085351.makeUrl(scheme.get, call_822085351.host, call_822085351.base,
                                   call_822085351.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085351, uri, valid, content)

proc call*(call_822085352: Call_DeletePermission_822085342; permission: string;
           tunedModel: string; Alt: string = "json"; Xgafv: string = "1";
           Callback: string = ""; PrettyPrint: bool = false): Recallable =
  ## deletePermission
  ## Deletes the permission.
  ##   permission: string (required)
  ##             : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   tunedModel: string (required)
  ##             : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   Alt: string
  ##      : Data format for response.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822085353 = newJObject()
  var query_822085354 = newJObject()
  add(path_822085353, "permission", newJString(permission))
  add(path_822085353, "tunedModel", newJString(tunedModel))
  add(query_822085354, "$alt", newJString(Alt))
  add(query_822085354, "$.xgafv", newJString(Xgafv))
  add(query_822085354, "$callback", newJString(Callback))
  add(query_822085354, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822085352.call(path_822085353, query_822085354, nil, nil, nil)

var deletePermission* = Call_DeletePermission_822085342(
    name: "deletePermission", meth: HttpMethod.HttpDelete,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/tunedModels/{tunedModel}/permissions/{permission}",
    validator: validate_DeletePermission_822085343, base: "/",
    makeUrl: url_DeletePermission_822085344, schemes: {Scheme.Https})
type
  Call_GetPermission_822085329 = ref object of OpenApiRestCall_822083972
proc url_GetPermission_822085331(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "tunedModel" in path, "`tunedModel` is a required path parameter"
  assert "permission" in path, "`permission` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/tunedModels/"),
                 (kind: VariableSegment, value: "tunedModel"),
                 (kind: ConstantSegment, value: "/permissions/"),
                 (kind: VariableSegment, value: "permission")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GetPermission_822085330(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Gets information about a specific Permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   permission: JString (required)
  ##             : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   tunedModel: JString (required)
  ##             : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `permission` field"
  var valid_822085332 = path.getOrDefault("permission")
  valid_822085332 = validateParameter(valid_822085332, JString, required = true,
                                      default = nil)
  if valid_822085332 != nil:
    section.add "permission", valid_822085332
  var valid_822085333 = path.getOrDefault("tunedModel")
  valid_822085333 = validateParameter(valid_822085333, JString, required = true,
                                      default = nil)
  if valid_822085333 != nil:
    section.add "tunedModel", valid_822085333
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822085334 = query.getOrDefault("$alt")
  valid_822085334 = validateParameter(valid_822085334, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822085334 != nil:
    section.add "$alt", valid_822085334
  var valid_822085335 = query.getOrDefault("$.xgafv")
  valid_822085335 = validateParameter(valid_822085335, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822085335 != nil:
    section.add "$.xgafv", valid_822085335
  var valid_822085336 = query.getOrDefault("$callback")
  valid_822085336 = validateParameter(valid_822085336, JString,
                                      required = false, default = nil)
  if valid_822085336 != nil:
    section.add "$callback", valid_822085336
  var valid_822085337 = query.getOrDefault("$prettyPrint")
  valid_822085337 = validateParameter(valid_822085337, JBool, required = false,
                                      default = nil)
  if valid_822085337 != nil:
    section.add "$prettyPrint", valid_822085337
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085338: Call_GetPermission_822085329; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Gets information about a specific Permission.
  ## 
  let valid = call_822085338.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085338.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085338.makeUrl(scheme.get, call_822085338.host, call_822085338.base,
                                   call_822085338.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085338, uri, valid, content)

proc call*(call_822085339: Call_GetPermission_822085329; permission: string;
           tunedModel: string; Alt: string = "json"; Xgafv: string = "1";
           Callback: string = ""; PrettyPrint: bool = false): Recallable =
  ## getPermission
  ## Gets information about a specific Permission.
  ##   permission: string (required)
  ##             : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   tunedModel: string (required)
  ##             : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   Alt: string
  ##      : Data format for response.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822085340 = newJObject()
  var query_822085341 = newJObject()
  add(path_822085340, "permission", newJString(permission))
  add(path_822085340, "tunedModel", newJString(tunedModel))
  add(query_822085341, "$alt", newJString(Alt))
  add(query_822085341, "$.xgafv", newJString(Xgafv))
  add(query_822085341, "$callback", newJString(Callback))
  add(query_822085341, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822085339.call(path_822085340, query_822085341, nil, nil, nil)

var getPermission* = Call_GetPermission_822085329(name: "getPermission",
    meth: HttpMethod.HttpGet, host: "generativelanguage.googleapis.com",
    route: "/v1beta/tunedModels/{tunedModel}/permissions/{permission}",
    validator: validate_GetPermission_822085330, base: "/",
    makeUrl: url_GetPermission_822085331, schemes: {Scheme.Https})
type
  Call_UpdatePermission_822085355 = ref object of OpenApiRestCall_822083972
proc url_UpdatePermission_822085357(protocol: Scheme; host: string;
                                    base: string; route: string; path: JsonNode;
                                    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "tunedModel" in path, "`tunedModel` is a required path parameter"
  assert "permission" in path, "`permission` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/tunedModels/"),
                 (kind: VariableSegment, value: "tunedModel"),
                 (kind: ConstantSegment, value: "/permissions/"),
                 (kind: VariableSegment, value: "permission")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_UpdatePermission_822085356(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Updates the permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   permission: JString (required)
  ##             : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   tunedModel: JString (required)
  ##             : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `permission` field"
  var valid_822085358 = path.getOrDefault("permission")
  valid_822085358 = validateParameter(valid_822085358, JString, required = true,
                                      default = nil)
  if valid_822085358 != nil:
    section.add "permission", valid_822085358
  var valid_822085359 = path.getOrDefault("tunedModel")
  valid_822085359 = validateParameter(valid_822085359, JString, required = true,
                                      default = nil)
  if valid_822085359 != nil:
    section.add "tunedModel", valid_822085359
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   updateMask: JString (required)
  ##             : Required. The list of fields to update. Accepted ones:
  ##  - role (`Permission.role` field)
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822085360 = query.getOrDefault("$alt")
  valid_822085360 = validateParameter(valid_822085360, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822085360 != nil:
    section.add "$alt", valid_822085360
  assert query != nil,
         "query argument is necessary due to required `updateMask` field"
  var valid_822085361 = query.getOrDefault("updateMask")
  valid_822085361 = validateParameter(valid_822085361, JString, required = true,
                                      default = nil)
  if valid_822085361 != nil:
    section.add "updateMask", valid_822085361
  var valid_822085362 = query.getOrDefault("$.xgafv")
  valid_822085362 = validateParameter(valid_822085362, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822085362 != nil:
    section.add "$.xgafv", valid_822085362
  var valid_822085363 = query.getOrDefault("$callback")
  valid_822085363 = validateParameter(valid_822085363, JString,
                                      required = false, default = nil)
  if valid_822085363 != nil:
    section.add "$callback", valid_822085363
  var valid_822085364 = query.getOrDefault("$prettyPrint")
  valid_822085364 = validateParameter(valid_822085364, JBool, required = false,
                                      default = nil)
  if valid_822085364 != nil:
    section.add "$prettyPrint", valid_822085364
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  ##       : Required. The permission to update.
  ## 
  ## The permission's `name` field is used to identify the permission to update.
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085366: Call_UpdatePermission_822085355;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Updates the permission.
  ## 
  let valid = call_822085366.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085366.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085366.makeUrl(scheme.get, call_822085366.host, call_822085366.base,
                                   call_822085366.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085366, uri, valid, content)

proc call*(call_822085367: Call_UpdatePermission_822085355; permission: string;
           tunedModel: string; updateMask: string; Alt: string = "json";
           body: JsonNode = nil; Xgafv: string = "1"; Callback: string = "";
           PrettyPrint: bool = false): Recallable =
  ## updatePermission
  ## Updates the permission.
  ##   permission: string (required)
  ##             : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   tunedModel: string (required)
  ##             : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   Alt: string
  ##      : Data format for response.
  ##   body: JObject
  ##       : Required. The permission to update.
  ## 
  ## The permission's `name` field is used to identify the permission to update.
  ##   updateMask: string (required)
  ##             : Required. The list of fields to update. Accepted ones:
  ##  - role (`Permission.role` field)
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822085368 = newJObject()
  var query_822085369 = newJObject()
  var body_822085370 = newJObject()
  add(path_822085368, "permission", newJString(permission))
  add(path_822085368, "tunedModel", newJString(tunedModel))
  add(query_822085369, "$alt", newJString(Alt))
  if body != nil:
    body_822085370 = body
  add(query_822085369, "updateMask", newJString(updateMask))
  add(query_822085369, "$.xgafv", newJString(Xgafv))
  add(query_822085369, "$callback", newJString(Callback))
  add(query_822085369, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822085367.call(path_822085368, query_822085369, nil, nil, body_822085370)

var updatePermission* = Call_UpdatePermission_822085355(
    name: "updatePermission", meth: HttpMethod.HttpPatch,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/tunedModels/{tunedModel}/permissions/{permission}",
    validator: validate_UpdatePermission_822085356, base: "/",
    makeUrl: url_UpdatePermission_822085357, schemes: {Scheme.Https})
type
  Call_GenerateContentByTunedModel_822085371 = ref object of OpenApiRestCall_822083972
proc url_GenerateContentByTunedModel_822085373(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "tunedModel" in path, "`tunedModel` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/tunedModels/"),
                 (kind: VariableSegment, value: "tunedModel"),
                 (kind: ConstantSegment, value: ":generateContent")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GenerateContentByTunedModel_822085372(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode;
    content: string = ""): JsonNode {.nosinks.} =
  ## Generates a model response given an input `GenerateContentRequest`.
  ## Refer to the [text generation
  ## guide](https://ai.google.dev/gemini-api/docs/text-generation) for detailed
  ## usage information. Input capabilities differ between models, including
  ## tuned models. Refer to the [model
  ## guide](https://ai.google.dev/gemini-api/docs/models/gemini) and [tuning
  ## guide](https://ai.google.dev/gemini-api/docs/model-tuning) for details.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tunedModel: JString (required)
  ##             : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `tunedModel` field"
  var valid_822085374 = path.getOrDefault("tunedModel")
  valid_822085374 = validateParameter(valid_822085374, JString, required = true,
                                      default = nil)
  if valid_822085374 != nil:
    section.add "tunedModel", valid_822085374
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822085375 = query.getOrDefault("$alt")
  valid_822085375 = validateParameter(valid_822085375, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822085375 != nil:
    section.add "$alt", valid_822085375
  var valid_822085376 = query.getOrDefault("$.xgafv")
  valid_822085376 = validateParameter(valid_822085376, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822085376 != nil:
    section.add "$.xgafv", valid_822085376
  var valid_822085377 = query.getOrDefault("$callback")
  valid_822085377 = validateParameter(valid_822085377, JString,
                                      required = false, default = nil)
  if valid_822085377 != nil:
    section.add "$callback", valid_822085377
  var valid_822085378 = query.getOrDefault("$prettyPrint")
  valid_822085378 = validateParameter(valid_822085378, JBool, required = false,
                                      default = nil)
  if valid_822085378 != nil:
    section.add "$prettyPrint", valid_822085378
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  ##       : The request body.
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085380: Call_GenerateContentByTunedModel_822085371;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Generates a model response given an input `GenerateContentRequest`.
  ## Refer to the [text generation
  ## guide](https://ai.google.dev/gemini-api/docs/text-generation) for detailed
  ## usage information. Input capabilities differ between models, including
  ## tuned models. Refer to the [model
  ## guide](https://ai.google.dev/gemini-api/docs/models/gemini) and [tuning
  ## guide](https://ai.google.dev/gemini-api/docs/model-tuning) for details.
  ## 
  let valid = call_822085380.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085380.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085380.makeUrl(scheme.get, call_822085380.host, call_822085380.base,
                                   call_822085380.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085380, uri, valid, content)

proc call*(call_822085381: Call_GenerateContentByTunedModel_822085371;
           tunedModel: string; Alt: string = "json"; body: JsonNode = nil;
           Xgafv: string = "1"; Callback: string = ""; PrettyPrint: bool = false): Recallable =
  ## generateContentByTunedModel
  ## Generates a model response given an input `GenerateContentRequest`.
  ## Refer to the [text generation
  ## guide](https://ai.google.dev/gemini-api/docs/text-generation) for detailed
  ## usage information. Input capabilities differ between models, including
  ## tuned models. Refer to the [model
  ## guide](https://ai.google.dev/gemini-api/docs/models/gemini) and [tuning
  ## guide](https://ai.google.dev/gemini-api/docs/model-tuning) for details.
  ##   tunedModel: string (required)
  ##             : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   Alt: string
  ##      : Data format for response.
  ##   body: JObject
  ##       : The request body.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822085382 = newJObject()
  var query_822085383 = newJObject()
  var body_822085384 = newJObject()
  add(path_822085382, "tunedModel", newJString(tunedModel))
  add(query_822085383, "$alt", newJString(Alt))
  if body != nil:
    body_822085384 = body
  add(query_822085383, "$.xgafv", newJString(Xgafv))
  add(query_822085383, "$callback", newJString(Callback))
  add(query_822085383, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822085381.call(path_822085382, query_822085383, nil, nil, body_822085384)

var generateContentByTunedModel* = Call_GenerateContentByTunedModel_822085371(
    name: "generateContentByTunedModel", meth: HttpMethod.HttpPost,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/tunedModels/{tunedModel}:generateContent",
    validator: validate_GenerateContentByTunedModel_822085372, base: "/",
    makeUrl: url_GenerateContentByTunedModel_822085373, schemes: {Scheme.Https})
type
  Call_GenerateTextByTunedModel_822085385 = ref object of OpenApiRestCall_822083972
proc url_GenerateTextByTunedModel_822085387(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "tunedModel" in path, "`tunedModel` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/tunedModels/"),
                 (kind: VariableSegment, value: "tunedModel"),
                 (kind: ConstantSegment, value: ":generateText")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GenerateTextByTunedModel_822085386(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode;
    content: string = ""): JsonNode {.nosinks.} =
  ## Generates a response from the model given an input message.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tunedModel: JString (required)
  ##             : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `tunedModel` field"
  var valid_822085388 = path.getOrDefault("tunedModel")
  valid_822085388 = validateParameter(valid_822085388, JString, required = true,
                                      default = nil)
  if valid_822085388 != nil:
    section.add "tunedModel", valid_822085388
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822085389 = query.getOrDefault("$alt")
  valid_822085389 = validateParameter(valid_822085389, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822085389 != nil:
    section.add "$alt", valid_822085389
  var valid_822085390 = query.getOrDefault("$.xgafv")
  valid_822085390 = validateParameter(valid_822085390, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822085390 != nil:
    section.add "$.xgafv", valid_822085390
  var valid_822085391 = query.getOrDefault("$callback")
  valid_822085391 = validateParameter(valid_822085391, JString,
                                      required = false, default = nil)
  if valid_822085391 != nil:
    section.add "$callback", valid_822085391
  var valid_822085392 = query.getOrDefault("$prettyPrint")
  valid_822085392 = validateParameter(valid_822085392, JBool, required = false,
                                      default = nil)
  if valid_822085392 != nil:
    section.add "$prettyPrint", valid_822085392
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  ##       : The request body.
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085394: Call_GenerateTextByTunedModel_822085385;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Generates a response from the model given an input message.
  ## 
  let valid = call_822085394.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085394.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085394.makeUrl(scheme.get, call_822085394.host, call_822085394.base,
                                   call_822085394.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085394, uri, valid, content)

proc call*(call_822085395: Call_GenerateTextByTunedModel_822085385;
           tunedModel: string; Alt: string = "json"; body: JsonNode = nil;
           Xgafv: string = "1"; Callback: string = ""; PrettyPrint: bool = false): Recallable =
  ## generateTextByTunedModel
  ## Generates a response from the model given an input message.
  ##   tunedModel: string (required)
  ##             : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   Alt: string
  ##      : Data format for response.
  ##   body: JObject
  ##       : The request body.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822085396 = newJObject()
  var query_822085397 = newJObject()
  var body_822085398 = newJObject()
  add(path_822085396, "tunedModel", newJString(tunedModel))
  add(query_822085397, "$alt", newJString(Alt))
  if body != nil:
    body_822085398 = body
  add(query_822085397, "$.xgafv", newJString(Xgafv))
  add(query_822085397, "$callback", newJString(Callback))
  add(query_822085397, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822085395.call(path_822085396, query_822085397, nil, nil, body_822085398)

var generateTextByTunedModel* = Call_GenerateTextByTunedModel_822085385(
    name: "generateTextByTunedModel", meth: HttpMethod.HttpPost,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/tunedModels/{tunedModel}:generateText",
    validator: validate_GenerateTextByTunedModel_822085386, base: "/",
    makeUrl: url_GenerateTextByTunedModel_822085387, schemes: {Scheme.Https})
type
  Call_StreamGenerateContentByTunedModel_822085399 = ref object of OpenApiRestCall_822083972
proc url_StreamGenerateContentByTunedModel_822085401(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "tunedModel" in path, "`tunedModel` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/tunedModels/"),
                 (kind: VariableSegment, value: "tunedModel"),
                 (kind: ConstantSegment, value: ":streamGenerateContent")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_StreamGenerateContentByTunedModel_822085400(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode;
    content: string = ""): JsonNode {.nosinks.} =
  ## Generates a [streamed
  ## response](https://ai.google.dev/gemini-api/docs/text-generation?lang=python#generate-a-text-stream)
  ## from the model given an input `GenerateContentRequest`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tunedModel: JString (required)
  ##             : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `tunedModel` field"
  var valid_822085402 = path.getOrDefault("tunedModel")
  valid_822085402 = validateParameter(valid_822085402, JString, required = true,
                                      default = nil)
  if valid_822085402 != nil:
    section.add "tunedModel", valid_822085402
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822085403 = query.getOrDefault("$alt")
  valid_822085403 = validateParameter(valid_822085403, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822085403 != nil:
    section.add "$alt", valid_822085403
  var valid_822085404 = query.getOrDefault("$.xgafv")
  valid_822085404 = validateParameter(valid_822085404, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822085404 != nil:
    section.add "$.xgafv", valid_822085404
  var valid_822085405 = query.getOrDefault("$callback")
  valid_822085405 = validateParameter(valid_822085405, JString,
                                      required = false, default = nil)
  if valid_822085405 != nil:
    section.add "$callback", valid_822085405
  var valid_822085406 = query.getOrDefault("$prettyPrint")
  valid_822085406 = validateParameter(valid_822085406, JBool, required = false,
                                      default = nil)
  if valid_822085406 != nil:
    section.add "$prettyPrint", valid_822085406
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  ##       : The request body.
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085408: Call_StreamGenerateContentByTunedModel_822085399;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Generates a [streamed
  ## response](https://ai.google.dev/gemini-api/docs/text-generation?lang=python#generate-a-text-stream)
  ## from the model given an input `GenerateContentRequest`.
  ## 
  let valid = call_822085408.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085408.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085408.makeUrl(scheme.get, call_822085408.host, call_822085408.base,
                                   call_822085408.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085408, uri, valid, content)

proc call*(call_822085409: Call_StreamGenerateContentByTunedModel_822085399;
           tunedModel: string; Alt: string = "json"; body: JsonNode = nil;
           Xgafv: string = "1"; Callback: string = ""; PrettyPrint: bool = false): Recallable =
  ## streamGenerateContentByTunedModel
  ## Generates a [streamed
  ## response](https://ai.google.dev/gemini-api/docs/text-generation?lang=python#generate-a-text-stream)
  ## from the model given an input `GenerateContentRequest`.
  ##   tunedModel: string (required)
  ##             : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   Alt: string
  ##      : Data format for response.
  ##   body: JObject
  ##       : The request body.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822085410 = newJObject()
  var query_822085411 = newJObject()
  var body_822085412 = newJObject()
  add(path_822085410, "tunedModel", newJString(tunedModel))
  add(query_822085411, "$alt", newJString(Alt))
  if body != nil:
    body_822085412 = body
  add(query_822085411, "$.xgafv", newJString(Xgafv))
  add(query_822085411, "$callback", newJString(Callback))
  add(query_822085411, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822085409.call(path_822085410, query_822085411, nil, nil, body_822085412)

var streamGenerateContentByTunedModel* = Call_StreamGenerateContentByTunedModel_822085399(
    name: "streamGenerateContentByTunedModel", meth: HttpMethod.HttpPost,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/tunedModels/{tunedModel}:streamGenerateContent",
    validator: validate_StreamGenerateContentByTunedModel_822085400, base: "/",
    makeUrl: url_StreamGenerateContentByTunedModel_822085401,
    schemes: {Scheme.Https})
type
  Call_TransferOwnership_822085413 = ref object of OpenApiRestCall_822083972
proc url_TransferOwnership_822085415(protocol: Scheme; host: string;
                                     base: string; route: string;
                                     path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "tunedModel" in path, "`tunedModel` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/tunedModels/"),
                 (kind: VariableSegment, value: "tunedModel"),
                 (kind: ConstantSegment, value: ":transferOwnership")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_TransferOwnership_822085414(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Transfers ownership of the tuned model.
  ## This is the only way to change ownership of the tuned model.
  ## The current owner will be downgraded to writer role.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tunedModel: JString (required)
  ##             : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `tunedModel` field"
  var valid_822085416 = path.getOrDefault("tunedModel")
  valid_822085416 = validateParameter(valid_822085416, JString, required = true,
                                      default = nil)
  if valid_822085416 != nil:
    section.add "tunedModel", valid_822085416
  result.add "path", section
  ## parameters in `query` object:
  ##   $alt: JString
  ##       : Data format for response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   $callback: JString
  ##            : JSONP
  ##   $prettyPrint: JBool
  ##               : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_822085417 = query.getOrDefault("$alt")
  valid_822085417 = validateParameter(valid_822085417, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822085417 != nil:
    section.add "$alt", valid_822085417
  var valid_822085418 = query.getOrDefault("$.xgafv")
  valid_822085418 = validateParameter(valid_822085418, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822085418 != nil:
    section.add "$.xgafv", valid_822085418
  var valid_822085419 = query.getOrDefault("$callback")
  valid_822085419 = validateParameter(valid_822085419, JString,
                                      required = false, default = nil)
  if valid_822085419 != nil:
    section.add "$callback", valid_822085419
  var valid_822085420 = query.getOrDefault("$prettyPrint")
  valid_822085420 = validateParameter(valid_822085420, JBool, required = false,
                                      default = nil)
  if valid_822085420 != nil:
    section.add "$prettyPrint", valid_822085420
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  ##       : The request body.
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085422: Call_TransferOwnership_822085413;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Transfers ownership of the tuned model.
  ## This is the only way to change ownership of the tuned model.
  ## The current owner will be downgraded to writer role.
  ## 
  let valid = call_822085422.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085422.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085422.makeUrl(scheme.get, call_822085422.host, call_822085422.base,
                                   call_822085422.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085422, uri, valid, content)

proc call*(call_822085423: Call_TransferOwnership_822085413; tunedModel: string;
           Alt: string = "json"; body: JsonNode = nil; Xgafv: string = "1";
           Callback: string = ""; PrettyPrint: bool = false): Recallable =
  ## transferOwnership
  ## Transfers ownership of the tuned model.
  ## This is the only way to change ownership of the tuned model.
  ## The current owner will be downgraded to writer role.
  ##   tunedModel: string (required)
  ##             : Resource ID segment making up resource `name`. It identifies the resource within its parent collection as described in https://google.aip.dev/122.
  ##   Alt: string
  ##      : Data format for response.
  ##   body: JObject
  ##       : The request body.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   Callback: string
  ##           : JSONP
  ##   PrettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_822085424 = newJObject()
  var query_822085425 = newJObject()
  var body_822085426 = newJObject()
  add(path_822085424, "tunedModel", newJString(tunedModel))
  add(query_822085425, "$alt", newJString(Alt))
  if body != nil:
    body_822085426 = body
  add(query_822085425, "$.xgafv", newJString(Xgafv))
  add(query_822085425, "$callback", newJString(Callback))
  add(query_822085425, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822085423.call(path_822085424, query_822085425, nil, nil, body_822085426)

var transferOwnership* = Call_TransferOwnership_822085413(
    name: "transferOwnership", meth: HttpMethod.HttpPost,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/tunedModels/{tunedModel}:transferOwnership",
    validator: validate_TransferOwnership_822085414, base: "/",
    makeUrl: url_TransferOwnership_822085415, schemes: {Scheme.Https})
discard