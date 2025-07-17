
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
  OpenApiRestCall_822083986 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_822083986](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base,
             route: t.route, schemes: t.schemes, validator: t.validator,
             url: t.url)

proc pickScheme(t: OpenApiRestCall_822083986): Option[Scheme] {.used.} =
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

method newRecallable(call: RestCall; url: Uri; input: JsonNode; content: string): Recallable {.
    base.} =
  newRecallable(call, url, input.getOrDefault("header").massageHeaders, content)

type
  Call_ListOperationsBy_822084174 = ref object of OpenApiRestCall_822083986
proc url_ListOperationsBy_822084176(protocol: Scheme; host: string;
                                    base: string; route: string; path: JsonNode;
                                    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_ListOperationsBy_822084175(path: JsonNode; query: JsonNode;
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
  var valid_822084267 = query.getOrDefault("$alt")
  valid_822084267 = validateParameter(valid_822084267, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084267 != nil:
    section.add "$alt", valid_822084267
  var valid_822084268 = query.getOrDefault("$.xgafv")
  valid_822084268 = validateParameter(valid_822084268, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084268 != nil:
    section.add "$.xgafv", valid_822084268
  var valid_822084269 = query.getOrDefault("$callback")
  valid_822084269 = validateParameter(valid_822084269, JString,
                                      required = false, default = nil)
  if valid_822084269 != nil:
    section.add "$callback", valid_822084269
  var valid_822084270 = query.getOrDefault("filter")
  valid_822084270 = validateParameter(valid_822084270, JString,
                                      required = false, default = nil)
  if valid_822084270 != nil:
    section.add "filter", valid_822084270
  var valid_822084271 = query.getOrDefault("pageSize")
  valid_822084271 = validateParameter(valid_822084271, JInt, required = false,
                                      default = nil)
  if valid_822084271 != nil:
    section.add "pageSize", valid_822084271
  var valid_822084272 = query.getOrDefault("pageToken")
  valid_822084272 = validateParameter(valid_822084272, JString,
                                      required = false, default = nil)
  if valid_822084272 != nil:
    section.add "pageToken", valid_822084272
  var valid_822084273 = query.getOrDefault("$prettyPrint")
  valid_822084273 = validateParameter(valid_822084273, JBool, required = false,
                                      default = nil)
  if valid_822084273 != nil:
    section.add "$prettyPrint", valid_822084273
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084285: Call_ListOperationsBy_822084174;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ## 
  let valid = call_822084285.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084285.makeUrl(scheme.get, call_822084285.host, call_822084285.base,
                                   call_822084285.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084285, uri, valid, content)

proc call*(call_822084334: Call_ListOperationsBy_822084174;
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
  var query_822084335 = newJObject()
  add(query_822084335, "$alt", newJString(Alt))
  add(query_822084335, "$.xgafv", newJString(Xgafv))
  add(query_822084335, "$callback", newJString(Callback))
  add(query_822084335, "filter", newJString(filter))
  add(query_822084335, "pageSize", newJInt(pageSize))
  add(query_822084335, "pageToken", newJString(pageToken))
  add(query_822084335, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084334.call(nil, query_822084335, nil, nil, nil)

var listOperationsBy* = Call_ListOperationsBy_822084174(
    name: "listOperationsBy", meth: HttpMethod.HttpGet,
    host: "generativelanguage.googleapis.com", route: "/v1beta/batches",
    validator: validate_ListOperationsBy_822084175, base: "/",
    makeUrl: url_ListOperationsBy_822084176, schemes: {Scheme.Https})
type
  Call_DeleteOperation_822084385 = ref object of OpenApiRestCall_822083986
proc url_DeleteOperation_822084387(protocol: Scheme; host: string; base: string;
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

proc validate_DeleteOperation_822084386(path: JsonNode; query: JsonNode;
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
  var valid_822084388 = path.getOrDefault("generateContentBatch")
  valid_822084388 = validateParameter(valid_822084388, JString, required = true,
                                      default = nil)
  if valid_822084388 != nil:
    section.add "generateContentBatch", valid_822084388
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
  var valid_822084389 = query.getOrDefault("$alt")
  valid_822084389 = validateParameter(valid_822084389, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084389 != nil:
    section.add "$alt", valid_822084389
  var valid_822084390 = query.getOrDefault("$.xgafv")
  valid_822084390 = validateParameter(valid_822084390, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084390 != nil:
    section.add "$.xgafv", valid_822084390
  var valid_822084391 = query.getOrDefault("$callback")
  valid_822084391 = validateParameter(valid_822084391, JString,
                                      required = false, default = nil)
  if valid_822084391 != nil:
    section.add "$callback", valid_822084391
  var valid_822084392 = query.getOrDefault("$prettyPrint")
  valid_822084392 = validateParameter(valid_822084392, JBool, required = false,
                                      default = nil)
  if valid_822084392 != nil:
    section.add "$prettyPrint", valid_822084392
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084393: Call_DeleteOperation_822084385; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ## 
  let valid = call_822084393.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084393.makeUrl(scheme.get, call_822084393.host, call_822084393.base,
                                   call_822084393.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084393, uri, valid, content)

proc call*(call_822084394: Call_DeleteOperation_822084385;
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
  var path_822084395 = newJObject()
  var query_822084396 = newJObject()
  add(path_822084395, "generateContentBatch", newJString(generateContentBatch))
  add(query_822084396, "$alt", newJString(Alt))
  add(query_822084396, "$.xgafv", newJString(Xgafv))
  add(query_822084396, "$callback", newJString(Callback))
  add(query_822084396, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084394.call(path_822084395, query_822084396, nil, nil, nil)

var deleteOperation* = Call_DeleteOperation_822084385(name: "deleteOperation",
    meth: HttpMethod.HttpDelete, host: "generativelanguage.googleapis.com",
    route: "/v1beta/batches/{generateContentBatch}",
    validator: validate_DeleteOperation_822084386, base: "/",
    makeUrl: url_DeleteOperation_822084387, schemes: {Scheme.Https})
type
  Call_GetOperationByGenerateContentBatch_822084362 = ref object of OpenApiRestCall_822083986
proc url_GetOperationByGenerateContentBatch_822084364(protocol: Scheme;
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

proc validate_GetOperationByGenerateContentBatch_822084363(path: JsonNode;
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
  var valid_822084376 = path.getOrDefault("generateContentBatch")
  valid_822084376 = validateParameter(valid_822084376, JString, required = true,
                                      default = nil)
  if valid_822084376 != nil:
    section.add "generateContentBatch", valid_822084376
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
  var valid_822084377 = query.getOrDefault("$alt")
  valid_822084377 = validateParameter(valid_822084377, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084377 != nil:
    section.add "$alt", valid_822084377
  var valid_822084378 = query.getOrDefault("$.xgafv")
  valid_822084378 = validateParameter(valid_822084378, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084378 != nil:
    section.add "$.xgafv", valid_822084378
  var valid_822084379 = query.getOrDefault("$callback")
  valid_822084379 = validateParameter(valid_822084379, JString,
                                      required = false, default = nil)
  if valid_822084379 != nil:
    section.add "$callback", valid_822084379
  var valid_822084380 = query.getOrDefault("$prettyPrint")
  valid_822084380 = validateParameter(valid_822084380, JBool, required = false,
                                      default = nil)
  if valid_822084380 != nil:
    section.add "$prettyPrint", valid_822084380
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084381: Call_GetOperationByGenerateContentBatch_822084362;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_822084381.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084381.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084381.makeUrl(scheme.get, call_822084381.host, call_822084381.base,
                                   call_822084381.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084381, uri, valid, content)

proc call*(call_822084382: Call_GetOperationByGenerateContentBatch_822084362;
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
  var path_822084383 = newJObject()
  var query_822084384 = newJObject()
  add(path_822084383, "generateContentBatch", newJString(generateContentBatch))
  add(query_822084384, "$alt", newJString(Alt))
  add(query_822084384, "$.xgafv", newJString(Xgafv))
  add(query_822084384, "$callback", newJString(Callback))
  add(query_822084384, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084382.call(path_822084383, query_822084384, nil, nil, nil)

var getOperationByGenerateContentBatch* = Call_GetOperationByGenerateContentBatch_822084362(
    name: "getOperationByGenerateContentBatch", meth: HttpMethod.HttpGet,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/batches/{generateContentBatch}",
    validator: validate_GetOperationByGenerateContentBatch_822084363, base: "/",
    makeUrl: url_GetOperationByGenerateContentBatch_822084364,
    schemes: {Scheme.Https})
type
  Call_CancelOperation_822084397 = ref object of OpenApiRestCall_822083986
proc url_CancelOperation_822084399(protocol: Scheme; host: string; base: string;
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

proc validate_CancelOperation_822084398(path: JsonNode; query: JsonNode;
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
  var valid_822084400 = path.getOrDefault("generateContentBatch")
  valid_822084400 = validateParameter(valid_822084400, JString, required = true,
                                      default = nil)
  if valid_822084400 != nil:
    section.add "generateContentBatch", valid_822084400
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
  var valid_822084401 = query.getOrDefault("$alt")
  valid_822084401 = validateParameter(valid_822084401, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084401 != nil:
    section.add "$alt", valid_822084401
  var valid_822084402 = query.getOrDefault("$.xgafv")
  valid_822084402 = validateParameter(valid_822084402, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084402 != nil:
    section.add "$.xgafv", valid_822084402
  var valid_822084403 = query.getOrDefault("$callback")
  valid_822084403 = validateParameter(valid_822084403, JString,
                                      required = false, default = nil)
  if valid_822084403 != nil:
    section.add "$callback", valid_822084403
  var valid_822084404 = query.getOrDefault("$prettyPrint")
  valid_822084404 = validateParameter(valid_822084404, JBool, required = false,
                                      default = nil)
  if valid_822084404 != nil:
    section.add "$prettyPrint", valid_822084404
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084405: Call_CancelOperation_822084397; path: JsonNode = nil;
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
  let valid = call_822084405.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084405.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084405.makeUrl(scheme.get, call_822084405.host, call_822084405.base,
                                   call_822084405.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084405, uri, valid, content)

proc call*(call_822084406: Call_CancelOperation_822084397;
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
  var path_822084407 = newJObject()
  var query_822084408 = newJObject()
  add(path_822084407, "generateContentBatch", newJString(generateContentBatch))
  add(query_822084408, "$alt", newJString(Alt))
  add(query_822084408, "$.xgafv", newJString(Xgafv))
  add(query_822084408, "$callback", newJString(Callback))
  add(query_822084408, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084406.call(path_822084407, query_822084408, nil, nil, nil)

var cancelOperation* = Call_CancelOperation_822084397(name: "cancelOperation",
    meth: HttpMethod.HttpPost, host: "generativelanguage.googleapis.com",
    route: "/v1beta/batches/{generateContentBatch}:cancel",
    validator: validate_CancelOperation_822084398, base: "/",
    makeUrl: url_CancelOperation_822084399, schemes: {Scheme.Https})
type
  Call_CreateCachedContent_822084421 = ref object of OpenApiRestCall_822083986
proc url_CreateCachedContent_822084423(protocol: Scheme; host: string;
                                       base: string; route: string;
                                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CreateCachedContent_822084422(path: JsonNode; query: JsonNode;
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
  var valid_822084434 = query.getOrDefault("$alt")
  valid_822084434 = validateParameter(valid_822084434, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084434 != nil:
    section.add "$alt", valid_822084434
  var valid_822084435 = query.getOrDefault("$.xgafv")
  valid_822084435 = validateParameter(valid_822084435, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084435 != nil:
    section.add "$.xgafv", valid_822084435
  var valid_822084436 = query.getOrDefault("$callback")
  valid_822084436 = validateParameter(valid_822084436, JString,
                                      required = false, default = nil)
  if valid_822084436 != nil:
    section.add "$callback", valid_822084436
  var valid_822084437 = query.getOrDefault("$prettyPrint")
  valid_822084437 = validateParameter(valid_822084437, JBool, required = false,
                                      default = nil)
  if valid_822084437 != nil:
    section.add "$prettyPrint", valid_822084437
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

proc call*(call_822084439: Call_CreateCachedContent_822084421;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Creates CachedContent resource.
  ## 
  let valid = call_822084439.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084439.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084439.makeUrl(scheme.get, call_822084439.host, call_822084439.base,
                                   call_822084439.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084439, uri, valid, content)

proc call*(call_822084440: Call_CreateCachedContent_822084421;
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
  var query_822084441 = newJObject()
  var body_822084442 = newJObject()
  add(query_822084441, "$alt", newJString(Alt))
  if body != nil:
    body_822084442 = body
  add(query_822084441, "$.xgafv", newJString(Xgafv))
  add(query_822084441, "$callback", newJString(Callback))
  add(query_822084441, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084440.call(nil, query_822084441, nil, nil, body_822084442)

var createCachedContent* = Call_CreateCachedContent_822084421(
    name: "createCachedContent", meth: HttpMethod.HttpPost,
    host: "generativelanguage.googleapis.com", route: "/v1beta/cachedContents",
    validator: validate_CreateCachedContent_822084422, base: "/",
    makeUrl: url_CreateCachedContent_822084423, schemes: {Scheme.Https})
type
  Call_ListCachedContents_822084409 = ref object of OpenApiRestCall_822083986
proc url_ListCachedContents_822084411(protocol: Scheme; host: string;
                                      base: string; route: string;
                                      path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_ListCachedContents_822084410(path: JsonNode; query: JsonNode;
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
  var valid_822084412 = query.getOrDefault("$alt")
  valid_822084412 = validateParameter(valid_822084412, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084412 != nil:
    section.add "$alt", valid_822084412
  var valid_822084413 = query.getOrDefault("$.xgafv")
  valid_822084413 = validateParameter(valid_822084413, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084413 != nil:
    section.add "$.xgafv", valid_822084413
  var valid_822084414 = query.getOrDefault("$callback")
  valid_822084414 = validateParameter(valid_822084414, JString,
                                      required = false, default = nil)
  if valid_822084414 != nil:
    section.add "$callback", valid_822084414
  var valid_822084415 = query.getOrDefault("pageSize")
  valid_822084415 = validateParameter(valid_822084415, JInt, required = false,
                                      default = nil)
  if valid_822084415 != nil:
    section.add "pageSize", valid_822084415
  var valid_822084416 = query.getOrDefault("pageToken")
  valid_822084416 = validateParameter(valid_822084416, JString,
                                      required = false, default = nil)
  if valid_822084416 != nil:
    section.add "pageToken", valid_822084416
  var valid_822084417 = query.getOrDefault("$prettyPrint")
  valid_822084417 = validateParameter(valid_822084417, JBool, required = false,
                                      default = nil)
  if valid_822084417 != nil:
    section.add "$prettyPrint", valid_822084417
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084418: Call_ListCachedContents_822084409;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Lists CachedContents.
  ## 
  let valid = call_822084418.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084418.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084418.makeUrl(scheme.get, call_822084418.host, call_822084418.base,
                                   call_822084418.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084418, uri, valid, content)

proc call*(call_822084419: Call_ListCachedContents_822084409;
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
  var query_822084420 = newJObject()
  add(query_822084420, "$alt", newJString(Alt))
  add(query_822084420, "$.xgafv", newJString(Xgafv))
  add(query_822084420, "$callback", newJString(Callback))
  add(query_822084420, "pageSize", newJInt(pageSize))
  add(query_822084420, "pageToken", newJString(pageToken))
  add(query_822084420, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084419.call(nil, query_822084420, nil, nil, nil)

var listCachedContents* = Call_ListCachedContents_822084409(
    name: "listCachedContents", meth: HttpMethod.HttpGet,
    host: "generativelanguage.googleapis.com", route: "/v1beta/cachedContents",
    validator: validate_ListCachedContents_822084410, base: "/",
    makeUrl: url_ListCachedContents_822084411, schemes: {Scheme.Https})
type
  Call_DeleteCachedContent_822084455 = ref object of OpenApiRestCall_822083986
proc url_DeleteCachedContent_822084457(protocol: Scheme; host: string;
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

proc validate_DeleteCachedContent_822084456(path: JsonNode; query: JsonNode;
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
  var valid_822084458 = path.getOrDefault("id")
  valid_822084458 = validateParameter(valid_822084458, JString, required = true,
                                      default = nil)
  if valid_822084458 != nil:
    section.add "id", valid_822084458
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
  var valid_822084459 = query.getOrDefault("$alt")
  valid_822084459 = validateParameter(valid_822084459, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084459 != nil:
    section.add "$alt", valid_822084459
  var valid_822084460 = query.getOrDefault("$.xgafv")
  valid_822084460 = validateParameter(valid_822084460, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084460 != nil:
    section.add "$.xgafv", valid_822084460
  var valid_822084461 = query.getOrDefault("$callback")
  valid_822084461 = validateParameter(valid_822084461, JString,
                                      required = false, default = nil)
  if valid_822084461 != nil:
    section.add "$callback", valid_822084461
  var valid_822084462 = query.getOrDefault("$prettyPrint")
  valid_822084462 = validateParameter(valid_822084462, JBool, required = false,
                                      default = nil)
  if valid_822084462 != nil:
    section.add "$prettyPrint", valid_822084462
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084463: Call_DeleteCachedContent_822084455;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Deletes CachedContent resource.
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

proc call*(call_822084464: Call_DeleteCachedContent_822084455; id: string;
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
  var path_822084465 = newJObject()
  var query_822084466 = newJObject()
  add(query_822084466, "$alt", newJString(Alt))
  add(query_822084466, "$.xgafv", newJString(Xgafv))
  add(query_822084466, "$callback", newJString(Callback))
  add(path_822084465, "id", newJString(id))
  add(query_822084466, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084464.call(path_822084465, query_822084466, nil, nil, nil)

var deleteCachedContent* = Call_DeleteCachedContent_822084455(
    name: "deleteCachedContent", meth: HttpMethod.HttpDelete,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/cachedContents/{id}",
    validator: validate_DeleteCachedContent_822084456, base: "/",
    makeUrl: url_DeleteCachedContent_822084457, schemes: {Scheme.Https})
type
  Call_GetCachedContent_822084443 = ref object of OpenApiRestCall_822083986
proc url_GetCachedContent_822084445(protocol: Scheme; host: string;
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

proc validate_GetCachedContent_822084444(path: JsonNode; query: JsonNode;
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
  var valid_822084446 = path.getOrDefault("id")
  valid_822084446 = validateParameter(valid_822084446, JString, required = true,
                                      default = nil)
  if valid_822084446 != nil:
    section.add "id", valid_822084446
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
  var valid_822084447 = query.getOrDefault("$alt")
  valid_822084447 = validateParameter(valid_822084447, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084447 != nil:
    section.add "$alt", valid_822084447
  var valid_822084448 = query.getOrDefault("$.xgafv")
  valid_822084448 = validateParameter(valid_822084448, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084448 != nil:
    section.add "$.xgafv", valid_822084448
  var valid_822084449 = query.getOrDefault("$callback")
  valid_822084449 = validateParameter(valid_822084449, JString,
                                      required = false, default = nil)
  if valid_822084449 != nil:
    section.add "$callback", valid_822084449
  var valid_822084450 = query.getOrDefault("$prettyPrint")
  valid_822084450 = validateParameter(valid_822084450, JBool, required = false,
                                      default = nil)
  if valid_822084450 != nil:
    section.add "$prettyPrint", valid_822084450
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084451: Call_GetCachedContent_822084443;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Reads CachedContent resource.
  ## 
  let valid = call_822084451.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084451.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084451.makeUrl(scheme.get, call_822084451.host, call_822084451.base,
                                   call_822084451.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084451, uri, valid, content)

proc call*(call_822084452: Call_GetCachedContent_822084443; id: string;
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
  var path_822084453 = newJObject()
  var query_822084454 = newJObject()
  add(query_822084454, "$alt", newJString(Alt))
  add(query_822084454, "$.xgafv", newJString(Xgafv))
  add(query_822084454, "$callback", newJString(Callback))
  add(path_822084453, "id", newJString(id))
  add(query_822084454, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084452.call(path_822084453, query_822084454, nil, nil, nil)

var getCachedContent* = Call_GetCachedContent_822084443(
    name: "getCachedContent", meth: HttpMethod.HttpGet,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/cachedContents/{id}", validator: validate_GetCachedContent_822084444,
    base: "/", makeUrl: url_GetCachedContent_822084445, schemes: {Scheme.Https})
type
  Call_UpdateCachedContent_822084467 = ref object of OpenApiRestCall_822083986
proc url_UpdateCachedContent_822084469(protocol: Scheme; host: string;
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

proc validate_UpdateCachedContent_822084468(path: JsonNode; query: JsonNode;
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
  var valid_822084470 = path.getOrDefault("id")
  valid_822084470 = validateParameter(valid_822084470, JString, required = true,
                                      default = nil)
  if valid_822084470 != nil:
    section.add "id", valid_822084470
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
  var valid_822084471 = query.getOrDefault("$alt")
  valid_822084471 = validateParameter(valid_822084471, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084471 != nil:
    section.add "$alt", valid_822084471
  var valid_822084472 = query.getOrDefault("updateMask")
  valid_822084472 = validateParameter(valid_822084472, JString,
                                      required = false, default = nil)
  if valid_822084472 != nil:
    section.add "updateMask", valid_822084472
  var valid_822084473 = query.getOrDefault("$.xgafv")
  valid_822084473 = validateParameter(valid_822084473, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084473 != nil:
    section.add "$.xgafv", valid_822084473
  var valid_822084474 = query.getOrDefault("$callback")
  valid_822084474 = validateParameter(valid_822084474, JString,
                                      required = false, default = nil)
  if valid_822084474 != nil:
    section.add "$callback", valid_822084474
  var valid_822084475 = query.getOrDefault("$prettyPrint")
  valid_822084475 = validateParameter(valid_822084475, JBool, required = false,
                                      default = nil)
  if valid_822084475 != nil:
    section.add "$prettyPrint", valid_822084475
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

proc call*(call_822084477: Call_UpdateCachedContent_822084467;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Updates CachedContent resource (only expiration is updatable).
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

proc call*(call_822084478: Call_UpdateCachedContent_822084467; id: string;
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
  var path_822084479 = newJObject()
  var query_822084480 = newJObject()
  var body_822084481 = newJObject()
  add(query_822084480, "$alt", newJString(Alt))
  if body != nil:
    body_822084481 = body
  add(query_822084480, "updateMask", newJString(updateMask))
  add(query_822084480, "$.xgafv", newJString(Xgafv))
  add(query_822084480, "$callback", newJString(Callback))
  add(path_822084479, "id", newJString(id))
  add(query_822084480, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084478.call(path_822084479, query_822084480, nil, nil, body_822084481)

var updateCachedContent* = Call_UpdateCachedContent_822084467(
    name: "updateCachedContent", meth: HttpMethod.HttpPatch,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/cachedContents/{id}",
    validator: validate_UpdateCachedContent_822084468, base: "/",
    makeUrl: url_UpdateCachedContent_822084469, schemes: {Scheme.Https})
type
  Call_CreateCorpus_822084494 = ref object of OpenApiRestCall_822083986
proc url_CreateCorpus_822084496(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CreateCorpus_822084495(path: JsonNode; query: JsonNode;
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
  var valid_822084497 = query.getOrDefault("$alt")
  valid_822084497 = validateParameter(valid_822084497, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084497 != nil:
    section.add "$alt", valid_822084497
  var valid_822084498 = query.getOrDefault("$.xgafv")
  valid_822084498 = validateParameter(valid_822084498, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084498 != nil:
    section.add "$.xgafv", valid_822084498
  var valid_822084499 = query.getOrDefault("$callback")
  valid_822084499 = validateParameter(valid_822084499, JString,
                                      required = false, default = nil)
  if valid_822084499 != nil:
    section.add "$callback", valid_822084499
  var valid_822084500 = query.getOrDefault("$prettyPrint")
  valid_822084500 = validateParameter(valid_822084500, JBool, required = false,
                                      default = nil)
  if valid_822084500 != nil:
    section.add "$prettyPrint", valid_822084500
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

proc call*(call_822084502: Call_CreateCorpus_822084494; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Creates an empty `Corpus`.
  ## 
  let valid = call_822084502.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084502.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084502.makeUrl(scheme.get, call_822084502.host, call_822084502.base,
                                   call_822084502.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084502, uri, valid, content)

proc call*(call_822084503: Call_CreateCorpus_822084494; Alt: string = "json";
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
  var query_822084504 = newJObject()
  var body_822084505 = newJObject()
  add(query_822084504, "$alt", newJString(Alt))
  if body != nil:
    body_822084505 = body
  add(query_822084504, "$.xgafv", newJString(Xgafv))
  add(query_822084504, "$callback", newJString(Callback))
  add(query_822084504, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084503.call(nil, query_822084504, nil, nil, body_822084505)

var createCorpus* = Call_CreateCorpus_822084494(name: "createCorpus",
    meth: HttpMethod.HttpPost, host: "generativelanguage.googleapis.com",
    route: "/v1beta/corpora", validator: validate_CreateCorpus_822084495,
    base: "/", makeUrl: url_CreateCorpus_822084496, schemes: {Scheme.Https})
type
  Call_ListCorpora_822084482 = ref object of OpenApiRestCall_822083986
proc url_ListCorpora_822084484(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_ListCorpora_822084483(path: JsonNode; query: JsonNode;
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
  var valid_822084485 = query.getOrDefault("$alt")
  valid_822084485 = validateParameter(valid_822084485, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084485 != nil:
    section.add "$alt", valid_822084485
  var valid_822084486 = query.getOrDefault("$.xgafv")
  valid_822084486 = validateParameter(valid_822084486, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084486 != nil:
    section.add "$.xgafv", valid_822084486
  var valid_822084487 = query.getOrDefault("$callback")
  valid_822084487 = validateParameter(valid_822084487, JString,
                                      required = false, default = nil)
  if valid_822084487 != nil:
    section.add "$callback", valid_822084487
  var valid_822084488 = query.getOrDefault("pageSize")
  valid_822084488 = validateParameter(valid_822084488, JInt, required = false,
                                      default = nil)
  if valid_822084488 != nil:
    section.add "pageSize", valid_822084488
  var valid_822084489 = query.getOrDefault("pageToken")
  valid_822084489 = validateParameter(valid_822084489, JString,
                                      required = false, default = nil)
  if valid_822084489 != nil:
    section.add "pageToken", valid_822084489
  var valid_822084490 = query.getOrDefault("$prettyPrint")
  valid_822084490 = validateParameter(valid_822084490, JBool, required = false,
                                      default = nil)
  if valid_822084490 != nil:
    section.add "$prettyPrint", valid_822084490
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084491: Call_ListCorpora_822084482; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Lists all `Corpora` owned by the user.
  ## 
  let valid = call_822084491.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084491.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084491.makeUrl(scheme.get, call_822084491.host, call_822084491.base,
                                   call_822084491.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084491, uri, valid, content)

proc call*(call_822084492: Call_ListCorpora_822084482; Alt: string = "json";
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
  var query_822084493 = newJObject()
  add(query_822084493, "$alt", newJString(Alt))
  add(query_822084493, "$.xgafv", newJString(Xgafv))
  add(query_822084493, "$callback", newJString(Callback))
  add(query_822084493, "pageSize", newJInt(pageSize))
  add(query_822084493, "pageToken", newJString(pageToken))
  add(query_822084493, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084492.call(nil, query_822084493, nil, nil, nil)

var listCorpora* = Call_ListCorpora_822084482(name: "listCorpora",
    meth: HttpMethod.HttpGet, host: "generativelanguage.googleapis.com",
    route: "/v1beta/corpora", validator: validate_ListCorpora_822084483,
    base: "/", makeUrl: url_ListCorpora_822084484, schemes: {Scheme.Https})
type
  Call_DeleteCorpus_822084518 = ref object of OpenApiRestCall_822083986
proc url_DeleteCorpus_822084520(protocol: Scheme; host: string; base: string;
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

proc validate_DeleteCorpus_822084519(path: JsonNode; query: JsonNode;
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
  var valid_822084521 = path.getOrDefault("corpus")
  valid_822084521 = validateParameter(valid_822084521, JString, required = true,
                                      default = nil)
  if valid_822084521 != nil:
    section.add "corpus", valid_822084521
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
  var valid_822084522 = query.getOrDefault("force")
  valid_822084522 = validateParameter(valid_822084522, JBool, required = false,
                                      default = nil)
  if valid_822084522 != nil:
    section.add "force", valid_822084522
  var valid_822084523 = query.getOrDefault("$alt")
  valid_822084523 = validateParameter(valid_822084523, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084523 != nil:
    section.add "$alt", valid_822084523
  var valid_822084524 = query.getOrDefault("$.xgafv")
  valid_822084524 = validateParameter(valid_822084524, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084524 != nil:
    section.add "$.xgafv", valid_822084524
  var valid_822084525 = query.getOrDefault("$callback")
  valid_822084525 = validateParameter(valid_822084525, JString,
                                      required = false, default = nil)
  if valid_822084525 != nil:
    section.add "$callback", valid_822084525
  var valid_822084526 = query.getOrDefault("$prettyPrint")
  valid_822084526 = validateParameter(valid_822084526, JBool, required = false,
                                      default = nil)
  if valid_822084526 != nil:
    section.add "$prettyPrint", valid_822084526
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084527: Call_DeleteCorpus_822084518; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Deletes a `Corpus`.
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

proc call*(call_822084528: Call_DeleteCorpus_822084518; corpus: string;
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
  var path_822084529 = newJObject()
  var query_822084530 = newJObject()
  add(query_822084530, "force", newJBool(force))
  add(query_822084530, "$alt", newJString(Alt))
  add(query_822084530, "$.xgafv", newJString(Xgafv))
  add(query_822084530, "$callback", newJString(Callback))
  add(path_822084529, "corpus", newJString(corpus))
  add(query_822084530, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084528.call(path_822084529, query_822084530, nil, nil, nil)

var deleteCorpus* = Call_DeleteCorpus_822084518(name: "deleteCorpus",
    meth: HttpMethod.HttpDelete, host: "generativelanguage.googleapis.com",
    route: "/v1beta/corpora/{corpus}", validator: validate_DeleteCorpus_822084519,
    base: "/", makeUrl: url_DeleteCorpus_822084520, schemes: {Scheme.Https})
type
  Call_GetCorpus_822084506 = ref object of OpenApiRestCall_822083986
proc url_GetCorpus_822084508(protocol: Scheme; host: string; base: string;
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

proc validate_GetCorpus_822084507(path: JsonNode; query: JsonNode;
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
  var valid_822084509 = path.getOrDefault("corpus")
  valid_822084509 = validateParameter(valid_822084509, JString, required = true,
                                      default = nil)
  if valid_822084509 != nil:
    section.add "corpus", valid_822084509
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
  var valid_822084510 = query.getOrDefault("$alt")
  valid_822084510 = validateParameter(valid_822084510, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084510 != nil:
    section.add "$alt", valid_822084510
  var valid_822084511 = query.getOrDefault("$.xgafv")
  valid_822084511 = validateParameter(valid_822084511, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084511 != nil:
    section.add "$.xgafv", valid_822084511
  var valid_822084512 = query.getOrDefault("$callback")
  valid_822084512 = validateParameter(valid_822084512, JString,
                                      required = false, default = nil)
  if valid_822084512 != nil:
    section.add "$callback", valid_822084512
  var valid_822084513 = query.getOrDefault("$prettyPrint")
  valid_822084513 = validateParameter(valid_822084513, JBool, required = false,
                                      default = nil)
  if valid_822084513 != nil:
    section.add "$prettyPrint", valid_822084513
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084514: Call_GetCorpus_822084506; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Gets information about a specific `Corpus`.
  ## 
  let valid = call_822084514.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084514.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084514.makeUrl(scheme.get, call_822084514.host, call_822084514.base,
                                   call_822084514.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084514, uri, valid, content)

proc call*(call_822084515: Call_GetCorpus_822084506; corpus: string;
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
  var path_822084516 = newJObject()
  var query_822084517 = newJObject()
  add(query_822084517, "$alt", newJString(Alt))
  add(query_822084517, "$.xgafv", newJString(Xgafv))
  add(query_822084517, "$callback", newJString(Callback))
  add(path_822084516, "corpus", newJString(corpus))
  add(query_822084517, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084515.call(path_822084516, query_822084517, nil, nil, nil)

var getCorpus* = Call_GetCorpus_822084506(name: "getCorpus",
    meth: HttpMethod.HttpGet, host: "generativelanguage.googleapis.com",
    route: "/v1beta/corpora/{corpus}", validator: validate_GetCorpus_822084507,
    base: "/", makeUrl: url_GetCorpus_822084508, schemes: {Scheme.Https})
type
  Call_UpdateCorpus_822084531 = ref object of OpenApiRestCall_822083986
proc url_UpdateCorpus_822084533(protocol: Scheme; host: string; base: string;
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

proc validate_UpdateCorpus_822084532(path: JsonNode; query: JsonNode;
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
  var valid_822084534 = path.getOrDefault("corpus")
  valid_822084534 = validateParameter(valid_822084534, JString, required = true,
                                      default = nil)
  if valid_822084534 != nil:
    section.add "corpus", valid_822084534
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
  var valid_822084535 = query.getOrDefault("$alt")
  valid_822084535 = validateParameter(valid_822084535, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084535 != nil:
    section.add "$alt", valid_822084535
  assert query != nil,
         "query argument is necessary due to required `updateMask` field"
  var valid_822084536 = query.getOrDefault("updateMask")
  valid_822084536 = validateParameter(valid_822084536, JString, required = true,
                                      default = nil)
  if valid_822084536 != nil:
    section.add "updateMask", valid_822084536
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
  var valid_822084539 = query.getOrDefault("$prettyPrint")
  valid_822084539 = validateParameter(valid_822084539, JBool, required = false,
                                      default = nil)
  if valid_822084539 != nil:
    section.add "$prettyPrint", valid_822084539
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

proc call*(call_822084541: Call_UpdateCorpus_822084531; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Updates a `Corpus`.
  ## 
  let valid = call_822084541.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084541.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084541.makeUrl(scheme.get, call_822084541.host, call_822084541.base,
                                   call_822084541.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084541, uri, valid, content)

proc call*(call_822084542: Call_UpdateCorpus_822084531; updateMask: string;
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
  var path_822084543 = newJObject()
  var query_822084544 = newJObject()
  var body_822084545 = newJObject()
  add(query_822084544, "$alt", newJString(Alt))
  if body != nil:
    body_822084545 = body
  add(query_822084544, "updateMask", newJString(updateMask))
  add(query_822084544, "$.xgafv", newJString(Xgafv))
  add(query_822084544, "$callback", newJString(Callback))
  add(path_822084543, "corpus", newJString(corpus))
  add(query_822084544, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084542.call(path_822084543, query_822084544, nil, nil, body_822084545)

var updateCorpus* = Call_UpdateCorpus_822084531(name: "updateCorpus",
    meth: HttpMethod.HttpPatch, host: "generativelanguage.googleapis.com",
    route: "/v1beta/corpora/{corpus}", validator: validate_UpdateCorpus_822084532,
    base: "/", makeUrl: url_UpdateCorpus_822084533, schemes: {Scheme.Https})
type
  Call_CreateDocument_822084560 = ref object of OpenApiRestCall_822083986
proc url_CreateDocument_822084562(protocol: Scheme; host: string; base: string;
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

proc validate_CreateDocument_822084561(path: JsonNode; query: JsonNode;
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
  var valid_822084563 = path.getOrDefault("corpus")
  valid_822084563 = validateParameter(valid_822084563, JString, required = true,
                                      default = nil)
  if valid_822084563 != nil:
    section.add "corpus", valid_822084563
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
  var valid_822084564 = query.getOrDefault("$alt")
  valid_822084564 = validateParameter(valid_822084564, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084564 != nil:
    section.add "$alt", valid_822084564
  var valid_822084565 = query.getOrDefault("$.xgafv")
  valid_822084565 = validateParameter(valid_822084565, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084565 != nil:
    section.add "$.xgafv", valid_822084565
  var valid_822084566 = query.getOrDefault("$callback")
  valid_822084566 = validateParameter(valid_822084566, JString,
                                      required = false, default = nil)
  if valid_822084566 != nil:
    section.add "$callback", valid_822084566
  var valid_822084567 = query.getOrDefault("$prettyPrint")
  valid_822084567 = validateParameter(valid_822084567, JBool, required = false,
                                      default = nil)
  if valid_822084567 != nil:
    section.add "$prettyPrint", valid_822084567
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

proc call*(call_822084569: Call_CreateDocument_822084560; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Creates an empty `Document`.
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

proc call*(call_822084570: Call_CreateDocument_822084560; corpus: string;
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
  var path_822084571 = newJObject()
  var query_822084572 = newJObject()
  var body_822084573 = newJObject()
  add(query_822084572, "$alt", newJString(Alt))
  if body != nil:
    body_822084573 = body
  add(query_822084572, "$.xgafv", newJString(Xgafv))
  add(query_822084572, "$callback", newJString(Callback))
  add(path_822084571, "corpus", newJString(corpus))
  add(query_822084572, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084570.call(path_822084571, query_822084572, nil, nil, body_822084573)

var createDocument* = Call_CreateDocument_822084560(name: "createDocument",
    meth: HttpMethod.HttpPost, host: "generativelanguage.googleapis.com",
    route: "/v1beta/corpora/{corpus}/documents",
    validator: validate_CreateDocument_822084561, base: "/",
    makeUrl: url_CreateDocument_822084562, schemes: {Scheme.Https})
type
  Call_ListDocuments_822084546 = ref object of OpenApiRestCall_822083986
proc url_ListDocuments_822084548(protocol: Scheme; host: string; base: string;
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

proc validate_ListDocuments_822084547(path: JsonNode; query: JsonNode;
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
  var valid_822084553 = query.getOrDefault("pageSize")
  valid_822084553 = validateParameter(valid_822084553, JInt, required = false,
                                      default = nil)
  if valid_822084553 != nil:
    section.add "pageSize", valid_822084553
  var valid_822084554 = query.getOrDefault("pageToken")
  valid_822084554 = validateParameter(valid_822084554, JString,
                                      required = false, default = nil)
  if valid_822084554 != nil:
    section.add "pageToken", valid_822084554
  var valid_822084555 = query.getOrDefault("$prettyPrint")
  valid_822084555 = validateParameter(valid_822084555, JBool, required = false,
                                      default = nil)
  if valid_822084555 != nil:
    section.add "$prettyPrint", valid_822084555
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084556: Call_ListDocuments_822084546; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Lists all `Document`s in a `Corpus`.
  ## 
  let valid = call_822084556.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084556.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084556.makeUrl(scheme.get, call_822084556.host, call_822084556.base,
                                   call_822084556.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084556, uri, valid, content)

proc call*(call_822084557: Call_ListDocuments_822084546; corpus: string;
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
  var path_822084558 = newJObject()
  var query_822084559 = newJObject()
  add(query_822084559, "$alt", newJString(Alt))
  add(query_822084559, "$.xgafv", newJString(Xgafv))
  add(query_822084559, "$callback", newJString(Callback))
  add(path_822084558, "corpus", newJString(corpus))
  add(query_822084559, "pageSize", newJInt(pageSize))
  add(query_822084559, "pageToken", newJString(pageToken))
  add(query_822084559, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084557.call(path_822084558, query_822084559, nil, nil, nil)

var listDocuments* = Call_ListDocuments_822084546(name: "listDocuments",
    meth: HttpMethod.HttpGet, host: "generativelanguage.googleapis.com",
    route: "/v1beta/corpora/{corpus}/documents",
    validator: validate_ListDocuments_822084547, base: "/",
    makeUrl: url_ListDocuments_822084548, schemes: {Scheme.Https})
type
  Call_DeleteDocument_822084587 = ref object of OpenApiRestCall_822083986
proc url_DeleteDocument_822084589(protocol: Scheme; host: string; base: string;
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

proc validate_DeleteDocument_822084588(path: JsonNode; query: JsonNode;
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
  var valid_822084592 = query.getOrDefault("force")
  valid_822084592 = validateParameter(valid_822084592, JBool, required = false,
                                      default = nil)
  if valid_822084592 != nil:
    section.add "force", valid_822084592
  var valid_822084593 = query.getOrDefault("$alt")
  valid_822084593 = validateParameter(valid_822084593, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084593 != nil:
    section.add "$alt", valid_822084593
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
  if body != nil:
    result.add "body", body

proc call*(call_822084597: Call_DeleteDocument_822084587; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Deletes a `Document`.
  ## 
  let valid = call_822084597.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084597.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084597.makeUrl(scheme.get, call_822084597.host, call_822084597.base,
                                   call_822084597.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084597, uri, valid, content)

proc call*(call_822084598: Call_DeleteDocument_822084587; document: string;
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
  var path_822084599 = newJObject()
  var query_822084600 = newJObject()
  add(path_822084599, "document", newJString(document))
  add(query_822084600, "force", newJBool(force))
  add(query_822084600, "$alt", newJString(Alt))
  add(query_822084600, "$.xgafv", newJString(Xgafv))
  add(query_822084600, "$callback", newJString(Callback))
  add(path_822084599, "corpus", newJString(corpus))
  add(query_822084600, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084598.call(path_822084599, query_822084600, nil, nil, nil)

var deleteDocument* = Call_DeleteDocument_822084587(name: "deleteDocument",
    meth: HttpMethod.HttpDelete, host: "generativelanguage.googleapis.com",
    route: "/v1beta/corpora/{corpus}/documents/{document}",
    validator: validate_DeleteDocument_822084588, base: "/",
    makeUrl: url_DeleteDocument_822084589, schemes: {Scheme.Https})
type
  Call_GetDocument_822084574 = ref object of OpenApiRestCall_822083986
proc url_GetDocument_822084576(protocol: Scheme; host: string; base: string;
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

proc validate_GetDocument_822084575(path: JsonNode; query: JsonNode;
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
  var valid_822084577 = path.getOrDefault("document")
  valid_822084577 = validateParameter(valid_822084577, JString, required = true,
                                      default = nil)
  if valid_822084577 != nil:
    section.add "document", valid_822084577
  var valid_822084578 = path.getOrDefault("corpus")
  valid_822084578 = validateParameter(valid_822084578, JString, required = true,
                                      default = nil)
  if valid_822084578 != nil:
    section.add "corpus", valid_822084578
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

proc call*(call_822084583: Call_GetDocument_822084574; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Gets information about a specific `Document`.
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

proc call*(call_822084584: Call_GetDocument_822084574; document: string;
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
  var path_822084585 = newJObject()
  var query_822084586 = newJObject()
  add(path_822084585, "document", newJString(document))
  add(query_822084586, "$alt", newJString(Alt))
  add(query_822084586, "$.xgafv", newJString(Xgafv))
  add(query_822084586, "$callback", newJString(Callback))
  add(path_822084585, "corpus", newJString(corpus))
  add(query_822084586, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084584.call(path_822084585, query_822084586, nil, nil, nil)

var getDocument* = Call_GetDocument_822084574(name: "getDocument",
    meth: HttpMethod.HttpGet, host: "generativelanguage.googleapis.com",
    route: "/v1beta/corpora/{corpus}/documents/{document}",
    validator: validate_GetDocument_822084575, base: "/",
    makeUrl: url_GetDocument_822084576, schemes: {Scheme.Https})
type
  Call_UpdateDocument_822084601 = ref object of OpenApiRestCall_822083986
proc url_UpdateDocument_822084603(protocol: Scheme; host: string; base: string;
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

proc validate_UpdateDocument_822084602(path: JsonNode; query: JsonNode;
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
  var valid_822084604 = path.getOrDefault("document")
  valid_822084604 = validateParameter(valid_822084604, JString, required = true,
                                      default = nil)
  if valid_822084604 != nil:
    section.add "document", valid_822084604
  var valid_822084605 = path.getOrDefault("corpus")
  valid_822084605 = validateParameter(valid_822084605, JString, required = true,
                                      default = nil)
  if valid_822084605 != nil:
    section.add "corpus", valid_822084605
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
  var valid_822084606 = query.getOrDefault("$alt")
  valid_822084606 = validateParameter(valid_822084606, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084606 != nil:
    section.add "$alt", valid_822084606
  assert query != nil,
         "query argument is necessary due to required `updateMask` field"
  var valid_822084607 = query.getOrDefault("updateMask")
  valid_822084607 = validateParameter(valid_822084607, JString, required = true,
                                      default = nil)
  if valid_822084607 != nil:
    section.add "updateMask", valid_822084607
  var valid_822084608 = query.getOrDefault("$.xgafv")
  valid_822084608 = validateParameter(valid_822084608, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084608 != nil:
    section.add "$.xgafv", valid_822084608
  var valid_822084609 = query.getOrDefault("$callback")
  valid_822084609 = validateParameter(valid_822084609, JString,
                                      required = false, default = nil)
  if valid_822084609 != nil:
    section.add "$callback", valid_822084609
  var valid_822084610 = query.getOrDefault("$prettyPrint")
  valid_822084610 = validateParameter(valid_822084610, JBool, required = false,
                                      default = nil)
  if valid_822084610 != nil:
    section.add "$prettyPrint", valid_822084610
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

proc call*(call_822084612: Call_UpdateDocument_822084601; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Updates a `Document`.
  ## 
  let valid = call_822084612.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084612.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084612.makeUrl(scheme.get, call_822084612.host, call_822084612.base,
                                   call_822084612.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084612, uri, valid, content)

proc call*(call_822084613: Call_UpdateDocument_822084601; document: string;
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
  var path_822084614 = newJObject()
  var query_822084615 = newJObject()
  var body_822084616 = newJObject()
  add(path_822084614, "document", newJString(document))
  add(query_822084615, "$alt", newJString(Alt))
  if body != nil:
    body_822084616 = body
  add(query_822084615, "updateMask", newJString(updateMask))
  add(query_822084615, "$.xgafv", newJString(Xgafv))
  add(query_822084615, "$callback", newJString(Callback))
  add(path_822084614, "corpus", newJString(corpus))
  add(query_822084615, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084613.call(path_822084614, query_822084615, nil, nil, body_822084616)

var updateDocument* = Call_UpdateDocument_822084601(name: "updateDocument",
    meth: HttpMethod.HttpPatch, host: "generativelanguage.googleapis.com",
    route: "/v1beta/corpora/{corpus}/documents/{document}",
    validator: validate_UpdateDocument_822084602, base: "/",
    makeUrl: url_UpdateDocument_822084603, schemes: {Scheme.Https})
type
  Call_CreateChunk_822084632 = ref object of OpenApiRestCall_822083986
proc url_CreateChunk_822084634(protocol: Scheme; host: string; base: string;
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

proc validate_CreateChunk_822084633(path: JsonNode; query: JsonNode;
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
  var valid_822084635 = path.getOrDefault("document")
  valid_822084635 = validateParameter(valid_822084635, JString, required = true,
                                      default = nil)
  if valid_822084635 != nil:
    section.add "document", valid_822084635
  var valid_822084636 = path.getOrDefault("corpus")
  valid_822084636 = validateParameter(valid_822084636, JString, required = true,
                                      default = nil)
  if valid_822084636 != nil:
    section.add "corpus", valid_822084636
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
  var valid_822084637 = query.getOrDefault("$alt")
  valid_822084637 = validateParameter(valid_822084637, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084637 != nil:
    section.add "$alt", valid_822084637
  var valid_822084638 = query.getOrDefault("$.xgafv")
  valid_822084638 = validateParameter(valid_822084638, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084638 != nil:
    section.add "$.xgafv", valid_822084638
  var valid_822084639 = query.getOrDefault("$callback")
  valid_822084639 = validateParameter(valid_822084639, JString,
                                      required = false, default = nil)
  if valid_822084639 != nil:
    section.add "$callback", valid_822084639
  var valid_822084640 = query.getOrDefault("$prettyPrint")
  valid_822084640 = validateParameter(valid_822084640, JBool, required = false,
                                      default = nil)
  if valid_822084640 != nil:
    section.add "$prettyPrint", valid_822084640
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

proc call*(call_822084642: Call_CreateChunk_822084632; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Creates a `Chunk`.
  ## 
  let valid = call_822084642.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084642.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084642.makeUrl(scheme.get, call_822084642.host, call_822084642.base,
                                   call_822084642.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084642, uri, valid, content)

proc call*(call_822084643: Call_CreateChunk_822084632; document: string;
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
  var path_822084644 = newJObject()
  var query_822084645 = newJObject()
  var body_822084646 = newJObject()
  add(path_822084644, "document", newJString(document))
  add(query_822084645, "$alt", newJString(Alt))
  if body != nil:
    body_822084646 = body
  add(query_822084645, "$.xgafv", newJString(Xgafv))
  add(query_822084645, "$callback", newJString(Callback))
  add(path_822084644, "corpus", newJString(corpus))
  add(query_822084645, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084643.call(path_822084644, query_822084645, nil, nil, body_822084646)

var createChunk* = Call_CreateChunk_822084632(name: "createChunk",
    meth: HttpMethod.HttpPost, host: "generativelanguage.googleapis.com",
    route: "/v1beta/corpora/{corpus}/documents/{document}/chunks",
    validator: validate_CreateChunk_822084633, base: "/",
    makeUrl: url_CreateChunk_822084634, schemes: {Scheme.Https})
type
  Call_ListChunks_822084617 = ref object of OpenApiRestCall_822083986
proc url_ListChunks_822084619(protocol: Scheme; host: string; base: string;
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

proc validate_ListChunks_822084618(path: JsonNode; query: JsonNode;
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
  var valid_822084620 = path.getOrDefault("document")
  valid_822084620 = validateParameter(valid_822084620, JString, required = true,
                                      default = nil)
  if valid_822084620 != nil:
    section.add "document", valid_822084620
  var valid_822084621 = path.getOrDefault("corpus")
  valid_822084621 = validateParameter(valid_822084621, JString, required = true,
                                      default = nil)
  if valid_822084621 != nil:
    section.add "corpus", valid_822084621
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
  var valid_822084622 = query.getOrDefault("$alt")
  valid_822084622 = validateParameter(valid_822084622, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084622 != nil:
    section.add "$alt", valid_822084622
  var valid_822084623 = query.getOrDefault("$.xgafv")
  valid_822084623 = validateParameter(valid_822084623, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084623 != nil:
    section.add "$.xgafv", valid_822084623
  var valid_822084624 = query.getOrDefault("$callback")
  valid_822084624 = validateParameter(valid_822084624, JString,
                                      required = false, default = nil)
  if valid_822084624 != nil:
    section.add "$callback", valid_822084624
  var valid_822084625 = query.getOrDefault("pageSize")
  valid_822084625 = validateParameter(valid_822084625, JInt, required = false,
                                      default = nil)
  if valid_822084625 != nil:
    section.add "pageSize", valid_822084625
  var valid_822084626 = query.getOrDefault("pageToken")
  valid_822084626 = validateParameter(valid_822084626, JString,
                                      required = false, default = nil)
  if valid_822084626 != nil:
    section.add "pageToken", valid_822084626
  var valid_822084627 = query.getOrDefault("$prettyPrint")
  valid_822084627 = validateParameter(valid_822084627, JBool, required = false,
                                      default = nil)
  if valid_822084627 != nil:
    section.add "$prettyPrint", valid_822084627
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084628: Call_ListChunks_822084617; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Lists all `Chunk`s in a `Document`.
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

proc call*(call_822084629: Call_ListChunks_822084617; document: string;
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
  var path_822084630 = newJObject()
  var query_822084631 = newJObject()
  add(path_822084630, "document", newJString(document))
  add(query_822084631, "$alt", newJString(Alt))
  add(query_822084631, "$.xgafv", newJString(Xgafv))
  add(query_822084631, "$callback", newJString(Callback))
  add(path_822084630, "corpus", newJString(corpus))
  add(query_822084631, "pageSize", newJInt(pageSize))
  add(query_822084631, "pageToken", newJString(pageToken))
  add(query_822084631, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084629.call(path_822084630, query_822084631, nil, nil, nil)

var listChunks* = Call_ListChunks_822084617(name: "listChunks",
    meth: HttpMethod.HttpGet, host: "generativelanguage.googleapis.com",
    route: "/v1beta/corpora/{corpus}/documents/{document}/chunks",
    validator: validate_ListChunks_822084618, base: "/",
    makeUrl: url_ListChunks_822084619, schemes: {Scheme.Https})
type
  Call_DeleteChunk_822084661 = ref object of OpenApiRestCall_822083986
proc url_DeleteChunk_822084663(protocol: Scheme; host: string; base: string;
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

proc validate_DeleteChunk_822084662(path: JsonNode; query: JsonNode;
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
  var valid_822084668 = query.getOrDefault("$.xgafv")
  valid_822084668 = validateParameter(valid_822084668, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084668 != nil:
    section.add "$.xgafv", valid_822084668
  var valid_822084669 = query.getOrDefault("$callback")
  valid_822084669 = validateParameter(valid_822084669, JString,
                                      required = false, default = nil)
  if valid_822084669 != nil:
    section.add "$callback", valid_822084669
  var valid_822084670 = query.getOrDefault("$prettyPrint")
  valid_822084670 = validateParameter(valid_822084670, JBool, required = false,
                                      default = nil)
  if valid_822084670 != nil:
    section.add "$prettyPrint", valid_822084670
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084671: Call_DeleteChunk_822084661; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Deletes a `Chunk`.
  ## 
  let valid = call_822084671.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084671.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084671.makeUrl(scheme.get, call_822084671.host, call_822084671.base,
                                   call_822084671.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084671, uri, valid, content)

proc call*(call_822084672: Call_DeleteChunk_822084661; document: string;
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
  var path_822084673 = newJObject()
  var query_822084674 = newJObject()
  add(path_822084673, "document", newJString(document))
  add(query_822084674, "$alt", newJString(Alt))
  add(query_822084674, "$.xgafv", newJString(Xgafv))
  add(query_822084674, "$callback", newJString(Callback))
  add(path_822084673, "corpus", newJString(corpus))
  add(path_822084673, "chunk", newJString(chunk))
  add(query_822084674, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084672.call(path_822084673, query_822084674, nil, nil, nil)

var deleteChunk* = Call_DeleteChunk_822084661(name: "deleteChunk",
    meth: HttpMethod.HttpDelete, host: "generativelanguage.googleapis.com",
    route: "/v1beta/corpora/{corpus}/documents/{document}/chunks/{chunk}",
    validator: validate_DeleteChunk_822084662, base: "/",
    makeUrl: url_DeleteChunk_822084663, schemes: {Scheme.Https})
type
  Call_GetChunk_822084647 = ref object of OpenApiRestCall_822083986
proc url_GetChunk_822084649(protocol: Scheme; host: string; base: string;
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

proc validate_GetChunk_822084648(path: JsonNode; query: JsonNode;
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

proc call*(call_822084657: Call_GetChunk_822084647; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Gets information about a specific `Chunk`.
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

proc call*(call_822084658: Call_GetChunk_822084647; document: string;
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

var getChunk* = Call_GetChunk_822084647(name: "getChunk",
                                        meth: HttpMethod.HttpGet, host: "generativelanguage.googleapis.com", route: "/v1beta/corpora/{corpus}/documents/{document}/chunks/{chunk}",
                                        validator: validate_GetChunk_822084648,
                                        base: "/", makeUrl: url_GetChunk_822084649,
                                        schemes: {Scheme.Https})
type
  Call_UpdateChunk_822084675 = ref object of OpenApiRestCall_822083986
proc url_UpdateChunk_822084677(protocol: Scheme; host: string; base: string;
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

proc validate_UpdateChunk_822084676(path: JsonNode; query: JsonNode;
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
  var valid_822084678 = path.getOrDefault("document")
  valid_822084678 = validateParameter(valid_822084678, JString, required = true,
                                      default = nil)
  if valid_822084678 != nil:
    section.add "document", valid_822084678
  var valid_822084679 = path.getOrDefault("corpus")
  valid_822084679 = validateParameter(valid_822084679, JString, required = true,
                                      default = nil)
  if valid_822084679 != nil:
    section.add "corpus", valid_822084679
  var valid_822084680 = path.getOrDefault("chunk")
  valid_822084680 = validateParameter(valid_822084680, JString, required = true,
                                      default = nil)
  if valid_822084680 != nil:
    section.add "chunk", valid_822084680
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
  var valid_822084681 = query.getOrDefault("$alt")
  valid_822084681 = validateParameter(valid_822084681, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084681 != nil:
    section.add "$alt", valid_822084681
  assert query != nil,
         "query argument is necessary due to required `updateMask` field"
  var valid_822084682 = query.getOrDefault("updateMask")
  valid_822084682 = validateParameter(valid_822084682, JString, required = true,
                                      default = nil)
  if valid_822084682 != nil:
    section.add "updateMask", valid_822084682
  var valid_822084683 = query.getOrDefault("$.xgafv")
  valid_822084683 = validateParameter(valid_822084683, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084683 != nil:
    section.add "$.xgafv", valid_822084683
  var valid_822084684 = query.getOrDefault("$callback")
  valid_822084684 = validateParameter(valid_822084684, JString,
                                      required = false, default = nil)
  if valid_822084684 != nil:
    section.add "$callback", valid_822084684
  var valid_822084685 = query.getOrDefault("$prettyPrint")
  valid_822084685 = validateParameter(valid_822084685, JBool, required = false,
                                      default = nil)
  if valid_822084685 != nil:
    section.add "$prettyPrint", valid_822084685
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

proc call*(call_822084687: Call_UpdateChunk_822084675; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Updates a `Chunk`.
  ## 
  let valid = call_822084687.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084687.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084687.makeUrl(scheme.get, call_822084687.host, call_822084687.base,
                                   call_822084687.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084687, uri, valid, content)

proc call*(call_822084688: Call_UpdateChunk_822084675; document: string;
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
  var path_822084689 = newJObject()
  var query_822084690 = newJObject()
  var body_822084691 = newJObject()
  add(path_822084689, "document", newJString(document))
  add(query_822084690, "$alt", newJString(Alt))
  if body != nil:
    body_822084691 = body
  add(query_822084690, "updateMask", newJString(updateMask))
  add(query_822084690, "$.xgafv", newJString(Xgafv))
  add(query_822084690, "$callback", newJString(Callback))
  add(path_822084689, "corpus", newJString(corpus))
  add(path_822084689, "chunk", newJString(chunk))
  add(query_822084690, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084688.call(path_822084689, query_822084690, nil, nil, body_822084691)

var updateChunk* = Call_UpdateChunk_822084675(name: "updateChunk",
    meth: HttpMethod.HttpPatch, host: "generativelanguage.googleapis.com",
    route: "/v1beta/corpora/{corpus}/documents/{document}/chunks/{chunk}",
    validator: validate_UpdateChunk_822084676, base: "/",
    makeUrl: url_UpdateChunk_822084677, schemes: {Scheme.Https})
type
  Call_BatchCreateChunks_822084692 = ref object of OpenApiRestCall_822083986
proc url_BatchCreateChunks_822084694(protocol: Scheme; host: string;
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

proc validate_BatchCreateChunks_822084693(path: JsonNode; query: JsonNode;
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
  var valid_822084695 = path.getOrDefault("document")
  valid_822084695 = validateParameter(valid_822084695, JString, required = true,
                                      default = nil)
  if valid_822084695 != nil:
    section.add "document", valid_822084695
  var valid_822084696 = path.getOrDefault("corpus")
  valid_822084696 = validateParameter(valid_822084696, JString, required = true,
                                      default = nil)
  if valid_822084696 != nil:
    section.add "corpus", valid_822084696
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
  var valid_822084697 = query.getOrDefault("$alt")
  valid_822084697 = validateParameter(valid_822084697, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084697 != nil:
    section.add "$alt", valid_822084697
  var valid_822084698 = query.getOrDefault("$.xgafv")
  valid_822084698 = validateParameter(valid_822084698, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084698 != nil:
    section.add "$.xgafv", valid_822084698
  var valid_822084699 = query.getOrDefault("$callback")
  valid_822084699 = validateParameter(valid_822084699, JString,
                                      required = false, default = nil)
  if valid_822084699 != nil:
    section.add "$callback", valid_822084699
  var valid_822084700 = query.getOrDefault("$prettyPrint")
  valid_822084700 = validateParameter(valid_822084700, JBool, required = false,
                                      default = nil)
  if valid_822084700 != nil:
    section.add "$prettyPrint", valid_822084700
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

proc call*(call_822084702: Call_BatchCreateChunks_822084692;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Batch create `Chunk`s.
  ## 
  let valid = call_822084702.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084702.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084702.makeUrl(scheme.get, call_822084702.host, call_822084702.base,
                                   call_822084702.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084702, uri, valid, content)

proc call*(call_822084703: Call_BatchCreateChunks_822084692; document: string;
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
  var path_822084704 = newJObject()
  var query_822084705 = newJObject()
  var body_822084706 = newJObject()
  add(path_822084704, "document", newJString(document))
  add(query_822084705, "$alt", newJString(Alt))
  if body != nil:
    body_822084706 = body
  add(query_822084705, "$.xgafv", newJString(Xgafv))
  add(query_822084705, "$callback", newJString(Callback))
  add(path_822084704, "corpus", newJString(corpus))
  add(query_822084705, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084703.call(path_822084704, query_822084705, nil, nil, body_822084706)

var batchCreateChunks* = Call_BatchCreateChunks_822084692(
    name: "batchCreateChunks", meth: HttpMethod.HttpPost,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/corpora/{corpus}/documents/{document}/chunks:batchCreate",
    validator: validate_BatchCreateChunks_822084693, base: "/",
    makeUrl: url_BatchCreateChunks_822084694, schemes: {Scheme.Https})
type
  Call_BatchDeleteChunks_822084707 = ref object of OpenApiRestCall_822083986
proc url_BatchDeleteChunks_822084709(protocol: Scheme; host: string;
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

proc validate_BatchDeleteChunks_822084708(path: JsonNode; query: JsonNode;
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
  var valid_822084710 = path.getOrDefault("document")
  valid_822084710 = validateParameter(valid_822084710, JString, required = true,
                                      default = nil)
  if valid_822084710 != nil:
    section.add "document", valid_822084710
  var valid_822084711 = path.getOrDefault("corpus")
  valid_822084711 = validateParameter(valid_822084711, JString, required = true,
                                      default = nil)
  if valid_822084711 != nil:
    section.add "corpus", valid_822084711
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
  var valid_822084712 = query.getOrDefault("$alt")
  valid_822084712 = validateParameter(valid_822084712, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084712 != nil:
    section.add "$alt", valid_822084712
  var valid_822084713 = query.getOrDefault("$.xgafv")
  valid_822084713 = validateParameter(valid_822084713, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084713 != nil:
    section.add "$.xgafv", valid_822084713
  var valid_822084714 = query.getOrDefault("$callback")
  valid_822084714 = validateParameter(valid_822084714, JString,
                                      required = false, default = nil)
  if valid_822084714 != nil:
    section.add "$callback", valid_822084714
  var valid_822084715 = query.getOrDefault("$prettyPrint")
  valid_822084715 = validateParameter(valid_822084715, JBool, required = false,
                                      default = nil)
  if valid_822084715 != nil:
    section.add "$prettyPrint", valid_822084715
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

proc call*(call_822084717: Call_BatchDeleteChunks_822084707;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Batch delete `Chunk`s.
  ## 
  let valid = call_822084717.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084717.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084717.makeUrl(scheme.get, call_822084717.host, call_822084717.base,
                                   call_822084717.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084717, uri, valid, content)

proc call*(call_822084718: Call_BatchDeleteChunks_822084707; document: string;
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
  var path_822084719 = newJObject()
  var query_822084720 = newJObject()
  var body_822084721 = newJObject()
  add(path_822084719, "document", newJString(document))
  add(query_822084720, "$alt", newJString(Alt))
  if body != nil:
    body_822084721 = body
  add(query_822084720, "$.xgafv", newJString(Xgafv))
  add(query_822084720, "$callback", newJString(Callback))
  add(path_822084719, "corpus", newJString(corpus))
  add(query_822084720, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084718.call(path_822084719, query_822084720, nil, nil, body_822084721)

var batchDeleteChunks* = Call_BatchDeleteChunks_822084707(
    name: "batchDeleteChunks", meth: HttpMethod.HttpPost,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/corpora/{corpus}/documents/{document}/chunks:batchDelete",
    validator: validate_BatchDeleteChunks_822084708, base: "/",
    makeUrl: url_BatchDeleteChunks_822084709, schemes: {Scheme.Https})
type
  Call_BatchUpdateChunks_822084722 = ref object of OpenApiRestCall_822083986
proc url_BatchUpdateChunks_822084724(protocol: Scheme; host: string;
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

proc validate_BatchUpdateChunks_822084723(path: JsonNode; query: JsonNode;
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
  var valid_822084725 = path.getOrDefault("document")
  valid_822084725 = validateParameter(valid_822084725, JString, required = true,
                                      default = nil)
  if valid_822084725 != nil:
    section.add "document", valid_822084725
  var valid_822084726 = path.getOrDefault("corpus")
  valid_822084726 = validateParameter(valid_822084726, JString, required = true,
                                      default = nil)
  if valid_822084726 != nil:
    section.add "corpus", valid_822084726
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
  var valid_822084727 = query.getOrDefault("$alt")
  valid_822084727 = validateParameter(valid_822084727, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084727 != nil:
    section.add "$alt", valid_822084727
  var valid_822084728 = query.getOrDefault("$.xgafv")
  valid_822084728 = validateParameter(valid_822084728, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084728 != nil:
    section.add "$.xgafv", valid_822084728
  var valid_822084729 = query.getOrDefault("$callback")
  valid_822084729 = validateParameter(valid_822084729, JString,
                                      required = false, default = nil)
  if valid_822084729 != nil:
    section.add "$callback", valid_822084729
  var valid_822084730 = query.getOrDefault("$prettyPrint")
  valid_822084730 = validateParameter(valid_822084730, JBool, required = false,
                                      default = nil)
  if valid_822084730 != nil:
    section.add "$prettyPrint", valid_822084730
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

proc call*(call_822084732: Call_BatchUpdateChunks_822084722;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Batch update `Chunk`s.
  ## 
  let valid = call_822084732.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084732.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084732.makeUrl(scheme.get, call_822084732.host, call_822084732.base,
                                   call_822084732.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084732, uri, valid, content)

proc call*(call_822084733: Call_BatchUpdateChunks_822084722; document: string;
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
  var path_822084734 = newJObject()
  var query_822084735 = newJObject()
  var body_822084736 = newJObject()
  add(path_822084734, "document", newJString(document))
  add(query_822084735, "$alt", newJString(Alt))
  if body != nil:
    body_822084736 = body
  add(query_822084735, "$.xgafv", newJString(Xgafv))
  add(query_822084735, "$callback", newJString(Callback))
  add(path_822084734, "corpus", newJString(corpus))
  add(query_822084735, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084733.call(path_822084734, query_822084735, nil, nil, body_822084736)

var batchUpdateChunks* = Call_BatchUpdateChunks_822084722(
    name: "batchUpdateChunks", meth: HttpMethod.HttpPost,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/corpora/{corpus}/documents/{document}/chunks:batchUpdate",
    validator: validate_BatchUpdateChunks_822084723, base: "/",
    makeUrl: url_BatchUpdateChunks_822084724, schemes: {Scheme.Https})
type
  Call_QueryDocument_822084737 = ref object of OpenApiRestCall_822083986
proc url_QueryDocument_822084739(protocol: Scheme; host: string; base: string;
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

proc validate_QueryDocument_822084738(path: JsonNode; query: JsonNode;
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
  var valid_822084740 = path.getOrDefault("document")
  valid_822084740 = validateParameter(valid_822084740, JString, required = true,
                                      default = nil)
  if valid_822084740 != nil:
    section.add "document", valid_822084740
  var valid_822084741 = path.getOrDefault("corpus")
  valid_822084741 = validateParameter(valid_822084741, JString, required = true,
                                      default = nil)
  if valid_822084741 != nil:
    section.add "corpus", valid_822084741
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
  var valid_822084742 = query.getOrDefault("$alt")
  valid_822084742 = validateParameter(valid_822084742, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084742 != nil:
    section.add "$alt", valid_822084742
  var valid_822084743 = query.getOrDefault("$.xgafv")
  valid_822084743 = validateParameter(valid_822084743, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084743 != nil:
    section.add "$.xgafv", valid_822084743
  var valid_822084744 = query.getOrDefault("$callback")
  valid_822084744 = validateParameter(valid_822084744, JString,
                                      required = false, default = nil)
  if valid_822084744 != nil:
    section.add "$callback", valid_822084744
  var valid_822084745 = query.getOrDefault("$prettyPrint")
  valid_822084745 = validateParameter(valid_822084745, JBool, required = false,
                                      default = nil)
  if valid_822084745 != nil:
    section.add "$prettyPrint", valid_822084745
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

proc call*(call_822084747: Call_QueryDocument_822084737; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Performs semantic search over a `Document`.
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

proc call*(call_822084748: Call_QueryDocument_822084737; document: string;
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
  var path_822084749 = newJObject()
  var query_822084750 = newJObject()
  var body_822084751 = newJObject()
  add(path_822084749, "document", newJString(document))
  add(query_822084750, "$alt", newJString(Alt))
  if body != nil:
    body_822084751 = body
  add(query_822084750, "$.xgafv", newJString(Xgafv))
  add(query_822084750, "$callback", newJString(Callback))
  add(path_822084749, "corpus", newJString(corpus))
  add(query_822084750, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084748.call(path_822084749, query_822084750, nil, nil, body_822084751)

var queryDocument* = Call_QueryDocument_822084737(name: "queryDocument",
    meth: HttpMethod.HttpPost, host: "generativelanguage.googleapis.com",
    route: "/v1beta/corpora/{corpus}/documents/{document}:query",
    validator: validate_QueryDocument_822084738, base: "/",
    makeUrl: url_QueryDocument_822084739, schemes: {Scheme.Https})
type
  Call_GetOperationByCorpusAndOperation_822084752 = ref object of OpenApiRestCall_822083986
proc url_GetOperationByCorpusAndOperation_822084754(protocol: Scheme;
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

proc validate_GetOperationByCorpusAndOperation_822084753(path: JsonNode;
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
  var valid_822084755 = path.getOrDefault("corpus")
  valid_822084755 = validateParameter(valid_822084755, JString, required = true,
                                      default = nil)
  if valid_822084755 != nil:
    section.add "corpus", valid_822084755
  var valid_822084756 = path.getOrDefault("operation")
  valid_822084756 = validateParameter(valid_822084756, JString, required = true,
                                      default = nil)
  if valid_822084756 != nil:
    section.add "operation", valid_822084756
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
  var valid_822084757 = query.getOrDefault("$alt")
  valid_822084757 = validateParameter(valid_822084757, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084757 != nil:
    section.add "$alt", valid_822084757
  var valid_822084758 = query.getOrDefault("$.xgafv")
  valid_822084758 = validateParameter(valid_822084758, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084758 != nil:
    section.add "$.xgafv", valid_822084758
  var valid_822084759 = query.getOrDefault("$callback")
  valid_822084759 = validateParameter(valid_822084759, JString,
                                      required = false, default = nil)
  if valid_822084759 != nil:
    section.add "$callback", valid_822084759
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

proc call*(call_822084761: Call_GetOperationByCorpusAndOperation_822084752;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
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

proc call*(call_822084762: Call_GetOperationByCorpusAndOperation_822084752;
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
  var path_822084763 = newJObject()
  var query_822084764 = newJObject()
  add(query_822084764, "$alt", newJString(Alt))
  add(query_822084764, "$.xgafv", newJString(Xgafv))
  add(query_822084764, "$callback", newJString(Callback))
  add(path_822084763, "corpus", newJString(corpus))
  add(path_822084763, "operation", newJString(operation))
  add(query_822084764, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084762.call(path_822084763, query_822084764, nil, nil, nil)

var getOperationByCorpusAndOperation* = Call_GetOperationByCorpusAndOperation_822084752(
    name: "getOperationByCorpusAndOperation", meth: HttpMethod.HttpGet,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/corpora/{corpus}/operations/{operation}",
    validator: validate_GetOperationByCorpusAndOperation_822084753, base: "/",
    makeUrl: url_GetOperationByCorpusAndOperation_822084754,
    schemes: {Scheme.Https})
type
  Call_CreatePermissionByCorpus_822084779 = ref object of OpenApiRestCall_822083986
proc url_CreatePermissionByCorpus_822084781(protocol: Scheme; host: string;
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

proc validate_CreatePermissionByCorpus_822084780(path: JsonNode;
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
  var valid_822084782 = path.getOrDefault("corpus")
  valid_822084782 = validateParameter(valid_822084782, JString, required = true,
                                      default = nil)
  if valid_822084782 != nil:
    section.add "corpus", valid_822084782
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
  var valid_822084783 = query.getOrDefault("$alt")
  valid_822084783 = validateParameter(valid_822084783, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084783 != nil:
    section.add "$alt", valid_822084783
  var valid_822084784 = query.getOrDefault("$.xgafv")
  valid_822084784 = validateParameter(valid_822084784, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084784 != nil:
    section.add "$.xgafv", valid_822084784
  var valid_822084785 = query.getOrDefault("$callback")
  valid_822084785 = validateParameter(valid_822084785, JString,
                                      required = false, default = nil)
  if valid_822084785 != nil:
    section.add "$callback", valid_822084785
  var valid_822084786 = query.getOrDefault("$prettyPrint")
  valid_822084786 = validateParameter(valid_822084786, JBool, required = false,
                                      default = nil)
  if valid_822084786 != nil:
    section.add "$prettyPrint", valid_822084786
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

proc call*(call_822084788: Call_CreatePermissionByCorpus_822084779;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Create a permission to a specific resource.
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

proc call*(call_822084789: Call_CreatePermissionByCorpus_822084779;
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
  var path_822084790 = newJObject()
  var query_822084791 = newJObject()
  var body_822084792 = newJObject()
  add(query_822084791, "$alt", newJString(Alt))
  if body != nil:
    body_822084792 = body
  add(query_822084791, "$.xgafv", newJString(Xgafv))
  add(query_822084791, "$callback", newJString(Callback))
  add(path_822084790, "corpus", newJString(corpus))
  add(query_822084791, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084789.call(path_822084790, query_822084791, nil, nil, body_822084792)

var createPermissionByCorpus* = Call_CreatePermissionByCorpus_822084779(
    name: "createPermissionByCorpus", meth: HttpMethod.HttpPost,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/corpora/{corpus}/permissions",
    validator: validate_CreatePermissionByCorpus_822084780, base: "/",
    makeUrl: url_CreatePermissionByCorpus_822084781, schemes: {Scheme.Https})
type
  Call_ListPermissionsByCorpus_822084765 = ref object of OpenApiRestCall_822083986
proc url_ListPermissionsByCorpus_822084767(protocol: Scheme; host: string;
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

proc validate_ListPermissionsByCorpus_822084766(path: JsonNode; query: JsonNode;
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
  var valid_822084772 = query.getOrDefault("pageSize")
  valid_822084772 = validateParameter(valid_822084772, JInt, required = false,
                                      default = nil)
  if valid_822084772 != nil:
    section.add "pageSize", valid_822084772
  var valid_822084773 = query.getOrDefault("pageToken")
  valid_822084773 = validateParameter(valid_822084773, JString,
                                      required = false, default = nil)
  if valid_822084773 != nil:
    section.add "pageToken", valid_822084773
  var valid_822084774 = query.getOrDefault("$prettyPrint")
  valid_822084774 = validateParameter(valid_822084774, JBool, required = false,
                                      default = nil)
  if valid_822084774 != nil:
    section.add "$prettyPrint", valid_822084774
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084775: Call_ListPermissionsByCorpus_822084765;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Lists permissions for the specific resource.
  ## 
  let valid = call_822084775.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084775.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084775.makeUrl(scheme.get, call_822084775.host, call_822084775.base,
                                   call_822084775.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084775, uri, valid, content)

proc call*(call_822084776: Call_ListPermissionsByCorpus_822084765;
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
  var path_822084777 = newJObject()
  var query_822084778 = newJObject()
  add(query_822084778, "$alt", newJString(Alt))
  add(query_822084778, "$.xgafv", newJString(Xgafv))
  add(query_822084778, "$callback", newJString(Callback))
  add(path_822084777, "corpus", newJString(corpus))
  add(query_822084778, "pageSize", newJInt(pageSize))
  add(query_822084778, "pageToken", newJString(pageToken))
  add(query_822084778, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084776.call(path_822084777, query_822084778, nil, nil, nil)

var listPermissionsByCorpus* = Call_ListPermissionsByCorpus_822084765(
    name: "listPermissionsByCorpus", meth: HttpMethod.HttpGet,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/corpora/{corpus}/permissions",
    validator: validate_ListPermissionsByCorpus_822084766, base: "/",
    makeUrl: url_ListPermissionsByCorpus_822084767, schemes: {Scheme.Https})
type
  Call_DeletePermissionByCorpusAndPermission_822084806 = ref object of OpenApiRestCall_822083986
proc url_DeletePermissionByCorpusAndPermission_822084808(protocol: Scheme;
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

proc validate_DeletePermissionByCorpusAndPermission_822084807(path: JsonNode;
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
  var valid_822084809 = path.getOrDefault("permission")
  valid_822084809 = validateParameter(valid_822084809, JString, required = true,
                                      default = nil)
  if valid_822084809 != nil:
    section.add "permission", valid_822084809
  var valid_822084810 = path.getOrDefault("corpus")
  valid_822084810 = validateParameter(valid_822084810, JString, required = true,
                                      default = nil)
  if valid_822084810 != nil:
    section.add "corpus", valid_822084810
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
  var valid_822084811 = query.getOrDefault("$alt")
  valid_822084811 = validateParameter(valid_822084811, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084811 != nil:
    section.add "$alt", valid_822084811
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
  if body != nil:
    result.add "body", body

proc call*(call_822084815: Call_DeletePermissionByCorpusAndPermission_822084806;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Deletes the permission.
  ## 
  let valid = call_822084815.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084815.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084815.makeUrl(scheme.get, call_822084815.host, call_822084815.base,
                                   call_822084815.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084815, uri, valid, content)

proc call*(call_822084816: Call_DeletePermissionByCorpusAndPermission_822084806;
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
  var path_822084817 = newJObject()
  var query_822084818 = newJObject()
  add(path_822084817, "permission", newJString(permission))
  add(query_822084818, "$alt", newJString(Alt))
  add(query_822084818, "$.xgafv", newJString(Xgafv))
  add(query_822084818, "$callback", newJString(Callback))
  add(path_822084817, "corpus", newJString(corpus))
  add(query_822084818, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084816.call(path_822084817, query_822084818, nil, nil, nil)

var deletePermissionByCorpusAndPermission* = Call_DeletePermissionByCorpusAndPermission_822084806(
    name: "deletePermissionByCorpusAndPermission", meth: HttpMethod.HttpDelete,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/corpora/{corpus}/permissions/{permission}",
    validator: validate_DeletePermissionByCorpusAndPermission_822084807,
    base: "/", makeUrl: url_DeletePermissionByCorpusAndPermission_822084808,
    schemes: {Scheme.Https})
type
  Call_GetPermissionByCorpusAndPermission_822084793 = ref object of OpenApiRestCall_822083986
proc url_GetPermissionByCorpusAndPermission_822084795(protocol: Scheme;
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

proc validate_GetPermissionByCorpusAndPermission_822084794(path: JsonNode;
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
  var valid_822084796 = path.getOrDefault("permission")
  valid_822084796 = validateParameter(valid_822084796, JString, required = true,
                                      default = nil)
  if valid_822084796 != nil:
    section.add "permission", valid_822084796
  var valid_822084797 = path.getOrDefault("corpus")
  valid_822084797 = validateParameter(valid_822084797, JString, required = true,
                                      default = nil)
  if valid_822084797 != nil:
    section.add "corpus", valid_822084797
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
  var valid_822084798 = query.getOrDefault("$alt")
  valid_822084798 = validateParameter(valid_822084798, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084798 != nil:
    section.add "$alt", valid_822084798
  var valid_822084799 = query.getOrDefault("$.xgafv")
  valid_822084799 = validateParameter(valid_822084799, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084799 != nil:
    section.add "$.xgafv", valid_822084799
  var valid_822084800 = query.getOrDefault("$callback")
  valid_822084800 = validateParameter(valid_822084800, JString,
                                      required = false, default = nil)
  if valid_822084800 != nil:
    section.add "$callback", valid_822084800
  var valid_822084801 = query.getOrDefault("$prettyPrint")
  valid_822084801 = validateParameter(valid_822084801, JBool, required = false,
                                      default = nil)
  if valid_822084801 != nil:
    section.add "$prettyPrint", valid_822084801
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084802: Call_GetPermissionByCorpusAndPermission_822084793;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Gets information about a specific Permission.
  ## 
  let valid = call_822084802.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084802.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084802.makeUrl(scheme.get, call_822084802.host, call_822084802.base,
                                   call_822084802.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084802, uri, valid, content)

proc call*(call_822084803: Call_GetPermissionByCorpusAndPermission_822084793;
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
  var path_822084804 = newJObject()
  var query_822084805 = newJObject()
  add(path_822084804, "permission", newJString(permission))
  add(query_822084805, "$alt", newJString(Alt))
  add(query_822084805, "$.xgafv", newJString(Xgafv))
  add(query_822084805, "$callback", newJString(Callback))
  add(path_822084804, "corpus", newJString(corpus))
  add(query_822084805, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084803.call(path_822084804, query_822084805, nil, nil, nil)

var getPermissionByCorpusAndPermission* = Call_GetPermissionByCorpusAndPermission_822084793(
    name: "getPermissionByCorpusAndPermission", meth: HttpMethod.HttpGet,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/corpora/{corpus}/permissions/{permission}",
    validator: validate_GetPermissionByCorpusAndPermission_822084794, base: "/",
    makeUrl: url_GetPermissionByCorpusAndPermission_822084795,
    schemes: {Scheme.Https})
type
  Call_UpdatePermissionByCorpusAndPermission_822084819 = ref object of OpenApiRestCall_822083986
proc url_UpdatePermissionByCorpusAndPermission_822084821(protocol: Scheme;
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

proc validate_UpdatePermissionByCorpusAndPermission_822084820(path: JsonNode;
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
  var valid_822084822 = path.getOrDefault("permission")
  valid_822084822 = validateParameter(valid_822084822, JString, required = true,
                                      default = nil)
  if valid_822084822 != nil:
    section.add "permission", valid_822084822
  var valid_822084823 = path.getOrDefault("corpus")
  valid_822084823 = validateParameter(valid_822084823, JString, required = true,
                                      default = nil)
  if valid_822084823 != nil:
    section.add "corpus", valid_822084823
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
  var valid_822084824 = query.getOrDefault("$alt")
  valid_822084824 = validateParameter(valid_822084824, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084824 != nil:
    section.add "$alt", valid_822084824
  assert query != nil,
         "query argument is necessary due to required `updateMask` field"
  var valid_822084825 = query.getOrDefault("updateMask")
  valid_822084825 = validateParameter(valid_822084825, JString, required = true,
                                      default = nil)
  if valid_822084825 != nil:
    section.add "updateMask", valid_822084825
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
  ##       : Required. The permission to update.
  ## 
  ## The permission's `name` field is used to identify the permission to update.
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822084830: Call_UpdatePermissionByCorpusAndPermission_822084819;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Updates the permission.
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

proc call*(call_822084831: Call_UpdatePermissionByCorpusAndPermission_822084819;
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
  var path_822084832 = newJObject()
  var query_822084833 = newJObject()
  var body_822084834 = newJObject()
  add(path_822084832, "permission", newJString(permission))
  add(query_822084833, "$alt", newJString(Alt))
  if body != nil:
    body_822084834 = body
  add(query_822084833, "updateMask", newJString(updateMask))
  add(query_822084833, "$.xgafv", newJString(Xgafv))
  add(query_822084833, "$callback", newJString(Callback))
  add(path_822084832, "corpus", newJString(corpus))
  add(query_822084833, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084831.call(path_822084832, query_822084833, nil, nil, body_822084834)

var updatePermissionByCorpusAndPermission* = Call_UpdatePermissionByCorpusAndPermission_822084819(
    name: "updatePermissionByCorpusAndPermission", meth: HttpMethod.HttpPatch,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/corpora/{corpus}/permissions/{permission}",
    validator: validate_UpdatePermissionByCorpusAndPermission_822084820,
    base: "/", makeUrl: url_UpdatePermissionByCorpusAndPermission_822084821,
    schemes: {Scheme.Https})
type
  Call_QueryCorpus_822084835 = ref object of OpenApiRestCall_822083986
proc url_QueryCorpus_822084837(protocol: Scheme; host: string; base: string;
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

proc validate_QueryCorpus_822084836(path: JsonNode; query: JsonNode;
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
  var valid_822084838 = path.getOrDefault("corpus")
  valid_822084838 = validateParameter(valid_822084838, JString, required = true,
                                      default = nil)
  if valid_822084838 != nil:
    section.add "corpus", valid_822084838
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

proc call*(call_822084844: Call_QueryCorpus_822084835; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Performs semantic search over a `Corpus`.
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

proc call*(call_822084845: Call_QueryCorpus_822084835; corpus: string;
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
  var path_822084846 = newJObject()
  var query_822084847 = newJObject()
  var body_822084848 = newJObject()
  add(query_822084847, "$alt", newJString(Alt))
  if body != nil:
    body_822084848 = body
  add(query_822084847, "$.xgafv", newJString(Xgafv))
  add(query_822084847, "$callback", newJString(Callback))
  add(path_822084846, "corpus", newJString(corpus))
  add(query_822084847, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084845.call(path_822084846, query_822084847, nil, nil, body_822084848)

var queryCorpus* = Call_QueryCorpus_822084835(name: "queryCorpus",
    meth: HttpMethod.HttpPost, host: "generativelanguage.googleapis.com",
    route: "/v1beta/corpora/{corpus}:query", validator: validate_QueryCorpus_822084836,
    base: "/", makeUrl: url_QueryCorpus_822084837, schemes: {Scheme.Https})
type
  Call_GenerateContentByDynamicId_822084849 = ref object of OpenApiRestCall_822083986
proc url_GenerateContentByDynamicId_822084851(protocol: Scheme; host: string;
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

proc validate_GenerateContentByDynamicId_822084850(path: JsonNode;
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

proc call*(call_822084858: Call_GenerateContentByDynamicId_822084849;
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

proc call*(call_822084859: Call_GenerateContentByDynamicId_822084849;
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

var generateContentByDynamicId* = Call_GenerateContentByDynamicId_822084849(
    name: "generateContentByDynamicId", meth: HttpMethod.HttpPost,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/dynamic/{dynamicId}:generateContent",
    validator: validate_GenerateContentByDynamicId_822084850, base: "/",
    makeUrl: url_GenerateContentByDynamicId_822084851, schemes: {Scheme.Https})
type
  Call_StreamGenerateContentByDynamicId_822084863 = ref object of OpenApiRestCall_822083986
proc url_StreamGenerateContentByDynamicId_822084865(protocol: Scheme;
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

proc validate_StreamGenerateContentByDynamicId_822084864(path: JsonNode;
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
  var valid_822084866 = path.getOrDefault("dynamicId")
  valid_822084866 = validateParameter(valid_822084866, JString, required = true,
                                      default = nil)
  if valid_822084866 != nil:
    section.add "dynamicId", valid_822084866
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
  var valid_822084867 = query.getOrDefault("$alt")
  valid_822084867 = validateParameter(valid_822084867, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084867 != nil:
    section.add "$alt", valid_822084867
  var valid_822084868 = query.getOrDefault("$.xgafv")
  valid_822084868 = validateParameter(valid_822084868, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084868 != nil:
    section.add "$.xgafv", valid_822084868
  var valid_822084869 = query.getOrDefault("$callback")
  valid_822084869 = validateParameter(valid_822084869, JString,
                                      required = false, default = nil)
  if valid_822084869 != nil:
    section.add "$callback", valid_822084869
  var valid_822084870 = query.getOrDefault("$prettyPrint")
  valid_822084870 = validateParameter(valid_822084870, JBool, required = false,
                                      default = nil)
  if valid_822084870 != nil:
    section.add "$prettyPrint", valid_822084870
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

proc call*(call_822084872: Call_StreamGenerateContentByDynamicId_822084863;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Generates a [streamed
  ## response](https://ai.google.dev/gemini-api/docs/text-generation?lang=python#generate-a-text-stream)
  ## from the model given an input `GenerateContentRequest`.
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

proc call*(call_822084873: Call_StreamGenerateContentByDynamicId_822084863;
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
  var path_822084874 = newJObject()
  var query_822084875 = newJObject()
  var body_822084876 = newJObject()
  add(path_822084874, "dynamicId", newJString(dynamicId))
  add(query_822084875, "$alt", newJString(Alt))
  if body != nil:
    body_822084876 = body
  add(query_822084875, "$.xgafv", newJString(Xgafv))
  add(query_822084875, "$callback", newJString(Callback))
  add(query_822084875, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084873.call(path_822084874, query_822084875, nil, nil, body_822084876)

var streamGenerateContentByDynamicId* = Call_StreamGenerateContentByDynamicId_822084863(
    name: "streamGenerateContentByDynamicId", meth: HttpMethod.HttpPost,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/dynamic/{dynamicId}:streamGenerateContent",
    validator: validate_StreamGenerateContentByDynamicId_822084864, base: "/",
    makeUrl: url_StreamGenerateContentByDynamicId_822084865,
    schemes: {Scheme.Https})
type
  Call_CreateFile_822084889 = ref object of OpenApiRestCall_822083986
proc url_CreateFile_822084891(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CreateFile_822084890(path: JsonNode; query: JsonNode;
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
  var valid_822084892 = query.getOrDefault("$alt")
  valid_822084892 = validateParameter(valid_822084892, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084892 != nil:
    section.add "$alt", valid_822084892
  var valid_822084893 = query.getOrDefault("$.xgafv")
  valid_822084893 = validateParameter(valid_822084893, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084893 != nil:
    section.add "$.xgafv", valid_822084893
  var valid_822084894 = query.getOrDefault("$callback")
  valid_822084894 = validateParameter(valid_822084894, JString,
                                      required = false, default = nil)
  if valid_822084894 != nil:
    section.add "$callback", valid_822084894
  var valid_822084895 = query.getOrDefault("$prettyPrint")
  valid_822084895 = validateParameter(valid_822084895, JBool, required = false,
                                      default = nil)
  if valid_822084895 != nil:
    section.add "$prettyPrint", valid_822084895
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

proc call*(call_822084897: Call_CreateFile_822084889; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Creates a `File`.
  ## 
  let valid = call_822084897.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084897.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084897.makeUrl(scheme.get, call_822084897.host, call_822084897.base,
                                   call_822084897.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084897, uri, valid, content)

proc call*(call_822084898: Call_CreateFile_822084889; Alt: string = "json";
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
  var query_822084899 = newJObject()
  var body_822084900 = newJObject()
  add(query_822084899, "$alt", newJString(Alt))
  if body != nil:
    body_822084900 = body
  add(query_822084899, "$.xgafv", newJString(Xgafv))
  add(query_822084899, "$callback", newJString(Callback))
  add(query_822084899, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084898.call(nil, query_822084899, nil, nil, body_822084900)

var createFile* = Call_CreateFile_822084889(name: "createFile",
    meth: HttpMethod.HttpPost, host: "generativelanguage.googleapis.com",
    route: "/v1beta/files", validator: validate_CreateFile_822084890, base: "/",
    makeUrl: url_CreateFile_822084891, schemes: {Scheme.Https})
type
  Call_ListFiles_822084877 = ref object of OpenApiRestCall_822083986
proc url_ListFiles_822084879(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_ListFiles_822084878(path: JsonNode; query: JsonNode;
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
  var valid_822084880 = query.getOrDefault("$alt")
  valid_822084880 = validateParameter(valid_822084880, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084880 != nil:
    section.add "$alt", valid_822084880
  var valid_822084881 = query.getOrDefault("$.xgafv")
  valid_822084881 = validateParameter(valid_822084881, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084881 != nil:
    section.add "$.xgafv", valid_822084881
  var valid_822084882 = query.getOrDefault("$callback")
  valid_822084882 = validateParameter(valid_822084882, JString,
                                      required = false, default = nil)
  if valid_822084882 != nil:
    section.add "$callback", valid_822084882
  var valid_822084883 = query.getOrDefault("pageSize")
  valid_822084883 = validateParameter(valid_822084883, JInt, required = false,
                                      default = nil)
  if valid_822084883 != nil:
    section.add "pageSize", valid_822084883
  var valid_822084884 = query.getOrDefault("pageToken")
  valid_822084884 = validateParameter(valid_822084884, JString,
                                      required = false, default = nil)
  if valid_822084884 != nil:
    section.add "pageToken", valid_822084884
  var valid_822084885 = query.getOrDefault("$prettyPrint")
  valid_822084885 = validateParameter(valid_822084885, JBool, required = false,
                                      default = nil)
  if valid_822084885 != nil:
    section.add "$prettyPrint", valid_822084885
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084886: Call_ListFiles_822084877; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Lists the metadata for `File`s owned by the requesting project.
  ## 
  let valid = call_822084886.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084886.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084886.makeUrl(scheme.get, call_822084886.host, call_822084886.base,
                                   call_822084886.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084886, uri, valid, content)

proc call*(call_822084887: Call_ListFiles_822084877; Alt: string = "json";
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
  var query_822084888 = newJObject()
  add(query_822084888, "$alt", newJString(Alt))
  add(query_822084888, "$.xgafv", newJString(Xgafv))
  add(query_822084888, "$callback", newJString(Callback))
  add(query_822084888, "pageSize", newJInt(pageSize))
  add(query_822084888, "pageToken", newJString(pageToken))
  add(query_822084888, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084887.call(nil, query_822084888, nil, nil, nil)

var listFiles* = Call_ListFiles_822084877(name: "listFiles",
    meth: HttpMethod.HttpGet, host: "generativelanguage.googleapis.com",
    route: "/v1beta/files", validator: validate_ListFiles_822084878, base: "/",
    makeUrl: url_ListFiles_822084879, schemes: {Scheme.Https})
type
  Call_DeleteFile_822084913 = ref object of OpenApiRestCall_822083986
proc url_DeleteFile_822084915(protocol: Scheme; host: string; base: string;
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

proc validate_DeleteFile_822084914(path: JsonNode; query: JsonNode;
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
  var valid_822084916 = path.getOrDefault("file")
  valid_822084916 = validateParameter(valid_822084916, JString, required = true,
                                      default = nil)
  if valid_822084916 != nil:
    section.add "file", valid_822084916
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
  var valid_822084917 = query.getOrDefault("$alt")
  valid_822084917 = validateParameter(valid_822084917, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084917 != nil:
    section.add "$alt", valid_822084917
  var valid_822084918 = query.getOrDefault("$.xgafv")
  valid_822084918 = validateParameter(valid_822084918, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084918 != nil:
    section.add "$.xgafv", valid_822084918
  var valid_822084919 = query.getOrDefault("$callback")
  valid_822084919 = validateParameter(valid_822084919, JString,
                                      required = false, default = nil)
  if valid_822084919 != nil:
    section.add "$callback", valid_822084919
  var valid_822084920 = query.getOrDefault("$prettyPrint")
  valid_822084920 = validateParameter(valid_822084920, JBool, required = false,
                                      default = nil)
  if valid_822084920 != nil:
    section.add "$prettyPrint", valid_822084920
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084921: Call_DeleteFile_822084913; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Deletes the `File`.
  ## 
  let valid = call_822084921.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084921.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084921.makeUrl(scheme.get, call_822084921.host, call_822084921.base,
                                   call_822084921.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084921, uri, valid, content)

proc call*(call_822084922: Call_DeleteFile_822084913; file: string;
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
  var path_822084923 = newJObject()
  var query_822084924 = newJObject()
  add(query_822084924, "$alt", newJString(Alt))
  add(query_822084924, "$.xgafv", newJString(Xgafv))
  add(query_822084924, "$callback", newJString(Callback))
  add(path_822084923, "file", newJString(file))
  add(query_822084924, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084922.call(path_822084923, query_822084924, nil, nil, nil)

var deleteFile* = Call_DeleteFile_822084913(name: "deleteFile",
    meth: HttpMethod.HttpDelete, host: "generativelanguage.googleapis.com",
    route: "/v1beta/files/{file}", validator: validate_DeleteFile_822084914,
    base: "/", makeUrl: url_DeleteFile_822084915, schemes: {Scheme.Https})
type
  Call_GetFile_822084901 = ref object of OpenApiRestCall_822083986
proc url_GetFile_822084903(protocol: Scheme; host: string; base: string;
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

proc validate_GetFile_822084902(path: JsonNode; query: JsonNode;
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
  var valid_822084904 = path.getOrDefault("file")
  valid_822084904 = validateParameter(valid_822084904, JString, required = true,
                                      default = nil)
  if valid_822084904 != nil:
    section.add "file", valid_822084904
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
  var valid_822084905 = query.getOrDefault("$alt")
  valid_822084905 = validateParameter(valid_822084905, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084905 != nil:
    section.add "$alt", valid_822084905
  var valid_822084906 = query.getOrDefault("$.xgafv")
  valid_822084906 = validateParameter(valid_822084906, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084906 != nil:
    section.add "$.xgafv", valid_822084906
  var valid_822084907 = query.getOrDefault("$callback")
  valid_822084907 = validateParameter(valid_822084907, JString,
                                      required = false, default = nil)
  if valid_822084907 != nil:
    section.add "$callback", valid_822084907
  var valid_822084908 = query.getOrDefault("$prettyPrint")
  valid_822084908 = validateParameter(valid_822084908, JBool, required = false,
                                      default = nil)
  if valid_822084908 != nil:
    section.add "$prettyPrint", valid_822084908
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084909: Call_GetFile_822084901; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Gets the metadata for the given `File`.
  ## 
  let valid = call_822084909.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084909.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084909.makeUrl(scheme.get, call_822084909.host, call_822084909.base,
                                   call_822084909.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084909, uri, valid, content)

proc call*(call_822084910: Call_GetFile_822084901; file: string;
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
  var path_822084911 = newJObject()
  var query_822084912 = newJObject()
  add(query_822084912, "$alt", newJString(Alt))
  add(query_822084912, "$.xgafv", newJString(Xgafv))
  add(query_822084912, "$callback", newJString(Callback))
  add(path_822084911, "file", newJString(file))
  add(query_822084912, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084910.call(path_822084911, query_822084912, nil, nil, nil)

var getFile* = Call_GetFile_822084901(name: "getFile", meth: HttpMethod.HttpGet, host: "generativelanguage.googleapis.com",
                                      route: "/v1beta/files/{file}",
                                      validator: validate_GetFile_822084902,
                                      base: "/", makeUrl: url_GetFile_822084903,
                                      schemes: {Scheme.Https})
type
  Call_DownloadFile_822084925 = ref object of OpenApiRestCall_822083986
proc url_DownloadFile_822084927(protocol: Scheme; host: string; base: string;
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

proc validate_DownloadFile_822084926(path: JsonNode; query: JsonNode;
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
  var valid_822084928 = path.getOrDefault("file")
  valid_822084928 = validateParameter(valid_822084928, JString, required = true,
                                      default = nil)
  if valid_822084928 != nil:
    section.add "file", valid_822084928
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
  var valid_822084929 = query.getOrDefault("$alt")
  valid_822084929 = validateParameter(valid_822084929, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084929 != nil:
    section.add "$alt", valid_822084929
  var valid_822084930 = query.getOrDefault("$.xgafv")
  valid_822084930 = validateParameter(valid_822084930, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084930 != nil:
    section.add "$.xgafv", valid_822084930
  var valid_822084931 = query.getOrDefault("$callback")
  valid_822084931 = validateParameter(valid_822084931, JString,
                                      required = false, default = nil)
  if valid_822084931 != nil:
    section.add "$callback", valid_822084931
  var valid_822084932 = query.getOrDefault("$prettyPrint")
  valid_822084932 = validateParameter(valid_822084932, JBool, required = false,
                                      default = nil)
  if valid_822084932 != nil:
    section.add "$prettyPrint", valid_822084932
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084933: Call_DownloadFile_822084925; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Download the `File`.
  ## 
  let valid = call_822084933.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084933.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084933.makeUrl(scheme.get, call_822084933.host, call_822084933.base,
                                   call_822084933.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084933, uri, valid, content)

proc call*(call_822084934: Call_DownloadFile_822084925; file: string;
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
  var path_822084935 = newJObject()
  var query_822084936 = newJObject()
  add(query_822084936, "$alt", newJString(Alt))
  add(query_822084936, "$.xgafv", newJString(Xgafv))
  add(query_822084936, "$callback", newJString(Callback))
  add(path_822084935, "file", newJString(file))
  add(query_822084936, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084934.call(path_822084935, query_822084936, nil, nil, nil)

var downloadFile* = Call_DownloadFile_822084925(name: "downloadFile",
    meth: HttpMethod.HttpGet, host: "generativelanguage.googleapis.com",
    route: "/v1beta/files/{file}:download", validator: validate_DownloadFile_822084926,
    base: "/", makeUrl: url_DownloadFile_822084927, schemes: {Scheme.Https})
type
  Call_ListGeneratedFiles_822084937 = ref object of OpenApiRestCall_822083986
proc url_ListGeneratedFiles_822084939(protocol: Scheme; host: string;
                                      base: string; route: string;
                                      path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_ListGeneratedFiles_822084938(path: JsonNode; query: JsonNode;
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
  var valid_822084940 = query.getOrDefault("$alt")
  valid_822084940 = validateParameter(valid_822084940, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084940 != nil:
    section.add "$alt", valid_822084940
  var valid_822084941 = query.getOrDefault("$.xgafv")
  valid_822084941 = validateParameter(valid_822084941, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084941 != nil:
    section.add "$.xgafv", valid_822084941
  var valid_822084942 = query.getOrDefault("$callback")
  valid_822084942 = validateParameter(valid_822084942, JString,
                                      required = false, default = nil)
  if valid_822084942 != nil:
    section.add "$callback", valid_822084942
  var valid_822084943 = query.getOrDefault("pageSize")
  valid_822084943 = validateParameter(valid_822084943, JInt, required = false,
                                      default = nil)
  if valid_822084943 != nil:
    section.add "pageSize", valid_822084943
  var valid_822084944 = query.getOrDefault("pageToken")
  valid_822084944 = validateParameter(valid_822084944, JString,
                                      required = false, default = nil)
  if valid_822084944 != nil:
    section.add "pageToken", valid_822084944
  var valid_822084945 = query.getOrDefault("$prettyPrint")
  valid_822084945 = validateParameter(valid_822084945, JBool, required = false,
                                      default = nil)
  if valid_822084945 != nil:
    section.add "$prettyPrint", valid_822084945
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084946: Call_ListGeneratedFiles_822084937;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Lists the generated files owned by the requesting project.
  ## 
  let valid = call_822084946.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084946.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084946.makeUrl(scheme.get, call_822084946.host, call_822084946.base,
                                   call_822084946.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084946, uri, valid, content)

proc call*(call_822084947: Call_ListGeneratedFiles_822084937;
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
  var query_822084948 = newJObject()
  add(query_822084948, "$alt", newJString(Alt))
  add(query_822084948, "$.xgafv", newJString(Xgafv))
  add(query_822084948, "$callback", newJString(Callback))
  add(query_822084948, "pageSize", newJInt(pageSize))
  add(query_822084948, "pageToken", newJString(pageToken))
  add(query_822084948, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084947.call(nil, query_822084948, nil, nil, nil)

var listGeneratedFiles* = Call_ListGeneratedFiles_822084937(
    name: "listGeneratedFiles", meth: HttpMethod.HttpGet,
    host: "generativelanguage.googleapis.com", route: "/v1beta/generatedFiles",
    validator: validate_ListGeneratedFiles_822084938, base: "/",
    makeUrl: url_ListGeneratedFiles_822084939, schemes: {Scheme.Https})
type
  Call_GetGeneratedFile_822084949 = ref object of OpenApiRestCall_822083986
proc url_GetGeneratedFile_822084951(protocol: Scheme; host: string;
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

proc validate_GetGeneratedFile_822084950(path: JsonNode; query: JsonNode;
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
  var valid_822084952 = path.getOrDefault("generatedFile")
  valid_822084952 = validateParameter(valid_822084952, JString, required = true,
                                      default = nil)
  if valid_822084952 != nil:
    section.add "generatedFile", valid_822084952
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
  var valid_822084953 = query.getOrDefault("$alt")
  valid_822084953 = validateParameter(valid_822084953, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084953 != nil:
    section.add "$alt", valid_822084953
  var valid_822084954 = query.getOrDefault("$.xgafv")
  valid_822084954 = validateParameter(valid_822084954, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084954 != nil:
    section.add "$.xgafv", valid_822084954
  var valid_822084955 = query.getOrDefault("$callback")
  valid_822084955 = validateParameter(valid_822084955, JString,
                                      required = false, default = nil)
  if valid_822084955 != nil:
    section.add "$callback", valid_822084955
  var valid_822084956 = query.getOrDefault("$prettyPrint")
  valid_822084956 = validateParameter(valid_822084956, JBool, required = false,
                                      default = nil)
  if valid_822084956 != nil:
    section.add "$prettyPrint", valid_822084956
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084957: Call_GetGeneratedFile_822084949;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Gets a generated file. When calling this method via REST, only the metadata
  ## of the generated file is returned. To retrieve the file content via REST,
  ## add alt=media as a query parameter.
  ## 
  let valid = call_822084957.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084957.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084957.makeUrl(scheme.get, call_822084957.host, call_822084957.base,
                                   call_822084957.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084957, uri, valid, content)

proc call*(call_822084958: Call_GetGeneratedFile_822084949;
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
  var path_822084959 = newJObject()
  var query_822084960 = newJObject()
  add(path_822084959, "generatedFile", newJString(generatedFile))
  add(query_822084960, "$alt", newJString(Alt))
  add(query_822084960, "$.xgafv", newJString(Xgafv))
  add(query_822084960, "$callback", newJString(Callback))
  add(query_822084960, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084958.call(path_822084959, query_822084960, nil, nil, nil)

var getGeneratedFile* = Call_GetGeneratedFile_822084949(
    name: "getGeneratedFile", meth: HttpMethod.HttpGet,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/generatedFiles/{generatedFile}",
    validator: validate_GetGeneratedFile_822084950, base: "/",
    makeUrl: url_GetGeneratedFile_822084951, schemes: {Scheme.Https})
type
  Call_GetOperationByGeneratedFileAndOperation_822084961 = ref object of OpenApiRestCall_822083986
proc url_GetOperationByGeneratedFileAndOperation_822084963(protocol: Scheme;
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

proc validate_GetOperationByGeneratedFileAndOperation_822084962(path: JsonNode;
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
  var valid_822084964 = path.getOrDefault("generatedFile")
  valid_822084964 = validateParameter(valid_822084964, JString, required = true,
                                      default = nil)
  if valid_822084964 != nil:
    section.add "generatedFile", valid_822084964
  var valid_822084965 = path.getOrDefault("operation")
  valid_822084965 = validateParameter(valid_822084965, JString, required = true,
                                      default = nil)
  if valid_822084965 != nil:
    section.add "operation", valid_822084965
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
  var valid_822084966 = query.getOrDefault("$alt")
  valid_822084966 = validateParameter(valid_822084966, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084966 != nil:
    section.add "$alt", valid_822084966
  var valid_822084967 = query.getOrDefault("$.xgafv")
  valid_822084967 = validateParameter(valid_822084967, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084967 != nil:
    section.add "$.xgafv", valid_822084967
  var valid_822084968 = query.getOrDefault("$callback")
  valid_822084968 = validateParameter(valid_822084968, JString,
                                      required = false, default = nil)
  if valid_822084968 != nil:
    section.add "$callback", valid_822084968
  var valid_822084969 = query.getOrDefault("$prettyPrint")
  valid_822084969 = validateParameter(valid_822084969, JBool, required = false,
                                      default = nil)
  if valid_822084969 != nil:
    section.add "$prettyPrint", valid_822084969
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084970: Call_GetOperationByGeneratedFileAndOperation_822084961;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_822084970.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084970.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084970.makeUrl(scheme.get, call_822084970.host, call_822084970.base,
                                   call_822084970.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084970, uri, valid, content)

proc call*(call_822084971: Call_GetOperationByGeneratedFileAndOperation_822084961;
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
  var path_822084972 = newJObject()
  var query_822084973 = newJObject()
  add(path_822084972, "generatedFile", newJString(generatedFile))
  add(query_822084973, "$alt", newJString(Alt))
  add(query_822084973, "$.xgafv", newJString(Xgafv))
  add(query_822084973, "$callback", newJString(Callback))
  add(path_822084972, "operation", newJString(operation))
  add(query_822084973, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084971.call(path_822084972, query_822084973, nil, nil, nil)

var getOperationByGeneratedFileAndOperation* = Call_GetOperationByGeneratedFileAndOperation_822084961(
    name: "getOperationByGeneratedFileAndOperation", meth: HttpMethod.HttpGet,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/generatedFiles/{generatedFile}/operations/{operation}",
    validator: validate_GetOperationByGeneratedFileAndOperation_822084962,
    base: "/", makeUrl: url_GetOperationByGeneratedFileAndOperation_822084963,
    schemes: {Scheme.Https})
type
  Call_ListModels_822084974 = ref object of OpenApiRestCall_822083986
proc url_ListModels_822084976(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_ListModels_822084975(path: JsonNode; query: JsonNode;
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
  var valid_822084977 = query.getOrDefault("$alt")
  valid_822084977 = validateParameter(valid_822084977, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084977 != nil:
    section.add "$alt", valid_822084977
  var valid_822084978 = query.getOrDefault("$.xgafv")
  valid_822084978 = validateParameter(valid_822084978, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084978 != nil:
    section.add "$.xgafv", valid_822084978
  var valid_822084979 = query.getOrDefault("$callback")
  valid_822084979 = validateParameter(valid_822084979, JString,
                                      required = false, default = nil)
  if valid_822084979 != nil:
    section.add "$callback", valid_822084979
  var valid_822084980 = query.getOrDefault("pageSize")
  valid_822084980 = validateParameter(valid_822084980, JInt, required = false,
                                      default = nil)
  if valid_822084980 != nil:
    section.add "pageSize", valid_822084980
  var valid_822084981 = query.getOrDefault("pageToken")
  valid_822084981 = validateParameter(valid_822084981, JString,
                                      required = false, default = nil)
  if valid_822084981 != nil:
    section.add "pageToken", valid_822084981
  var valid_822084982 = query.getOrDefault("$prettyPrint")
  valid_822084982 = validateParameter(valid_822084982, JBool, required = false,
                                      default = nil)
  if valid_822084982 != nil:
    section.add "$prettyPrint", valid_822084982
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084983: Call_ListModels_822084974; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Lists the [`Model`s](https://ai.google.dev/gemini-api/docs/models/gemini)
  ## available through the Gemini API.
  ## 
  let valid = call_822084983.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084983.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084983.makeUrl(scheme.get, call_822084983.host, call_822084983.base,
                                   call_822084983.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084983, uri, valid, content)

proc call*(call_822084984: Call_ListModels_822084974; Alt: string = "json";
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
  var query_822084985 = newJObject()
  add(query_822084985, "$alt", newJString(Alt))
  add(query_822084985, "$.xgafv", newJString(Xgafv))
  add(query_822084985, "$callback", newJString(Callback))
  add(query_822084985, "pageSize", newJInt(pageSize))
  add(query_822084985, "pageToken", newJString(pageToken))
  add(query_822084985, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084984.call(nil, query_822084985, nil, nil, nil)

var listModels* = Call_ListModels_822084974(name: "listModels",
    meth: HttpMethod.HttpGet, host: "generativelanguage.googleapis.com",
    route: "/v1beta/models", validator: validate_ListModels_822084975,
    base: "/", makeUrl: url_ListModels_822084976, schemes: {Scheme.Https})
type
  Call_GetModel_822084986 = ref object of OpenApiRestCall_822083986
proc url_GetModel_822084988(protocol: Scheme; host: string; base: string;
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

proc validate_GetModel_822084987(path: JsonNode; query: JsonNode;
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
  var valid_822084989 = path.getOrDefault("model")
  valid_822084989 = validateParameter(valid_822084989, JString, required = true,
                                      default = nil)
  if valid_822084989 != nil:
    section.add "model", valid_822084989
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
  var valid_822084990 = query.getOrDefault("$alt")
  valid_822084990 = validateParameter(valid_822084990, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084990 != nil:
    section.add "$alt", valid_822084990
  var valid_822084991 = query.getOrDefault("$.xgafv")
  valid_822084991 = validateParameter(valid_822084991, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822084991 != nil:
    section.add "$.xgafv", valid_822084991
  var valid_822084992 = query.getOrDefault("$callback")
  valid_822084992 = validateParameter(valid_822084992, JString,
                                      required = false, default = nil)
  if valid_822084992 != nil:
    section.add "$callback", valid_822084992
  var valid_822084993 = query.getOrDefault("$prettyPrint")
  valid_822084993 = validateParameter(valid_822084993, JBool, required = false,
                                      default = nil)
  if valid_822084993 != nil:
    section.add "$prettyPrint", valid_822084993
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084994: Call_GetModel_822084986; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Gets information about a specific `Model` such as its version number, token
  ## limits,
  ## [parameters](https://ai.google.dev/gemini-api/docs/models/generative-models#model-parameters)
  ## and other metadata. Refer to the [Gemini models
  ## guide](https://ai.google.dev/gemini-api/docs/models/gemini) for detailed
  ## model information.
  ## 
  let valid = call_822084994.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084994.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084994.makeUrl(scheme.get, call_822084994.host, call_822084994.base,
                                   call_822084994.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084994, uri, valid, content)

proc call*(call_822084995: Call_GetModel_822084986; model: string;
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
  var path_822084996 = newJObject()
  var query_822084997 = newJObject()
  add(query_822084997, "$alt", newJString(Alt))
  add(query_822084997, "$.xgafv", newJString(Xgafv))
  add(query_822084997, "$callback", newJString(Callback))
  add(path_822084996, "model", newJString(model))
  add(query_822084997, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822084995.call(path_822084996, query_822084997, nil, nil, nil)

var getModel* = Call_GetModel_822084986(name: "getModel",
                                        meth: HttpMethod.HttpGet, host: "generativelanguage.googleapis.com",
                                        route: "/v1beta/models/{model}",
                                        validator: validate_GetModel_822084987,
                                        base: "/", makeUrl: url_GetModel_822084988,
                                        schemes: {Scheme.Https})
type
  Call_ListOperationsByModel_822084998 = ref object of OpenApiRestCall_822083986
proc url_ListOperationsByModel_822085000(protocol: Scheme; host: string;
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

proc validate_ListOperationsByModel_822084999(path: JsonNode; query: JsonNode;
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
  var valid_822085001 = path.getOrDefault("model")
  valid_822085001 = validateParameter(valid_822085001, JString, required = true,
                                      default = nil)
  if valid_822085001 != nil:
    section.add "model", valid_822085001
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
  var valid_822085002 = query.getOrDefault("$alt")
  valid_822085002 = validateParameter(valid_822085002, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822085002 != nil:
    section.add "$alt", valid_822085002
  var valid_822085003 = query.getOrDefault("$.xgafv")
  valid_822085003 = validateParameter(valid_822085003, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822085003 != nil:
    section.add "$.xgafv", valid_822085003
  var valid_822085004 = query.getOrDefault("$callback")
  valid_822085004 = validateParameter(valid_822085004, JString,
                                      required = false, default = nil)
  if valid_822085004 != nil:
    section.add "$callback", valid_822085004
  var valid_822085005 = query.getOrDefault("filter")
  valid_822085005 = validateParameter(valid_822085005, JString,
                                      required = false, default = nil)
  if valid_822085005 != nil:
    section.add "filter", valid_822085005
  var valid_822085006 = query.getOrDefault("pageSize")
  valid_822085006 = validateParameter(valid_822085006, JInt, required = false,
                                      default = nil)
  if valid_822085006 != nil:
    section.add "pageSize", valid_822085006
  var valid_822085007 = query.getOrDefault("pageToken")
  valid_822085007 = validateParameter(valid_822085007, JString,
                                      required = false, default = nil)
  if valid_822085007 != nil:
    section.add "pageToken", valid_822085007
  var valid_822085008 = query.getOrDefault("$prettyPrint")
  valid_822085008 = validateParameter(valid_822085008, JBool, required = false,
                                      default = nil)
  if valid_822085008 != nil:
    section.add "$prettyPrint", valid_822085008
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085009: Call_ListOperationsByModel_822084998;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ## 
  let valid = call_822085009.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085009.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085009.makeUrl(scheme.get, call_822085009.host, call_822085009.base,
                                   call_822085009.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085009, uri, valid, content)

proc call*(call_822085010: Call_ListOperationsByModel_822084998; model: string;
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
  var path_822085011 = newJObject()
  var query_822085012 = newJObject()
  add(query_822085012, "$alt", newJString(Alt))
  add(query_822085012, "$.xgafv", newJString(Xgafv))
  add(query_822085012, "$callback", newJString(Callback))
  add(query_822085012, "filter", newJString(filter))
  add(path_822085011, "model", newJString(model))
  add(query_822085012, "pageSize", newJInt(pageSize))
  add(query_822085012, "pageToken", newJString(pageToken))
  add(query_822085012, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822085010.call(path_822085011, query_822085012, nil, nil, nil)

var listOperationsByModel* = Call_ListOperationsByModel_822084998(
    name: "listOperationsByModel", meth: HttpMethod.HttpGet,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/models/{model}/operations",
    validator: validate_ListOperationsByModel_822084999, base: "/",
    makeUrl: url_ListOperationsByModel_822085000, schemes: {Scheme.Https})
type
  Call_GetOperationByModelAndOperation_822085013 = ref object of OpenApiRestCall_822083986
proc url_GetOperationByModelAndOperation_822085015(protocol: Scheme;
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

proc validate_GetOperationByModelAndOperation_822085014(path: JsonNode;
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
  var valid_822085016 = path.getOrDefault("model")
  valid_822085016 = validateParameter(valid_822085016, JString, required = true,
                                      default = nil)
  if valid_822085016 != nil:
    section.add "model", valid_822085016
  var valid_822085017 = path.getOrDefault("operation")
  valid_822085017 = validateParameter(valid_822085017, JString, required = true,
                                      default = nil)
  if valid_822085017 != nil:
    section.add "operation", valid_822085017
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
  var valid_822085018 = query.getOrDefault("$alt")
  valid_822085018 = validateParameter(valid_822085018, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822085018 != nil:
    section.add "$alt", valid_822085018
  var valid_822085019 = query.getOrDefault("$.xgafv")
  valid_822085019 = validateParameter(valid_822085019, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822085019 != nil:
    section.add "$.xgafv", valid_822085019
  var valid_822085020 = query.getOrDefault("$callback")
  valid_822085020 = validateParameter(valid_822085020, JString,
                                      required = false, default = nil)
  if valid_822085020 != nil:
    section.add "$callback", valid_822085020
  var valid_822085021 = query.getOrDefault("$prettyPrint")
  valid_822085021 = validateParameter(valid_822085021, JBool, required = false,
                                      default = nil)
  if valid_822085021 != nil:
    section.add "$prettyPrint", valid_822085021
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085022: Call_GetOperationByModelAndOperation_822085013;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_822085022.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085022.makeUrl(scheme.get, call_822085022.host, call_822085022.base,
                                   call_822085022.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085022, uri, valid, content)

proc call*(call_822085023: Call_GetOperationByModelAndOperation_822085013;
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
  var path_822085024 = newJObject()
  var query_822085025 = newJObject()
  add(query_822085025, "$alt", newJString(Alt))
  add(query_822085025, "$.xgafv", newJString(Xgafv))
  add(query_822085025, "$callback", newJString(Callback))
  add(path_822085024, "model", newJString(model))
  add(path_822085024, "operation", newJString(operation))
  add(query_822085025, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822085023.call(path_822085024, query_822085025, nil, nil, nil)

var getOperationByModelAndOperation* = Call_GetOperationByModelAndOperation_822085013(
    name: "getOperationByModelAndOperation", meth: HttpMethod.HttpGet,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/models/{model}/operations/{operation}",
    validator: validate_GetOperationByModelAndOperation_822085014, base: "/",
    makeUrl: url_GetOperationByModelAndOperation_822085015,
    schemes: {Scheme.Https})
type
  Call_BatchEmbedContents_822085026 = ref object of OpenApiRestCall_822083986
proc url_BatchEmbedContents_822085028(protocol: Scheme; host: string;
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

proc validate_BatchEmbedContents_822085027(path: JsonNode; query: JsonNode;
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

proc call*(call_822085035: Call_BatchEmbedContents_822085026;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Generates multiple embedding vectors from the input `Content` which
  ## consists of a batch of strings represented as `EmbedContentRequest`
  ## objects.
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

proc call*(call_822085036: Call_BatchEmbedContents_822085026; model: string;
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

var batchEmbedContents* = Call_BatchEmbedContents_822085026(
    name: "batchEmbedContents", meth: HttpMethod.HttpPost,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/models/{model}:batchEmbedContents",
    validator: validate_BatchEmbedContents_822085027, base: "/",
    makeUrl: url_BatchEmbedContents_822085028, schemes: {Scheme.Https})
type
  Call_BatchEmbedText_822085040 = ref object of OpenApiRestCall_822083986
proc url_BatchEmbedText_822085042(protocol: Scheme; host: string; base: string;
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

proc validate_BatchEmbedText_822085041(path: JsonNode; query: JsonNode;
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

proc call*(call_822085049: Call_BatchEmbedText_822085040; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Generates multiple embeddings from the model given input text in a
  ## synchronous call.
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

proc call*(call_822085050: Call_BatchEmbedText_822085040; model: string;
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

var batchEmbedText* = Call_BatchEmbedText_822085040(name: "batchEmbedText",
    meth: HttpMethod.HttpPost, host: "generativelanguage.googleapis.com",
    route: "/v1beta/models/{model}:batchEmbedText",
    validator: validate_BatchEmbedText_822085041, base: "/",
    makeUrl: url_BatchEmbedText_822085042, schemes: {Scheme.Https})
type
  Call_CountMessageTokens_822085054 = ref object of OpenApiRestCall_822083986
proc url_CountMessageTokens_822085056(protocol: Scheme; host: string;
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

proc validate_CountMessageTokens_822085055(path: JsonNode; query: JsonNode;
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

proc call*(call_822085063: Call_CountMessageTokens_822085054;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Runs a model's tokenizer on a string and returns the token count.
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

proc call*(call_822085064: Call_CountMessageTokens_822085054; model: string;
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

var countMessageTokens* = Call_CountMessageTokens_822085054(
    name: "countMessageTokens", meth: HttpMethod.HttpPost,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/models/{model}:countMessageTokens",
    validator: validate_CountMessageTokens_822085055, base: "/",
    makeUrl: url_CountMessageTokens_822085056, schemes: {Scheme.Https})
type
  Call_CountTextTokens_822085068 = ref object of OpenApiRestCall_822083986
proc url_CountTextTokens_822085070(protocol: Scheme; host: string; base: string;
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

proc validate_CountTextTokens_822085069(path: JsonNode; query: JsonNode;
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

proc call*(call_822085077: Call_CountTextTokens_822085068; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Runs a model's tokenizer on a text and returns the token count.
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

proc call*(call_822085078: Call_CountTextTokens_822085068; model: string;
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

var countTextTokens* = Call_CountTextTokens_822085068(name: "countTextTokens",
    meth: HttpMethod.HttpPost, host: "generativelanguage.googleapis.com",
    route: "/v1beta/models/{model}:countTextTokens",
    validator: validate_CountTextTokens_822085069, base: "/",
    makeUrl: url_CountTextTokens_822085070, schemes: {Scheme.Https})
type
  Call_CountTokens_822085082 = ref object of OpenApiRestCall_822083986
proc url_CountTokens_822085084(protocol: Scheme; host: string; base: string;
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

proc validate_CountTokens_822085083(path: JsonNode; query: JsonNode;
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

proc call*(call_822085091: Call_CountTokens_822085082; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Runs a model's tokenizer on input `Content` and returns the token count.
  ## Refer to the [tokens guide](https://ai.google.dev/gemini-api/docs/tokens)
  ## to learn more about tokens.
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

proc call*(call_822085092: Call_CountTokens_822085082; model: string;
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

var countTokens* = Call_CountTokens_822085082(name: "countTokens",
    meth: HttpMethod.HttpPost, host: "generativelanguage.googleapis.com",
    route: "/v1beta/models/{model}:countTokens",
    validator: validate_CountTokens_822085083, base: "/",
    makeUrl: url_CountTokens_822085084, schemes: {Scheme.Https})
type
  Call_EmbedContent_822085096 = ref object of OpenApiRestCall_822083986
proc url_EmbedContent_822085098(protocol: Scheme; host: string; base: string;
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

proc validate_EmbedContent_822085097(path: JsonNode; query: JsonNode;
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

proc call*(call_822085105: Call_EmbedContent_822085096; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Generates a text embedding vector from the input `Content` using the
  ## specified [Gemini Embedding
  ## model](https://ai.google.dev/gemini-api/docs/models/gemini#text-embedding).
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

proc call*(call_822085106: Call_EmbedContent_822085096; model: string;
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

var embedContent* = Call_EmbedContent_822085096(name: "embedContent",
    meth: HttpMethod.HttpPost, host: "generativelanguage.googleapis.com",
    route: "/v1beta/models/{model}:embedContent",
    validator: validate_EmbedContent_822085097, base: "/",
    makeUrl: url_EmbedContent_822085098, schemes: {Scheme.Https})
type
  Call_EmbedText_822085110 = ref object of OpenApiRestCall_822083986
proc url_EmbedText_822085112(protocol: Scheme; host: string; base: string;
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

proc validate_EmbedText_822085111(path: JsonNode; query: JsonNode;
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

proc call*(call_822085119: Call_EmbedText_822085110; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Generates an embedding from the model given an input message.
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

proc call*(call_822085120: Call_EmbedText_822085110; model: string;
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

var embedText* = Call_EmbedText_822085110(name: "embedText",
    meth: HttpMethod.HttpPost, host: "generativelanguage.googleapis.com",
    route: "/v1beta/models/{model}:embedText", validator: validate_EmbedText_822085111,
    base: "/", makeUrl: url_EmbedText_822085112, schemes: {Scheme.Https})
type
  Call_GenerateAnswer_822085124 = ref object of OpenApiRestCall_822083986
proc url_GenerateAnswer_822085126(protocol: Scheme; host: string; base: string;
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

proc validate_GenerateAnswer_822085125(path: JsonNode; query: JsonNode;
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

proc call*(call_822085133: Call_GenerateAnswer_822085124; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Generates a grounded answer from the model given an input
  ## `GenerateAnswerRequest`.
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

proc call*(call_822085134: Call_GenerateAnswer_822085124; model: string;
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

var generateAnswer* = Call_GenerateAnswer_822085124(name: "generateAnswer",
    meth: HttpMethod.HttpPost, host: "generativelanguage.googleapis.com",
    route: "/v1beta/models/{model}:generateAnswer",
    validator: validate_GenerateAnswer_822085125, base: "/",
    makeUrl: url_GenerateAnswer_822085126, schemes: {Scheme.Https})
type
  Call_GenerateContent_822085138 = ref object of OpenApiRestCall_822083986
proc url_GenerateContent_822085140(protocol: Scheme; host: string; base: string;
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

proc validate_GenerateContent_822085139(path: JsonNode; query: JsonNode;
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

proc call*(call_822085147: Call_GenerateContent_822085138; path: JsonNode = nil;
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

proc call*(call_822085148: Call_GenerateContent_822085138; model: string;
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

var generateContent* = Call_GenerateContent_822085138(name: "generateContent",
    meth: HttpMethod.HttpPost, host: "generativelanguage.googleapis.com",
    route: "/v1beta/models/{model}:generateContent",
    validator: validate_GenerateContent_822085139, base: "/",
    makeUrl: url_GenerateContent_822085140, schemes: {Scheme.Https})
type
  Call_GenerateMessage_822085152 = ref object of OpenApiRestCall_822083986
proc url_GenerateMessage_822085154(protocol: Scheme; host: string; base: string;
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

proc validate_GenerateMessage_822085153(path: JsonNode; query: JsonNode;
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

proc call*(call_822085161: Call_GenerateMessage_822085152; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Generates a response from the model given an input `MessagePrompt`.
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

proc call*(call_822085162: Call_GenerateMessage_822085152; model: string;
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

var generateMessage* = Call_GenerateMessage_822085152(name: "generateMessage",
    meth: HttpMethod.HttpPost, host: "generativelanguage.googleapis.com",
    route: "/v1beta/models/{model}:generateMessage",
    validator: validate_GenerateMessage_822085153, base: "/",
    makeUrl: url_GenerateMessage_822085154, schemes: {Scheme.Https})
type
  Call_GenerateText_822085166 = ref object of OpenApiRestCall_822083986
proc url_GenerateText_822085168(protocol: Scheme; host: string; base: string;
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

proc validate_GenerateText_822085167(path: JsonNode; query: JsonNode;
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

proc call*(call_822085175: Call_GenerateText_822085166; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Generates a response from the model given an input message.
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

proc call*(call_822085176: Call_GenerateText_822085166; model: string;
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

var generateText* = Call_GenerateText_822085166(name: "generateText",
    meth: HttpMethod.HttpPost, host: "generativelanguage.googleapis.com",
    route: "/v1beta/models/{model}:generateText",
    validator: validate_GenerateText_822085167, base: "/",
    makeUrl: url_GenerateText_822085168, schemes: {Scheme.Https})
type
  Call_Predict_822085180 = ref object of OpenApiRestCall_822083986
proc url_Predict_822085182(protocol: Scheme; host: string; base: string;
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

proc validate_Predict_822085181(path: JsonNode; query: JsonNode;
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

proc call*(call_822085189: Call_Predict_822085180; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Performs a prediction request.
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

proc call*(call_822085190: Call_Predict_822085180; model: string;
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

var predict* = Call_Predict_822085180(name: "predict",
                                      meth: HttpMethod.HttpPost, host: "generativelanguage.googleapis.com",
                                      route: "/v1beta/models/{model}:predict",
                                      validator: validate_Predict_822085181,
                                      base: "/", makeUrl: url_Predict_822085182,
                                      schemes: {Scheme.Https})
type
  Call_PredictLongRunning_822085194 = ref object of OpenApiRestCall_822083986
proc url_PredictLongRunning_822085196(protocol: Scheme; host: string;
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

proc validate_PredictLongRunning_822085195(path: JsonNode; query: JsonNode;
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

proc call*(call_822085203: Call_PredictLongRunning_822085194;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Same as Predict but returns an LRO.
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

proc call*(call_822085204: Call_PredictLongRunning_822085194; model: string;
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

var predictLongRunning* = Call_PredictLongRunning_822085194(
    name: "predictLongRunning", meth: HttpMethod.HttpPost,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/models/{model}:predictLongRunning",
    validator: validate_PredictLongRunning_822085195, base: "/",
    makeUrl: url_PredictLongRunning_822085196, schemes: {Scheme.Https})
type
  Call_StreamGenerateContent_822085208 = ref object of OpenApiRestCall_822083986
proc url_StreamGenerateContent_822085210(protocol: Scheme; host: string;
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

proc validate_StreamGenerateContent_822085209(path: JsonNode; query: JsonNode;
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
  var valid_822085211 = path.getOrDefault("model")
  valid_822085211 = validateParameter(valid_822085211, JString, required = true,
                                      default = nil)
  if valid_822085211 != nil:
    section.add "model", valid_822085211
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
  var valid_822085212 = query.getOrDefault("$alt")
  valid_822085212 = validateParameter(valid_822085212, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822085212 != nil:
    section.add "$alt", valid_822085212
  var valid_822085213 = query.getOrDefault("$.xgafv")
  valid_822085213 = validateParameter(valid_822085213, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822085213 != nil:
    section.add "$.xgafv", valid_822085213
  var valid_822085214 = query.getOrDefault("$callback")
  valid_822085214 = validateParameter(valid_822085214, JString,
                                      required = false, default = nil)
  if valid_822085214 != nil:
    section.add "$callback", valid_822085214
  var valid_822085215 = query.getOrDefault("$prettyPrint")
  valid_822085215 = validateParameter(valid_822085215, JBool, required = false,
                                      default = nil)
  if valid_822085215 != nil:
    section.add "$prettyPrint", valid_822085215
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

proc call*(call_822085217: Call_StreamGenerateContent_822085208;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Generates a [streamed
  ## response](https://ai.google.dev/gemini-api/docs/text-generation?lang=python#generate-a-text-stream)
  ## from the model given an input `GenerateContentRequest`.
  ## 
  let valid = call_822085217.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085217.makeUrl(scheme.get, call_822085217.host, call_822085217.base,
                                   call_822085217.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085217, uri, valid, content)

proc call*(call_822085218: Call_StreamGenerateContent_822085208; model: string;
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
  var path_822085219 = newJObject()
  var query_822085220 = newJObject()
  var body_822085221 = newJObject()
  add(query_822085220, "$alt", newJString(Alt))
  if body != nil:
    body_822085221 = body
  add(query_822085220, "$.xgafv", newJString(Xgafv))
  add(query_822085220, "$callback", newJString(Callback))
  add(path_822085219, "model", newJString(model))
  add(query_822085220, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822085218.call(path_822085219, query_822085220, nil, nil, body_822085221)

var streamGenerateContent* = Call_StreamGenerateContent_822085208(
    name: "streamGenerateContent", meth: HttpMethod.HttpPost,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/models/{model}:streamGenerateContent",
    validator: validate_StreamGenerateContent_822085209, base: "/",
    makeUrl: url_StreamGenerateContent_822085210, schemes: {Scheme.Https})
type
  Call_CreateTunedModel_822085235 = ref object of OpenApiRestCall_822083986
proc url_CreateTunedModel_822085237(protocol: Scheme; host: string;
                                    base: string; route: string; path: JsonNode;
                                    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CreateTunedModel_822085236(path: JsonNode; query: JsonNode;
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
  var valid_822085241 = query.getOrDefault("tunedModelId")
  valid_822085241 = validateParameter(valid_822085241, JString,
                                      required = false, default = nil)
  if valid_822085241 != nil:
    section.add "tunedModelId", valid_822085241
  var valid_822085242 = query.getOrDefault("$prettyPrint")
  valid_822085242 = validateParameter(valid_822085242, JBool, required = false,
                                      default = nil)
  if valid_822085242 != nil:
    section.add "$prettyPrint", valid_822085242
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

proc call*(call_822085244: Call_CreateTunedModel_822085235;
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
  let valid = call_822085244.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085244.makeUrl(scheme.get, call_822085244.host, call_822085244.base,
                                   call_822085244.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085244, uri, valid, content)

proc call*(call_822085245: Call_CreateTunedModel_822085235;
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
  var query_822085246 = newJObject()
  var body_822085247 = newJObject()
  add(query_822085246, "$alt", newJString(Alt))
  if body != nil:
    body_822085247 = body
  add(query_822085246, "$.xgafv", newJString(Xgafv))
  add(query_822085246, "$callback", newJString(Callback))
  add(query_822085246, "tunedModelId", newJString(tunedModelId))
  add(query_822085246, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822085245.call(nil, query_822085246, nil, nil, body_822085247)

var createTunedModel* = Call_CreateTunedModel_822085235(
    name: "createTunedModel", meth: HttpMethod.HttpPost,
    host: "generativelanguage.googleapis.com", route: "/v1beta/tunedModels",
    validator: validate_CreateTunedModel_822085236, base: "/",
    makeUrl: url_CreateTunedModel_822085237, schemes: {Scheme.Https})
type
  Call_ListTunedModels_822085222 = ref object of OpenApiRestCall_822083986
proc url_ListTunedModels_822085224(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode;
                                   query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_ListTunedModels_822085223(path: JsonNode; query: JsonNode;
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
  var valid_822085225 = query.getOrDefault("$alt")
  valid_822085225 = validateParameter(valid_822085225, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822085225 != nil:
    section.add "$alt", valid_822085225
  var valid_822085226 = query.getOrDefault("$.xgafv")
  valid_822085226 = validateParameter(valid_822085226, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822085226 != nil:
    section.add "$.xgafv", valid_822085226
  var valid_822085227 = query.getOrDefault("$callback")
  valid_822085227 = validateParameter(valid_822085227, JString,
                                      required = false, default = nil)
  if valid_822085227 != nil:
    section.add "$callback", valid_822085227
  var valid_822085228 = query.getOrDefault("filter")
  valid_822085228 = validateParameter(valid_822085228, JString,
                                      required = false, default = nil)
  if valid_822085228 != nil:
    section.add "filter", valid_822085228
  var valid_822085229 = query.getOrDefault("pageSize")
  valid_822085229 = validateParameter(valid_822085229, JInt, required = false,
                                      default = nil)
  if valid_822085229 != nil:
    section.add "pageSize", valid_822085229
  var valid_822085230 = query.getOrDefault("pageToken")
  valid_822085230 = validateParameter(valid_822085230, JString,
                                      required = false, default = nil)
  if valid_822085230 != nil:
    section.add "pageToken", valid_822085230
  var valid_822085231 = query.getOrDefault("$prettyPrint")
  valid_822085231 = validateParameter(valid_822085231, JBool, required = false,
                                      default = nil)
  if valid_822085231 != nil:
    section.add "$prettyPrint", valid_822085231
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085232: Call_ListTunedModels_822085222; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Lists created tuned models.
  ## 
  let valid = call_822085232.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085232.makeUrl(scheme.get, call_822085232.host, call_822085232.base,
                                   call_822085232.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085232, uri, valid, content)

proc call*(call_822085233: Call_ListTunedModels_822085222; Alt: string = "json";
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
  var query_822085234 = newJObject()
  add(query_822085234, "$alt", newJString(Alt))
  add(query_822085234, "$.xgafv", newJString(Xgafv))
  add(query_822085234, "$callback", newJString(Callback))
  add(query_822085234, "filter", newJString(filter))
  add(query_822085234, "pageSize", newJInt(pageSize))
  add(query_822085234, "pageToken", newJString(pageToken))
  add(query_822085234, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822085233.call(nil, query_822085234, nil, nil, nil)

var listTunedModels* = Call_ListTunedModels_822085222(name: "listTunedModels",
    meth: HttpMethod.HttpGet, host: "generativelanguage.googleapis.com",
    route: "/v1beta/tunedModels", validator: validate_ListTunedModels_822085223,
    base: "/", makeUrl: url_ListTunedModels_822085224, schemes: {Scheme.Https})
type
  Call_DeleteTunedModel_822085260 = ref object of OpenApiRestCall_822083986
proc url_DeleteTunedModel_822085262(protocol: Scheme; host: string;
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

proc validate_DeleteTunedModel_822085261(path: JsonNode; query: JsonNode;
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
  var valid_822085263 = path.getOrDefault("tunedModel")
  valid_822085263 = validateParameter(valid_822085263, JString, required = true,
                                      default = nil)
  if valid_822085263 != nil:
    section.add "tunedModel", valid_822085263
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
  var valid_822085264 = query.getOrDefault("$alt")
  valid_822085264 = validateParameter(valid_822085264, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822085264 != nil:
    section.add "$alt", valid_822085264
  var valid_822085265 = query.getOrDefault("$.xgafv")
  valid_822085265 = validateParameter(valid_822085265, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822085265 != nil:
    section.add "$.xgafv", valid_822085265
  var valid_822085266 = query.getOrDefault("$callback")
  valid_822085266 = validateParameter(valid_822085266, JString,
                                      required = false, default = nil)
  if valid_822085266 != nil:
    section.add "$callback", valid_822085266
  var valid_822085267 = query.getOrDefault("$prettyPrint")
  valid_822085267 = validateParameter(valid_822085267, JBool, required = false,
                                      default = nil)
  if valid_822085267 != nil:
    section.add "$prettyPrint", valid_822085267
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085268: Call_DeleteTunedModel_822085260;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Deletes a tuned model.
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

proc call*(call_822085269: Call_DeleteTunedModel_822085260; tunedModel: string;
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
  var path_822085270 = newJObject()
  var query_822085271 = newJObject()
  add(path_822085270, "tunedModel", newJString(tunedModel))
  add(query_822085271, "$alt", newJString(Alt))
  add(query_822085271, "$.xgafv", newJString(Xgafv))
  add(query_822085271, "$callback", newJString(Callback))
  add(query_822085271, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822085269.call(path_822085270, query_822085271, nil, nil, nil)

var deleteTunedModel* = Call_DeleteTunedModel_822085260(
    name: "deleteTunedModel", meth: HttpMethod.HttpDelete,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/tunedModels/{tunedModel}",
    validator: validate_DeleteTunedModel_822085261, base: "/",
    makeUrl: url_DeleteTunedModel_822085262, schemes: {Scheme.Https})
type
  Call_GetTunedModel_822085248 = ref object of OpenApiRestCall_822083986
proc url_GetTunedModel_822085250(protocol: Scheme; host: string; base: string;
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

proc validate_GetTunedModel_822085249(path: JsonNode; query: JsonNode;
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
  var valid_822085251 = path.getOrDefault("tunedModel")
  valid_822085251 = validateParameter(valid_822085251, JString, required = true,
                                      default = nil)
  if valid_822085251 != nil:
    section.add "tunedModel", valid_822085251
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
  var valid_822085252 = query.getOrDefault("$alt")
  valid_822085252 = validateParameter(valid_822085252, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822085252 != nil:
    section.add "$alt", valid_822085252
  var valid_822085253 = query.getOrDefault("$.xgafv")
  valid_822085253 = validateParameter(valid_822085253, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822085253 != nil:
    section.add "$.xgafv", valid_822085253
  var valid_822085254 = query.getOrDefault("$callback")
  valid_822085254 = validateParameter(valid_822085254, JString,
                                      required = false, default = nil)
  if valid_822085254 != nil:
    section.add "$callback", valid_822085254
  var valid_822085255 = query.getOrDefault("$prettyPrint")
  valid_822085255 = validateParameter(valid_822085255, JBool, required = false,
                                      default = nil)
  if valid_822085255 != nil:
    section.add "$prettyPrint", valid_822085255
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085256: Call_GetTunedModel_822085248; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Gets information about a specific TunedModel.
  ## 
  let valid = call_822085256.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085256.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085256.makeUrl(scheme.get, call_822085256.host, call_822085256.base,
                                   call_822085256.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085256, uri, valid, content)

proc call*(call_822085257: Call_GetTunedModel_822085248; tunedModel: string;
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
  var path_822085258 = newJObject()
  var query_822085259 = newJObject()
  add(path_822085258, "tunedModel", newJString(tunedModel))
  add(query_822085259, "$alt", newJString(Alt))
  add(query_822085259, "$.xgafv", newJString(Xgafv))
  add(query_822085259, "$callback", newJString(Callback))
  add(query_822085259, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822085257.call(path_822085258, query_822085259, nil, nil, nil)

var getTunedModel* = Call_GetTunedModel_822085248(name: "getTunedModel",
    meth: HttpMethod.HttpGet, host: "generativelanguage.googleapis.com",
    route: "/v1beta/tunedModels/{tunedModel}",
    validator: validate_GetTunedModel_822085249, base: "/",
    makeUrl: url_GetTunedModel_822085250, schemes: {Scheme.Https})
type
  Call_UpdateTunedModel_822085272 = ref object of OpenApiRestCall_822083986
proc url_UpdateTunedModel_822085274(protocol: Scheme; host: string;
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

proc validate_UpdateTunedModel_822085273(path: JsonNode; query: JsonNode;
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
  var valid_822085275 = path.getOrDefault("tunedModel")
  valid_822085275 = validateParameter(valid_822085275, JString, required = true,
                                      default = nil)
  if valid_822085275 != nil:
    section.add "tunedModel", valid_822085275
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
  var valid_822085276 = query.getOrDefault("$alt")
  valid_822085276 = validateParameter(valid_822085276, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822085276 != nil:
    section.add "$alt", valid_822085276
  var valid_822085277 = query.getOrDefault("updateMask")
  valid_822085277 = validateParameter(valid_822085277, JString,
                                      required = false, default = nil)
  if valid_822085277 != nil:
    section.add "updateMask", valid_822085277
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
  var valid_822085280 = query.getOrDefault("$prettyPrint")
  valid_822085280 = validateParameter(valid_822085280, JBool, required = false,
                                      default = nil)
  if valid_822085280 != nil:
    section.add "$prettyPrint", valid_822085280
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

proc call*(call_822085282: Call_UpdateTunedModel_822085272;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Updates a tuned model.
  ## 
  let valid = call_822085282.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085282.makeUrl(scheme.get, call_822085282.host, call_822085282.base,
                                   call_822085282.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085282, uri, valid, content)

proc call*(call_822085283: Call_UpdateTunedModel_822085272; tunedModel: string;
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
  var path_822085284 = newJObject()
  var query_822085285 = newJObject()
  var body_822085286 = newJObject()
  add(path_822085284, "tunedModel", newJString(tunedModel))
  add(query_822085285, "$alt", newJString(Alt))
  if body != nil:
    body_822085286 = body
  add(query_822085285, "updateMask", newJString(updateMask))
  add(query_822085285, "$.xgafv", newJString(Xgafv))
  add(query_822085285, "$callback", newJString(Callback))
  add(query_822085285, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822085283.call(path_822085284, query_822085285, nil, nil, body_822085286)

var updateTunedModel* = Call_UpdateTunedModel_822085272(
    name: "updateTunedModel", meth: HttpMethod.HttpPatch,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/tunedModels/{tunedModel}",
    validator: validate_UpdateTunedModel_822085273, base: "/",
    makeUrl: url_UpdateTunedModel_822085274, schemes: {Scheme.Https})
type
  Call_ListOperations_822085287 = ref object of OpenApiRestCall_822083986
proc url_ListOperations_822085289(protocol: Scheme; host: string; base: string;
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

proc validate_ListOperations_822085288(path: JsonNode; query: JsonNode;
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
  var valid_822085290 = path.getOrDefault("tunedModel")
  valid_822085290 = validateParameter(valid_822085290, JString, required = true,
                                      default = nil)
  if valid_822085290 != nil:
    section.add "tunedModel", valid_822085290
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
  var valid_822085291 = query.getOrDefault("$alt")
  valid_822085291 = validateParameter(valid_822085291, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822085291 != nil:
    section.add "$alt", valid_822085291
  var valid_822085292 = query.getOrDefault("$.xgafv")
  valid_822085292 = validateParameter(valid_822085292, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822085292 != nil:
    section.add "$.xgafv", valid_822085292
  var valid_822085293 = query.getOrDefault("$callback")
  valid_822085293 = validateParameter(valid_822085293, JString,
                                      required = false, default = nil)
  if valid_822085293 != nil:
    section.add "$callback", valid_822085293
  var valid_822085294 = query.getOrDefault("filter")
  valid_822085294 = validateParameter(valid_822085294, JString,
                                      required = false, default = nil)
  if valid_822085294 != nil:
    section.add "filter", valid_822085294
  var valid_822085295 = query.getOrDefault("pageSize")
  valid_822085295 = validateParameter(valid_822085295, JInt, required = false,
                                      default = nil)
  if valid_822085295 != nil:
    section.add "pageSize", valid_822085295
  var valid_822085296 = query.getOrDefault("pageToken")
  valid_822085296 = validateParameter(valid_822085296, JString,
                                      required = false, default = nil)
  if valid_822085296 != nil:
    section.add "pageToken", valid_822085296
  var valid_822085297 = query.getOrDefault("$prettyPrint")
  valid_822085297 = validateParameter(valid_822085297, JBool, required = false,
                                      default = nil)
  if valid_822085297 != nil:
    section.add "$prettyPrint", valid_822085297
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085298: Call_ListOperations_822085287; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ## 
  let valid = call_822085298.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085298.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085298.makeUrl(scheme.get, call_822085298.host, call_822085298.base,
                                   call_822085298.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085298, uri, valid, content)

proc call*(call_822085299: Call_ListOperations_822085287; tunedModel: string;
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
  var path_822085300 = newJObject()
  var query_822085301 = newJObject()
  add(path_822085300, "tunedModel", newJString(tunedModel))
  add(query_822085301, "$alt", newJString(Alt))
  add(query_822085301, "$.xgafv", newJString(Xgafv))
  add(query_822085301, "$callback", newJString(Callback))
  add(query_822085301, "filter", newJString(filter))
  add(query_822085301, "pageSize", newJInt(pageSize))
  add(query_822085301, "pageToken", newJString(pageToken))
  add(query_822085301, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822085299.call(path_822085300, query_822085301, nil, nil, nil)

var listOperations* = Call_ListOperations_822085287(name: "listOperations",
    meth: HttpMethod.HttpGet, host: "generativelanguage.googleapis.com",
    route: "/v1beta/tunedModels/{tunedModel}/operations",
    validator: validate_ListOperations_822085288, base: "/",
    makeUrl: url_ListOperations_822085289, schemes: {Scheme.Https})
type
  Call_GetOperation_822085302 = ref object of OpenApiRestCall_822083986
proc url_GetOperation_822085304(protocol: Scheme; host: string; base: string;
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

proc validate_GetOperation_822085303(path: JsonNode; query: JsonNode;
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
  var valid_822085305 = path.getOrDefault("tunedModel")
  valid_822085305 = validateParameter(valid_822085305, JString, required = true,
                                      default = nil)
  if valid_822085305 != nil:
    section.add "tunedModel", valid_822085305
  var valid_822085306 = path.getOrDefault("operation")
  valid_822085306 = validateParameter(valid_822085306, JString, required = true,
                                      default = nil)
  if valid_822085306 != nil:
    section.add "operation", valid_822085306
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
  var valid_822085307 = query.getOrDefault("$alt")
  valid_822085307 = validateParameter(valid_822085307, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822085307 != nil:
    section.add "$alt", valid_822085307
  var valid_822085308 = query.getOrDefault("$.xgafv")
  valid_822085308 = validateParameter(valid_822085308, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822085308 != nil:
    section.add "$.xgafv", valid_822085308
  var valid_822085309 = query.getOrDefault("$callback")
  valid_822085309 = validateParameter(valid_822085309, JString,
                                      required = false, default = nil)
  if valid_822085309 != nil:
    section.add "$callback", valid_822085309
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

proc call*(call_822085311: Call_GetOperation_822085302; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
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

proc call*(call_822085312: Call_GetOperation_822085302; tunedModel: string;
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
  var path_822085313 = newJObject()
  var query_822085314 = newJObject()
  add(path_822085313, "tunedModel", newJString(tunedModel))
  add(query_822085314, "$alt", newJString(Alt))
  add(query_822085314, "$.xgafv", newJString(Xgafv))
  add(query_822085314, "$callback", newJString(Callback))
  add(path_822085313, "operation", newJString(operation))
  add(query_822085314, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822085312.call(path_822085313, query_822085314, nil, nil, nil)

var getOperation* = Call_GetOperation_822085302(name: "getOperation",
    meth: HttpMethod.HttpGet, host: "generativelanguage.googleapis.com",
    route: "/v1beta/tunedModels/{tunedModel}/operations/{operation}",
    validator: validate_GetOperation_822085303, base: "/",
    makeUrl: url_GetOperation_822085304, schemes: {Scheme.Https})
type
  Call_CreatePermission_822085329 = ref object of OpenApiRestCall_822083986
proc url_CreatePermission_822085331(protocol: Scheme; host: string;
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

proc validate_CreatePermission_822085330(path: JsonNode; query: JsonNode;
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
  var valid_822085332 = path.getOrDefault("tunedModel")
  valid_822085332 = validateParameter(valid_822085332, JString, required = true,
                                      default = nil)
  if valid_822085332 != nil:
    section.add "tunedModel", valid_822085332
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
  var valid_822085333 = query.getOrDefault("$alt")
  valid_822085333 = validateParameter(valid_822085333, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822085333 != nil:
    section.add "$alt", valid_822085333
  var valid_822085334 = query.getOrDefault("$.xgafv")
  valid_822085334 = validateParameter(valid_822085334, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822085334 != nil:
    section.add "$.xgafv", valid_822085334
  var valid_822085335 = query.getOrDefault("$callback")
  valid_822085335 = validateParameter(valid_822085335, JString,
                                      required = false, default = nil)
  if valid_822085335 != nil:
    section.add "$callback", valid_822085335
  var valid_822085336 = query.getOrDefault("$prettyPrint")
  valid_822085336 = validateParameter(valid_822085336, JBool, required = false,
                                      default = nil)
  if valid_822085336 != nil:
    section.add "$prettyPrint", valid_822085336
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

proc call*(call_822085338: Call_CreatePermission_822085329;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Create a permission to a specific resource.
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

proc call*(call_822085339: Call_CreatePermission_822085329; tunedModel: string;
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
  var path_822085340 = newJObject()
  var query_822085341 = newJObject()
  var body_822085342 = newJObject()
  add(path_822085340, "tunedModel", newJString(tunedModel))
  add(query_822085341, "$alt", newJString(Alt))
  if body != nil:
    body_822085342 = body
  add(query_822085341, "$.xgafv", newJString(Xgafv))
  add(query_822085341, "$callback", newJString(Callback))
  add(query_822085341, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822085339.call(path_822085340, query_822085341, nil, nil, body_822085342)

var createPermission* = Call_CreatePermission_822085329(
    name: "createPermission", meth: HttpMethod.HttpPost,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/tunedModels/{tunedModel}/permissions",
    validator: validate_CreatePermission_822085330, base: "/",
    makeUrl: url_CreatePermission_822085331, schemes: {Scheme.Https})
type
  Call_ListPermissions_822085315 = ref object of OpenApiRestCall_822083986
proc url_ListPermissions_822085317(protocol: Scheme; host: string; base: string;
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

proc validate_ListPermissions_822085316(path: JsonNode; query: JsonNode;
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
  var valid_822085322 = query.getOrDefault("pageSize")
  valid_822085322 = validateParameter(valid_822085322, JInt, required = false,
                                      default = nil)
  if valid_822085322 != nil:
    section.add "pageSize", valid_822085322
  var valid_822085323 = query.getOrDefault("pageToken")
  valid_822085323 = validateParameter(valid_822085323, JString,
                                      required = false, default = nil)
  if valid_822085323 != nil:
    section.add "pageToken", valid_822085323
  var valid_822085324 = query.getOrDefault("$prettyPrint")
  valid_822085324 = validateParameter(valid_822085324, JBool, required = false,
                                      default = nil)
  if valid_822085324 != nil:
    section.add "$prettyPrint", valid_822085324
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085325: Call_ListPermissions_822085315; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Lists permissions for the specific resource.
  ## 
  let valid = call_822085325.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085325.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085325.makeUrl(scheme.get, call_822085325.host, call_822085325.base,
                                   call_822085325.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085325, uri, valid, content)

proc call*(call_822085326: Call_ListPermissions_822085315; tunedModel: string;
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
  var path_822085327 = newJObject()
  var query_822085328 = newJObject()
  add(path_822085327, "tunedModel", newJString(tunedModel))
  add(query_822085328, "$alt", newJString(Alt))
  add(query_822085328, "$.xgafv", newJString(Xgafv))
  add(query_822085328, "$callback", newJString(Callback))
  add(query_822085328, "pageSize", newJInt(pageSize))
  add(query_822085328, "pageToken", newJString(pageToken))
  add(query_822085328, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822085326.call(path_822085327, query_822085328, nil, nil, nil)

var listPermissions* = Call_ListPermissions_822085315(name: "listPermissions",
    meth: HttpMethod.HttpGet, host: "generativelanguage.googleapis.com",
    route: "/v1beta/tunedModels/{tunedModel}/permissions",
    validator: validate_ListPermissions_822085316, base: "/",
    makeUrl: url_ListPermissions_822085317, schemes: {Scheme.Https})
type
  Call_DeletePermission_822085356 = ref object of OpenApiRestCall_822083986
proc url_DeletePermission_822085358(protocol: Scheme; host: string;
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

proc validate_DeletePermission_822085357(path: JsonNode; query: JsonNode;
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
  var valid_822085359 = path.getOrDefault("permission")
  valid_822085359 = validateParameter(valid_822085359, JString, required = true,
                                      default = nil)
  if valid_822085359 != nil:
    section.add "permission", valid_822085359
  var valid_822085360 = path.getOrDefault("tunedModel")
  valid_822085360 = validateParameter(valid_822085360, JString, required = true,
                                      default = nil)
  if valid_822085360 != nil:
    section.add "tunedModel", valid_822085360
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
  var valid_822085361 = query.getOrDefault("$alt")
  valid_822085361 = validateParameter(valid_822085361, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822085361 != nil:
    section.add "$alt", valid_822085361
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
  if body != nil:
    result.add "body", body

proc call*(call_822085365: Call_DeletePermission_822085356;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Deletes the permission.
  ## 
  let valid = call_822085365.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085365.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085365.makeUrl(scheme.get, call_822085365.host, call_822085365.base,
                                   call_822085365.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085365, uri, valid, content)

proc call*(call_822085366: Call_DeletePermission_822085356; permission: string;
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
  var path_822085367 = newJObject()
  var query_822085368 = newJObject()
  add(path_822085367, "permission", newJString(permission))
  add(path_822085367, "tunedModel", newJString(tunedModel))
  add(query_822085368, "$alt", newJString(Alt))
  add(query_822085368, "$.xgafv", newJString(Xgafv))
  add(query_822085368, "$callback", newJString(Callback))
  add(query_822085368, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822085366.call(path_822085367, query_822085368, nil, nil, nil)

var deletePermission* = Call_DeletePermission_822085356(
    name: "deletePermission", meth: HttpMethod.HttpDelete,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/tunedModels/{tunedModel}/permissions/{permission}",
    validator: validate_DeletePermission_822085357, base: "/",
    makeUrl: url_DeletePermission_822085358, schemes: {Scheme.Https})
type
  Call_GetPermission_822085343 = ref object of OpenApiRestCall_822083986
proc url_GetPermission_822085345(protocol: Scheme; host: string; base: string;
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

proc validate_GetPermission_822085344(path: JsonNode; query: JsonNode;
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
  var valid_822085346 = path.getOrDefault("permission")
  valid_822085346 = validateParameter(valid_822085346, JString, required = true,
                                      default = nil)
  if valid_822085346 != nil:
    section.add "permission", valid_822085346
  var valid_822085347 = path.getOrDefault("tunedModel")
  valid_822085347 = validateParameter(valid_822085347, JString, required = true,
                                      default = nil)
  if valid_822085347 != nil:
    section.add "tunedModel", valid_822085347
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
  var valid_822085348 = query.getOrDefault("$alt")
  valid_822085348 = validateParameter(valid_822085348, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822085348 != nil:
    section.add "$alt", valid_822085348
  var valid_822085349 = query.getOrDefault("$.xgafv")
  valid_822085349 = validateParameter(valid_822085349, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822085349 != nil:
    section.add "$.xgafv", valid_822085349
  var valid_822085350 = query.getOrDefault("$callback")
  valid_822085350 = validateParameter(valid_822085350, JString,
                                      required = false, default = nil)
  if valid_822085350 != nil:
    section.add "$callback", valid_822085350
  var valid_822085351 = query.getOrDefault("$prettyPrint")
  valid_822085351 = validateParameter(valid_822085351, JBool, required = false,
                                      default = nil)
  if valid_822085351 != nil:
    section.add "$prettyPrint", valid_822085351
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085352: Call_GetPermission_822085343; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Gets information about a specific Permission.
  ## 
  let valid = call_822085352.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085352.makeUrl(scheme.get, call_822085352.host, call_822085352.base,
                                   call_822085352.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085352, uri, valid, content)

proc call*(call_822085353: Call_GetPermission_822085343; permission: string;
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
  var path_822085354 = newJObject()
  var query_822085355 = newJObject()
  add(path_822085354, "permission", newJString(permission))
  add(path_822085354, "tunedModel", newJString(tunedModel))
  add(query_822085355, "$alt", newJString(Alt))
  add(query_822085355, "$.xgafv", newJString(Xgafv))
  add(query_822085355, "$callback", newJString(Callback))
  add(query_822085355, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822085353.call(path_822085354, query_822085355, nil, nil, nil)

var getPermission* = Call_GetPermission_822085343(name: "getPermission",
    meth: HttpMethod.HttpGet, host: "generativelanguage.googleapis.com",
    route: "/v1beta/tunedModels/{tunedModel}/permissions/{permission}",
    validator: validate_GetPermission_822085344, base: "/",
    makeUrl: url_GetPermission_822085345, schemes: {Scheme.Https})
type
  Call_UpdatePermission_822085369 = ref object of OpenApiRestCall_822083986
proc url_UpdatePermission_822085371(protocol: Scheme; host: string;
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

proc validate_UpdatePermission_822085370(path: JsonNode; query: JsonNode;
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
  var valid_822085372 = path.getOrDefault("permission")
  valid_822085372 = validateParameter(valid_822085372, JString, required = true,
                                      default = nil)
  if valid_822085372 != nil:
    section.add "permission", valid_822085372
  var valid_822085373 = path.getOrDefault("tunedModel")
  valid_822085373 = validateParameter(valid_822085373, JString, required = true,
                                      default = nil)
  if valid_822085373 != nil:
    section.add "tunedModel", valid_822085373
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
  var valid_822085374 = query.getOrDefault("$alt")
  valid_822085374 = validateParameter(valid_822085374, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822085374 != nil:
    section.add "$alt", valid_822085374
  assert query != nil,
         "query argument is necessary due to required `updateMask` field"
  var valid_822085375 = query.getOrDefault("updateMask")
  valid_822085375 = validateParameter(valid_822085375, JString, required = true,
                                      default = nil)
  if valid_822085375 != nil:
    section.add "updateMask", valid_822085375
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
  ##       : Required. The permission to update.
  ## 
  ## The permission's `name` field is used to identify the permission to update.
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085380: Call_UpdatePermission_822085369;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Updates the permission.
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

proc call*(call_822085381: Call_UpdatePermission_822085369; permission: string;
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
  var path_822085382 = newJObject()
  var query_822085383 = newJObject()
  var body_822085384 = newJObject()
  add(path_822085382, "permission", newJString(permission))
  add(path_822085382, "tunedModel", newJString(tunedModel))
  add(query_822085383, "$alt", newJString(Alt))
  if body != nil:
    body_822085384 = body
  add(query_822085383, "updateMask", newJString(updateMask))
  add(query_822085383, "$.xgafv", newJString(Xgafv))
  add(query_822085383, "$callback", newJString(Callback))
  add(query_822085383, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822085381.call(path_822085382, query_822085383, nil, nil, body_822085384)

var updatePermission* = Call_UpdatePermission_822085369(
    name: "updatePermission", meth: HttpMethod.HttpPatch,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/tunedModels/{tunedModel}/permissions/{permission}",
    validator: validate_UpdatePermission_822085370, base: "/",
    makeUrl: url_UpdatePermission_822085371, schemes: {Scheme.Https})
type
  Call_GenerateContentByTunedModel_822085385 = ref object of OpenApiRestCall_822083986
proc url_GenerateContentByTunedModel_822085387(protocol: Scheme; host: string;
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

proc validate_GenerateContentByTunedModel_822085386(path: JsonNode;
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

proc call*(call_822085394: Call_GenerateContentByTunedModel_822085385;
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

proc call*(call_822085395: Call_GenerateContentByTunedModel_822085385;
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

var generateContentByTunedModel* = Call_GenerateContentByTunedModel_822085385(
    name: "generateContentByTunedModel", meth: HttpMethod.HttpPost,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/tunedModels/{tunedModel}:generateContent",
    validator: validate_GenerateContentByTunedModel_822085386, base: "/",
    makeUrl: url_GenerateContentByTunedModel_822085387, schemes: {Scheme.Https})
type
  Call_GenerateTextByTunedModel_822085399 = ref object of OpenApiRestCall_822083986
proc url_GenerateTextByTunedModel_822085401(protocol: Scheme; host: string;
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

proc validate_GenerateTextByTunedModel_822085400(path: JsonNode;
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

proc call*(call_822085408: Call_GenerateTextByTunedModel_822085399;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Generates a response from the model given an input message.
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

proc call*(call_822085409: Call_GenerateTextByTunedModel_822085399;
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

var generateTextByTunedModel* = Call_GenerateTextByTunedModel_822085399(
    name: "generateTextByTunedModel", meth: HttpMethod.HttpPost,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/tunedModels/{tunedModel}:generateText",
    validator: validate_GenerateTextByTunedModel_822085400, base: "/",
    makeUrl: url_GenerateTextByTunedModel_822085401, schemes: {Scheme.Https})
type
  Call_StreamGenerateContentByTunedModel_822085413 = ref object of OpenApiRestCall_822083986
proc url_StreamGenerateContentByTunedModel_822085415(protocol: Scheme;
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

proc validate_StreamGenerateContentByTunedModel_822085414(path: JsonNode;
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

proc call*(call_822085422: Call_StreamGenerateContentByTunedModel_822085413;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Generates a [streamed
  ## response](https://ai.google.dev/gemini-api/docs/text-generation?lang=python#generate-a-text-stream)
  ## from the model given an input `GenerateContentRequest`.
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

proc call*(call_822085423: Call_StreamGenerateContentByTunedModel_822085413;
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

var streamGenerateContentByTunedModel* = Call_StreamGenerateContentByTunedModel_822085413(
    name: "streamGenerateContentByTunedModel", meth: HttpMethod.HttpPost,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/tunedModels/{tunedModel}:streamGenerateContent",
    validator: validate_StreamGenerateContentByTunedModel_822085414, base: "/",
    makeUrl: url_StreamGenerateContentByTunedModel_822085415,
    schemes: {Scheme.Https})
type
  Call_TransferOwnership_822085427 = ref object of OpenApiRestCall_822083986
proc url_TransferOwnership_822085429(protocol: Scheme; host: string;
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

proc validate_TransferOwnership_822085428(path: JsonNode; query: JsonNode;
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
  var valid_822085430 = path.getOrDefault("tunedModel")
  valid_822085430 = validateParameter(valid_822085430, JString, required = true,
                                      default = nil)
  if valid_822085430 != nil:
    section.add "tunedModel", valid_822085430
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
  var valid_822085431 = query.getOrDefault("$alt")
  valid_822085431 = validateParameter(valid_822085431, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822085431 != nil:
    section.add "$alt", valid_822085431
  var valid_822085432 = query.getOrDefault("$.xgafv")
  valid_822085432 = validateParameter(valid_822085432, JString,
                                      required = false,
                                      default = newJString("1"))
  if valid_822085432 != nil:
    section.add "$.xgafv", valid_822085432
  var valid_822085433 = query.getOrDefault("$callback")
  valid_822085433 = validateParameter(valid_822085433, JString,
                                      required = false, default = nil)
  if valid_822085433 != nil:
    section.add "$callback", valid_822085433
  var valid_822085434 = query.getOrDefault("$prettyPrint")
  valid_822085434 = validateParameter(valid_822085434, JBool, required = false,
                                      default = nil)
  if valid_822085434 != nil:
    section.add "$prettyPrint", valid_822085434
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

proc call*(call_822085436: Call_TransferOwnership_822085427;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Transfers ownership of the tuned model.
  ## This is the only way to change ownership of the tuned model.
  ## The current owner will be downgraded to writer role.
  ## 
  let valid = call_822085436.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085436.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085436.makeUrl(scheme.get, call_822085436.host, call_822085436.base,
                                   call_822085436.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085436, uri, valid, content)

proc call*(call_822085437: Call_TransferOwnership_822085427; tunedModel: string;
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
  var path_822085438 = newJObject()
  var query_822085439 = newJObject()
  var body_822085440 = newJObject()
  add(path_822085438, "tunedModel", newJString(tunedModel))
  add(query_822085439, "$alt", newJString(Alt))
  if body != nil:
    body_822085440 = body
  add(query_822085439, "$.xgafv", newJString(Xgafv))
  add(query_822085439, "$callback", newJString(Callback))
  add(query_822085439, "$prettyPrint", newJBool(PrettyPrint))
  result = call_822085437.call(path_822085438, query_822085439, nil, nil, body_822085440)

var transferOwnership* = Call_TransferOwnership_822085427(
    name: "transferOwnership", meth: HttpMethod.HttpPost,
    host: "generativelanguage.googleapis.com",
    route: "/v1beta/tunedModels/{tunedModel}:transferOwnership",
    validator: validate_TransferOwnership_822085428, base: "/",
    makeUrl: url_TransferOwnership_822085429, schemes: {Scheme.Https})
discard