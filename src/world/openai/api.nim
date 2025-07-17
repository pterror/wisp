
import
  json, options, hashes, uri, strutils, rest

## auto-generated via openapi macro
## title: OpenAI API
## version: 2.3.0
## termsOfService: https://openai.com/policies/terms-of-use
## license:
##     name: MIT
##     url: https://github.com/openai/openai-openapi/blob/master/LICENSE
## 
## The OpenAI REST API. Please see https://platform.openai.com/docs/api-reference for more details.
## 
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
  OpenApiRestCall_822083995 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_822083995](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base,
             route: t.route, schemes: t.schemes, validator: t.validator,
             url: t.url)

proc pickScheme(t: OpenApiRestCall_822083995): Option[Scheme] {.used.} =
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
  Call_CreateAssistant_822084348 = ref object of OpenApiRestCall_822083995
proc url_CreateAssistant_822084350(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode;
                                   query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CreateAssistant_822084349(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  if `==`(content, ""): assert body != nil, "body argument is necessary"
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822084362: Call_CreateAssistant_822084348; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084362.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084362.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084362.makeUrl(scheme.get, call_822084362.host, call_822084362.base,
                                   call_822084362.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084362, uri, valid, content)

proc call*(call_822084363: Call_CreateAssistant_822084348; body: JsonNode): Recallable =
  ## createAssistant
  ##   body: JObject (required)
  var body_822084364 = newJObject()
  if body != nil:
    body_822084364 = body
  result = call_822084363.call(nil, nil, nil, nil, body_822084364)

var createAssistant* = Call_CreateAssistant_822084348(name: "createAssistant",
    meth: HttpMethod.HttpPost, host: "api.openai.com", route: "/assistants",
    validator: validate_CreateAssistant_822084349, base: "/v1",
    makeUrl: url_CreateAssistant_822084350, schemes: {Scheme.Https})
type
  Call_ListAssistants_822084139 = ref object of OpenApiRestCall_822083995
proc url_ListAssistants_822084141(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_ListAssistants_822084140(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   after: JString
  ##        : A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
  ## 
  ##   order: JString
  ##        : Sort order by the `created_at` timestamp of the objects. `asc` for ascending order and `desc` for descending order.
  ## 
  ##   limit: JInt
  ##        : A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.
  ## 
  ##   before: JString
  ##         : A cursor for use in pagination. `before` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, starting with obj_foo, your subsequent call can include before=obj_foo in order to fetch the previous page of the list.
  ## 
  section = newJObject()
  var valid_822084241 = query.getOrDefault("after")
  valid_822084241 = validateParameter(valid_822084241, JString,
                                      required = false, default = nil)
  if valid_822084241 != nil:
    section.add "after", valid_822084241
  var valid_822084254 = query.getOrDefault("order")
  valid_822084254 = validateParameter(valid_822084254, JString,
                                      required = false,
                                      default = newJString("desc"))
  if valid_822084254 != nil:
    section.add "order", valid_822084254
  var valid_822084255 = query.getOrDefault("limit")
  valid_822084255 = validateParameter(valid_822084255, JInt, required = false,
                                      default = newJInt(20))
  if valid_822084255 != nil:
    section.add "limit", valid_822084255
  var valid_822084256 = query.getOrDefault("before")
  valid_822084256 = validateParameter(valid_822084256, JString,
                                      required = false, default = nil)
  if valid_822084256 != nil:
    section.add "before", valid_822084256
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084268: Call_ListAssistants_822084139; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084268.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084268.makeUrl(scheme.get, call_822084268.host, call_822084268.base,
                                   call_822084268.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084268, uri, valid, content)

proc call*(call_822084317: Call_ListAssistants_822084139; after: string = "";
           order: string = "desc"; limit: int = 20; before: string = ""): Recallable =
  ## listAssistants
  ##   after: string
  ##        : A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
  ## 
  ##   order: string
  ##        : Sort order by the `created_at` timestamp of the objects. `asc` for ascending order and `desc` for descending order.
  ## 
  ##   limit: int
  ##        : A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.
  ## 
  ##   before: string
  ##         : A cursor for use in pagination. `before` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, starting with obj_foo, your subsequent call can include before=obj_foo in order to fetch the previous page of the list.
  ## 
  var query_822084318 = newJObject()
  add(query_822084318, "after", newJString(after))
  add(query_822084318, "order", newJString(order))
  add(query_822084318, "limit", newJInt(limit))
  add(query_822084318, "before", newJString(before))
  result = call_822084317.call(nil, query_822084318, nil, nil, nil)

var listAssistants* = Call_ListAssistants_822084139(name: "listAssistants",
    meth: HttpMethod.HttpGet, host: "api.openai.com", route: "/assistants",
    validator: validate_ListAssistants_822084140, base: "/v1",
    makeUrl: url_ListAssistants_822084141, schemes: {Scheme.Https})
type
  Call_DeleteAssistant_822084392 = ref object of OpenApiRestCall_822083995
proc url_DeleteAssistant_822084394(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode;
                                   query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "assistant_id" in path, "`assistant_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/assistants/"),
                 (kind: VariableSegment, value: "assistant_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DeleteAssistant_822084393(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   assistant_id: JString (required)
  ##               : The ID of the assistant to delete.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `assistant_id` field"
  var valid_822084395 = path.getOrDefault("assistant_id")
  valid_822084395 = validateParameter(valid_822084395, JString, required = true,
                                      default = nil)
  if valid_822084395 != nil:
    section.add "assistant_id", valid_822084395
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084396: Call_DeleteAssistant_822084392; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084396.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084396.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084396.makeUrl(scheme.get, call_822084396.host, call_822084396.base,
                                   call_822084396.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084396, uri, valid, content)

proc call*(call_822084397: Call_DeleteAssistant_822084392; assistantId: string): Recallable =
  ## deleteAssistant
  ##   assistantId: string (required)
  ##              : The ID of the assistant to delete.
  var path_822084398 = newJObject()
  add(path_822084398, "assistant_id", newJString(assistantId))
  result = call_822084397.call(path_822084398, nil, nil, nil, nil)

var deleteAssistant* = Call_DeleteAssistant_822084392(name: "deleteAssistant",
    meth: HttpMethod.HttpDelete, host: "api.openai.com",
    route: "/assistants/{assistant_id}", validator: validate_DeleteAssistant_822084393,
    base: "/v1", makeUrl: url_DeleteAssistant_822084394, schemes: {Scheme.Https})
type
  Call_ModifyAssistant_822084383 = ref object of OpenApiRestCall_822083995
proc url_ModifyAssistant_822084385(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode;
                                   query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "assistant_id" in path, "`assistant_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/assistants/"),
                 (kind: VariableSegment, value: "assistant_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ModifyAssistant_822084384(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   assistant_id: JString (required)
  ##               : The ID of the assistant to modify.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `assistant_id` field"
  var valid_822084386 = path.getOrDefault("assistant_id")
  valid_822084386 = validateParameter(valid_822084386, JString, required = true,
                                      default = nil)
  if valid_822084386 != nil:
    section.add "assistant_id", valid_822084386
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  if `==`(content, ""): assert body != nil, "body argument is necessary"
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822084388: Call_ModifyAssistant_822084383; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084388.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084388.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084388.makeUrl(scheme.get, call_822084388.host, call_822084388.base,
                                   call_822084388.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084388, uri, valid, content)

proc call*(call_822084389: Call_ModifyAssistant_822084383; assistantId: string;
           body: JsonNode): Recallable =
  ## modifyAssistant
  ##   assistantId: string (required)
  ##              : The ID of the assistant to modify.
  ##   body: JObject (required)
  var path_822084390 = newJObject()
  var body_822084391 = newJObject()
  add(path_822084390, "assistant_id", newJString(assistantId))
  if body != nil:
    body_822084391 = body
  result = call_822084389.call(path_822084390, nil, nil, nil, body_822084391)

var modifyAssistant* = Call_ModifyAssistant_822084383(name: "modifyAssistant",
    meth: HttpMethod.HttpPost, host: "api.openai.com",
    route: "/assistants/{assistant_id}", validator: validate_ModifyAssistant_822084384,
    base: "/v1", makeUrl: url_ModifyAssistant_822084385, schemes: {Scheme.Https})
type
  Call_GetAssistant_822084365 = ref object of OpenApiRestCall_822083995
proc url_GetAssistant_822084367(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "assistant_id" in path, "`assistant_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/assistants/"),
                 (kind: VariableSegment, value: "assistant_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GetAssistant_822084366(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   assistant_id: JString (required)
  ##               : The ID of the assistant to retrieve.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `assistant_id` field"
  var valid_822084379 = path.getOrDefault("assistant_id")
  valid_822084379 = validateParameter(valid_822084379, JString, required = true,
                                      default = nil)
  if valid_822084379 != nil:
    section.add "assistant_id", valid_822084379
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084380: Call_GetAssistant_822084365; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084380.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084380.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084380.makeUrl(scheme.get, call_822084380.host, call_822084380.base,
                                   call_822084380.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084380, uri, valid, content)

proc call*(call_822084381: Call_GetAssistant_822084365; assistantId: string): Recallable =
  ## getAssistant
  ##   assistantId: string (required)
  ##              : The ID of the assistant to retrieve.
  var path_822084382 = newJObject()
  add(path_822084382, "assistant_id", newJString(assistantId))
  result = call_822084381.call(path_822084382, nil, nil, nil, nil)

var getAssistant* = Call_GetAssistant_822084365(name: "getAssistant",
    meth: HttpMethod.HttpGet, host: "api.openai.com",
    route: "/assistants/{assistant_id}", validator: validate_GetAssistant_822084366,
    base: "/v1", makeUrl: url_GetAssistant_822084367, schemes: {Scheme.Https})
type
  Call_CreateSpeech_822084399 = ref object of OpenApiRestCall_822083995
proc url_CreateSpeech_822084401(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CreateSpeech_822084400(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  if `==`(content, ""): assert body != nil, "body argument is necessary"
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822084403: Call_CreateSpeech_822084399; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084403.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084403.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084403.makeUrl(scheme.get, call_822084403.host, call_822084403.base,
                                   call_822084403.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084403, uri, valid, content)

proc call*(call_822084404: Call_CreateSpeech_822084399; body: JsonNode): Recallable =
  ## createSpeech
  ##   body: JObject (required)
  var body_822084405 = newJObject()
  if body != nil:
    body_822084405 = body
  result = call_822084404.call(nil, nil, nil, nil, body_822084405)

var createSpeech* = Call_CreateSpeech_822084399(name: "createSpeech",
    meth: HttpMethod.HttpPost, host: "api.openai.com", route: "/audio/speech",
    validator: validate_CreateSpeech_822084400, base: "/v1",
    makeUrl: url_CreateSpeech_822084401, schemes: {Scheme.Https})
type
  Call_CreateTranscription_822084406 = ref object of OpenApiRestCall_822083995
proc url_CreateTranscription_822084408(protocol: Scheme; host: string;
                                       base: string; route: string;
                                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CreateTranscription_822084407(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  ## parameters in `formData` object:
  ##   file: JString (required)
  ##       : The audio file object (not file name) to transcribe, in one of these formats: flac, mp3, mp4, mpeg, mpga, m4a, ogg, wav, or webm.
  ## 
  ##   temperature: JFloat
  ##              : The sampling temperature, between 0 and 1. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. If set to 0, the model will use [log probability](https://en.wikipedia.org/wiki/Log_probability) to automatically increase the temperature until certain thresholds are hit.
  ## 
  ##   chunking_strategy: JString
  ##                    : Controls how the audio is cut into chunks. When set to `"auto"`, the server first normalizes loudness and then uses voice activity detection (VAD) to choose boundaries. `server_vad` object can be provided to tweak VAD detection parameters manually. If unset, the audio is transcribed as a single block. 
  ##   timestamp_granularities[]: JArray
  ##                            : The timestamp granularities to populate for this transcription. `response_format` must be set `verbose_json` to use timestamp granularities. Either or both of these options are supported: `word`, or `segment`. Note: There is no additional latency for segment timestamps, but generating word timestamps incurs additional latency.
  ## 
  ##   response_format: JString
  ##                  : The format of the output, in one of these options: `json`, `text`, `srt`, `verbose_json`, or `vtt`. For `gpt-4o-transcribe` and `gpt-4o-mini-transcribe`, the only supported format is `json`.
  ## 
  ##   model: JString (required)
  ##        : ID of the model to use. The options are `gpt-4o-transcribe`, `gpt-4o-mini-transcribe`, and `whisper-1` (which is powered by our open source Whisper V2 model).
  ## 
  ##   prompt: JString
  ##         : An optional text to guide the model's style or continue a previous audio segment. The [prompt](/docs/guides/speech-to-text#prompting) should match the audio language.
  ## 
  ##   language: JString
  ##           : The language of the input audio. Supplying the input language in [ISO-639-1](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes) (e.g. `en`) format will improve accuracy and latency.
  ## 
  ##   stream: JBool
  ##         : If set to true, the model response data will be streamed to the client
  ## as it is generated using [server-sent 
  ## events](https://developer.mozilla.org/en-US/docs/Web/API/Server-sent_events/Using_server-sent_events#Event_stream_format). 
  ## See the [Streaming section of the Speech-to-Text guide](/docs/guides/speech-to-text?lang=curl#streaming-transcriptions)
  ## for more information.
  ## 
  ## Note: Streaming is not supported for the `whisper-1` model and will be ignored.
  ## 
  ##   include[]: JArray
  ##            : Additional information to include in the transcription response. 
  ## `logprobs` will return the log probabilities of the tokens in the 
  ## response to understand the model's confidence in the transcription. 
  ## `logprobs` only works with response_format set to `json` and only with 
  ## the models `gpt-4o-transcribe` and `gpt-4o-mini-transcribe`.
  ## 
  section = newJObject()
  assert formData != nil,
         "formData argument is necessary due to required `file` field"
  var valid_822084428 = formData.getOrDefault("file")
  valid_822084428 = validateParameter(valid_822084428, JString, required = true,
                                      default = nil)
  if valid_822084428 != nil:
    section.add "file", valid_822084428
  var valid_822084429 = formData.getOrDefault("temperature")
  valid_822084429 = validateParameter(valid_822084429, JFloat, required = false,
                                      default = nil)
  if valid_822084429 != nil:
    section.add "temperature", valid_822084429
  var valid_822084430 = formData.getOrDefault("chunking_strategy")
  valid_822084430 = validateParameter(valid_822084430, JString,
                                      required = false, default = nil)
  if valid_822084430 != nil:
    section.add "chunking_strategy", valid_822084430
  var valid_822084431 = formData.getOrDefault("timestamp_granularities[]")
  valid_822084431 = validateParameter(valid_822084431, JArray, required = false, default = block:
    var jarray = newJArray()
    jarray)
  if valid_822084431 != nil:
    section.add "timestamp_granularities[]", valid_822084431
  var valid_822084432 = formData.getOrDefault("response_format")
  valid_822084432 = validateParameter(valid_822084432, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084432 != nil:
    section.add "response_format", valid_822084432
  var valid_822084433 = formData.getOrDefault("model")
  valid_822084433 = validateParameter(valid_822084433, JString, required = true,
                                      default = nil)
  if valid_822084433 != nil:
    section.add "model", valid_822084433
  var valid_822084434 = formData.getOrDefault("prompt")
  valid_822084434 = validateParameter(valid_822084434, JString,
                                      required = false, default = nil)
  if valid_822084434 != nil:
    section.add "prompt", valid_822084434
  var valid_822084435 = formData.getOrDefault("language")
  valid_822084435 = validateParameter(valid_822084435, JString,
                                      required = false, default = nil)
  if valid_822084435 != nil:
    section.add "language", valid_822084435
  var valid_822084436 = formData.getOrDefault("stream")
  valid_822084436 = validateParameter(valid_822084436, JBool, required = false,
                                      default = newJBool(false))
  if valid_822084436 != nil:
    section.add "stream", valid_822084436
  var valid_822084437 = formData.getOrDefault("include[]")
  valid_822084437 = validateParameter(valid_822084437, JArray, required = false,
                                      default = nil)
  if valid_822084437 != nil:
    section.add "include[]", valid_822084437
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084438: Call_CreateTranscription_822084406;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084438.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084438.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084438.makeUrl(scheme.get, call_822084438.host, call_822084438.base,
                                   call_822084438.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084438, uri, valid, content)

proc call*(call_822084439: Call_CreateTranscription_822084406; file: string;
           model: string; temperature: float = 0.0;
           chunkingStrategy: string = "";
           timestampGranularities: JsonNode = nil;
           responseFormat: string = "json"; prompt: string = "";
           language: string = ""; stream: bool = false;
           `include`: JsonNode = nil): Recallable =
  ## createTranscription
  ##   file: string (required)
  ##       : The audio file object (not file name) to transcribe, in one of these formats: flac, mp3, mp4, mpeg, mpga, m4a, ogg, wav, or webm.
  ## 
  ##   temperature: float
  ##              : The sampling temperature, between 0 and 1. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. If set to 0, the model will use [log probability](https://en.wikipedia.org/wiki/Log_probability) to automatically increase the temperature until certain thresholds are hit.
  ## 
  ##   chunkingStrategy: string
  ##                   : Controls how the audio is cut into chunks. When set to `"auto"`, the server first normalizes loudness and then uses voice activity detection (VAD) to choose boundaries. `server_vad` object can be provided to tweak VAD detection parameters manually. If unset, the audio is transcribed as a single block. 
  ##   timestampGranularities: JArray
  ##                         : The timestamp granularities to populate for this transcription. `response_format` must be set `verbose_json` to use timestamp granularities. Either or both of these options are supported: `word`, or `segment`. Note: There is no additional latency for segment timestamps, but generating word timestamps incurs additional latency.
  ## 
  ##   responseFormat: string
  ##                 : The format of the output, in one of these options: `json`, `text`, `srt`, `verbose_json`, or `vtt`. For `gpt-4o-transcribe` and `gpt-4o-mini-transcribe`, the only supported format is `json`.
  ## 
  ##   model: string (required)
  ##        : ID of the model to use. The options are `gpt-4o-transcribe`, `gpt-4o-mini-transcribe`, and `whisper-1` (which is powered by our open source Whisper V2 model).
  ## 
  ##   prompt: string
  ##         : An optional text to guide the model's style or continue a previous audio segment. The [prompt](/docs/guides/speech-to-text#prompting) should match the audio language.
  ## 
  ##   language: string
  ##           : The language of the input audio. Supplying the input language in [ISO-639-1](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes) (e.g. `en`) format will improve accuracy and latency.
  ## 
  ##   stream: bool
  ##         : If set to true, the model response data will be streamed to the client
  ## as it is generated using [server-sent 
  ## events](https://developer.mozilla.org/en-US/docs/Web/API/Server-sent_events/Using_server-sent_events#Event_stream_format). 
  ## See the [Streaming section of the Speech-to-Text guide](/docs/guides/speech-to-text?lang=curl#streaming-transcriptions)
  ## for more information.
  ## 
  ## Note: Streaming is not supported for the `whisper-1` model and will be ignored.
  ## 
  ##   include: JArray
  ##          : Additional information to include in the transcription response. 
  ## `logprobs` will return the log probabilities of the tokens in the 
  ## response to understand the model's confidence in the transcription. 
  ## `logprobs` only works with response_format set to `json` and only with 
  ## the models `gpt-4o-transcribe` and `gpt-4o-mini-transcribe`.
  ## 
  var formData_822084440 = newJObject()
  add(formData_822084440, "file", newJString(file))
  add(formData_822084440, "temperature", newJFloat(temperature))
  add(formData_822084440, "chunking_strategy", newJString(chunkingStrategy))
  if timestampGranularities != nil:
    formData_822084440.add "timestamp_granularities[]", timestampGranularities
  add(formData_822084440, "response_format", newJString(responseFormat))
  add(formData_822084440, "model", newJString(model))
  add(formData_822084440, "prompt", newJString(prompt))
  add(formData_822084440, "language", newJString(language))
  add(formData_822084440, "stream", newJBool(stream))
  if `include` != nil:
    formData_822084440.add "include[]", `include`
  result = call_822084439.call(nil, nil, nil, formData_822084440, nil)

var createTranscription* = Call_CreateTranscription_822084406(
    name: "createTranscription", meth: HttpMethod.HttpPost,
    host: "api.openai.com", route: "/audio/transcriptions",
    validator: validate_CreateTranscription_822084407, base: "/v1",
    makeUrl: url_CreateTranscription_822084408, schemes: {Scheme.Https})
type
  Call_CreateTranslation_822084441 = ref object of OpenApiRestCall_822083995
proc url_CreateTranslation_822084443(protocol: Scheme; host: string;
                                     base: string; route: string;
                                     path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CreateTranslation_822084442(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  ## parameters in `formData` object:
  ##   file: JString (required)
  ##       : The audio file object (not file name) translate, in one of these formats: flac, mp3, mp4, mpeg, mpga, m4a, ogg, wav, or webm.
  ## 
  ##   temperature: JFloat
  ##              : The sampling temperature, between 0 and 1. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. If set to 0, the model will use [log probability](https://en.wikipedia.org/wiki/Log_probability) to automatically increase the temperature until certain thresholds are hit.
  ## 
  ##   response_format: JString
  ##                  : The format of the output, in one of these options: `json`, `text`, `srt`, `verbose_json`, or `vtt`.
  ## 
  ##   model: JString (required)
  ##        : ID of the model to use. Only `whisper-1` (which is powered by our open source Whisper V2 model) is currently available.
  ## 
  ##   prompt: JString
  ##         : An optional text to guide the model's style or continue a previous audio segment. The [prompt](/docs/guides/speech-to-text#prompting) should be in English.
  ## 
  section = newJObject()
  assert formData != nil,
         "formData argument is necessary due to required `file` field"
  var valid_822084444 = formData.getOrDefault("file")
  valid_822084444 = validateParameter(valid_822084444, JString, required = true,
                                      default = nil)
  if valid_822084444 != nil:
    section.add "file", valid_822084444
  var valid_822084445 = formData.getOrDefault("temperature")
  valid_822084445 = validateParameter(valid_822084445, JFloat, required = false,
                                      default = nil)
  if valid_822084445 != nil:
    section.add "temperature", valid_822084445
  var valid_822084446 = formData.getOrDefault("response_format")
  valid_822084446 = validateParameter(valid_822084446, JString,
                                      required = false,
                                      default = newJString("json"))
  if valid_822084446 != nil:
    section.add "response_format", valid_822084446
  var valid_822084447 = formData.getOrDefault("model")
  valid_822084447 = validateParameter(valid_822084447, JString, required = true,
                                      default = nil)
  if valid_822084447 != nil:
    section.add "model", valid_822084447
  var valid_822084448 = formData.getOrDefault("prompt")
  valid_822084448 = validateParameter(valid_822084448, JString,
                                      required = false, default = nil)
  if valid_822084448 != nil:
    section.add "prompt", valid_822084448
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084449: Call_CreateTranslation_822084441;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
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

proc call*(call_822084450: Call_CreateTranslation_822084441; file: string;
           model: string; temperature: float = 0.0;
           responseFormat: string = "json"; prompt: string = ""): Recallable =
  ## createTranslation
  ##   file: string (required)
  ##       : The audio file object (not file name) translate, in one of these formats: flac, mp3, mp4, mpeg, mpga, m4a, ogg, wav, or webm.
  ## 
  ##   temperature: float
  ##              : The sampling temperature, between 0 and 1. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. If set to 0, the model will use [log probability](https://en.wikipedia.org/wiki/Log_probability) to automatically increase the temperature until certain thresholds are hit.
  ## 
  ##   responseFormat: string
  ##                 : The format of the output, in one of these options: `json`, `text`, `srt`, `verbose_json`, or `vtt`.
  ## 
  ##   model: string (required)
  ##        : ID of the model to use. Only `whisper-1` (which is powered by our open source Whisper V2 model) is currently available.
  ## 
  ##   prompt: string
  ##         : An optional text to guide the model's style or continue a previous audio segment. The [prompt](/docs/guides/speech-to-text#prompting) should be in English.
  ## 
  var formData_822084451 = newJObject()
  add(formData_822084451, "file", newJString(file))
  add(formData_822084451, "temperature", newJFloat(temperature))
  add(formData_822084451, "response_format", newJString(responseFormat))
  add(formData_822084451, "model", newJString(model))
  add(formData_822084451, "prompt", newJString(prompt))
  result = call_822084450.call(nil, nil, nil, formData_822084451, nil)

var createTranslation* = Call_CreateTranslation_822084441(
    name: "createTranslation", meth: HttpMethod.HttpPost,
    host: "api.openai.com", route: "/audio/translations",
    validator: validate_CreateTranslation_822084442, base: "/v1",
    makeUrl: url_CreateTranslation_822084443, schemes: {Scheme.Https})
type
  Call_CreateBatch_822084460 = ref object of OpenApiRestCall_822083995
proc url_CreateBatch_822084462(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CreateBatch_822084461(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  if `==`(content, ""): assert body != nil, "body argument is necessary"
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822084464: Call_CreateBatch_822084460; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084464.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084464.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084464.makeUrl(scheme.get, call_822084464.host, call_822084464.base,
                                   call_822084464.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084464, uri, valid, content)

proc call*(call_822084465: Call_CreateBatch_822084460; body: JsonNode): Recallable =
  ## createBatch
  ##   body: JObject (required)
  var body_822084466 = newJObject()
  if body != nil:
    body_822084466 = body
  result = call_822084465.call(nil, nil, nil, nil, body_822084466)

var createBatch* = Call_CreateBatch_822084460(name: "createBatch",
    meth: HttpMethod.HttpPost, host: "api.openai.com", route: "/batches",
    validator: validate_CreateBatch_822084461, base: "/v1",
    makeUrl: url_CreateBatch_822084462, schemes: {Scheme.Https})
type
  Call_ListBatches_822084452 = ref object of OpenApiRestCall_822083995
proc url_ListBatches_822084454(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_ListBatches_822084453(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   after: JString
  ##        : A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
  ## 
  ##   limit: JInt
  ##        : A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.
  ## 
  section = newJObject()
  var valid_822084455 = query.getOrDefault("after")
  valid_822084455 = validateParameter(valid_822084455, JString,
                                      required = false, default = nil)
  if valid_822084455 != nil:
    section.add "after", valid_822084455
  var valid_822084456 = query.getOrDefault("limit")
  valid_822084456 = validateParameter(valid_822084456, JInt, required = false,
                                      default = newJInt(20))
  if valid_822084456 != nil:
    section.add "limit", valid_822084456
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084457: Call_ListBatches_822084452; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084457.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084457.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084457.makeUrl(scheme.get, call_822084457.host, call_822084457.base,
                                   call_822084457.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084457, uri, valid, content)

proc call*(call_822084458: Call_ListBatches_822084452; after: string = "";
           limit: int = 20): Recallable =
  ## listBatches
  ##   after: string
  ##        : A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
  ## 
  ##   limit: int
  ##        : A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.
  ## 
  var query_822084459 = newJObject()
  add(query_822084459, "after", newJString(after))
  add(query_822084459, "limit", newJInt(limit))
  result = call_822084458.call(nil, query_822084459, nil, nil, nil)

var listBatches* = Call_ListBatches_822084452(name: "listBatches",
    meth: HttpMethod.HttpGet, host: "api.openai.com", route: "/batches",
    validator: validate_ListBatches_822084453, base: "/v1",
    makeUrl: url_ListBatches_822084454, schemes: {Scheme.Https})
type
  Call_RetrieveBatch_822084467 = ref object of OpenApiRestCall_822083995
proc url_RetrieveBatch_822084469(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "batch_id" in path, "`batch_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/batches/"),
                 (kind: VariableSegment, value: "batch_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RetrieveBatch_822084468(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   batch_id: JString (required)
  ##           : The ID of the batch to retrieve.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `batch_id` field"
  var valid_822084470 = path.getOrDefault("batch_id")
  valid_822084470 = validateParameter(valid_822084470, JString, required = true,
                                      default = nil)
  if valid_822084470 != nil:
    section.add "batch_id", valid_822084470
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084471: Call_RetrieveBatch_822084467; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084471.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084471.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084471.makeUrl(scheme.get, call_822084471.host, call_822084471.base,
                                   call_822084471.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084471, uri, valid, content)

proc call*(call_822084472: Call_RetrieveBatch_822084467; batchId: string): Recallable =
  ## retrieveBatch
  ##   batchId: string (required)
  ##          : The ID of the batch to retrieve.
  var path_822084473 = newJObject()
  add(path_822084473, "batch_id", newJString(batchId))
  result = call_822084472.call(path_822084473, nil, nil, nil, nil)

var retrieveBatch* = Call_RetrieveBatch_822084467(name: "retrieveBatch",
    meth: HttpMethod.HttpGet, host: "api.openai.com",
    route: "/batches/{batch_id}", validator: validate_RetrieveBatch_822084468,
    base: "/v1", makeUrl: url_RetrieveBatch_822084469, schemes: {Scheme.Https})
type
  Call_CancelBatch_822084474 = ref object of OpenApiRestCall_822083995
proc url_CancelBatch_822084476(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "batch_id" in path, "`batch_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/batches/"),
                 (kind: VariableSegment, value: "batch_id"),
                 (kind: ConstantSegment, value: "/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CancelBatch_822084475(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   batch_id: JString (required)
  ##           : The ID of the batch to cancel.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `batch_id` field"
  var valid_822084477 = path.getOrDefault("batch_id")
  valid_822084477 = validateParameter(valid_822084477, JString, required = true,
                                      default = nil)
  if valid_822084477 != nil:
    section.add "batch_id", valid_822084477
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084478: Call_CancelBatch_822084474; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084478.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084478.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084478.makeUrl(scheme.get, call_822084478.host, call_822084478.base,
                                   call_822084478.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084478, uri, valid, content)

proc call*(call_822084479: Call_CancelBatch_822084474; batchId: string): Recallable =
  ## cancelBatch
  ##   batchId: string (required)
  ##          : The ID of the batch to cancel.
  var path_822084480 = newJObject()
  add(path_822084480, "batch_id", newJString(batchId))
  result = call_822084479.call(path_822084480, nil, nil, nil, nil)

var cancelBatch* = Call_CancelBatch_822084474(name: "cancelBatch",
    meth: HttpMethod.HttpPost, host: "api.openai.com",
    route: "/batches/{batch_id}/cancel", validator: validate_CancelBatch_822084475,
    base: "/v1", makeUrl: url_CancelBatch_822084476, schemes: {Scheme.Https})
type
  Call_CreateChatCompletion_822084492 = ref object of OpenApiRestCall_822083995
proc url_CreateChatCompletion_822084494(protocol: Scheme; host: string;
                                        base: string; route: string;
                                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CreateChatCompletion_822084493(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  if `==`(content, ""): assert body != nil, "body argument is necessary"
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822084496: Call_CreateChatCompletion_822084492;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084496.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084496.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084496.makeUrl(scheme.get, call_822084496.host, call_822084496.base,
                                   call_822084496.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084496, uri, valid, content)

proc call*(call_822084497: Call_CreateChatCompletion_822084492; body: JsonNode): Recallable =
  ## createChatCompletion
  ##   body: JObject (required)
  var body_822084498 = newJObject()
  if body != nil:
    body_822084498 = body
  result = call_822084497.call(nil, nil, nil, nil, body_822084498)

var createChatCompletion* = Call_CreateChatCompletion_822084492(
    name: "createChatCompletion", meth: HttpMethod.HttpPost,
    host: "api.openai.com", route: "/chat/completions",
    validator: validate_CreateChatCompletion_822084493, base: "/v1",
    makeUrl: url_CreateChatCompletion_822084494, schemes: {Scheme.Https})
type
  Call_ListChatCompletions_822084481 = ref object of OpenApiRestCall_822083995
proc url_ListChatCompletions_822084483(protocol: Scheme; host: string;
                                       base: string; route: string;
                                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_ListChatCompletions_822084482(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   after: JString
  ##        : Identifier for the last chat completion from the previous pagination request.
  ##   metadata: JObject
  ##           : A list of metadata keys to filter the Chat Completions by. Example:
  ## 
  ## `metadata[key1]=value1&metadata[key2]=value2`
  ## 
  ##   order: JString
  ##        : Sort order for Chat Completions by timestamp. Use `asc` for ascending order or `desc` for descending order. Defaults to `asc`.
  ##   model: JString
  ##        : The model used to generate the Chat Completions.
  ##   limit: JInt
  ##        : Number of Chat Completions to retrieve.
  section = newJObject()
  var valid_822084484 = query.getOrDefault("after")
  valid_822084484 = validateParameter(valid_822084484, JString,
                                      required = false, default = nil)
  if valid_822084484 != nil:
    section.add "after", valid_822084484
  var valid_822084485 = query.getOrDefault("metadata")
  valid_822084485 = validateParameter(valid_822084485, JObject,
                                      required = false, default = nil)
  if valid_822084485 != nil:
    section.add "metadata", valid_822084485
  var valid_822084486 = query.getOrDefault("order")
  valid_822084486 = validateParameter(valid_822084486, JString,
                                      required = false,
                                      default = newJString("asc"))
  if valid_822084486 != nil:
    section.add "order", valid_822084486
  var valid_822084487 = query.getOrDefault("model")
  valid_822084487 = validateParameter(valid_822084487, JString,
                                      required = false, default = nil)
  if valid_822084487 != nil:
    section.add "model", valid_822084487
  var valid_822084488 = query.getOrDefault("limit")
  valid_822084488 = validateParameter(valid_822084488, JInt, required = false,
                                      default = newJInt(20))
  if valid_822084488 != nil:
    section.add "limit", valid_822084488
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084489: Call_ListChatCompletions_822084481;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084489.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084489.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084489.makeUrl(scheme.get, call_822084489.host, call_822084489.base,
                                   call_822084489.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084489, uri, valid, content)

proc call*(call_822084490: Call_ListChatCompletions_822084481;
           after: string = ""; metadata: JsonNode = nil; order: string = "asc";
           model: string = ""; limit: int = 20): Recallable =
  ## listChatCompletions
  ##   after: string
  ##        : Identifier for the last chat completion from the previous pagination request.
  ##   metadata: JObject
  ##           : A list of metadata keys to filter the Chat Completions by. Example:
  ## 
  ## `metadata[key1]=value1&metadata[key2]=value2`
  ## 
  ##   order: string
  ##        : Sort order for Chat Completions by timestamp. Use `asc` for ascending order or `desc` for descending order. Defaults to `asc`.
  ##   model: string
  ##        : The model used to generate the Chat Completions.
  ##   limit: int
  ##        : Number of Chat Completions to retrieve.
  var query_822084491 = newJObject()
  add(query_822084491, "after", newJString(after))
  if metadata != nil:
    query_822084491.add "metadata", metadata
  add(query_822084491, "order", newJString(order))
  add(query_822084491, "model", newJString(model))
  add(query_822084491, "limit", newJInt(limit))
  result = call_822084490.call(nil, query_822084491, nil, nil, nil)

var listChatCompletions* = Call_ListChatCompletions_822084481(
    name: "listChatCompletions", meth: HttpMethod.HttpGet,
    host: "api.openai.com", route: "/chat/completions",
    validator: validate_ListChatCompletions_822084482, base: "/v1",
    makeUrl: url_ListChatCompletions_822084483, schemes: {Scheme.Https})
type
  Call_DeleteChatCompletion_822084515 = ref object of OpenApiRestCall_822083995
proc url_DeleteChatCompletion_822084517(protocol: Scheme; host: string;
                                        base: string; route: string;
                                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "completion_id" in path, "`completion_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/chat/completions/"),
                 (kind: VariableSegment, value: "completion_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DeleteChatCompletion_822084516(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   completion_id: JString (required)
  ##                : The ID of the chat completion to delete.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `completion_id` field"
  var valid_822084518 = path.getOrDefault("completion_id")
  valid_822084518 = validateParameter(valid_822084518, JString, required = true,
                                      default = nil)
  if valid_822084518 != nil:
    section.add "completion_id", valid_822084518
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084519: Call_DeleteChatCompletion_822084515;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084519.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084519.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084519.makeUrl(scheme.get, call_822084519.host, call_822084519.base,
                                   call_822084519.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084519, uri, valid, content)

proc call*(call_822084520: Call_DeleteChatCompletion_822084515;
           completionId: string): Recallable =
  ## deleteChatCompletion
  ##   completionId: string (required)
  ##               : The ID of the chat completion to delete.
  var path_822084521 = newJObject()
  add(path_822084521, "completion_id", newJString(completionId))
  result = call_822084520.call(path_822084521, nil, nil, nil, nil)

var deleteChatCompletion* = Call_DeleteChatCompletion_822084515(
    name: "deleteChatCompletion", meth: HttpMethod.HttpDelete,
    host: "api.openai.com", route: "/chat/completions/{completion_id}",
    validator: validate_DeleteChatCompletion_822084516, base: "/v1",
    makeUrl: url_DeleteChatCompletion_822084517, schemes: {Scheme.Https})
type
  Call_UpdateChatCompletion_822084506 = ref object of OpenApiRestCall_822083995
proc url_UpdateChatCompletion_822084508(protocol: Scheme; host: string;
                                        base: string; route: string;
                                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "completion_id" in path, "`completion_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/chat/completions/"),
                 (kind: VariableSegment, value: "completion_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_UpdateChatCompletion_822084507(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   completion_id: JString (required)
  ##                : The ID of the chat completion to update.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `completion_id` field"
  var valid_822084509 = path.getOrDefault("completion_id")
  valid_822084509 = validateParameter(valid_822084509, JString, required = true,
                                      default = nil)
  if valid_822084509 != nil:
    section.add "completion_id", valid_822084509
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  if `==`(content, ""): assert body != nil, "body argument is necessary"
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822084511: Call_UpdateChatCompletion_822084506;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084511.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084511.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084511.makeUrl(scheme.get, call_822084511.host, call_822084511.base,
                                   call_822084511.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084511, uri, valid, content)

proc call*(call_822084512: Call_UpdateChatCompletion_822084506;
           completionId: string; body: JsonNode): Recallable =
  ## updateChatCompletion
  ##   completionId: string (required)
  ##               : The ID of the chat completion to update.
  ##   body: JObject (required)
  var path_822084513 = newJObject()
  var body_822084514 = newJObject()
  add(path_822084513, "completion_id", newJString(completionId))
  if body != nil:
    body_822084514 = body
  result = call_822084512.call(path_822084513, nil, nil, nil, body_822084514)

var updateChatCompletion* = Call_UpdateChatCompletion_822084506(
    name: "updateChatCompletion", meth: HttpMethod.HttpPost,
    host: "api.openai.com", route: "/chat/completions/{completion_id}",
    validator: validate_UpdateChatCompletion_822084507, base: "/v1",
    makeUrl: url_UpdateChatCompletion_822084508, schemes: {Scheme.Https})
type
  Call_GetChatCompletion_822084499 = ref object of OpenApiRestCall_822083995
proc url_GetChatCompletion_822084501(protocol: Scheme; host: string;
                                     base: string; route: string;
                                     path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "completion_id" in path, "`completion_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/chat/completions/"),
                 (kind: VariableSegment, value: "completion_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GetChatCompletion_822084500(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   completion_id: JString (required)
  ##                : The ID of the chat completion to retrieve.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `completion_id` field"
  var valid_822084502 = path.getOrDefault("completion_id")
  valid_822084502 = validateParameter(valid_822084502, JString, required = true,
                                      default = nil)
  if valid_822084502 != nil:
    section.add "completion_id", valid_822084502
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084503: Call_GetChatCompletion_822084499;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084503.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084503.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084503.makeUrl(scheme.get, call_822084503.host, call_822084503.base,
                                   call_822084503.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084503, uri, valid, content)

proc call*(call_822084504: Call_GetChatCompletion_822084499;
           completionId: string): Recallable =
  ## getChatCompletion
  ##   completionId: string (required)
  ##               : The ID of the chat completion to retrieve.
  var path_822084505 = newJObject()
  add(path_822084505, "completion_id", newJString(completionId))
  result = call_822084504.call(path_822084505, nil, nil, nil, nil)

var getChatCompletion* = Call_GetChatCompletion_822084499(
    name: "getChatCompletion", meth: HttpMethod.HttpGet, host: "api.openai.com",
    route: "/chat/completions/{completion_id}",
    validator: validate_GetChatCompletion_822084500, base: "/v1",
    makeUrl: url_GetChatCompletion_822084501, schemes: {Scheme.Https})
type
  Call_GetChatCompletionMessages_822084522 = ref object of OpenApiRestCall_822083995
proc url_GetChatCompletionMessages_822084524(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "completion_id" in path, "`completion_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/chat/completions/"),
                 (kind: VariableSegment, value: "completion_id"),
                 (kind: ConstantSegment, value: "/messages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GetChatCompletionMessages_822084523(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode;
    content: string = ""): JsonNode {.nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   completion_id: JString (required)
  ##                : The ID of the chat completion to retrieve messages from.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `completion_id` field"
  var valid_822084525 = path.getOrDefault("completion_id")
  valid_822084525 = validateParameter(valid_822084525, JString, required = true,
                                      default = nil)
  if valid_822084525 != nil:
    section.add "completion_id", valid_822084525
  result.add "path", section
  ## parameters in `query` object:
  ##   after: JString
  ##        : Identifier for the last message from the previous pagination request.
  ##   order: JString
  ##        : Sort order for messages by timestamp. Use `asc` for ascending order or `desc` for descending order. Defaults to `asc`.
  ##   limit: JInt
  ##        : Number of messages to retrieve.
  section = newJObject()
  var valid_822084526 = query.getOrDefault("after")
  valid_822084526 = validateParameter(valid_822084526, JString,
                                      required = false, default = nil)
  if valid_822084526 != nil:
    section.add "after", valid_822084526
  var valid_822084527 = query.getOrDefault("order")
  valid_822084527 = validateParameter(valid_822084527, JString,
                                      required = false,
                                      default = newJString("asc"))
  if valid_822084527 != nil:
    section.add "order", valid_822084527
  var valid_822084528 = query.getOrDefault("limit")
  valid_822084528 = validateParameter(valid_822084528, JInt, required = false,
                                      default = newJInt(20))
  if valid_822084528 != nil:
    section.add "limit", valid_822084528
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084529: Call_GetChatCompletionMessages_822084522;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084529.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084529.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084529.makeUrl(scheme.get, call_822084529.host, call_822084529.base,
                                   call_822084529.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084529, uri, valid, content)

proc call*(call_822084530: Call_GetChatCompletionMessages_822084522;
           completionId: string; after: string = ""; order: string = "asc";
           limit: int = 20): Recallable =
  ## getChatCompletionMessages
  ##   after: string
  ##        : Identifier for the last message from the previous pagination request.
  ##   completionId: string (required)
  ##               : The ID of the chat completion to retrieve messages from.
  ##   order: string
  ##        : Sort order for messages by timestamp. Use `asc` for ascending order or `desc` for descending order. Defaults to `asc`.
  ##   limit: int
  ##        : Number of messages to retrieve.
  var path_822084531 = newJObject()
  var query_822084532 = newJObject()
  add(query_822084532, "after", newJString(after))
  add(path_822084531, "completion_id", newJString(completionId))
  add(query_822084532, "order", newJString(order))
  add(query_822084532, "limit", newJInt(limit))
  result = call_822084530.call(path_822084531, query_822084532, nil, nil, nil)

var getChatCompletionMessages* = Call_GetChatCompletionMessages_822084522(
    name: "getChatCompletionMessages", meth: HttpMethod.HttpGet,
    host: "api.openai.com", route: "/chat/completions/{completion_id}/messages",
    validator: validate_GetChatCompletionMessages_822084523, base: "/v1",
    makeUrl: url_GetChatCompletionMessages_822084524, schemes: {Scheme.Https})
type
  Call_CreateCompletion_822084533 = ref object of OpenApiRestCall_822083995
proc url_CreateCompletion_822084535(protocol: Scheme; host: string;
                                    base: string; route: string; path: JsonNode;
                                    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CreateCompletion_822084534(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  if `==`(content, ""): assert body != nil, "body argument is necessary"
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822084537: Call_CreateCompletion_822084533;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084537.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084537.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084537.makeUrl(scheme.get, call_822084537.host, call_822084537.base,
                                   call_822084537.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084537, uri, valid, content)

proc call*(call_822084538: Call_CreateCompletion_822084533; body: JsonNode): Recallable =
  ## createCompletion
  ##   body: JObject (required)
  var body_822084539 = newJObject()
  if body != nil:
    body_822084539 = body
  result = call_822084538.call(nil, nil, nil, nil, body_822084539)

var createCompletion* = Call_CreateCompletion_822084533(
    name: "createCompletion", meth: HttpMethod.HttpPost, host: "api.openai.com",
    route: "/completions", validator: validate_CreateCompletion_822084534,
    base: "/v1", makeUrl: url_CreateCompletion_822084535,
    schemes: {Scheme.Https})
type
  Call_CreateContainer_822084549 = ref object of OpenApiRestCall_822083995
proc url_CreateContainer_822084551(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode;
                                   query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CreateContainer_822084550(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Creates a container.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822084553: Call_CreateContainer_822084549; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Creates a container.
  ## 
  let valid = call_822084553.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084553.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084553.makeUrl(scheme.get, call_822084553.host, call_822084553.base,
                                   call_822084553.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084553, uri, valid, content)

proc call*(call_822084554: Call_CreateContainer_822084549; body: JsonNode = nil): Recallable =
  ## createContainer
  ## Creates a container.
  ##   body: JObject
  var body_822084555 = newJObject()
  if body != nil:
    body_822084555 = body
  result = call_822084554.call(nil, nil, nil, nil, body_822084555)

var createContainer* = Call_CreateContainer_822084549(name: "createContainer",
    meth: HttpMethod.HttpPost, host: "api.openai.com", route: "/containers",
    validator: validate_CreateContainer_822084550, base: "/v1",
    makeUrl: url_CreateContainer_822084551, schemes: {Scheme.Https})
type
  Call_ListContainers_822084540 = ref object of OpenApiRestCall_822083995
proc url_ListContainers_822084542(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_ListContainers_822084541(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Lists containers.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   after: JString
  ##        : A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
  ## 
  ##   order: JString
  ##        : Sort order by the `created_at` timestamp of the objects. `asc` for ascending order and `desc` for descending order.
  ## 
  ##   limit: JInt
  ##        : A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.
  ## 
  section = newJObject()
  var valid_822084543 = query.getOrDefault("after")
  valid_822084543 = validateParameter(valid_822084543, JString,
                                      required = false, default = nil)
  if valid_822084543 != nil:
    section.add "after", valid_822084543
  var valid_822084544 = query.getOrDefault("order")
  valid_822084544 = validateParameter(valid_822084544, JString,
                                      required = false,
                                      default = newJString("desc"))
  if valid_822084544 != nil:
    section.add "order", valid_822084544
  var valid_822084545 = query.getOrDefault("limit")
  valid_822084545 = validateParameter(valid_822084545, JInt, required = false,
                                      default = newJInt(20))
  if valid_822084545 != nil:
    section.add "limit", valid_822084545
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084546: Call_ListContainers_822084540; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Lists containers.
  ## 
  let valid = call_822084546.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084546.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084546.makeUrl(scheme.get, call_822084546.host, call_822084546.base,
                                   call_822084546.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084546, uri, valid, content)

proc call*(call_822084547: Call_ListContainers_822084540; after: string = "";
           order: string = "desc"; limit: int = 20): Recallable =
  ## listContainers
  ## Lists containers.
  ##   after: string
  ##        : A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
  ## 
  ##   order: string
  ##        : Sort order by the `created_at` timestamp of the objects. `asc` for ascending order and `desc` for descending order.
  ## 
  ##   limit: int
  ##        : A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.
  ## 
  var query_822084548 = newJObject()
  add(query_822084548, "after", newJString(after))
  add(query_822084548, "order", newJString(order))
  add(query_822084548, "limit", newJInt(limit))
  result = call_822084547.call(nil, query_822084548, nil, nil, nil)

var listContainers* = Call_ListContainers_822084540(name: "listContainers",
    meth: HttpMethod.HttpGet, host: "api.openai.com", route: "/containers",
    validator: validate_ListContainers_822084541, base: "/v1",
    makeUrl: url_ListContainers_822084542, schemes: {Scheme.Https})
type
  Call_DeleteContainer_822084563 = ref object of OpenApiRestCall_822083995
proc url_DeleteContainer_822084565(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode;
                                   query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "container_id" in path, "`container_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/containers/"),
                 (kind: VariableSegment, value: "container_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DeleteContainer_822084564(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Delete a container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   container_id: JString (required)
  ##               : The ID of the container to delete.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `container_id` field"
  var valid_822084566 = path.getOrDefault("container_id")
  valid_822084566 = validateParameter(valid_822084566, JString, required = true,
                                      default = nil)
  if valid_822084566 != nil:
    section.add "container_id", valid_822084566
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084567: Call_DeleteContainer_822084563; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Delete a container.
  ## 
  let valid = call_822084567.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084567.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084567.makeUrl(scheme.get, call_822084567.host, call_822084567.base,
                                   call_822084567.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084567, uri, valid, content)

proc call*(call_822084568: Call_DeleteContainer_822084563; containerId: string): Recallable =
  ## deleteContainer
  ## Delete a container.
  ##   containerId: string (required)
  ##              : The ID of the container to delete.
  var path_822084569 = newJObject()
  add(path_822084569, "container_id", newJString(containerId))
  result = call_822084568.call(path_822084569, nil, nil, nil, nil)

var deleteContainer* = Call_DeleteContainer_822084563(name: "deleteContainer",
    meth: HttpMethod.HttpDelete, host: "api.openai.com",
    route: "/containers/{container_id}", validator: validate_DeleteContainer_822084564,
    base: "/v1", makeUrl: url_DeleteContainer_822084565, schemes: {Scheme.Https})
type
  Call_RetrieveContainer_822084556 = ref object of OpenApiRestCall_822083995
proc url_RetrieveContainer_822084558(protocol: Scheme; host: string;
                                     base: string; route: string;
                                     path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "container_id" in path, "`container_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/containers/"),
                 (kind: VariableSegment, value: "container_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RetrieveContainer_822084557(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Retrieves a container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   container_id: JString (required)
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `container_id` field"
  var valid_822084559 = path.getOrDefault("container_id")
  valid_822084559 = validateParameter(valid_822084559, JString, required = true,
                                      default = nil)
  if valid_822084559 != nil:
    section.add "container_id", valid_822084559
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084560: Call_RetrieveContainer_822084556;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Retrieves a container.
  ## 
  let valid = call_822084560.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084560.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084560.makeUrl(scheme.get, call_822084560.host, call_822084560.base,
                                   call_822084560.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084560, uri, valid, content)

proc call*(call_822084561: Call_RetrieveContainer_822084556; containerId: string): Recallable =
  ## retrieveContainer
  ## Retrieves a container.
  ##   containerId: string (required)
  var path_822084562 = newJObject()
  add(path_822084562, "container_id", newJString(containerId))
  result = call_822084561.call(path_822084562, nil, nil, nil, nil)

var retrieveContainer* = Call_RetrieveContainer_822084556(
    name: "retrieveContainer", meth: HttpMethod.HttpGet, host: "api.openai.com",
    route: "/containers/{container_id}", validator: validate_RetrieveContainer_822084557,
    base: "/v1", makeUrl: url_RetrieveContainer_822084558,
    schemes: {Scheme.Https})
type
  Call_CreateContainerFile_822084581 = ref object of OpenApiRestCall_822083995
proc url_CreateContainerFile_822084583(protocol: Scheme; host: string;
                                       base: string; route: string;
                                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "container_id" in path, "`container_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/containers/"),
                 (kind: VariableSegment, value: "container_id"),
                 (kind: ConstantSegment, value: "/files")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CreateContainerFile_822084582(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Creates a container file.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   container_id: JString (required)
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `container_id` field"
  var valid_822084584 = path.getOrDefault("container_id")
  valid_822084584 = validateParameter(valid_822084584, JString, required = true,
                                      default = nil)
  if valid_822084584 != nil:
    section.add "container_id", valid_822084584
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  ## parameters in `formData` object:
  ##   file: JString
  ##       : The File object (not file name) to be uploaded.
  ## 
  ##   file_id: JString
  ##          : Name of the file to create.
  section = newJObject()
  var valid_822084585 = formData.getOrDefault("file")
  valid_822084585 = validateParameter(valid_822084585, JString,
                                      required = false, default = nil)
  if valid_822084585 != nil:
    section.add "file", valid_822084585
  var valid_822084586 = formData.getOrDefault("file_id")
  valid_822084586 = validateParameter(valid_822084586, JString,
                                      required = false, default = nil)
  if valid_822084586 != nil:
    section.add "file_id", valid_822084586
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084587: Call_CreateContainerFile_822084581;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Creates a container file.
  ## 
  ## 
  let valid = call_822084587.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084587.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084587.makeUrl(scheme.get, call_822084587.host, call_822084587.base,
                                   call_822084587.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084587, uri, valid, content)

proc call*(call_822084588: Call_CreateContainerFile_822084581;
           containerId: string; file: string = ""; fileId: string = ""): Recallable =
  ## createContainerFile
  ## Creates a container file.
  ## 
  ##   file: string
  ##       : The File object (not file name) to be uploaded.
  ## 
  ##   containerId: string (required)
  ##   fileId: string
  ##         : Name of the file to create.
  var path_822084589 = newJObject()
  var formData_822084590 = newJObject()
  add(formData_822084590, "file", newJString(file))
  add(path_822084589, "container_id", newJString(containerId))
  add(formData_822084590, "file_id", newJString(fileId))
  result = call_822084588.call(path_822084589, nil, nil, formData_822084590, nil)

var createContainerFile* = Call_CreateContainerFile_822084581(
    name: "createContainerFile", meth: HttpMethod.HttpPost,
    host: "api.openai.com", route: "/containers/{container_id}/files",
    validator: validate_CreateContainerFile_822084582, base: "/v1",
    makeUrl: url_CreateContainerFile_822084583, schemes: {Scheme.Https})
type
  Call_ListContainerFiles_822084570 = ref object of OpenApiRestCall_822083995
proc url_ListContainerFiles_822084572(protocol: Scheme; host: string;
                                      base: string; route: string;
                                      path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "container_id" in path, "`container_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/containers/"),
                 (kind: VariableSegment, value: "container_id"),
                 (kind: ConstantSegment, value: "/files")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ListContainerFiles_822084571(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Lists container files.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   container_id: JString (required)
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `container_id` field"
  var valid_822084573 = path.getOrDefault("container_id")
  valid_822084573 = validateParameter(valid_822084573, JString, required = true,
                                      default = nil)
  if valid_822084573 != nil:
    section.add "container_id", valid_822084573
  result.add "path", section
  ## parameters in `query` object:
  ##   after: JString
  ##        : A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
  ## 
  ##   order: JString
  ##        : Sort order by the `created_at` timestamp of the objects. `asc` for ascending order and `desc` for descending order.
  ## 
  ##   limit: JInt
  ##        : A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.
  ## 
  section = newJObject()
  var valid_822084574 = query.getOrDefault("after")
  valid_822084574 = validateParameter(valid_822084574, JString,
                                      required = false, default = nil)
  if valid_822084574 != nil:
    section.add "after", valid_822084574
  var valid_822084575 = query.getOrDefault("order")
  valid_822084575 = validateParameter(valid_822084575, JString,
                                      required = false,
                                      default = newJString("desc"))
  if valid_822084575 != nil:
    section.add "order", valid_822084575
  var valid_822084576 = query.getOrDefault("limit")
  valid_822084576 = validateParameter(valid_822084576, JInt, required = false,
                                      default = newJInt(20))
  if valid_822084576 != nil:
    section.add "limit", valid_822084576
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084577: Call_ListContainerFiles_822084570;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Lists container files.
  ## 
  let valid = call_822084577.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084577.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084577.makeUrl(scheme.get, call_822084577.host, call_822084577.base,
                                   call_822084577.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084577, uri, valid, content)

proc call*(call_822084578: Call_ListContainerFiles_822084570;
           containerId: string; after: string = ""; order: string = "desc";
           limit: int = 20): Recallable =
  ## listContainerFiles
  ## Lists container files.
  ##   containerId: string (required)
  ##   after: string
  ##        : A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
  ## 
  ##   order: string
  ##        : Sort order by the `created_at` timestamp of the objects. `asc` for ascending order and `desc` for descending order.
  ## 
  ##   limit: int
  ##        : A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.
  ## 
  var path_822084579 = newJObject()
  var query_822084580 = newJObject()
  add(path_822084579, "container_id", newJString(containerId))
  add(query_822084580, "after", newJString(after))
  add(query_822084580, "order", newJString(order))
  add(query_822084580, "limit", newJInt(limit))
  result = call_822084578.call(path_822084579, query_822084580, nil, nil, nil)

var listContainerFiles* = Call_ListContainerFiles_822084570(
    name: "listContainerFiles", meth: HttpMethod.HttpGet,
    host: "api.openai.com", route: "/containers/{container_id}/files",
    validator: validate_ListContainerFiles_822084571, base: "/v1",
    makeUrl: url_ListContainerFiles_822084572, schemes: {Scheme.Https})
type
  Call_DeleteContainerFile_822084599 = ref object of OpenApiRestCall_822083995
proc url_DeleteContainerFile_822084601(protocol: Scheme; host: string;
                                       base: string; route: string;
                                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "container_id" in path, "`container_id` is a required path parameter"
  assert "file_id" in path, "`file_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/containers/"),
                 (kind: VariableSegment, value: "container_id"),
                 (kind: ConstantSegment, value: "/files/"),
                 (kind: VariableSegment, value: "file_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DeleteContainerFile_822084600(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Delete a container file.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   container_id: JString (required)
  ##   file_id: JString (required)
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `container_id` field"
  var valid_822084602 = path.getOrDefault("container_id")
  valid_822084602 = validateParameter(valid_822084602, JString, required = true,
                                      default = nil)
  if valid_822084602 != nil:
    section.add "container_id", valid_822084602
  var valid_822084603 = path.getOrDefault("file_id")
  valid_822084603 = validateParameter(valid_822084603, JString, required = true,
                                      default = nil)
  if valid_822084603 != nil:
    section.add "file_id", valid_822084603
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084604: Call_DeleteContainerFile_822084599;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Delete a container file.
  ## 
  let valid = call_822084604.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084604.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084604.makeUrl(scheme.get, call_822084604.host, call_822084604.base,
                                   call_822084604.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084604, uri, valid, content)

proc call*(call_822084605: Call_DeleteContainerFile_822084599;
           containerId: string; fileId: string): Recallable =
  ## deleteContainerFile
  ## Delete a container file.
  ##   containerId: string (required)
  ##   fileId: string (required)
  var path_822084606 = newJObject()
  add(path_822084606, "container_id", newJString(containerId))
  add(path_822084606, "file_id", newJString(fileId))
  result = call_822084605.call(path_822084606, nil, nil, nil, nil)

var deleteContainerFile* = Call_DeleteContainerFile_822084599(
    name: "deleteContainerFile", meth: HttpMethod.HttpDelete,
    host: "api.openai.com", route: "/containers/{container_id}/files/{file_id}",
    validator: validate_DeleteContainerFile_822084600, base: "/v1",
    makeUrl: url_DeleteContainerFile_822084601, schemes: {Scheme.Https})
type
  Call_RetrieveContainerFile_822084591 = ref object of OpenApiRestCall_822083995
proc url_RetrieveContainerFile_822084593(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "container_id" in path, "`container_id` is a required path parameter"
  assert "file_id" in path, "`file_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/containers/"),
                 (kind: VariableSegment, value: "container_id"),
                 (kind: ConstantSegment, value: "/files/"),
                 (kind: VariableSegment, value: "file_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RetrieveContainerFile_822084592(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Retrieves a container file.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   container_id: JString (required)
  ##   file_id: JString (required)
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `container_id` field"
  var valid_822084594 = path.getOrDefault("container_id")
  valid_822084594 = validateParameter(valid_822084594, JString, required = true,
                                      default = nil)
  if valid_822084594 != nil:
    section.add "container_id", valid_822084594
  var valid_822084595 = path.getOrDefault("file_id")
  valid_822084595 = validateParameter(valid_822084595, JString, required = true,
                                      default = nil)
  if valid_822084595 != nil:
    section.add "file_id", valid_822084595
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084596: Call_RetrieveContainerFile_822084591;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Retrieves a container file.
  ## 
  let valid = call_822084596.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084596.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084596.makeUrl(scheme.get, call_822084596.host, call_822084596.base,
                                   call_822084596.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084596, uri, valid, content)

proc call*(call_822084597: Call_RetrieveContainerFile_822084591;
           containerId: string; fileId: string): Recallable =
  ## retrieveContainerFile
  ## Retrieves a container file.
  ##   containerId: string (required)
  ##   fileId: string (required)
  var path_822084598 = newJObject()
  add(path_822084598, "container_id", newJString(containerId))
  add(path_822084598, "file_id", newJString(fileId))
  result = call_822084597.call(path_822084598, nil, nil, nil, nil)

var retrieveContainerFile* = Call_RetrieveContainerFile_822084591(
    name: "retrieveContainerFile", meth: HttpMethod.HttpGet,
    host: "api.openai.com", route: "/containers/{container_id}/files/{file_id}",
    validator: validate_RetrieveContainerFile_822084592, base: "/v1",
    makeUrl: url_RetrieveContainerFile_822084593, schemes: {Scheme.Https})
type
  Call_RetrieveContainerFileContent_822084607 = ref object of OpenApiRestCall_822083995
proc url_RetrieveContainerFileContent_822084609(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "container_id" in path, "`container_id` is a required path parameter"
  assert "file_id" in path, "`file_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/containers/"),
                 (kind: VariableSegment, value: "container_id"),
                 (kind: ConstantSegment, value: "/files/"),
                 (kind: VariableSegment, value: "file_id"),
                 (kind: ConstantSegment, value: "/content")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RetrieveContainerFileContent_822084608(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode;
    content: string = ""): JsonNode {.nosinks.} =
  ## Retrieves a container file content.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   container_id: JString (required)
  ##   file_id: JString (required)
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `container_id` field"
  var valid_822084610 = path.getOrDefault("container_id")
  valid_822084610 = validateParameter(valid_822084610, JString, required = true,
                                      default = nil)
  if valid_822084610 != nil:
    section.add "container_id", valid_822084610
  var valid_822084611 = path.getOrDefault("file_id")
  valid_822084611 = validateParameter(valid_822084611, JString, required = true,
                                      default = nil)
  if valid_822084611 != nil:
    section.add "file_id", valid_822084611
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084612: Call_RetrieveContainerFileContent_822084607;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Retrieves a container file content.
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

proc call*(call_822084613: Call_RetrieveContainerFileContent_822084607;
           containerId: string; fileId: string): Recallable =
  ## retrieveContainerFileContent
  ## Retrieves a container file content.
  ##   containerId: string (required)
  ##   fileId: string (required)
  var path_822084614 = newJObject()
  add(path_822084614, "container_id", newJString(containerId))
  add(path_822084614, "file_id", newJString(fileId))
  result = call_822084613.call(path_822084614, nil, nil, nil, nil)

var retrieveContainerFileContent* = Call_RetrieveContainerFileContent_822084607(
    name: "retrieveContainerFileContent", meth: HttpMethod.HttpGet,
    host: "api.openai.com",
    route: "/containers/{container_id}/files/{file_id}/content",
    validator: validate_RetrieveContainerFileContent_822084608, base: "/v1",
    makeUrl: url_RetrieveContainerFileContent_822084609, schemes: {Scheme.Https})
type
  Call_CreateEmbedding_822084615 = ref object of OpenApiRestCall_822083995
proc url_CreateEmbedding_822084617(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode;
                                   query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CreateEmbedding_822084616(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  if `==`(content, ""): assert body != nil, "body argument is necessary"
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822084619: Call_CreateEmbedding_822084615; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084619.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084619.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084619.makeUrl(scheme.get, call_822084619.host, call_822084619.base,
                                   call_822084619.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084619, uri, valid, content)

proc call*(call_822084620: Call_CreateEmbedding_822084615; body: JsonNode): Recallable =
  ## createEmbedding
  ##   body: JObject (required)
  var body_822084621 = newJObject()
  if body != nil:
    body_822084621 = body
  result = call_822084620.call(nil, nil, nil, nil, body_822084621)

var createEmbedding* = Call_CreateEmbedding_822084615(name: "createEmbedding",
    meth: HttpMethod.HttpPost, host: "api.openai.com", route: "/embeddings",
    validator: validate_CreateEmbedding_822084616, base: "/v1",
    makeUrl: url_CreateEmbedding_822084617, schemes: {Scheme.Https})
type
  Call_CreateEval_822084632 = ref object of OpenApiRestCall_822083995
proc url_CreateEval_822084634(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CreateEval_822084633(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  if `==`(content, ""): assert body != nil, "body argument is necessary"
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822084636: Call_CreateEval_822084632; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084636.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084636.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084636.makeUrl(scheme.get, call_822084636.host, call_822084636.base,
                                   call_822084636.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084636, uri, valid, content)

proc call*(call_822084637: Call_CreateEval_822084632; body: JsonNode): Recallable =
  ## createEval
  ##   body: JObject (required)
  var body_822084638 = newJObject()
  if body != nil:
    body_822084638 = body
  result = call_822084637.call(nil, nil, nil, nil, body_822084638)

var createEval* = Call_CreateEval_822084632(name: "createEval",
    meth: HttpMethod.HttpPost, host: "api.openai.com", route: "/evals",
    validator: validate_CreateEval_822084633, base: "/v1",
    makeUrl: url_CreateEval_822084634, schemes: {Scheme.Https})
type
  Call_ListEvals_822084622 = ref object of OpenApiRestCall_822083995
proc url_ListEvals_822084624(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_ListEvals_822084623(path: JsonNode; query: JsonNode;
                                  header: JsonNode; formData: JsonNode;
                                  body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   order_by: JString
  ##           : Evals can be ordered by creation time or last updated time. Use
  ## `created_at` for creation time or `updated_at` for last updated time.
  ## 
  ##   after: JString
  ##        : Identifier for the last eval from the previous pagination request.
  ##   order: JString
  ##        : Sort order for evals by timestamp. Use `asc` for ascending order or `desc` for descending order.
  ##   limit: JInt
  ##        : Number of evals to retrieve.
  section = newJObject()
  var valid_822084625 = query.getOrDefault("order_by")
  valid_822084625 = validateParameter(valid_822084625, JString,
                                      required = false,
                                      default = newJString("created_at"))
  if valid_822084625 != nil:
    section.add "order_by", valid_822084625
  var valid_822084626 = query.getOrDefault("after")
  valid_822084626 = validateParameter(valid_822084626, JString,
                                      required = false, default = nil)
  if valid_822084626 != nil:
    section.add "after", valid_822084626
  var valid_822084627 = query.getOrDefault("order")
  valid_822084627 = validateParameter(valid_822084627, JString,
                                      required = false,
                                      default = newJString("asc"))
  if valid_822084627 != nil:
    section.add "order", valid_822084627
  var valid_822084628 = query.getOrDefault("limit")
  valid_822084628 = validateParameter(valid_822084628, JInt, required = false,
                                      default = newJInt(20))
  if valid_822084628 != nil:
    section.add "limit", valid_822084628
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084629: Call_ListEvals_822084622; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084629.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084629.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084629.makeUrl(scheme.get, call_822084629.host, call_822084629.base,
                                   call_822084629.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084629, uri, valid, content)

proc call*(call_822084630: Call_ListEvals_822084622;
           orderBy: string = "created_at"; after: string = "";
           order: string = "asc"; limit: int = 20): Recallable =
  ## listEvals
  ##   orderBy: string
  ##          : Evals can be ordered by creation time or last updated time. Use
  ## `created_at` for creation time or `updated_at` for last updated time.
  ## 
  ##   after: string
  ##        : Identifier for the last eval from the previous pagination request.
  ##   order: string
  ##        : Sort order for evals by timestamp. Use `asc` for ascending order or `desc` for descending order.
  ##   limit: int
  ##        : Number of evals to retrieve.
  var query_822084631 = newJObject()
  add(query_822084631, "order_by", newJString(orderBy))
  add(query_822084631, "after", newJString(after))
  add(query_822084631, "order", newJString(order))
  add(query_822084631, "limit", newJInt(limit))
  result = call_822084630.call(nil, query_822084631, nil, nil, nil)

var listEvals* = Call_ListEvals_822084622(name: "listEvals",
    meth: HttpMethod.HttpGet, host: "api.openai.com", route: "/evals",
    validator: validate_ListEvals_822084623, base: "/v1",
    makeUrl: url_ListEvals_822084624, schemes: {Scheme.Https})
type
  Call_DeleteEval_822084655 = ref object of OpenApiRestCall_822083995
proc url_DeleteEval_822084657(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "eval_id" in path, "`eval_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/evals/"),
                 (kind: VariableSegment, value: "eval_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DeleteEval_822084656(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   eval_id: JString (required)
  ##          : The ID of the evaluation to delete.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `eval_id` field"
  var valid_822084658 = path.getOrDefault("eval_id")
  valid_822084658 = validateParameter(valid_822084658, JString, required = true,
                                      default = nil)
  if valid_822084658 != nil:
    section.add "eval_id", valid_822084658
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084659: Call_DeleteEval_822084655; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084659.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084659.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084659.makeUrl(scheme.get, call_822084659.host, call_822084659.base,
                                   call_822084659.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084659, uri, valid, content)

proc call*(call_822084660: Call_DeleteEval_822084655; evalId: string): Recallable =
  ## deleteEval
  ##   evalId: string (required)
  ##         : The ID of the evaluation to delete.
  var path_822084661 = newJObject()
  add(path_822084661, "eval_id", newJString(evalId))
  result = call_822084660.call(path_822084661, nil, nil, nil, nil)

var deleteEval* = Call_DeleteEval_822084655(name: "deleteEval",
    meth: HttpMethod.HttpDelete, host: "api.openai.com",
    route: "/evals/{eval_id}", validator: validate_DeleteEval_822084656,
    base: "/v1", makeUrl: url_DeleteEval_822084657, schemes: {Scheme.Https})
type
  Call_UpdateEval_822084646 = ref object of OpenApiRestCall_822083995
proc url_UpdateEval_822084648(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "eval_id" in path, "`eval_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/evals/"),
                 (kind: VariableSegment, value: "eval_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_UpdateEval_822084647(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   eval_id: JString (required)
  ##          : The ID of the evaluation to update.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `eval_id` field"
  var valid_822084649 = path.getOrDefault("eval_id")
  valid_822084649 = validateParameter(valid_822084649, JString, required = true,
                                      default = nil)
  if valid_822084649 != nil:
    section.add "eval_id", valid_822084649
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Request to update an evaluation
  if `==`(content, ""): assert body != nil, "body argument is necessary"
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822084651: Call_UpdateEval_822084646; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084651.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084651.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084651.makeUrl(scheme.get, call_822084651.host, call_822084651.base,
                                   call_822084651.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084651, uri, valid, content)

proc call*(call_822084652: Call_UpdateEval_822084646; body: JsonNode;
           evalId: string): Recallable =
  ## updateEval
  ##   body: JObject (required)
  ##       : Request to update an evaluation
  ##   evalId: string (required)
  ##         : The ID of the evaluation to update.
  var path_822084653 = newJObject()
  var body_822084654 = newJObject()
  if body != nil:
    body_822084654 = body
  add(path_822084653, "eval_id", newJString(evalId))
  result = call_822084652.call(path_822084653, nil, nil, nil, body_822084654)

var updateEval* = Call_UpdateEval_822084646(name: "updateEval",
    meth: HttpMethod.HttpPost, host: "api.openai.com",
    route: "/evals/{eval_id}", validator: validate_UpdateEval_822084647,
    base: "/v1", makeUrl: url_UpdateEval_822084648, schemes: {Scheme.Https})
type
  Call_GetEval_822084639 = ref object of OpenApiRestCall_822083995
proc url_GetEval_822084641(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "eval_id" in path, "`eval_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/evals/"),
                 (kind: VariableSegment, value: "eval_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GetEval_822084640(path: JsonNode; query: JsonNode;
                                header: JsonNode; formData: JsonNode;
                                body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   eval_id: JString (required)
  ##          : The ID of the evaluation to retrieve.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `eval_id` field"
  var valid_822084642 = path.getOrDefault("eval_id")
  valid_822084642 = validateParameter(valid_822084642, JString, required = true,
                                      default = nil)
  if valid_822084642 != nil:
    section.add "eval_id", valid_822084642
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084643: Call_GetEval_822084639; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
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

proc call*(call_822084644: Call_GetEval_822084639; evalId: string): Recallable =
  ## getEval
  ##   evalId: string (required)
  ##         : The ID of the evaluation to retrieve.
  var path_822084645 = newJObject()
  add(path_822084645, "eval_id", newJString(evalId))
  result = call_822084644.call(path_822084645, nil, nil, nil, nil)

var getEval* = Call_GetEval_822084639(name: "getEval", meth: HttpMethod.HttpGet,
                                      host: "api.openai.com",
                                      route: "/evals/{eval_id}",
                                      validator: validate_GetEval_822084640,
                                      base: "/v1", makeUrl: url_GetEval_822084641,
                                      schemes: {Scheme.Https})
type
  Call_CreateEvalRun_822084674 = ref object of OpenApiRestCall_822083995
proc url_CreateEvalRun_822084676(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "eval_id" in path, "`eval_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/evals/"),
                 (kind: VariableSegment, value: "eval_id"),
                 (kind: ConstantSegment, value: "/runs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CreateEvalRun_822084675(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   eval_id: JString (required)
  ##          : The ID of the evaluation to create a run for.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `eval_id` field"
  var valid_822084677 = path.getOrDefault("eval_id")
  valid_822084677 = validateParameter(valid_822084677, JString, required = true,
                                      default = nil)
  if valid_822084677 != nil:
    section.add "eval_id", valid_822084677
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  if `==`(content, ""): assert body != nil, "body argument is necessary"
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822084679: Call_CreateEvalRun_822084674; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084679.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084679.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084679.makeUrl(scheme.get, call_822084679.host, call_822084679.base,
                                   call_822084679.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084679, uri, valid, content)

proc call*(call_822084680: Call_CreateEvalRun_822084674; body: JsonNode;
           evalId: string): Recallable =
  ## createEvalRun
  ##   body: JObject (required)
  ##   evalId: string (required)
  ##         : The ID of the evaluation to create a run for.
  var path_822084681 = newJObject()
  var body_822084682 = newJObject()
  if body != nil:
    body_822084682 = body
  add(path_822084681, "eval_id", newJString(evalId))
  result = call_822084680.call(path_822084681, nil, nil, nil, body_822084682)

var createEvalRun* = Call_CreateEvalRun_822084674(name: "createEvalRun",
    meth: HttpMethod.HttpPost, host: "api.openai.com",
    route: "/evals/{eval_id}/runs", validator: validate_CreateEvalRun_822084675,
    base: "/v1", makeUrl: url_CreateEvalRun_822084676, schemes: {Scheme.Https})
type
  Call_GetEvalRuns_822084662 = ref object of OpenApiRestCall_822083995
proc url_GetEvalRuns_822084664(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "eval_id" in path, "`eval_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/evals/"),
                 (kind: VariableSegment, value: "eval_id"),
                 (kind: ConstantSegment, value: "/runs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GetEvalRuns_822084663(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   eval_id: JString (required)
  ##          : The ID of the evaluation to retrieve runs for.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `eval_id` field"
  var valid_822084665 = path.getOrDefault("eval_id")
  valid_822084665 = validateParameter(valid_822084665, JString, required = true,
                                      default = nil)
  if valid_822084665 != nil:
    section.add "eval_id", valid_822084665
  result.add "path", section
  ## parameters in `query` object:
  ##   after: JString
  ##        : Identifier for the last run from the previous pagination request.
  ##   order: JString
  ##        : Sort order for runs by timestamp. Use `asc` for ascending order or `desc` for descending order. Defaults to `asc`.
  ##   status: JString
  ##         : Filter runs by status. One of `queued` | `in_progress` | `failed` | `completed` | `canceled`.
  ##   limit: JInt
  ##        : Number of runs to retrieve.
  section = newJObject()
  var valid_822084666 = query.getOrDefault("after")
  valid_822084666 = validateParameter(valid_822084666, JString,
                                      required = false, default = nil)
  if valid_822084666 != nil:
    section.add "after", valid_822084666
  var valid_822084667 = query.getOrDefault("order")
  valid_822084667 = validateParameter(valid_822084667, JString,
                                      required = false,
                                      default = newJString("asc"))
  if valid_822084667 != nil:
    section.add "order", valid_822084667
  var valid_822084668 = query.getOrDefault("status")
  valid_822084668 = validateParameter(valid_822084668, JString,
                                      required = false,
                                      default = newJString("queued"))
  if valid_822084668 != nil:
    section.add "status", valid_822084668
  var valid_822084669 = query.getOrDefault("limit")
  valid_822084669 = validateParameter(valid_822084669, JInt, required = false,
                                      default = newJInt(20))
  if valid_822084669 != nil:
    section.add "limit", valid_822084669
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084670: Call_GetEvalRuns_822084662; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084670.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084670.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084670.makeUrl(scheme.get, call_822084670.host, call_822084670.base,
                                   call_822084670.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084670, uri, valid, content)

proc call*(call_822084671: Call_GetEvalRuns_822084662; evalId: string;
           after: string = ""; order: string = "asc"; status: string = "queued";
           limit: int = 20): Recallable =
  ## getEvalRuns
  ##   after: string
  ##        : Identifier for the last run from the previous pagination request.
  ##   order: string
  ##        : Sort order for runs by timestamp. Use `asc` for ascending order or `desc` for descending order. Defaults to `asc`.
  ##   status: string
  ##         : Filter runs by status. One of `queued` | `in_progress` | `failed` | `completed` | `canceled`.
  ##   evalId: string (required)
  ##         : The ID of the evaluation to retrieve runs for.
  ##   limit: int
  ##        : Number of runs to retrieve.
  var path_822084672 = newJObject()
  var query_822084673 = newJObject()
  add(query_822084673, "after", newJString(after))
  add(query_822084673, "order", newJString(order))
  add(query_822084673, "status", newJString(status))
  add(path_822084672, "eval_id", newJString(evalId))
  add(query_822084673, "limit", newJInt(limit))
  result = call_822084671.call(path_822084672, query_822084673, nil, nil, nil)

var getEvalRuns* = Call_GetEvalRuns_822084662(name: "getEvalRuns",
    meth: HttpMethod.HttpGet, host: "api.openai.com",
    route: "/evals/{eval_id}/runs", validator: validate_GetEvalRuns_822084663,
    base: "/v1", makeUrl: url_GetEvalRuns_822084664, schemes: {Scheme.Https})
type
  Call_DeleteEvalRun_822084699 = ref object of OpenApiRestCall_822083995
proc url_DeleteEvalRun_822084701(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "eval_id" in path, "`eval_id` is a required path parameter"
  assert "run_id" in path, "`run_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/evals/"),
                 (kind: VariableSegment, value: "eval_id"),
                 (kind: ConstantSegment, value: "/runs/"),
                 (kind: VariableSegment, value: "run_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DeleteEvalRun_822084700(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   run_id: JString (required)
  ##         : The ID of the run to delete.
  ##   eval_id: JString (required)
  ##          : The ID of the evaluation to delete the run from.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `run_id` field"
  var valid_822084702 = path.getOrDefault("run_id")
  valid_822084702 = validateParameter(valid_822084702, JString, required = true,
                                      default = nil)
  if valid_822084702 != nil:
    section.add "run_id", valid_822084702
  var valid_822084703 = path.getOrDefault("eval_id")
  valid_822084703 = validateParameter(valid_822084703, JString, required = true,
                                      default = nil)
  if valid_822084703 != nil:
    section.add "eval_id", valid_822084703
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084704: Call_DeleteEvalRun_822084699; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084704.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084704.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084704.makeUrl(scheme.get, call_822084704.host, call_822084704.base,
                                   call_822084704.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084704, uri, valid, content)

proc call*(call_822084705: Call_DeleteEvalRun_822084699; runId: string;
           evalId: string): Recallable =
  ## deleteEvalRun
  ##   runId: string (required)
  ##        : The ID of the run to delete.
  ##   evalId: string (required)
  ##         : The ID of the evaluation to delete the run from.
  var path_822084706 = newJObject()
  add(path_822084706, "run_id", newJString(runId))
  add(path_822084706, "eval_id", newJString(evalId))
  result = call_822084705.call(path_822084706, nil, nil, nil, nil)

var deleteEvalRun* = Call_DeleteEvalRun_822084699(name: "deleteEvalRun",
    meth: HttpMethod.HttpDelete, host: "api.openai.com",
    route: "/evals/{eval_id}/runs/{run_id}", validator: validate_DeleteEvalRun_822084700,
    base: "/v1", makeUrl: url_DeleteEvalRun_822084701, schemes: {Scheme.Https})
type
  Call_CancelEvalRun_822084691 = ref object of OpenApiRestCall_822083995
proc url_CancelEvalRun_822084693(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "eval_id" in path, "`eval_id` is a required path parameter"
  assert "run_id" in path, "`run_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/evals/"),
                 (kind: VariableSegment, value: "eval_id"),
                 (kind: ConstantSegment, value: "/runs/"),
                 (kind: VariableSegment, value: "run_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CancelEvalRun_822084692(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   run_id: JString (required)
  ##         : The ID of the run to cancel.
  ##   eval_id: JString (required)
  ##          : The ID of the evaluation whose run you want to cancel.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `run_id` field"
  var valid_822084694 = path.getOrDefault("run_id")
  valid_822084694 = validateParameter(valid_822084694, JString, required = true,
                                      default = nil)
  if valid_822084694 != nil:
    section.add "run_id", valid_822084694
  var valid_822084695 = path.getOrDefault("eval_id")
  valid_822084695 = validateParameter(valid_822084695, JString, required = true,
                                      default = nil)
  if valid_822084695 != nil:
    section.add "eval_id", valid_822084695
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084696: Call_CancelEvalRun_822084691; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084696.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084696.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084696.makeUrl(scheme.get, call_822084696.host, call_822084696.base,
                                   call_822084696.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084696, uri, valid, content)

proc call*(call_822084697: Call_CancelEvalRun_822084691; runId: string;
           evalId: string): Recallable =
  ## cancelEvalRun
  ##   runId: string (required)
  ##        : The ID of the run to cancel.
  ##   evalId: string (required)
  ##         : The ID of the evaluation whose run you want to cancel.
  var path_822084698 = newJObject()
  add(path_822084698, "run_id", newJString(runId))
  add(path_822084698, "eval_id", newJString(evalId))
  result = call_822084697.call(path_822084698, nil, nil, nil, nil)

var cancelEvalRun* = Call_CancelEvalRun_822084691(name: "cancelEvalRun",
    meth: HttpMethod.HttpPost, host: "api.openai.com",
    route: "/evals/{eval_id}/runs/{run_id}", validator: validate_CancelEvalRun_822084692,
    base: "/v1", makeUrl: url_CancelEvalRun_822084693, schemes: {Scheme.Https})
type
  Call_GetEvalRun_822084683 = ref object of OpenApiRestCall_822083995
proc url_GetEvalRun_822084685(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "eval_id" in path, "`eval_id` is a required path parameter"
  assert "run_id" in path, "`run_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/evals/"),
                 (kind: VariableSegment, value: "eval_id"),
                 (kind: ConstantSegment, value: "/runs/"),
                 (kind: VariableSegment, value: "run_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GetEvalRun_822084684(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   run_id: JString (required)
  ##         : The ID of the run to retrieve.
  ##   eval_id: JString (required)
  ##          : The ID of the evaluation to retrieve runs for.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `run_id` field"
  var valid_822084686 = path.getOrDefault("run_id")
  valid_822084686 = validateParameter(valid_822084686, JString, required = true,
                                      default = nil)
  if valid_822084686 != nil:
    section.add "run_id", valid_822084686
  var valid_822084687 = path.getOrDefault("eval_id")
  valid_822084687 = validateParameter(valid_822084687, JString, required = true,
                                      default = nil)
  if valid_822084687 != nil:
    section.add "eval_id", valid_822084687
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084688: Call_GetEvalRun_822084683; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
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

proc call*(call_822084689: Call_GetEvalRun_822084683; runId: string;
           evalId: string): Recallable =
  ## getEvalRun
  ##   runId: string (required)
  ##        : The ID of the run to retrieve.
  ##   evalId: string (required)
  ##         : The ID of the evaluation to retrieve runs for.
  var path_822084690 = newJObject()
  add(path_822084690, "run_id", newJString(runId))
  add(path_822084690, "eval_id", newJString(evalId))
  result = call_822084689.call(path_822084690, nil, nil, nil, nil)

var getEvalRun* = Call_GetEvalRun_822084683(name: "getEvalRun",
    meth: HttpMethod.HttpGet, host: "api.openai.com",
    route: "/evals/{eval_id}/runs/{run_id}", validator: validate_GetEvalRun_822084684,
    base: "/v1", makeUrl: url_GetEvalRun_822084685, schemes: {Scheme.Https})
type
  Call_GetEvalRunOutputItems_822084707 = ref object of OpenApiRestCall_822083995
proc url_GetEvalRunOutputItems_822084709(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "eval_id" in path, "`eval_id` is a required path parameter"
  assert "run_id" in path, "`run_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/evals/"),
                 (kind: VariableSegment, value: "eval_id"),
                 (kind: ConstantSegment, value: "/runs/"),
                 (kind: VariableSegment, value: "run_id"),
                 (kind: ConstantSegment, value: "/output_items")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GetEvalRunOutputItems_822084708(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   run_id: JString (required)
  ##         : The ID of the run to retrieve output items for.
  ##   eval_id: JString (required)
  ##          : The ID of the evaluation to retrieve runs for.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `run_id` field"
  var valid_822084710 = path.getOrDefault("run_id")
  valid_822084710 = validateParameter(valid_822084710, JString, required = true,
                                      default = nil)
  if valid_822084710 != nil:
    section.add "run_id", valid_822084710
  var valid_822084711 = path.getOrDefault("eval_id")
  valid_822084711 = validateParameter(valid_822084711, JString, required = true,
                                      default = nil)
  if valid_822084711 != nil:
    section.add "eval_id", valid_822084711
  result.add "path", section
  ## parameters in `query` object:
  ##   after: JString
  ##        : Identifier for the last output item from the previous pagination request.
  ##   order: JString
  ##        : Sort order for output items by timestamp. Use `asc` for ascending order or `desc` for descending order. Defaults to `asc`.
  ##   status: JString
  ##         : Filter output items by status. Use `failed` to filter by failed output
  ## items or `pass` to filter by passed output items.
  ## 
  ##   limit: JInt
  ##        : Number of output items to retrieve.
  section = newJObject()
  var valid_822084712 = query.getOrDefault("after")
  valid_822084712 = validateParameter(valid_822084712, JString,
                                      required = false, default = nil)
  if valid_822084712 != nil:
    section.add "after", valid_822084712
  var valid_822084713 = query.getOrDefault("order")
  valid_822084713 = validateParameter(valid_822084713, JString,
                                      required = false,
                                      default = newJString("asc"))
  if valid_822084713 != nil:
    section.add "order", valid_822084713
  var valid_822084714 = query.getOrDefault("status")
  valid_822084714 = validateParameter(valid_822084714, JString,
                                      required = false,
                                      default = newJString("fail"))
  if valid_822084714 != nil:
    section.add "status", valid_822084714
  var valid_822084715 = query.getOrDefault("limit")
  valid_822084715 = validateParameter(valid_822084715, JInt, required = false,
                                      default = newJInt(20))
  if valid_822084715 != nil:
    section.add "limit", valid_822084715
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084716: Call_GetEvalRunOutputItems_822084707;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084716.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084716.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084716.makeUrl(scheme.get, call_822084716.host, call_822084716.base,
                                   call_822084716.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084716, uri, valid, content)

proc call*(call_822084717: Call_GetEvalRunOutputItems_822084707; runId: string;
           evalId: string; after: string = ""; order: string = "asc";
           status: string = "fail"; limit: int = 20): Recallable =
  ## getEvalRunOutputItems
  ##   runId: string (required)
  ##        : The ID of the run to retrieve output items for.
  ##   after: string
  ##        : Identifier for the last output item from the previous pagination request.
  ##   order: string
  ##        : Sort order for output items by timestamp. Use `asc` for ascending order or `desc` for descending order. Defaults to `asc`.
  ##   status: string
  ##         : Filter output items by status. Use `failed` to filter by failed output
  ## items or `pass` to filter by passed output items.
  ## 
  ##   evalId: string (required)
  ##         : The ID of the evaluation to retrieve runs for.
  ##   limit: int
  ##        : Number of output items to retrieve.
  var path_822084718 = newJObject()
  var query_822084719 = newJObject()
  add(path_822084718, "run_id", newJString(runId))
  add(query_822084719, "after", newJString(after))
  add(query_822084719, "order", newJString(order))
  add(query_822084719, "status", newJString(status))
  add(path_822084718, "eval_id", newJString(evalId))
  add(query_822084719, "limit", newJInt(limit))
  result = call_822084717.call(path_822084718, query_822084719, nil, nil, nil)

var getEvalRunOutputItems* = Call_GetEvalRunOutputItems_822084707(
    name: "getEvalRunOutputItems", meth: HttpMethod.HttpGet,
    host: "api.openai.com",
    route: "/evals/{eval_id}/runs/{run_id}/output_items",
    validator: validate_GetEvalRunOutputItems_822084708, base: "/v1",
    makeUrl: url_GetEvalRunOutputItems_822084709, schemes: {Scheme.Https})
type
  Call_GetEvalRunOutputItem_822084720 = ref object of OpenApiRestCall_822083995
proc url_GetEvalRunOutputItem_822084722(protocol: Scheme; host: string;
                                        base: string; route: string;
                                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "eval_id" in path, "`eval_id` is a required path parameter"
  assert "run_id" in path, "`run_id` is a required path parameter"
  assert "output_item_id" in path,
         "`output_item_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/evals/"),
                 (kind: VariableSegment, value: "eval_id"),
                 (kind: ConstantSegment, value: "/runs/"),
                 (kind: VariableSegment, value: "run_id"),
                 (kind: ConstantSegment, value: "/output_items/"),
                 (kind: VariableSegment, value: "output_item_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GetEvalRunOutputItem_822084721(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   run_id: JString (required)
  ##         : The ID of the run to retrieve.
  ##   eval_id: JString (required)
  ##          : The ID of the evaluation to retrieve runs for.
  ##   output_item_id: JString (required)
  ##                 : The ID of the output item to retrieve.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `run_id` field"
  var valid_822084723 = path.getOrDefault("run_id")
  valid_822084723 = validateParameter(valid_822084723, JString, required = true,
                                      default = nil)
  if valid_822084723 != nil:
    section.add "run_id", valid_822084723
  var valid_822084724 = path.getOrDefault("eval_id")
  valid_822084724 = validateParameter(valid_822084724, JString, required = true,
                                      default = nil)
  if valid_822084724 != nil:
    section.add "eval_id", valid_822084724
  var valid_822084725 = path.getOrDefault("output_item_id")
  valid_822084725 = validateParameter(valid_822084725, JString, required = true,
                                      default = nil)
  if valid_822084725 != nil:
    section.add "output_item_id", valid_822084725
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084726: Call_GetEvalRunOutputItem_822084720;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084726.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084726.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084726.makeUrl(scheme.get, call_822084726.host, call_822084726.base,
                                   call_822084726.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084726, uri, valid, content)

proc call*(call_822084727: Call_GetEvalRunOutputItem_822084720; runId: string;
           evalId: string; outputItemId: string): Recallable =
  ## getEvalRunOutputItem
  ##   runId: string (required)
  ##        : The ID of the run to retrieve.
  ##   evalId: string (required)
  ##         : The ID of the evaluation to retrieve runs for.
  ##   outputItemId: string (required)
  ##               : The ID of the output item to retrieve.
  var path_822084728 = newJObject()
  add(path_822084728, "run_id", newJString(runId))
  add(path_822084728, "eval_id", newJString(evalId))
  add(path_822084728, "output_item_id", newJString(outputItemId))
  result = call_822084727.call(path_822084728, nil, nil, nil, nil)

var getEvalRunOutputItem* = Call_GetEvalRunOutputItem_822084720(
    name: "getEvalRunOutputItem", meth: HttpMethod.HttpGet,
    host: "api.openai.com",
    route: "/evals/{eval_id}/runs/{run_id}/output_items/{output_item_id}",
    validator: validate_GetEvalRunOutputItem_822084721, base: "/v1",
    makeUrl: url_GetEvalRunOutputItem_822084722, schemes: {Scheme.Https})
type
  Call_CreateFile_822084739 = ref object of OpenApiRestCall_822083995
proc url_CreateFile_822084741(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CreateFile_822084740(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  ## parameters in `formData` object:
  ##   file: JString (required)
  ##       : The File object (not file name) to be uploaded.
  ## 
  ##   purpose: JString (required)
  ##          : The intended purpose of the uploaded file. One of: - `assistants`: Used in the Assistants API - `batch`: Used in the Batch API - `fine-tune`: Used for fine-tuning - `vision`: Images used for vision fine-tuning - `user_data`: Flexible file type for any purpose - `evals`: Used for eval data sets
  ## 
  section = newJObject()
  assert formData != nil,
         "formData argument is necessary due to required `file` field"
  var valid_822084742 = formData.getOrDefault("file")
  valid_822084742 = validateParameter(valid_822084742, JString, required = true,
                                      default = nil)
  if valid_822084742 != nil:
    section.add "file", valid_822084742
  var valid_822084743 = formData.getOrDefault("purpose")
  valid_822084743 = validateParameter(valid_822084743, JString, required = true,
                                      default = newJString("assistants"))
  if valid_822084743 != nil:
    section.add "purpose", valid_822084743
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084744: Call_CreateFile_822084739; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084744.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084744.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084744.makeUrl(scheme.get, call_822084744.host, call_822084744.base,
                                   call_822084744.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084744, uri, valid, content)

proc call*(call_822084745: Call_CreateFile_822084739; file: string;
           purpose: string = "assistants"): Recallable =
  ## createFile
  ##   file: string (required)
  ##       : The File object (not file name) to be uploaded.
  ## 
  ##   purpose: string (required)
  ##          : The intended purpose of the uploaded file. One of: - `assistants`: Used in the Assistants API - `batch`: Used in the Batch API - `fine-tune`: Used for fine-tuning - `vision`: Images used for vision fine-tuning - `user_data`: Flexible file type for any purpose - `evals`: Used for eval data sets
  ## 
  var formData_822084746 = newJObject()
  add(formData_822084746, "file", newJString(file))
  add(formData_822084746, "purpose", newJString(purpose))
  result = call_822084745.call(nil, nil, nil, formData_822084746, nil)

var createFile* = Call_CreateFile_822084739(name: "createFile",
    meth: HttpMethod.HttpPost, host: "api.openai.com", route: "/files",
    validator: validate_CreateFile_822084740, base: "/v1",
    makeUrl: url_CreateFile_822084741, schemes: {Scheme.Https})
type
  Call_ListFiles_822084729 = ref object of OpenApiRestCall_822083995
proc url_ListFiles_822084731(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_ListFiles_822084730(path: JsonNode; query: JsonNode;
                                  header: JsonNode; formData: JsonNode;
                                  body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   purpose: JString
  ##          : Only return files with the given purpose.
  ##   after: JString
  ##        : A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
  ## 
  ##   order: JString
  ##        : Sort order by the `created_at` timestamp of the objects. `asc` for ascending order and `desc` for descending order.
  ## 
  ##   limit: JInt
  ##        : A limit on the number of objects to be returned. Limit can range between 1 and 10,000, and the default is 10,000.
  ## 
  section = newJObject()
  var valid_822084732 = query.getOrDefault("purpose")
  valid_822084732 = validateParameter(valid_822084732, JString,
                                      required = false, default = nil)
  if valid_822084732 != nil:
    section.add "purpose", valid_822084732
  var valid_822084733 = query.getOrDefault("after")
  valid_822084733 = validateParameter(valid_822084733, JString,
                                      required = false, default = nil)
  if valid_822084733 != nil:
    section.add "after", valid_822084733
  var valid_822084734 = query.getOrDefault("order")
  valid_822084734 = validateParameter(valid_822084734, JString,
                                      required = false,
                                      default = newJString("desc"))
  if valid_822084734 != nil:
    section.add "order", valid_822084734
  var valid_822084735 = query.getOrDefault("limit")
  valid_822084735 = validateParameter(valid_822084735, JInt, required = false,
                                      default = newJInt(10000))
  if valid_822084735 != nil:
    section.add "limit", valid_822084735
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084736: Call_ListFiles_822084729; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084736.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084736.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084736.makeUrl(scheme.get, call_822084736.host, call_822084736.base,
                                   call_822084736.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084736, uri, valid, content)

proc call*(call_822084737: Call_ListFiles_822084729; purpose: string = "";
           after: string = ""; order: string = "desc"; limit: int = 10000): Recallable =
  ## listFiles
  ##   purpose: string
  ##          : Only return files with the given purpose.
  ##   after: string
  ##        : A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
  ## 
  ##   order: string
  ##        : Sort order by the `created_at` timestamp of the objects. `asc` for ascending order and `desc` for descending order.
  ## 
  ##   limit: int
  ##        : A limit on the number of objects to be returned. Limit can range between 1 and 10,000, and the default is 10,000.
  ## 
  var query_822084738 = newJObject()
  add(query_822084738, "purpose", newJString(purpose))
  add(query_822084738, "after", newJString(after))
  add(query_822084738, "order", newJString(order))
  add(query_822084738, "limit", newJInt(limit))
  result = call_822084737.call(nil, query_822084738, nil, nil, nil)

var listFiles* = Call_ListFiles_822084729(name: "listFiles",
    meth: HttpMethod.HttpGet, host: "api.openai.com", route: "/files",
    validator: validate_ListFiles_822084730, base: "/v1",
    makeUrl: url_ListFiles_822084731, schemes: {Scheme.Https})
type
  Call_DeleteFile_822084754 = ref object of OpenApiRestCall_822083995
proc url_DeleteFile_822084756(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "file_id" in path, "`file_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
                 (kind: VariableSegment, value: "file_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DeleteFile_822084755(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   file_id: JString (required)
  ##          : The ID of the file to use for this request.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `file_id` field"
  var valid_822084757 = path.getOrDefault("file_id")
  valid_822084757 = validateParameter(valid_822084757, JString, required = true,
                                      default = nil)
  if valid_822084757 != nil:
    section.add "file_id", valid_822084757
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084758: Call_DeleteFile_822084754; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084758.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084758.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084758.makeUrl(scheme.get, call_822084758.host, call_822084758.base,
                                   call_822084758.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084758, uri, valid, content)

proc call*(call_822084759: Call_DeleteFile_822084754; fileId: string): Recallable =
  ## deleteFile
  ##   fileId: string (required)
  ##         : The ID of the file to use for this request.
  var path_822084760 = newJObject()
  add(path_822084760, "file_id", newJString(fileId))
  result = call_822084759.call(path_822084760, nil, nil, nil, nil)

var deleteFile* = Call_DeleteFile_822084754(name: "deleteFile",
    meth: HttpMethod.HttpDelete, host: "api.openai.com",
    route: "/files/{file_id}", validator: validate_DeleteFile_822084755,
    base: "/v1", makeUrl: url_DeleteFile_822084756, schemes: {Scheme.Https})
type
  Call_RetrieveFile_822084747 = ref object of OpenApiRestCall_822083995
proc url_RetrieveFile_822084749(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "file_id" in path, "`file_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
                 (kind: VariableSegment, value: "file_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RetrieveFile_822084748(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   file_id: JString (required)
  ##          : The ID of the file to use for this request.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `file_id` field"
  var valid_822084750 = path.getOrDefault("file_id")
  valid_822084750 = validateParameter(valid_822084750, JString, required = true,
                                      default = nil)
  if valid_822084750 != nil:
    section.add "file_id", valid_822084750
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084751: Call_RetrieveFile_822084747; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084751.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084751.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084751.makeUrl(scheme.get, call_822084751.host, call_822084751.base,
                                   call_822084751.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084751, uri, valid, content)

proc call*(call_822084752: Call_RetrieveFile_822084747; fileId: string): Recallable =
  ## retrieveFile
  ##   fileId: string (required)
  ##         : The ID of the file to use for this request.
  var path_822084753 = newJObject()
  add(path_822084753, "file_id", newJString(fileId))
  result = call_822084752.call(path_822084753, nil, nil, nil, nil)

var retrieveFile* = Call_RetrieveFile_822084747(name: "retrieveFile",
    meth: HttpMethod.HttpGet, host: "api.openai.com", route: "/files/{file_id}",
    validator: validate_RetrieveFile_822084748, base: "/v1",
    makeUrl: url_RetrieveFile_822084749, schemes: {Scheme.Https})
type
  Call_DownloadFile_822084761 = ref object of OpenApiRestCall_822083995
proc url_DownloadFile_822084763(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "file_id" in path, "`file_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/files/"),
                 (kind: VariableSegment, value: "file_id"),
                 (kind: ConstantSegment, value: "/content")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DownloadFile_822084762(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   file_id: JString (required)
  ##          : The ID of the file to use for this request.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `file_id` field"
  var valid_822084764 = path.getOrDefault("file_id")
  valid_822084764 = validateParameter(valid_822084764, JString, required = true,
                                      default = nil)
  if valid_822084764 != nil:
    section.add "file_id", valid_822084764
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084765: Call_DownloadFile_822084761; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084765.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084765.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084765.makeUrl(scheme.get, call_822084765.host, call_822084765.base,
                                   call_822084765.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084765, uri, valid, content)

proc call*(call_822084766: Call_DownloadFile_822084761; fileId: string): Recallable =
  ## downloadFile
  ##   fileId: string (required)
  ##         : The ID of the file to use for this request.
  var path_822084767 = newJObject()
  add(path_822084767, "file_id", newJString(fileId))
  result = call_822084766.call(path_822084767, nil, nil, nil, nil)

var downloadFile* = Call_DownloadFile_822084761(name: "downloadFile",
    meth: HttpMethod.HttpGet, host: "api.openai.com",
    route: "/files/{file_id}/content", validator: validate_DownloadFile_822084762,
    base: "/v1", makeUrl: url_DownloadFile_822084763, schemes: {Scheme.Https})
type
  Call_RunGrader_822084768 = ref object of OpenApiRestCall_822083995
proc url_RunGrader_822084770(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_RunGrader_822084769(path: JsonNode; query: JsonNode;
                                  header: JsonNode; formData: JsonNode;
                                  body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  if `==`(content, ""): assert body != nil, "body argument is necessary"
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822084772: Call_RunGrader_822084768; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084772.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084772.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084772.makeUrl(scheme.get, call_822084772.host, call_822084772.base,
                                   call_822084772.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084772, uri, valid, content)

proc call*(call_822084773: Call_RunGrader_822084768; body: JsonNode): Recallable =
  ## runGrader
  ##   body: JObject (required)
  var body_822084774 = newJObject()
  if body != nil:
    body_822084774 = body
  result = call_822084773.call(nil, nil, nil, nil, body_822084774)

var runGrader* = Call_RunGrader_822084768(name: "runGrader",
    meth: HttpMethod.HttpPost, host: "api.openai.com",
    route: "/fine_tuning/alpha/graders/run", validator: validate_RunGrader_822084769,
    base: "/v1", makeUrl: url_RunGrader_822084770, schemes: {Scheme.Https})
type
  Call_ValidateGrader_822084775 = ref object of OpenApiRestCall_822083995
proc url_ValidateGrader_822084777(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_ValidateGrader_822084776(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  if `==`(content, ""): assert body != nil, "body argument is necessary"
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822084779: Call_ValidateGrader_822084775; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084779.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084779.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084779.makeUrl(scheme.get, call_822084779.host, call_822084779.base,
                                   call_822084779.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084779, uri, valid, content)

proc call*(call_822084780: Call_ValidateGrader_822084775; body: JsonNode): Recallable =
  ## validateGrader
  ##   body: JObject (required)
  var body_822084781 = newJObject()
  if body != nil:
    body_822084781 = body
  result = call_822084780.call(nil, nil, nil, nil, body_822084781)

var validateGrader* = Call_ValidateGrader_822084775(name: "validateGrader",
    meth: HttpMethod.HttpPost, host: "api.openai.com",
    route: "/fine_tuning/alpha/graders/validate",
    validator: validate_ValidateGrader_822084776, base: "/v1",
    makeUrl: url_ValidateGrader_822084777, schemes: {Scheme.Https})
type
  Call_CreateFineTuningCheckpointPermission_822084794 = ref object of OpenApiRestCall_822083995
proc url_CreateFineTuningCheckpointPermission_822084796(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "fine_tuned_model_checkpoint" in path,
         "`fine_tuned_model_checkpoint` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/fine_tuning/checkpoints/"),
                 (kind: VariableSegment, value: "fine_tuned_model_checkpoint"),
                 (kind: ConstantSegment, value: "/permissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CreateFineTuningCheckpointPermission_822084795(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode;
    content: string = ""): JsonNode {.nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fine_tuned_model_checkpoint: JString (required)
  ##                              : The ID of the fine-tuned model checkpoint to create a permission for.
  ## 
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fine_tuned_model_checkpoint` field"
  var valid_822084797 = path.getOrDefault("fine_tuned_model_checkpoint")
  valid_822084797 = validateParameter(valid_822084797, JString, required = true,
                                      default = nil)
  if valid_822084797 != nil:
    section.add "fine_tuned_model_checkpoint", valid_822084797
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  if `==`(content, ""): assert body != nil, "body argument is necessary"
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822084799: Call_CreateFineTuningCheckpointPermission_822084794;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084799.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084799.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084799.makeUrl(scheme.get, call_822084799.host, call_822084799.base,
                                   call_822084799.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084799, uri, valid, content)

proc call*(call_822084800: Call_CreateFineTuningCheckpointPermission_822084794;
           fineTunedModelCheckpoint: string; body: JsonNode): Recallable =
  ## createFineTuningCheckpointPermission
  ##   fineTunedModelCheckpoint: string (required)
  ##                           : The ID of the fine-tuned model checkpoint to create a permission for.
  ## 
  ##   body: JObject (required)
  var path_822084801 = newJObject()
  var body_822084802 = newJObject()
  add(path_822084801, "fine_tuned_model_checkpoint",
      newJString(fineTunedModelCheckpoint))
  if body != nil:
    body_822084802 = body
  result = call_822084800.call(path_822084801, nil, nil, nil, body_822084802)

var createFineTuningCheckpointPermission* = Call_CreateFineTuningCheckpointPermission_822084794(
    name: "createFineTuningCheckpointPermission", meth: HttpMethod.HttpPost,
    host: "api.openai.com", route: "/fine_tuning/checkpoints/{fine_tuned_model_checkpoint}/permissions",
    validator: validate_CreateFineTuningCheckpointPermission_822084795,
    base: "/v1", makeUrl: url_CreateFineTuningCheckpointPermission_822084796,
    schemes: {Scheme.Https})
type
  Call_ListFineTuningCheckpointPermissions_822084782 = ref object of OpenApiRestCall_822083995
proc url_ListFineTuningCheckpointPermissions_822084784(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "fine_tuned_model_checkpoint" in path,
         "`fine_tuned_model_checkpoint` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/fine_tuning/checkpoints/"),
                 (kind: VariableSegment, value: "fine_tuned_model_checkpoint"),
                 (kind: ConstantSegment, value: "/permissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ListFineTuningCheckpointPermissions_822084783(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode;
    content: string = ""): JsonNode {.nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fine_tuned_model_checkpoint: JString (required)
  ##                              : The ID of the fine-tuned model checkpoint to get permissions for.
  ## 
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fine_tuned_model_checkpoint` field"
  var valid_822084785 = path.getOrDefault("fine_tuned_model_checkpoint")
  valid_822084785 = validateParameter(valid_822084785, JString, required = true,
                                      default = nil)
  if valid_822084785 != nil:
    section.add "fine_tuned_model_checkpoint", valid_822084785
  result.add "path", section
  ## parameters in `query` object:
  ##   after: JString
  ##        : Identifier for the last permission ID from the previous pagination request.
  ##   order: JString
  ##        : The order in which to retrieve permissions.
  ##   limit: JInt
  ##        : Number of permissions to retrieve.
  ##   project_id: JString
  ##             : The ID of the project to get permissions for.
  section = newJObject()
  var valid_822084786 = query.getOrDefault("after")
  valid_822084786 = validateParameter(valid_822084786, JString,
                                      required = false, default = nil)
  if valid_822084786 != nil:
    section.add "after", valid_822084786
  var valid_822084787 = query.getOrDefault("order")
  valid_822084787 = validateParameter(valid_822084787, JString,
                                      required = false,
                                      default = newJString("descending"))
  if valid_822084787 != nil:
    section.add "order", valid_822084787
  var valid_822084788 = query.getOrDefault("limit")
  valid_822084788 = validateParameter(valid_822084788, JInt, required = false,
                                      default = newJInt(10))
  if valid_822084788 != nil:
    section.add "limit", valid_822084788
  var valid_822084789 = query.getOrDefault("project_id")
  valid_822084789 = validateParameter(valid_822084789, JString,
                                      required = false, default = nil)
  if valid_822084789 != nil:
    section.add "project_id", valid_822084789
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084790: Call_ListFineTuningCheckpointPermissions_822084782;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084790.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084790.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084790.makeUrl(scheme.get, call_822084790.host, call_822084790.base,
                                   call_822084790.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084790, uri, valid, content)

proc call*(call_822084791: Call_ListFineTuningCheckpointPermissions_822084782;
           fineTunedModelCheckpoint: string; after: string = "";
           order: string = "descending"; limit: int = 10; projectId: string = ""): Recallable =
  ## listFineTuningCheckpointPermissions
  ##   fineTunedModelCheckpoint: string (required)
  ##                           : The ID of the fine-tuned model checkpoint to get permissions for.
  ## 
  ##   after: string
  ##        : Identifier for the last permission ID from the previous pagination request.
  ##   order: string
  ##        : The order in which to retrieve permissions.
  ##   limit: int
  ##        : Number of permissions to retrieve.
  ##   projectId: string
  ##            : The ID of the project to get permissions for.
  var path_822084792 = newJObject()
  var query_822084793 = newJObject()
  add(path_822084792, "fine_tuned_model_checkpoint",
      newJString(fineTunedModelCheckpoint))
  add(query_822084793, "after", newJString(after))
  add(query_822084793, "order", newJString(order))
  add(query_822084793, "limit", newJInt(limit))
  add(query_822084793, "project_id", newJString(projectId))
  result = call_822084791.call(path_822084792, query_822084793, nil, nil, nil)

var listFineTuningCheckpointPermissions* = Call_ListFineTuningCheckpointPermissions_822084782(
    name: "listFineTuningCheckpointPermissions", meth: HttpMethod.HttpGet,
    host: "api.openai.com", route: "/fine_tuning/checkpoints/{fine_tuned_model_checkpoint}/permissions",
    validator: validate_ListFineTuningCheckpointPermissions_822084783,
    base: "/v1", makeUrl: url_ListFineTuningCheckpointPermissions_822084784,
    schemes: {Scheme.Https})
type
  Call_DeleteFineTuningCheckpointPermission_822084803 = ref object of OpenApiRestCall_822083995
proc url_DeleteFineTuningCheckpointPermission_822084805(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "fine_tuned_model_checkpoint" in path,
         "`fine_tuned_model_checkpoint` is a required path parameter"
  assert "permission_id" in path, "`permission_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/fine_tuning/checkpoints/"),
                 (kind: VariableSegment, value: "fine_tuned_model_checkpoint"),
                 (kind: ConstantSegment, value: "/permissions/"),
                 (kind: VariableSegment, value: "permission_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DeleteFineTuningCheckpointPermission_822084804(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode;
    content: string = ""): JsonNode {.nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fine_tuned_model_checkpoint: JString (required)
  ##                              : The ID of the fine-tuned model checkpoint to delete a permission for.
  ## 
  ##   permission_id: JString (required)
  ##                : The ID of the fine-tuned model checkpoint permission to delete.
  ## 
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fine_tuned_model_checkpoint` field"
  var valid_822084806 = path.getOrDefault("fine_tuned_model_checkpoint")
  valid_822084806 = validateParameter(valid_822084806, JString, required = true,
                                      default = nil)
  if valid_822084806 != nil:
    section.add "fine_tuned_model_checkpoint", valid_822084806
  var valid_822084807 = path.getOrDefault("permission_id")
  valid_822084807 = validateParameter(valid_822084807, JString, required = true,
                                      default = nil)
  if valid_822084807 != nil:
    section.add "permission_id", valid_822084807
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084808: Call_DeleteFineTuningCheckpointPermission_822084803;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084808.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084808.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084808.makeUrl(scheme.get, call_822084808.host, call_822084808.base,
                                   call_822084808.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084808, uri, valid, content)

proc call*(call_822084809: Call_DeleteFineTuningCheckpointPermission_822084803;
           fineTunedModelCheckpoint: string; permissionId: string): Recallable =
  ## deleteFineTuningCheckpointPermission
  ##   fineTunedModelCheckpoint: string (required)
  ##                           : The ID of the fine-tuned model checkpoint to delete a permission for.
  ## 
  ##   permissionId: string (required)
  ##               : The ID of the fine-tuned model checkpoint permission to delete.
  ## 
  var path_822084810 = newJObject()
  add(path_822084810, "fine_tuned_model_checkpoint",
      newJString(fineTunedModelCheckpoint))
  add(path_822084810, "permission_id", newJString(permissionId))
  result = call_822084809.call(path_822084810, nil, nil, nil, nil)

var deleteFineTuningCheckpointPermission* = Call_DeleteFineTuningCheckpointPermission_822084803(
    name: "deleteFineTuningCheckpointPermission", meth: HttpMethod.HttpDelete,
    host: "api.openai.com", route: "/fine_tuning/checkpoints/{fine_tuned_model_checkpoint}/permissions/{permission_id}",
    validator: validate_DeleteFineTuningCheckpointPermission_822084804,
    base: "/v1", makeUrl: url_DeleteFineTuningCheckpointPermission_822084805,
    schemes: {Scheme.Https})
type
  Call_CreateFineTuningJob_822084820 = ref object of OpenApiRestCall_822083995
proc url_CreateFineTuningJob_822084822(protocol: Scheme; host: string;
                                       base: string; route: string;
                                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CreateFineTuningJob_822084821(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  if `==`(content, ""): assert body != nil, "body argument is necessary"
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822084824: Call_CreateFineTuningJob_822084820;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084824.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084824.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084824.makeUrl(scheme.get, call_822084824.host, call_822084824.base,
                                   call_822084824.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084824, uri, valid, content)

proc call*(call_822084825: Call_CreateFineTuningJob_822084820; body: JsonNode): Recallable =
  ## createFineTuningJob
  ##   body: JObject (required)
  var body_822084826 = newJObject()
  if body != nil:
    body_822084826 = body
  result = call_822084825.call(nil, nil, nil, nil, body_822084826)

var createFineTuningJob* = Call_CreateFineTuningJob_822084820(
    name: "createFineTuningJob", meth: HttpMethod.HttpPost,
    host: "api.openai.com", route: "/fine_tuning/jobs",
    validator: validate_CreateFineTuningJob_822084821, base: "/v1",
    makeUrl: url_CreateFineTuningJob_822084822, schemes: {Scheme.Https})
type
  Call_ListPaginatedFineTuningJobs_822084811 = ref object of OpenApiRestCall_822083995
proc url_ListPaginatedFineTuningJobs_822084813(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_ListPaginatedFineTuningJobs_822084812(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode;
    content: string = ""): JsonNode {.nosinks.} =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   after: JString
  ##        : Identifier for the last job from the previous pagination request.
  ##   metadata: JObject
  ##           : Optional metadata filter. To filter, use the syntax `metadata[k]=v`. Alternatively, set `metadata=null` to indicate no metadata.
  ## 
  ##   limit: JInt
  ##        : Number of fine-tuning jobs to retrieve.
  section = newJObject()
  var valid_822084814 = query.getOrDefault("after")
  valid_822084814 = validateParameter(valid_822084814, JString,
                                      required = false, default = nil)
  if valid_822084814 != nil:
    section.add "after", valid_822084814
  var valid_822084815 = query.getOrDefault("metadata")
  valid_822084815 = validateParameter(valid_822084815, JObject,
                                      required = false, default = nil)
  if valid_822084815 != nil:
    section.add "metadata", valid_822084815
  var valid_822084816 = query.getOrDefault("limit")
  valid_822084816 = validateParameter(valid_822084816, JInt, required = false,
                                      default = newJInt(20))
  if valid_822084816 != nil:
    section.add "limit", valid_822084816
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084817: Call_ListPaginatedFineTuningJobs_822084811;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084817.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084817.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084817.makeUrl(scheme.get, call_822084817.host, call_822084817.base,
                                   call_822084817.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084817, uri, valid, content)

proc call*(call_822084818: Call_ListPaginatedFineTuningJobs_822084811;
           after: string = ""; metadata: JsonNode = nil; limit: int = 20): Recallable =
  ## listPaginatedFineTuningJobs
  ##   after: string
  ##        : Identifier for the last job from the previous pagination request.
  ##   metadata: JObject
  ##           : Optional metadata filter. To filter, use the syntax `metadata[k]=v`. Alternatively, set `metadata=null` to indicate no metadata.
  ## 
  ##   limit: int
  ##        : Number of fine-tuning jobs to retrieve.
  var query_822084819 = newJObject()
  add(query_822084819, "after", newJString(after))
  if metadata != nil:
    query_822084819.add "metadata", metadata
  add(query_822084819, "limit", newJInt(limit))
  result = call_822084818.call(nil, query_822084819, nil, nil, nil)

var listPaginatedFineTuningJobs* = Call_ListPaginatedFineTuningJobs_822084811(
    name: "listPaginatedFineTuningJobs", meth: HttpMethod.HttpGet,
    host: "api.openai.com", route: "/fine_tuning/jobs",
    validator: validate_ListPaginatedFineTuningJobs_822084812, base: "/v1",
    makeUrl: url_ListPaginatedFineTuningJobs_822084813, schemes: {Scheme.Https})
type
  Call_RetrieveFineTuningJob_822084827 = ref object of OpenApiRestCall_822083995
proc url_RetrieveFineTuningJob_822084829(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "fine_tuning_job_id" in path,
         "`fine_tuning_job_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/fine_tuning/jobs/"),
                 (kind: VariableSegment, value: "fine_tuning_job_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RetrieveFineTuningJob_822084828(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fine_tuning_job_id: JString (required)
  ##                     : The ID of the fine-tuning job.
  ## 
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fine_tuning_job_id` field"
  var valid_822084830 = path.getOrDefault("fine_tuning_job_id")
  valid_822084830 = validateParameter(valid_822084830, JString, required = true,
                                      default = nil)
  if valid_822084830 != nil:
    section.add "fine_tuning_job_id", valid_822084830
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084831: Call_RetrieveFineTuningJob_822084827;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084831.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084831.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084831.makeUrl(scheme.get, call_822084831.host, call_822084831.base,
                                   call_822084831.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084831, uri, valid, content)

proc call*(call_822084832: Call_RetrieveFineTuningJob_822084827;
           fineTuningJobId: string): Recallable =
  ## retrieveFineTuningJob
  ##   fineTuningJobId: string (required)
  ##                  : The ID of the fine-tuning job.
  ## 
  var path_822084833 = newJObject()
  add(path_822084833, "fine_tuning_job_id", newJString(fineTuningJobId))
  result = call_822084832.call(path_822084833, nil, nil, nil, nil)

var retrieveFineTuningJob* = Call_RetrieveFineTuningJob_822084827(
    name: "retrieveFineTuningJob", meth: HttpMethod.HttpGet,
    host: "api.openai.com", route: "/fine_tuning/jobs/{fine_tuning_job_id}",
    validator: validate_RetrieveFineTuningJob_822084828, base: "/v1",
    makeUrl: url_RetrieveFineTuningJob_822084829, schemes: {Scheme.Https})
type
  Call_CancelFineTuningJob_822084834 = ref object of OpenApiRestCall_822083995
proc url_CancelFineTuningJob_822084836(protocol: Scheme; host: string;
                                       base: string; route: string;
                                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "fine_tuning_job_id" in path,
         "`fine_tuning_job_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/fine_tuning/jobs/"),
                 (kind: VariableSegment, value: "fine_tuning_job_id"),
                 (kind: ConstantSegment, value: "/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CancelFineTuningJob_822084835(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fine_tuning_job_id: JString (required)
  ##                     : The ID of the fine-tuning job to cancel.
  ## 
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fine_tuning_job_id` field"
  var valid_822084837 = path.getOrDefault("fine_tuning_job_id")
  valid_822084837 = validateParameter(valid_822084837, JString, required = true,
                                      default = nil)
  if valid_822084837 != nil:
    section.add "fine_tuning_job_id", valid_822084837
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084838: Call_CancelFineTuningJob_822084834;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084838.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084838.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084838.makeUrl(scheme.get, call_822084838.host, call_822084838.base,
                                   call_822084838.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084838, uri, valid, content)

proc call*(call_822084839: Call_CancelFineTuningJob_822084834;
           fineTuningJobId: string): Recallable =
  ## cancelFineTuningJob
  ##   fineTuningJobId: string (required)
  ##                  : The ID of the fine-tuning job to cancel.
  ## 
  var path_822084840 = newJObject()
  add(path_822084840, "fine_tuning_job_id", newJString(fineTuningJobId))
  result = call_822084839.call(path_822084840, nil, nil, nil, nil)

var cancelFineTuningJob* = Call_CancelFineTuningJob_822084834(
    name: "cancelFineTuningJob", meth: HttpMethod.HttpPost,
    host: "api.openai.com",
    route: "/fine_tuning/jobs/{fine_tuning_job_id}/cancel",
    validator: validate_CancelFineTuningJob_822084835, base: "/v1",
    makeUrl: url_CancelFineTuningJob_822084836, schemes: {Scheme.Https})
type
  Call_ListFineTuningJobCheckpoints_822084841 = ref object of OpenApiRestCall_822083995
proc url_ListFineTuningJobCheckpoints_822084843(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "fine_tuning_job_id" in path,
         "`fine_tuning_job_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/fine_tuning/jobs/"),
                 (kind: VariableSegment, value: "fine_tuning_job_id"),
                 (kind: ConstantSegment, value: "/checkpoints")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ListFineTuningJobCheckpoints_822084842(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode;
    content: string = ""): JsonNode {.nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fine_tuning_job_id: JString (required)
  ##                     : The ID of the fine-tuning job to get checkpoints for.
  ## 
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fine_tuning_job_id` field"
  var valid_822084844 = path.getOrDefault("fine_tuning_job_id")
  valid_822084844 = validateParameter(valid_822084844, JString, required = true,
                                      default = nil)
  if valid_822084844 != nil:
    section.add "fine_tuning_job_id", valid_822084844
  result.add "path", section
  ## parameters in `query` object:
  ##   after: JString
  ##        : Identifier for the last checkpoint ID from the previous pagination request.
  ##   limit: JInt
  ##        : Number of checkpoints to retrieve.
  section = newJObject()
  var valid_822084845 = query.getOrDefault("after")
  valid_822084845 = validateParameter(valid_822084845, JString,
                                      required = false, default = nil)
  if valid_822084845 != nil:
    section.add "after", valid_822084845
  var valid_822084846 = query.getOrDefault("limit")
  valid_822084846 = validateParameter(valid_822084846, JInt, required = false,
                                      default = newJInt(10))
  if valid_822084846 != nil:
    section.add "limit", valid_822084846
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084847: Call_ListFineTuningJobCheckpoints_822084841;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084847.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084847.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084847.makeUrl(scheme.get, call_822084847.host, call_822084847.base,
                                   call_822084847.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084847, uri, valid, content)

proc call*(call_822084848: Call_ListFineTuningJobCheckpoints_822084841;
           fineTuningJobId: string; after: string = ""; limit: int = 10): Recallable =
  ## listFineTuningJobCheckpoints
  ##   after: string
  ##        : Identifier for the last checkpoint ID from the previous pagination request.
  ##   fineTuningJobId: string (required)
  ##                  : The ID of the fine-tuning job to get checkpoints for.
  ## 
  ##   limit: int
  ##        : Number of checkpoints to retrieve.
  var path_822084849 = newJObject()
  var query_822084850 = newJObject()
  add(query_822084850, "after", newJString(after))
  add(path_822084849, "fine_tuning_job_id", newJString(fineTuningJobId))
  add(query_822084850, "limit", newJInt(limit))
  result = call_822084848.call(path_822084849, query_822084850, nil, nil, nil)

var listFineTuningJobCheckpoints* = Call_ListFineTuningJobCheckpoints_822084841(
    name: "listFineTuningJobCheckpoints", meth: HttpMethod.HttpGet,
    host: "api.openai.com",
    route: "/fine_tuning/jobs/{fine_tuning_job_id}/checkpoints",
    validator: validate_ListFineTuningJobCheckpoints_822084842, base: "/v1",
    makeUrl: url_ListFineTuningJobCheckpoints_822084843, schemes: {Scheme.Https})
type
  Call_ListFineTuningEvents_822084851 = ref object of OpenApiRestCall_822083995
proc url_ListFineTuningEvents_822084853(protocol: Scheme; host: string;
                                        base: string; route: string;
                                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "fine_tuning_job_id" in path,
         "`fine_tuning_job_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/fine_tuning/jobs/"),
                 (kind: VariableSegment, value: "fine_tuning_job_id"),
                 (kind: ConstantSegment, value: "/events")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ListFineTuningEvents_822084852(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fine_tuning_job_id: JString (required)
  ##                     : The ID of the fine-tuning job to get events for.
  ## 
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fine_tuning_job_id` field"
  var valid_822084854 = path.getOrDefault("fine_tuning_job_id")
  valid_822084854 = validateParameter(valid_822084854, JString, required = true,
                                      default = nil)
  if valid_822084854 != nil:
    section.add "fine_tuning_job_id", valid_822084854
  result.add "path", section
  ## parameters in `query` object:
  ##   after: JString
  ##        : Identifier for the last event from the previous pagination request.
  ##   limit: JInt
  ##        : Number of events to retrieve.
  section = newJObject()
  var valid_822084855 = query.getOrDefault("after")
  valid_822084855 = validateParameter(valid_822084855, JString,
                                      required = false, default = nil)
  if valid_822084855 != nil:
    section.add "after", valid_822084855
  var valid_822084856 = query.getOrDefault("limit")
  valid_822084856 = validateParameter(valid_822084856, JInt, required = false,
                                      default = newJInt(20))
  if valid_822084856 != nil:
    section.add "limit", valid_822084856
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084857: Call_ListFineTuningEvents_822084851;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084857.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084857.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084857.makeUrl(scheme.get, call_822084857.host, call_822084857.base,
                                   call_822084857.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084857, uri, valid, content)

proc call*(call_822084858: Call_ListFineTuningEvents_822084851;
           fineTuningJobId: string; after: string = ""; limit: int = 20): Recallable =
  ## listFineTuningEvents
  ##   after: string
  ##        : Identifier for the last event from the previous pagination request.
  ##   fineTuningJobId: string (required)
  ##                  : The ID of the fine-tuning job to get events for.
  ## 
  ##   limit: int
  ##        : Number of events to retrieve.
  var path_822084859 = newJObject()
  var query_822084860 = newJObject()
  add(query_822084860, "after", newJString(after))
  add(path_822084859, "fine_tuning_job_id", newJString(fineTuningJobId))
  add(query_822084860, "limit", newJInt(limit))
  result = call_822084858.call(path_822084859, query_822084860, nil, nil, nil)

var listFineTuningEvents* = Call_ListFineTuningEvents_822084851(
    name: "listFineTuningEvents", meth: HttpMethod.HttpGet,
    host: "api.openai.com",
    route: "/fine_tuning/jobs/{fine_tuning_job_id}/events",
    validator: validate_ListFineTuningEvents_822084852, base: "/v1",
    makeUrl: url_ListFineTuningEvents_822084853, schemes: {Scheme.Https})
type
  Call_PauseFineTuningJob_822084861 = ref object of OpenApiRestCall_822083995
proc url_PauseFineTuningJob_822084863(protocol: Scheme; host: string;
                                      base: string; route: string;
                                      path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "fine_tuning_job_id" in path,
         "`fine_tuning_job_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/fine_tuning/jobs/"),
                 (kind: VariableSegment, value: "fine_tuning_job_id"),
                 (kind: ConstantSegment, value: "/pause")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_PauseFineTuningJob_822084862(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fine_tuning_job_id: JString (required)
  ##                     : The ID of the fine-tuning job to pause.
  ## 
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fine_tuning_job_id` field"
  var valid_822084864 = path.getOrDefault("fine_tuning_job_id")
  valid_822084864 = validateParameter(valid_822084864, JString, required = true,
                                      default = nil)
  if valid_822084864 != nil:
    section.add "fine_tuning_job_id", valid_822084864
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084865: Call_PauseFineTuningJob_822084861;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084865.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084865.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084865.makeUrl(scheme.get, call_822084865.host, call_822084865.base,
                                   call_822084865.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084865, uri, valid, content)

proc call*(call_822084866: Call_PauseFineTuningJob_822084861;
           fineTuningJobId: string): Recallable =
  ## pauseFineTuningJob
  ##   fineTuningJobId: string (required)
  ##                  : The ID of the fine-tuning job to pause.
  ## 
  var path_822084867 = newJObject()
  add(path_822084867, "fine_tuning_job_id", newJString(fineTuningJobId))
  result = call_822084866.call(path_822084867, nil, nil, nil, nil)

var pauseFineTuningJob* = Call_PauseFineTuningJob_822084861(
    name: "pauseFineTuningJob", meth: HttpMethod.HttpPost,
    host: "api.openai.com",
    route: "/fine_tuning/jobs/{fine_tuning_job_id}/pause",
    validator: validate_PauseFineTuningJob_822084862, base: "/v1",
    makeUrl: url_PauseFineTuningJob_822084863, schemes: {Scheme.Https})
type
  Call_ResumeFineTuningJob_822084868 = ref object of OpenApiRestCall_822083995
proc url_ResumeFineTuningJob_822084870(protocol: Scheme; host: string;
                                       base: string; route: string;
                                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "fine_tuning_job_id" in path,
         "`fine_tuning_job_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/fine_tuning/jobs/"),
                 (kind: VariableSegment, value: "fine_tuning_job_id"),
                 (kind: ConstantSegment, value: "/resume")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ResumeFineTuningJob_822084869(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fine_tuning_job_id: JString (required)
  ##                     : The ID of the fine-tuning job to resume.
  ## 
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `fine_tuning_job_id` field"
  var valid_822084871 = path.getOrDefault("fine_tuning_job_id")
  valid_822084871 = validateParameter(valid_822084871, JString, required = true,
                                      default = nil)
  if valid_822084871 != nil:
    section.add "fine_tuning_job_id", valid_822084871
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084872: Call_ResumeFineTuningJob_822084868;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
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

proc call*(call_822084873: Call_ResumeFineTuningJob_822084868;
           fineTuningJobId: string): Recallable =
  ## resumeFineTuningJob
  ##   fineTuningJobId: string (required)
  ##                  : The ID of the fine-tuning job to resume.
  ## 
  var path_822084874 = newJObject()
  add(path_822084874, "fine_tuning_job_id", newJString(fineTuningJobId))
  result = call_822084873.call(path_822084874, nil, nil, nil, nil)

var resumeFineTuningJob* = Call_ResumeFineTuningJob_822084868(
    name: "resumeFineTuningJob", meth: HttpMethod.HttpPost,
    host: "api.openai.com",
    route: "/fine_tuning/jobs/{fine_tuning_job_id}/resume",
    validator: validate_ResumeFineTuningJob_822084869, base: "/v1",
    makeUrl: url_ResumeFineTuningJob_822084870, schemes: {Scheme.Https})
type
  Call_CreateImageEdit_822084875 = ref object of OpenApiRestCall_822083995
proc url_CreateImageEdit_822084877(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode;
                                   query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CreateImageEdit_822084876(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  ## parameters in `formData` object:
  ##   output_format: JString
  ##                : The format in which the generated images are returned. This parameter is
  ## only supported for `gpt-image-1`. Must be one of `png`, `jpeg`, or `webp`.
  ## The default value is `png`.
  ## 
  ##   input_fidelity: JString
  ##                 : Control how much effort the model will exert to match the style and features,
  ## especially facial features, of input images. This parameter is only supported
  ## for `gpt-image-1`. Supports `high` and `low`. Defaults to `low`.
  ## 
  ##   output_compression: JInt
  ##                     : The compression level (0-100%) for the generated images. This parameter 
  ## is only supported for `gpt-image-1` with the `webp` or `jpeg` output 
  ## formats, and defaults to 100.
  ## 
  ##   response_format: JString
  ##                  : The format in which the generated images are returned. Must be one of `url` or `b64_json`. URLs are only valid for 60 minutes after the image has been generated. This parameter is only supported for `dall-e-2`, as `gpt-image-1` will always return base64-encoded images.
  ##   size: JString
  ##       : The size of the generated images. Must be one of `1024x1024`, `1536x1024` (landscape), `1024x1536` (portrait), or `auto` (default value) for `gpt-image-1`, and one of `256x256`, `512x512`, or `1024x1024` for `dall-e-2`.
  ##   model: JString
  ##        : The model to use for image generation. Only `dall-e-2` and `gpt-image-1` are supported. Defaults to `dall-e-2` unless a parameter specific to `gpt-image-1` is used.
  ##   prompt: JString (required)
  ##         : A text description of the desired image(s). The maximum length is 1000 characters for `dall-e-2`, and 32000 characters for `gpt-image-1`.
  ##   mask: JString
  ##       : An additional image whose fully transparent areas (e.g. where alpha is zero) indicate where `image` should be edited. If there are multiple images provided, the mask will be applied on the first image. Must be a valid PNG file, less than 4MB, and have the same dimensions as `image`.
  ##   quality: JString
  ##          : The quality of the image that will be generated. `high`, `medium` and `low` are only supported for `gpt-image-1`. `dall-e-2` only supports `standard` quality. Defaults to `auto`.
  ## 
  ##   n: JInt
  ##    : The number of images to generate. Must be between 1 and 10.
  ##   user: JString
  ##       : A unique identifier representing your end-user, which can help OpenAI to monitor and detect abuse. [Learn more](/docs/guides/safety-best-practices#end-user-ids).
  ## 
  ##   stream: JBool
  ##         : Edit the image in streaming mode. Defaults to `false`. See the 
  ## [Image generation guide](/docs/guides/image-generation) for more information.
  ## 
  ##   image: JObject (required)
  ##        : The image(s) to edit. Must be a supported image file or an array of images.
  ## 
  ## For `gpt-image-1`, each image should be a `png`, `webp`, or `jpg` file less 
  ## than 50MB. You can provide up to 16 images.
  ## 
  ## For `dall-e-2`, you can only provide one image, and it should be a square 
  ## `png` file less than 4MB.
  ## 
  ##   background: JString
  ##             : Allows to set transparency for the background of the generated image(s). 
  ## This parameter is only supported for `gpt-image-1`. Must be one of 
  ## `transparent`, `opaque` or `auto` (default value). When `auto` is used, the 
  ## model will automatically determine the best background for the image.
  ## 
  ## If `transparent`, the output format needs to support transparency, so it 
  ## should be set to either `png` (default value) or `webp`.
  ## 
  ##   partial_images: JInt
  ##                 : The number of partial images to generate. This parameter is used for
  ## streaming responses that return partial images. Value must be between 0 and 3.
  ## When set to 0, the response will be a single image sent in one streaming event.
  ## 
  section = newJObject()
  var valid_822084878 = formData.getOrDefault("output_format")
  valid_822084878 = validateParameter(valid_822084878, JString,
                                      required = false,
                                      default = newJString("png"))
  if valid_822084878 != nil:
    section.add "output_format", valid_822084878
  var valid_822084879 = formData.getOrDefault("input_fidelity")
  valid_822084879 = validateParameter(valid_822084879, JString,
                                      required = false,
                                      default = newJString("low"))
  if valid_822084879 != nil:
    section.add "input_fidelity", valid_822084879
  var valid_822084880 = formData.getOrDefault("output_compression")
  valid_822084880 = validateParameter(valid_822084880, JInt, required = false,
                                      default = newJInt(100))
  if valid_822084880 != nil:
    section.add "output_compression", valid_822084880
  var valid_822084881 = formData.getOrDefault("response_format")
  valid_822084881 = validateParameter(valid_822084881, JString,
                                      required = false,
                                      default = newJString("url"))
  if valid_822084881 != nil:
    section.add "response_format", valid_822084881
  var valid_822084882 = formData.getOrDefault("size")
  valid_822084882 = validateParameter(valid_822084882, JString,
                                      required = false,
                                      default = newJString("1024x1024"))
  if valid_822084882 != nil:
    section.add "size", valid_822084882
  var valid_822084883 = formData.getOrDefault("model")
  valid_822084883 = validateParameter(valid_822084883, JString,
                                      required = false,
                                      default = newJString("dall-e-2"))
  if valid_822084883 != nil:
    section.add "model", valid_822084883
  assert formData != nil,
         "formData argument is necessary due to required `prompt` field"
  var valid_822084884 = formData.getOrDefault("prompt")
  valid_822084884 = validateParameter(valid_822084884, JString, required = true,
                                      default = nil)
  if valid_822084884 != nil:
    section.add "prompt", valid_822084884
  var valid_822084885 = formData.getOrDefault("mask")
  valid_822084885 = validateParameter(valid_822084885, JString,
                                      required = false, default = nil)
  if valid_822084885 != nil:
    section.add "mask", valid_822084885
  var valid_822084886 = formData.getOrDefault("quality")
  valid_822084886 = validateParameter(valid_822084886, JString,
                                      required = false,
                                      default = newJString("auto"))
  if valid_822084886 != nil:
    section.add "quality", valid_822084886
  var valid_822084887 = formData.getOrDefault("n")
  valid_822084887 = validateParameter(valid_822084887, JInt, required = false,
                                      default = newJInt(1))
  if valid_822084887 != nil:
    section.add "n", valid_822084887
  var valid_822084888 = formData.getOrDefault("user")
  valid_822084888 = validateParameter(valid_822084888, JString,
                                      required = false, default = nil)
  if valid_822084888 != nil:
    section.add "user", valid_822084888
  var valid_822084889 = formData.getOrDefault("stream")
  valid_822084889 = validateParameter(valid_822084889, JBool, required = false,
                                      default = newJBool(false))
  if valid_822084889 != nil:
    section.add "stream", valid_822084889
  var valid_822084890 = formData.getOrDefault("image")
  valid_822084890 = validateParameter(valid_822084890, JObject, required = true,
                                      default = nil)
  if valid_822084890 != nil:
    section.add "image", valid_822084890
  var valid_822084891 = formData.getOrDefault("background")
  valid_822084891 = validateParameter(valid_822084891, JString,
                                      required = false,
                                      default = newJString("auto"))
  if valid_822084891 != nil:
    section.add "background", valid_822084891
  var valid_822084892 = formData.getOrDefault("partial_images")
  valid_822084892 = validateParameter(valid_822084892, JInt, required = false,
                                      default = newJInt(0))
  if valid_822084892 != nil:
    section.add "partial_images", valid_822084892
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084893: Call_CreateImageEdit_822084875; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084893.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084893.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084893.makeUrl(scheme.get, call_822084893.host, call_822084893.base,
                                   call_822084893.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084893, uri, valid, content)

proc call*(call_822084894: Call_CreateImageEdit_822084875; prompt: string;
           image: JsonNode; outputFormat: string = "png";
           inputFidelity: string = "low"; outputCompression: int = 100;
           responseFormat: string = "url"; size: string = "1024x1024";
           model: string = "dall-e-2"; mask: string = "";
           quality: string = "auto"; n: int = 1; user: string = "";
           stream: bool = false; background: string = "auto";
           partialImages: int = 0): Recallable =
  ## createImageEdit
  ##   outputFormat: string
  ##               : The format in which the generated images are returned. This parameter is
  ## only supported for `gpt-image-1`. Must be one of `png`, `jpeg`, or `webp`.
  ## The default value is `png`.
  ## 
  ##   inputFidelity: string
  ##                : Control how much effort the model will exert to match the style and features,
  ## especially facial features, of input images. This parameter is only supported
  ## for `gpt-image-1`. Supports `high` and `low`. Defaults to `low`.
  ## 
  ##   outputCompression: int
  ##                    : The compression level (0-100%) for the generated images. This parameter 
  ## is only supported for `gpt-image-1` with the `webp` or `jpeg` output 
  ## formats, and defaults to 100.
  ## 
  ##   responseFormat: string
  ##                 : The format in which the generated images are returned. Must be one of `url` or `b64_json`. URLs are only valid for 60 minutes after the image has been generated. This parameter is only supported for `dall-e-2`, as `gpt-image-1` will always return base64-encoded images.
  ##   size: string
  ##       : The size of the generated images. Must be one of `1024x1024`, `1536x1024` (landscape), `1024x1536` (portrait), or `auto` (default value) for `gpt-image-1`, and one of `256x256`, `512x512`, or `1024x1024` for `dall-e-2`.
  ##   model: string
  ##        : The model to use for image generation. Only `dall-e-2` and `gpt-image-1` are supported. Defaults to `dall-e-2` unless a parameter specific to `gpt-image-1` is used.
  ##   prompt: string (required)
  ##         : A text description of the desired image(s). The maximum length is 1000 characters for `dall-e-2`, and 32000 characters for `gpt-image-1`.
  ##   mask: string
  ##       : An additional image whose fully transparent areas (e.g. where alpha is zero) indicate where `image` should be edited. If there are multiple images provided, the mask will be applied on the first image. Must be a valid PNG file, less than 4MB, and have the same dimensions as `image`.
  ##   quality: string
  ##          : The quality of the image that will be generated. `high`, `medium` and `low` are only supported for `gpt-image-1`. `dall-e-2` only supports `standard` quality. Defaults to `auto`.
  ## 
  ##   n: int
  ##    : The number of images to generate. Must be between 1 and 10.
  ##   user: string
  ##       : A unique identifier representing your end-user, which can help OpenAI to monitor and detect abuse. [Learn more](/docs/guides/safety-best-practices#end-user-ids).
  ## 
  ##   stream: bool
  ##         : Edit the image in streaming mode. Defaults to `false`. See the 
  ## [Image generation guide](/docs/guides/image-generation) for more information.
  ## 
  ##   image: JObject (required)
  ##        : The image(s) to edit. Must be a supported image file or an array of images.
  ## 
  ## For `gpt-image-1`, each image should be a `png`, `webp`, or `jpg` file less 
  ## than 50MB. You can provide up to 16 images.
  ## 
  ## For `dall-e-2`, you can only provide one image, and it should be a square 
  ## `png` file less than 4MB.
  ## 
  ##   background: string
  ##             : Allows to set transparency for the background of the generated image(s). 
  ## This parameter is only supported for `gpt-image-1`. Must be one of 
  ## `transparent`, `opaque` or `auto` (default value). When `auto` is used, the 
  ## model will automatically determine the best background for the image.
  ## 
  ## If `transparent`, the output format needs to support transparency, so it 
  ## should be set to either `png` (default value) or `webp`.
  ## 
  ##   partialImages: int
  ##                : The number of partial images to generate. This parameter is used for
  ## streaming responses that return partial images. Value must be between 0 and 3.
  ## When set to 0, the response will be a single image sent in one streaming event.
  ## 
  var formData_822084895 = newJObject()
  add(formData_822084895, "output_format", newJString(outputFormat))
  add(formData_822084895, "input_fidelity", newJString(inputFidelity))
  add(formData_822084895, "output_compression", newJInt(outputCompression))
  add(formData_822084895, "response_format", newJString(responseFormat))
  add(formData_822084895, "size", newJString(size))
  add(formData_822084895, "model", newJString(model))
  add(formData_822084895, "prompt", newJString(prompt))
  add(formData_822084895, "mask", newJString(mask))
  add(formData_822084895, "quality", newJString(quality))
  add(formData_822084895, "n", newJInt(n))
  add(formData_822084895, "user", newJString(user))
  add(formData_822084895, "stream", newJBool(stream))
  if image != nil:
    formData_822084895.add "image", image
  add(formData_822084895, "background", newJString(background))
  add(formData_822084895, "partial_images", newJInt(partialImages))
  result = call_822084894.call(nil, nil, nil, formData_822084895, nil)

var createImageEdit* = Call_CreateImageEdit_822084875(name: "createImageEdit",
    meth: HttpMethod.HttpPost, host: "api.openai.com", route: "/images/edits",
    validator: validate_CreateImageEdit_822084876, base: "/v1",
    makeUrl: url_CreateImageEdit_822084877, schemes: {Scheme.Https})
type
  Call_CreateImage_822084896 = ref object of OpenApiRestCall_822083995
proc url_CreateImage_822084898(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CreateImage_822084897(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  if `==`(content, ""): assert body != nil, "body argument is necessary"
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822084900: Call_CreateImage_822084896; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084900.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084900.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084900.makeUrl(scheme.get, call_822084900.host, call_822084900.base,
                                   call_822084900.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084900, uri, valid, content)

proc call*(call_822084901: Call_CreateImage_822084896; body: JsonNode): Recallable =
  ## createImage
  ##   body: JObject (required)
  var body_822084902 = newJObject()
  if body != nil:
    body_822084902 = body
  result = call_822084901.call(nil, nil, nil, nil, body_822084902)

var createImage* = Call_CreateImage_822084896(name: "createImage",
    meth: HttpMethod.HttpPost, host: "api.openai.com",
    route: "/images/generations", validator: validate_CreateImage_822084897,
    base: "/v1", makeUrl: url_CreateImage_822084898, schemes: {Scheme.Https})
type
  Call_CreateImageVariation_822084903 = ref object of OpenApiRestCall_822083995
proc url_CreateImageVariation_822084905(protocol: Scheme; host: string;
                                        base: string; route: string;
                                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CreateImageVariation_822084904(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  ## parameters in `formData` object:
  ##   response_format: JString
  ##                  : The format in which the generated images are returned. Must be one of `url` or `b64_json`. URLs are only valid for 60 minutes after the image has been generated.
  ##   size: JString
  ##       : The size of the generated images. Must be one of `256x256`, `512x512`, or `1024x1024`.
  ##   model: JString
  ##        : The model to use for image generation. Only `dall-e-2` is supported at this time.
  ##   n: JInt
  ##    : The number of images to generate. Must be between 1 and 10.
  ##   user: JString
  ##       : A unique identifier representing your end-user, which can help OpenAI to monitor and detect abuse. [Learn more](/docs/guides/safety-best-practices#end-user-ids).
  ## 
  ##   image: JString (required)
  ##        : The image to use as the basis for the variation(s). Must be a valid PNG file, less than 4MB, and square.
  section = newJObject()
  var valid_822084906 = formData.getOrDefault("response_format")
  valid_822084906 = validateParameter(valid_822084906, JString,
                                      required = false,
                                      default = newJString("url"))
  if valid_822084906 != nil:
    section.add "response_format", valid_822084906
  var valid_822084907 = formData.getOrDefault("size")
  valid_822084907 = validateParameter(valid_822084907, JString,
                                      required = false,
                                      default = newJString("1024x1024"))
  if valid_822084907 != nil:
    section.add "size", valid_822084907
  var valid_822084908 = formData.getOrDefault("model")
  valid_822084908 = validateParameter(valid_822084908, JString,
                                      required = false,
                                      default = newJString("dall-e-2"))
  if valid_822084908 != nil:
    section.add "model", valid_822084908
  var valid_822084909 = formData.getOrDefault("n")
  valid_822084909 = validateParameter(valid_822084909, JInt, required = false,
                                      default = newJInt(1))
  if valid_822084909 != nil:
    section.add "n", valid_822084909
  var valid_822084910 = formData.getOrDefault("user")
  valid_822084910 = validateParameter(valid_822084910, JString,
                                      required = false, default = nil)
  if valid_822084910 != nil:
    section.add "user", valid_822084910
  assert formData != nil,
         "formData argument is necessary due to required `image` field"
  var valid_822084911 = formData.getOrDefault("image")
  valid_822084911 = validateParameter(valid_822084911, JString, required = true,
                                      default = nil)
  if valid_822084911 != nil:
    section.add "image", valid_822084911
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084912: Call_CreateImageVariation_822084903;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084912.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084912.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084912.makeUrl(scheme.get, call_822084912.host, call_822084912.base,
                                   call_822084912.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084912, uri, valid, content)

proc call*(call_822084913: Call_CreateImageVariation_822084903; image: string;
           responseFormat: string = "url"; size: string = "1024x1024";
           model: string = "dall-e-2"; n: int = 1; user: string = ""): Recallable =
  ## createImageVariation
  ##   responseFormat: string
  ##                 : The format in which the generated images are returned. Must be one of `url` or `b64_json`. URLs are only valid for 60 minutes after the image has been generated.
  ##   size: string
  ##       : The size of the generated images. Must be one of `256x256`, `512x512`, or `1024x1024`.
  ##   model: string
  ##        : The model to use for image generation. Only `dall-e-2` is supported at this time.
  ##   n: int
  ##    : The number of images to generate. Must be between 1 and 10.
  ##   user: string
  ##       : A unique identifier representing your end-user, which can help OpenAI to monitor and detect abuse. [Learn more](/docs/guides/safety-best-practices#end-user-ids).
  ## 
  ##   image: string (required)
  ##        : The image to use as the basis for the variation(s). Must be a valid PNG file, less than 4MB, and square.
  var formData_822084914 = newJObject()
  add(formData_822084914, "response_format", newJString(responseFormat))
  add(formData_822084914, "size", newJString(size))
  add(formData_822084914, "model", newJString(model))
  add(formData_822084914, "n", newJInt(n))
  add(formData_822084914, "user", newJString(user))
  add(formData_822084914, "image", newJString(image))
  result = call_822084913.call(nil, nil, nil, formData_822084914, nil)

var createImageVariation* = Call_CreateImageVariation_822084903(
    name: "createImageVariation", meth: HttpMethod.HttpPost,
    host: "api.openai.com", route: "/images/variations",
    validator: validate_CreateImageVariation_822084904, base: "/v1",
    makeUrl: url_CreateImageVariation_822084905, schemes: {Scheme.Https})
type
  Call_ListModels_822084915 = ref object of OpenApiRestCall_822083995
proc url_ListModels_822084917(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_ListModels_822084916(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084918: Call_ListModels_822084915; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084918.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084918.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084918.makeUrl(scheme.get, call_822084918.host, call_822084918.base,
                                   call_822084918.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084918, uri, valid, content)

proc call*(call_822084919: Call_ListModels_822084915): Recallable =
  ## listModels
  result = call_822084919.call(nil, nil, nil, nil, nil)

var listModels* = Call_ListModels_822084915(name: "listModels",
    meth: HttpMethod.HttpGet, host: "api.openai.com", route: "/models",
    validator: validate_ListModels_822084916, base: "/v1",
    makeUrl: url_ListModels_822084917, schemes: {Scheme.Https})
type
  Call_DeleteModel_822084927 = ref object of OpenApiRestCall_822083995
proc url_DeleteModel_822084929(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "model" in path, "`model` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/models/"),
                 (kind: VariableSegment, value: "model")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DeleteModel_822084928(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   model: JString (required)
  ##        : The model to delete
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `model` field"
  var valid_822084930 = path.getOrDefault("model")
  valid_822084930 = validateParameter(valid_822084930, JString, required = true,
                                      default = nil)
  if valid_822084930 != nil:
    section.add "model", valid_822084930
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084931: Call_DeleteModel_822084927; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084931.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084931.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084931.makeUrl(scheme.get, call_822084931.host, call_822084931.base,
                                   call_822084931.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084931, uri, valid, content)

proc call*(call_822084932: Call_DeleteModel_822084927; model: string): Recallable =
  ## deleteModel
  ##   model: string (required)
  ##        : The model to delete
  var path_822084933 = newJObject()
  add(path_822084933, "model", newJString(model))
  result = call_822084932.call(path_822084933, nil, nil, nil, nil)

var deleteModel* = Call_DeleteModel_822084927(name: "deleteModel",
    meth: HttpMethod.HttpDelete, host: "api.openai.com",
    route: "/models/{model}", validator: validate_DeleteModel_822084928,
    base: "/v1", makeUrl: url_DeleteModel_822084929, schemes: {Scheme.Https})
type
  Call_RetrieveModel_822084920 = ref object of OpenApiRestCall_822083995
proc url_RetrieveModel_822084922(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "model" in path, "`model` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/models/"),
                 (kind: VariableSegment, value: "model")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RetrieveModel_822084921(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   model: JString (required)
  ##        : The ID of the model to use for this request
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `model` field"
  var valid_822084923 = path.getOrDefault("model")
  valid_822084923 = validateParameter(valid_822084923, JString, required = true,
                                      default = nil)
  if valid_822084923 != nil:
    section.add "model", valid_822084923
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084924: Call_RetrieveModel_822084920; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084924.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084924.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084924.makeUrl(scheme.get, call_822084924.host, call_822084924.base,
                                   call_822084924.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084924, uri, valid, content)

proc call*(call_822084925: Call_RetrieveModel_822084920; model: string): Recallable =
  ## retrieveModel
  ##   model: string (required)
  ##        : The ID of the model to use for this request
  var path_822084926 = newJObject()
  add(path_822084926, "model", newJString(model))
  result = call_822084925.call(path_822084926, nil, nil, nil, nil)

var retrieveModel* = Call_RetrieveModel_822084920(name: "retrieveModel",
    meth: HttpMethod.HttpGet, host: "api.openai.com", route: "/models/{model}",
    validator: validate_RetrieveModel_822084921, base: "/v1",
    makeUrl: url_RetrieveModel_822084922, schemes: {Scheme.Https})
type
  Call_CreateModeration_822084934 = ref object of OpenApiRestCall_822083995
proc url_CreateModeration_822084936(protocol: Scheme; host: string;
                                    base: string; route: string; path: JsonNode;
                                    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CreateModeration_822084935(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  if `==`(content, ""): assert body != nil, "body argument is necessary"
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822084938: Call_CreateModeration_822084934;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084938.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084938.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084938.makeUrl(scheme.get, call_822084938.host, call_822084938.base,
                                   call_822084938.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084938, uri, valid, content)

proc call*(call_822084939: Call_CreateModeration_822084934; body: JsonNode): Recallable =
  ## createModeration
  ##   body: JObject (required)
  var body_822084940 = newJObject()
  if body != nil:
    body_822084940 = body
  result = call_822084939.call(nil, nil, nil, nil, body_822084940)

var createModeration* = Call_CreateModeration_822084934(
    name: "createModeration", meth: HttpMethod.HttpPost, host: "api.openai.com",
    route: "/moderations", validator: validate_CreateModeration_822084935,
    base: "/v1", makeUrl: url_CreateModeration_822084936,
    schemes: {Scheme.Https})
type
  Call_AdminApiKeysCreate_822084950 = ref object of OpenApiRestCall_822083995
proc url_AdminApiKeysCreate_822084952(protocol: Scheme; host: string;
                                      base: string; route: string;
                                      path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_AdminApiKeysCreate_822084951(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Create a new admin-level API key for the organization.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  if `==`(content, ""): assert body != nil, "body argument is necessary"
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822084954: Call_AdminApiKeysCreate_822084950;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Create a new admin-level API key for the organization.
  ## 
  let valid = call_822084954.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084954.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084954.makeUrl(scheme.get, call_822084954.host, call_822084954.base,
                                   call_822084954.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084954, uri, valid, content)

proc call*(call_822084955: Call_AdminApiKeysCreate_822084950; body: JsonNode): Recallable =
  ## adminApiKeysCreate
  ## Create a new admin-level API key for the organization.
  ##   body: JObject (required)
  var body_822084956 = newJObject()
  if body != nil:
    body_822084956 = body
  result = call_822084955.call(nil, nil, nil, nil, body_822084956)

var adminApiKeysCreate* = Call_AdminApiKeysCreate_822084950(
    name: "adminApiKeysCreate", meth: HttpMethod.HttpPost,
    host: "api.openai.com", route: "/organization/admin_api_keys",
    validator: validate_AdminApiKeysCreate_822084951, base: "/v1",
    makeUrl: url_AdminApiKeysCreate_822084952, schemes: {Scheme.Https})
type
  Call_AdminApiKeysList_822084941 = ref object of OpenApiRestCall_822083995
proc url_AdminApiKeysList_822084943(protocol: Scheme; host: string;
                                    base: string; route: string; path: JsonNode;
                                    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_AdminApiKeysList_822084942(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Retrieve a paginated list of organization admin API keys.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   after: JString
  ##        : Return keys with IDs that come after this ID in the pagination order.
  ##   order: JString
  ##        : Order results by creation time, ascending or descending.
  ##   limit: JInt
  ##        : Maximum number of keys to return.
  section = newJObject()
  var valid_822084944 = query.getOrDefault("after")
  valid_822084944 = validateParameter(valid_822084944, JString,
                                      required = false, default = nil)
  if valid_822084944 != nil:
    section.add "after", valid_822084944
  var valid_822084945 = query.getOrDefault("order")
  valid_822084945 = validateParameter(valid_822084945, JString,
                                      required = false,
                                      default = newJString("asc"))
  if valid_822084945 != nil:
    section.add "order", valid_822084945
  var valid_822084946 = query.getOrDefault("limit")
  valid_822084946 = validateParameter(valid_822084946, JInt, required = false,
                                      default = newJInt(20))
  if valid_822084946 != nil:
    section.add "limit", valid_822084946
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084947: Call_AdminApiKeysList_822084941;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Retrieve a paginated list of organization admin API keys.
  ## 
  let valid = call_822084947.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084947.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084947.makeUrl(scheme.get, call_822084947.host, call_822084947.base,
                                   call_822084947.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084947, uri, valid, content)

proc call*(call_822084948: Call_AdminApiKeysList_822084941; after: string = "";
           order: string = "asc"; limit: int = 20): Recallable =
  ## adminApiKeysList
  ## Retrieve a paginated list of organization admin API keys.
  ##   after: string
  ##        : Return keys with IDs that come after this ID in the pagination order.
  ##   order: string
  ##        : Order results by creation time, ascending or descending.
  ##   limit: int
  ##        : Maximum number of keys to return.
  var query_822084949 = newJObject()
  add(query_822084949, "after", newJString(after))
  add(query_822084949, "order", newJString(order))
  add(query_822084949, "limit", newJInt(limit))
  result = call_822084948.call(nil, query_822084949, nil, nil, nil)

var adminApiKeysList* = Call_AdminApiKeysList_822084941(
    name: "adminApiKeysList", meth: HttpMethod.HttpGet, host: "api.openai.com",
    route: "/organization/admin_api_keys", validator: validate_AdminApiKeysList_822084942,
    base: "/v1", makeUrl: url_AdminApiKeysList_822084943,
    schemes: {Scheme.Https})
type
  Call_AdminApiKeysDelete_822084964 = ref object of OpenApiRestCall_822083995
proc url_AdminApiKeysDelete_822084966(protocol: Scheme; host: string;
                                      base: string; route: string;
                                      path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "key_id" in path, "`key_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/organization/admin_api_keys/"),
                 (kind: VariableSegment, value: "key_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_AdminApiKeysDelete_822084965(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Delete the specified admin API key.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   key_id: JString (required)
  ##         : The ID of the API key to be deleted.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `key_id` field"
  var valid_822084967 = path.getOrDefault("key_id")
  valid_822084967 = validateParameter(valid_822084967, JString, required = true,
                                      default = nil)
  if valid_822084967 != nil:
    section.add "key_id", valid_822084967
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084968: Call_AdminApiKeysDelete_822084964;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Delete the specified admin API key.
  ## 
  let valid = call_822084968.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084968.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084968.makeUrl(scheme.get, call_822084968.host, call_822084968.base,
                                   call_822084968.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084968, uri, valid, content)

proc call*(call_822084969: Call_AdminApiKeysDelete_822084964; keyId: string): Recallable =
  ## adminApiKeysDelete
  ## Delete the specified admin API key.
  ##   keyId: string (required)
  ##        : The ID of the API key to be deleted.
  var path_822084970 = newJObject()
  add(path_822084970, "key_id", newJString(keyId))
  result = call_822084969.call(path_822084970, nil, nil, nil, nil)

var adminApiKeysDelete* = Call_AdminApiKeysDelete_822084964(
    name: "adminApiKeysDelete", meth: HttpMethod.HttpDelete,
    host: "api.openai.com", route: "/organization/admin_api_keys/{key_id}",
    validator: validate_AdminApiKeysDelete_822084965, base: "/v1",
    makeUrl: url_AdminApiKeysDelete_822084966, schemes: {Scheme.Https})
type
  Call_AdminApiKeysGet_822084957 = ref object of OpenApiRestCall_822083995
proc url_AdminApiKeysGet_822084959(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode;
                                   query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "key_id" in path, "`key_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/organization/admin_api_keys/"),
                 (kind: VariableSegment, value: "key_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_AdminApiKeysGet_822084958(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  ## Get details for a specific organization API key by its ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   key_id: JString (required)
  ##         : The ID of the API key.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `key_id` field"
  var valid_822084960 = path.getOrDefault("key_id")
  valid_822084960 = validateParameter(valid_822084960, JString, required = true,
                                      default = nil)
  if valid_822084960 != nil:
    section.add "key_id", valid_822084960
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084961: Call_AdminApiKeysGet_822084957; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  ## Get details for a specific organization API key by its ID.
  ## 
  let valid = call_822084961.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084961.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084961.makeUrl(scheme.get, call_822084961.host, call_822084961.base,
                                   call_822084961.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084961, uri, valid, content)

proc call*(call_822084962: Call_AdminApiKeysGet_822084957; keyId: string): Recallable =
  ## adminApiKeysGet
  ## Get details for a specific organization API key by its ID.
  ##   keyId: string (required)
  ##        : The ID of the API key.
  var path_822084963 = newJObject()
  add(path_822084963, "key_id", newJString(keyId))
  result = call_822084962.call(path_822084963, nil, nil, nil, nil)

var adminApiKeysGet* = Call_AdminApiKeysGet_822084957(name: "adminApiKeysGet",
    meth: HttpMethod.HttpGet, host: "api.openai.com",
    route: "/organization/admin_api_keys/{key_id}",
    validator: validate_AdminApiKeysGet_822084958, base: "/v1",
    makeUrl: url_AdminApiKeysGet_822084959, schemes: {Scheme.Https})
type
  Call_ListAuditLogs_822084971 = ref object of OpenApiRestCall_822083995
proc url_ListAuditLogs_822084973(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_ListAuditLogs_822084972(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   event_types[]: JArray
  ##                : Return only events with a `type` in one of these values. For example, `project.created`. For all options, see the documentation for the [audit log object](/docs/api-reference/audit-logs/object).
  ##   resource_ids[]: JArray
  ##                 : Return only events performed on these targets. For example, a project ID updated.
  ##   after: JString
  ##        : A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
  ## 
  ##   actor_ids[]: JArray
  ##              : Return only events performed by these actors. Can be a user ID, a service account ID, or an api key tracking ID.
  ##   limit: JInt
  ##        : A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.
  ## 
  ##   effective_at: JObject
  ##               : Return only events whose `effective_at` (Unix seconds) is in this range.
  ##   actor_emails[]: JArray
  ##                 : Return only events performed by users with these emails.
  ##   before: JString
  ##         : A cursor for use in pagination. `before` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, starting with obj_foo, your subsequent call can include before=obj_foo in order to fetch the previous page of the list.
  ## 
  ##   project_ids[]: JArray
  ##                : Return only events for these projects.
  section = newJObject()
  var valid_822084974 = query.getOrDefault("event_types[]")
  valid_822084974 = validateParameter(valid_822084974, JArray, required = false,
                                      default = nil)
  if valid_822084974 != nil:
    section.add "event_types[]", valid_822084974
  var valid_822084975 = query.getOrDefault("resource_ids[]")
  valid_822084975 = validateParameter(valid_822084975, JArray, required = false,
                                      default = nil)
  if valid_822084975 != nil:
    section.add "resource_ids[]", valid_822084975
  var valid_822084976 = query.getOrDefault("after")
  valid_822084976 = validateParameter(valid_822084976, JString,
                                      required = false, default = nil)
  if valid_822084976 != nil:
    section.add "after", valid_822084976
  var valid_822084977 = query.getOrDefault("actor_ids[]")
  valid_822084977 = validateParameter(valid_822084977, JArray, required = false,
                                      default = nil)
  if valid_822084977 != nil:
    section.add "actor_ids[]", valid_822084977
  var valid_822084978 = query.getOrDefault("limit")
  valid_822084978 = validateParameter(valid_822084978, JInt, required = false,
                                      default = newJInt(20))
  if valid_822084978 != nil:
    section.add "limit", valid_822084978
  var valid_822084979 = query.getOrDefault("effective_at")
  valid_822084979 = validateParameter(valid_822084979, JObject,
                                      required = false, default = nil)
  if valid_822084979 != nil:
    section.add "effective_at", valid_822084979
  var valid_822084980 = query.getOrDefault("actor_emails[]")
  valid_822084980 = validateParameter(valid_822084980, JArray, required = false,
                                      default = nil)
  if valid_822084980 != nil:
    section.add "actor_emails[]", valid_822084980
  var valid_822084981 = query.getOrDefault("before")
  valid_822084981 = validateParameter(valid_822084981, JString,
                                      required = false, default = nil)
  if valid_822084981 != nil:
    section.add "before", valid_822084981
  var valid_822084982 = query.getOrDefault("project_ids[]")
  valid_822084982 = validateParameter(valid_822084982, JArray, required = false,
                                      default = nil)
  if valid_822084982 != nil:
    section.add "project_ids[]", valid_822084982
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084983: Call_ListAuditLogs_822084971; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
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

proc call*(call_822084984: Call_ListAuditLogs_822084971;
           eventTypes: JsonNode = nil; resourceIds: JsonNode = nil;
           after: string = ""; actorIds: JsonNode = nil; limit: int = 20;
           effectiveAt: JsonNode = nil; actorEmails: JsonNode = nil;
           before: string = ""; projectIds: JsonNode = nil): Recallable =
  ## listAuditLogs
  ##   eventTypes: JArray
  ##             : Return only events with a `type` in one of these values. For example, `project.created`. For all options, see the documentation for the [audit log object](/docs/api-reference/audit-logs/object).
  ##   resourceIds: JArray
  ##              : Return only events performed on these targets. For example, a project ID updated.
  ##   after: string
  ##        : A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
  ## 
  ##   actorIds: JArray
  ##           : Return only events performed by these actors. Can be a user ID, a service account ID, or an api key tracking ID.
  ##   limit: int
  ##        : A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.
  ## 
  ##   effectiveAt: JObject
  ##              : Return only events whose `effective_at` (Unix seconds) is in this range.
  ##   actorEmails: JArray
  ##              : Return only events performed by users with these emails.
  ##   before: string
  ##         : A cursor for use in pagination. `before` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, starting with obj_foo, your subsequent call can include before=obj_foo in order to fetch the previous page of the list.
  ## 
  ##   projectIds: JArray
  ##             : Return only events for these projects.
  var query_822084985 = newJObject()
  if eventTypes != nil:
    query_822084985.add "event_types[]", eventTypes
  if resourceIds != nil:
    query_822084985.add "resource_ids[]", resourceIds
  add(query_822084985, "after", newJString(after))
  if actorIds != nil:
    query_822084985.add "actor_ids[]", actorIds
  add(query_822084985, "limit", newJInt(limit))
  if effectiveAt != nil:
    query_822084985.add "effective_at", effectiveAt
  if actorEmails != nil:
    query_822084985.add "actor_emails[]", actorEmails
  add(query_822084985, "before", newJString(before))
  if projectIds != nil:
    query_822084985.add "project_ids[]", projectIds
  result = call_822084984.call(nil, query_822084985, nil, nil, nil)

var listAuditLogs* = Call_ListAuditLogs_822084971(name: "listAuditLogs",
    meth: HttpMethod.HttpGet, host: "api.openai.com",
    route: "/organization/audit_logs", validator: validate_ListAuditLogs_822084972,
    base: "/v1", makeUrl: url_ListAuditLogs_822084973, schemes: {Scheme.Https})
type
  Call_UploadCertificate_822084995 = ref object of OpenApiRestCall_822083995
proc url_UploadCertificate_822084997(protocol: Scheme; host: string;
                                     base: string; route: string;
                                     path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_UploadCertificate_822084996(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : The certificate upload payload.
  if `==`(content, ""): assert body != nil, "body argument is necessary"
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822084999: Call_UploadCertificate_822084995;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084999.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084999.makeUrl(scheme.get, call_822084999.host, call_822084999.base,
                                   call_822084999.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084999, uri, valid, content)

proc call*(call_822085000: Call_UploadCertificate_822084995; body: JsonNode): Recallable =
  ## uploadCertificate
  ##   body: JObject (required)
  ##       : The certificate upload payload.
  var body_822085001 = newJObject()
  if body != nil:
    body_822085001 = body
  result = call_822085000.call(nil, nil, nil, nil, body_822085001)

var uploadCertificate* = Call_UploadCertificate_822084995(
    name: "uploadCertificate", meth: HttpMethod.HttpPost,
    host: "api.openai.com", route: "/organization/certificates",
    validator: validate_UploadCertificate_822084996, base: "/v1",
    makeUrl: url_UploadCertificate_822084997, schemes: {Scheme.Https})
type
  Call_ListOrganizationCertificates_822084986 = ref object of OpenApiRestCall_822083995
proc url_ListOrganizationCertificates_822084988(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_ListOrganizationCertificates_822084987(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode;
    content: string = ""): JsonNode {.nosinks.} =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   after: JString
  ##        : A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
  ## 
  ##   order: JString
  ##        : Sort order by the `created_at` timestamp of the objects. `asc` for ascending order and `desc` for descending order.
  ## 
  ##   limit: JInt
  ##        : A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.
  ## 
  section = newJObject()
  var valid_822084989 = query.getOrDefault("after")
  valid_822084989 = validateParameter(valid_822084989, JString,
                                      required = false, default = nil)
  if valid_822084989 != nil:
    section.add "after", valid_822084989
  var valid_822084990 = query.getOrDefault("order")
  valid_822084990 = validateParameter(valid_822084990, JString,
                                      required = false,
                                      default = newJString("desc"))
  if valid_822084990 != nil:
    section.add "order", valid_822084990
  var valid_822084991 = query.getOrDefault("limit")
  valid_822084991 = validateParameter(valid_822084991, JInt, required = false,
                                      default = newJInt(20))
  if valid_822084991 != nil:
    section.add "limit", valid_822084991
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822084992: Call_ListOrganizationCertificates_822084986;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822084992.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822084992.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822084992.makeUrl(scheme.get, call_822084992.host, call_822084992.base,
                                   call_822084992.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822084992, uri, valid, content)

proc call*(call_822084993: Call_ListOrganizationCertificates_822084986;
           after: string = ""; order: string = "desc"; limit: int = 20): Recallable =
  ## listOrganizationCertificates
  ##   after: string
  ##        : A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
  ## 
  ##   order: string
  ##        : Sort order by the `created_at` timestamp of the objects. `asc` for ascending order and `desc` for descending order.
  ## 
  ##   limit: int
  ##        : A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.
  ## 
  var query_822084994 = newJObject()
  add(query_822084994, "after", newJString(after))
  add(query_822084994, "order", newJString(order))
  add(query_822084994, "limit", newJInt(limit))
  result = call_822084993.call(nil, query_822084994, nil, nil, nil)

var listOrganizationCertificates* = Call_ListOrganizationCertificates_822084986(
    name: "listOrganizationCertificates", meth: HttpMethod.HttpGet,
    host: "api.openai.com", route: "/organization/certificates",
    validator: validate_ListOrganizationCertificates_822084987, base: "/v1",
    makeUrl: url_ListOrganizationCertificates_822084988, schemes: {Scheme.Https})
type
  Call_ActivateOrganizationCertificates_822085002 = ref object of OpenApiRestCall_822083995
proc url_ActivateOrganizationCertificates_822085004(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_ActivateOrganizationCertificates_822085003(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode;
    content: string = ""): JsonNode {.nosinks.} =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : The certificate activation payload.
  if `==`(content, ""): assert body != nil, "body argument is necessary"
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085006: Call_ActivateOrganizationCertificates_822085002;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085006.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085006.makeUrl(scheme.get, call_822085006.host, call_822085006.base,
                                   call_822085006.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085006, uri, valid, content)

proc call*(call_822085007: Call_ActivateOrganizationCertificates_822085002;
           body: JsonNode): Recallable =
  ## activateOrganizationCertificates
  ##   body: JObject (required)
  ##       : The certificate activation payload.
  var body_822085008 = newJObject()
  if body != nil:
    body_822085008 = body
  result = call_822085007.call(nil, nil, nil, nil, body_822085008)

var activateOrganizationCertificates* = Call_ActivateOrganizationCertificates_822085002(
    name: "activateOrganizationCertificates", meth: HttpMethod.HttpPost,
    host: "api.openai.com", route: "/organization/certificates/activate",
    validator: validate_ActivateOrganizationCertificates_822085003, base: "/v1",
    makeUrl: url_ActivateOrganizationCertificates_822085004,
    schemes: {Scheme.Https})
type
  Call_DeactivateOrganizationCertificates_822085009 = ref object of OpenApiRestCall_822083995
proc url_DeactivateOrganizationCertificates_822085011(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_DeactivateOrganizationCertificates_822085010(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode;
    content: string = ""): JsonNode {.nosinks.} =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : The certificate deactivation payload.
  if `==`(content, ""): assert body != nil, "body argument is necessary"
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085013: Call_DeactivateOrganizationCertificates_822085009;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085013.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085013.makeUrl(scheme.get, call_822085013.host, call_822085013.base,
                                   call_822085013.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085013, uri, valid, content)

proc call*(call_822085014: Call_DeactivateOrganizationCertificates_822085009;
           body: JsonNode): Recallable =
  ## deactivateOrganizationCertificates
  ##   body: JObject (required)
  ##       : The certificate deactivation payload.
  var body_822085015 = newJObject()
  if body != nil:
    body_822085015 = body
  result = call_822085014.call(nil, nil, nil, nil, body_822085015)

var deactivateOrganizationCertificates* = Call_DeactivateOrganizationCertificates_822085009(
    name: "deactivateOrganizationCertificates", meth: HttpMethod.HttpPost,
    host: "api.openai.com", route: "/organization/certificates/deactivate",
    validator: validate_DeactivateOrganizationCertificates_822085010,
    base: "/v1", makeUrl: url_DeactivateOrganizationCertificates_822085011,
    schemes: {Scheme.Https})
type
  Call_DeleteCertificate_822085032 = ref object of OpenApiRestCall_822083995
proc url_DeleteCertificate_822085034(protocol: Scheme; host: string;
                                     base: string; route: string;
                                     path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  const
    segments = @[(kind: ConstantSegment, value: "/organization/certificates/"),
                 (kind: VariableSegment, value: "certificate_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DeleteCertificate_822085033(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085035: Call_DeleteCertificate_822085032;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
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

proc call*(call_822085036: Call_DeleteCertificate_822085032): Recallable =
  ## deleteCertificate
  result = call_822085036.call(nil, nil, nil, nil, nil)

var deleteCertificate* = Call_DeleteCertificate_822085032(
    name: "deleteCertificate", meth: HttpMethod.HttpDelete,
    host: "api.openai.com",
    route: "/organization/certificates/{certificate_id}",
    validator: validate_DeleteCertificate_822085033, base: "/v1",
    makeUrl: url_DeleteCertificate_822085034, schemes: {Scheme.Https})
type
  Call_ModifyCertificate_822085025 = ref object of OpenApiRestCall_822083995
proc url_ModifyCertificate_822085027(protocol: Scheme; host: string;
                                     base: string; route: string;
                                     path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  const
    segments = @[(kind: ConstantSegment, value: "/organization/certificates/"),
                 (kind: VariableSegment, value: "certificate_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ModifyCertificate_822085026(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : The certificate modification payload.
  if `==`(content, ""): assert body != nil, "body argument is necessary"
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085029: Call_ModifyCertificate_822085025;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085029.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085029.makeUrl(scheme.get, call_822085029.host, call_822085029.base,
                                   call_822085029.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085029, uri, valid, content)

proc call*(call_822085030: Call_ModifyCertificate_822085025; body: JsonNode): Recallable =
  ## modifyCertificate
  ##   body: JObject (required)
  ##       : The certificate modification payload.
  var body_822085031 = newJObject()
  if body != nil:
    body_822085031 = body
  result = call_822085030.call(nil, nil, nil, nil, body_822085031)

var modifyCertificate* = Call_ModifyCertificate_822085025(
    name: "modifyCertificate", meth: HttpMethod.HttpPost,
    host: "api.openai.com",
    route: "/organization/certificates/{certificate_id}",
    validator: validate_ModifyCertificate_822085026, base: "/v1",
    makeUrl: url_ModifyCertificate_822085027, schemes: {Scheme.Https})
type
  Call_GetCertificate_822085016 = ref object of OpenApiRestCall_822083995
proc url_GetCertificate_822085018(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "certificate_id" in path,
         "`certificate_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/organization/certificates/"),
                 (kind: VariableSegment, value: "certificate_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GetCertificate_822085017(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   certificate_id: JString (required)
  ##                 : Unique ID of the certificate to retrieve.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `certificate_id` field"
  var valid_822085019 = path.getOrDefault("certificate_id")
  valid_822085019 = validateParameter(valid_822085019, JString, required = true,
                                      default = nil)
  if valid_822085019 != nil:
    section.add "certificate_id", valid_822085019
  result.add "path", section
  ## parameters in `query` object:
  ##   include: JArray
  ##          : A list of additional fields to include in the response. Currently the only supported value is `content` to fetch the PEM content of the certificate.
  section = newJObject()
  var valid_822085020 = query.getOrDefault("include")
  valid_822085020 = validateParameter(valid_822085020, JArray, required = false,
                                      default = nil)
  if valid_822085020 != nil:
    section.add "include", valid_822085020
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085021: Call_GetCertificate_822085016; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
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

proc call*(call_822085022: Call_GetCertificate_822085016; certificateId: string;
           `include`: JsonNode = nil): Recallable =
  ## getCertificate
  ##   certificateId: string (required)
  ##                : Unique ID of the certificate to retrieve.
  ##   include: JArray
  ##          : A list of additional fields to include in the response. Currently the only supported value is `content` to fetch the PEM content of the certificate.
  var path_822085023 = newJObject()
  var query_822085024 = newJObject()
  add(path_822085023, "certificate_id", newJString(certificateId))
  if `include` != nil:
    query_822085024.add "include", `include`
  result = call_822085022.call(path_822085023, query_822085024, nil, nil, nil)

var getCertificate* = Call_GetCertificate_822085016(name: "getCertificate",
    meth: HttpMethod.HttpGet, host: "api.openai.com",
    route: "/organization/certificates/{certificate_id}",
    validator: validate_GetCertificate_822085017, base: "/v1",
    makeUrl: url_GetCertificate_822085018, schemes: {Scheme.Https})
type
  Call_UsageCosts_822085037 = ref object of OpenApiRestCall_822083995
proc url_UsageCosts_822085039(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_UsageCosts_822085038(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   end_time: JInt
  ##           : End time (Unix seconds) of the query time range, exclusive.
  ##   group_by: JArray
  ##           : Group the costs by the specified fields. Support fields include `project_id`, `line_item` and any combination of them.
  ##   project_ids: JArray
  ##              : Return only costs for these projects.
  ##   page: JString
  ##       : A cursor for use in pagination. Corresponding to the `next_page` field from the previous response.
  ##   bucket_width: JString
  ##               : Width of each time bucket in response. Currently only `1d` is supported, default to `1d`.
  ##   limit: JInt
  ##        : A limit on the number of buckets to be returned. Limit can range between 1 and 180, and the default is 7.
  ## 
  ##   start_time: JInt (required)
  ##             : Start time (Unix seconds) of the query time range, inclusive.
  section = newJObject()
  var valid_822085040 = query.getOrDefault("end_time")
  valid_822085040 = validateParameter(valid_822085040, JInt, required = false,
                                      default = nil)
  if valid_822085040 != nil:
    section.add "end_time", valid_822085040
  var valid_822085041 = query.getOrDefault("group_by")
  valid_822085041 = validateParameter(valid_822085041, JArray, required = false,
                                      default = nil)
  if valid_822085041 != nil:
    section.add "group_by", valid_822085041
  var valid_822085042 = query.getOrDefault("project_ids")
  valid_822085042 = validateParameter(valid_822085042, JArray, required = false,
                                      default = nil)
  if valid_822085042 != nil:
    section.add "project_ids", valid_822085042
  var valid_822085043 = query.getOrDefault("page")
  valid_822085043 = validateParameter(valid_822085043, JString,
                                      required = false, default = nil)
  if valid_822085043 != nil:
    section.add "page", valid_822085043
  var valid_822085044 = query.getOrDefault("bucket_width")
  valid_822085044 = validateParameter(valid_822085044, JString,
                                      required = false,
                                      default = newJString("1d"))
  if valid_822085044 != nil:
    section.add "bucket_width", valid_822085044
  var valid_822085045 = query.getOrDefault("limit")
  valid_822085045 = validateParameter(valid_822085045, JInt, required = false,
                                      default = newJInt(7))
  if valid_822085045 != nil:
    section.add "limit", valid_822085045
  assert query != nil,
         "query argument is necessary due to required `start_time` field"
  var valid_822085046 = query.getOrDefault("start_time")
  valid_822085046 = validateParameter(valid_822085046, JInt, required = true,
                                      default = nil)
  if valid_822085046 != nil:
    section.add "start_time", valid_822085046
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085047: Call_UsageCosts_822085037; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085047.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085047.makeUrl(scheme.get, call_822085047.host, call_822085047.base,
                                   call_822085047.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085047, uri, valid, content)

proc call*(call_822085048: Call_UsageCosts_822085037; startTime: int;
           endTime: int = 0; groupBy: JsonNode = nil;
           projectIds: JsonNode = nil; page: string = "";
           bucketWidth: string = "1d"; limit: int = 7): Recallable =
  ## usageCosts
  ##   endTime: int
  ##          : End time (Unix seconds) of the query time range, exclusive.
  ##   groupBy: JArray
  ##          : Group the costs by the specified fields. Support fields include `project_id`, `line_item` and any combination of them.
  ##   projectIds: JArray
  ##             : Return only costs for these projects.
  ##   page: string
  ##       : A cursor for use in pagination. Corresponding to the `next_page` field from the previous response.
  ##   bucketWidth: string
  ##              : Width of each time bucket in response. Currently only `1d` is supported, default to `1d`.
  ##   limit: int
  ##        : A limit on the number of buckets to be returned. Limit can range between 1 and 180, and the default is 7.
  ## 
  ##   startTime: int (required)
  ##            : Start time (Unix seconds) of the query time range, inclusive.
  var query_822085049 = newJObject()
  add(query_822085049, "end_time", newJInt(endTime))
  if groupBy != nil:
    query_822085049.add "group_by", groupBy
  if projectIds != nil:
    query_822085049.add "project_ids", projectIds
  add(query_822085049, "page", newJString(page))
  add(query_822085049, "bucket_width", newJString(bucketWidth))
  add(query_822085049, "limit", newJInt(limit))
  add(query_822085049, "start_time", newJInt(startTime))
  result = call_822085048.call(nil, query_822085049, nil, nil, nil)

var usageCosts* = Call_UsageCosts_822085037(name: "usageCosts",
    meth: HttpMethod.HttpGet, host: "api.openai.com",
    route: "/organization/costs", validator: validate_UsageCosts_822085038,
    base: "/v1", makeUrl: url_UsageCosts_822085039, schemes: {Scheme.Https})
type
  Call_InviteUser_822085058 = ref object of OpenApiRestCall_822083995
proc url_InviteUser_822085060(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_InviteUser_822085059(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : The invite request payload.
  if `==`(content, ""): assert body != nil, "body argument is necessary"
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085062: Call_InviteUser_822085058; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085062.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085062.makeUrl(scheme.get, call_822085062.host, call_822085062.base,
                                   call_822085062.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085062, uri, valid, content)

proc call*(call_822085063: Call_InviteUser_822085058; body: JsonNode): Recallable =
  ## inviteUser
  ##   body: JObject (required)
  ##       : The invite request payload.
  var body_822085064 = newJObject()
  if body != nil:
    body_822085064 = body
  result = call_822085063.call(nil, nil, nil, nil, body_822085064)

var inviteUser* = Call_InviteUser_822085058(name: "inviteUser",
    meth: HttpMethod.HttpPost, host: "api.openai.com",
    route: "/organization/invites", validator: validate_InviteUser_822085059,
    base: "/v1", makeUrl: url_InviteUser_822085060, schemes: {Scheme.Https})
type
  Call_ListInvites_822085050 = ref object of OpenApiRestCall_822083995
proc url_ListInvites_822085052(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_ListInvites_822085051(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   after: JString
  ##        : A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
  ## 
  ##   limit: JInt
  ##        : A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.
  ## 
  section = newJObject()
  var valid_822085053 = query.getOrDefault("after")
  valid_822085053 = validateParameter(valid_822085053, JString,
                                      required = false, default = nil)
  if valid_822085053 != nil:
    section.add "after", valid_822085053
  var valid_822085054 = query.getOrDefault("limit")
  valid_822085054 = validateParameter(valid_822085054, JInt, required = false,
                                      default = newJInt(20))
  if valid_822085054 != nil:
    section.add "limit", valid_822085054
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085055: Call_ListInvites_822085050; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085055.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085055.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085055.makeUrl(scheme.get, call_822085055.host, call_822085055.base,
                                   call_822085055.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085055, uri, valid, content)

proc call*(call_822085056: Call_ListInvites_822085050; after: string = "";
           limit: int = 20): Recallable =
  ## listInvites
  ##   after: string
  ##        : A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
  ## 
  ##   limit: int
  ##        : A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.
  ## 
  var query_822085057 = newJObject()
  add(query_822085057, "after", newJString(after))
  add(query_822085057, "limit", newJInt(limit))
  result = call_822085056.call(nil, query_822085057, nil, nil, nil)

var listInvites* = Call_ListInvites_822085050(name: "listInvites",
    meth: HttpMethod.HttpGet, host: "api.openai.com",
    route: "/organization/invites", validator: validate_ListInvites_822085051,
    base: "/v1", makeUrl: url_ListInvites_822085052, schemes: {Scheme.Https})
type
  Call_DeleteInvite_822085072 = ref object of OpenApiRestCall_822083995
proc url_DeleteInvite_822085074(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "invite_id" in path, "`invite_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/organization/invites/"),
                 (kind: VariableSegment, value: "invite_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DeleteInvite_822085073(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   invite_id: JString (required)
  ##            : The ID of the invite to delete.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `invite_id` field"
  var valid_822085075 = path.getOrDefault("invite_id")
  valid_822085075 = validateParameter(valid_822085075, JString, required = true,
                                      default = nil)
  if valid_822085075 != nil:
    section.add "invite_id", valid_822085075
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085076: Call_DeleteInvite_822085072; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085076.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085076.makeUrl(scheme.get, call_822085076.host, call_822085076.base,
                                   call_822085076.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085076, uri, valid, content)

proc call*(call_822085077: Call_DeleteInvite_822085072; inviteId: string): Recallable =
  ## deleteInvite
  ##   inviteId: string (required)
  ##           : The ID of the invite to delete.
  var path_822085078 = newJObject()
  add(path_822085078, "invite_id", newJString(inviteId))
  result = call_822085077.call(path_822085078, nil, nil, nil, nil)

var deleteInvite* = Call_DeleteInvite_822085072(name: "deleteInvite",
    meth: HttpMethod.HttpDelete, host: "api.openai.com",
    route: "/organization/invites/{invite_id}",
    validator: validate_DeleteInvite_822085073, base: "/v1",
    makeUrl: url_DeleteInvite_822085074, schemes: {Scheme.Https})
type
  Call_RetrieveInvite_822085065 = ref object of OpenApiRestCall_822083995
proc url_RetrieveInvite_822085067(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "invite_id" in path, "`invite_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/organization/invites/"),
                 (kind: VariableSegment, value: "invite_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RetrieveInvite_822085066(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   invite_id: JString (required)
  ##            : The ID of the invite to retrieve.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `invite_id` field"
  var valid_822085068 = path.getOrDefault("invite_id")
  valid_822085068 = validateParameter(valid_822085068, JString, required = true,
                                      default = nil)
  if valid_822085068 != nil:
    section.add "invite_id", valid_822085068
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085069: Call_RetrieveInvite_822085065; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085069.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085069.makeUrl(scheme.get, call_822085069.host, call_822085069.base,
                                   call_822085069.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085069, uri, valid, content)

proc call*(call_822085070: Call_RetrieveInvite_822085065; inviteId: string): Recallable =
  ## retrieveInvite
  ##   inviteId: string (required)
  ##           : The ID of the invite to retrieve.
  var path_822085071 = newJObject()
  add(path_822085071, "invite_id", newJString(inviteId))
  result = call_822085070.call(path_822085071, nil, nil, nil, nil)

var retrieveInvite* = Call_RetrieveInvite_822085065(name: "retrieveInvite",
    meth: HttpMethod.HttpGet, host: "api.openai.com",
    route: "/organization/invites/{invite_id}",
    validator: validate_RetrieveInvite_822085066, base: "/v1",
    makeUrl: url_RetrieveInvite_822085067, schemes: {Scheme.Https})
type
  Call_CreateProject_822085088 = ref object of OpenApiRestCall_822083995
proc url_CreateProject_822085090(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CreateProject_822085089(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : The project create request payload.
  if `==`(content, ""): assert body != nil, "body argument is necessary"
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085092: Call_CreateProject_822085088; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085092.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085092.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085092.makeUrl(scheme.get, call_822085092.host, call_822085092.base,
                                   call_822085092.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085092, uri, valid, content)

proc call*(call_822085093: Call_CreateProject_822085088; body: JsonNode): Recallable =
  ## createProject
  ##   body: JObject (required)
  ##       : The project create request payload.
  var body_822085094 = newJObject()
  if body != nil:
    body_822085094 = body
  result = call_822085093.call(nil, nil, nil, nil, body_822085094)

var createProject* = Call_CreateProject_822085088(name: "createProject",
    meth: HttpMethod.HttpPost, host: "api.openai.com",
    route: "/organization/projects", validator: validate_CreateProject_822085089,
    base: "/v1", makeUrl: url_CreateProject_822085090, schemes: {Scheme.Https})
type
  Call_ListProjects_822085079 = ref object of OpenApiRestCall_822083995
proc url_ListProjects_822085081(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_ListProjects_822085080(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   after: JString
  ##        : A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
  ## 
  ##   limit: JInt
  ##        : A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.
  ## 
  ##   include_archived: JBool
  ##                   : If `true` returns all projects including those that have been `archived`. Archived projects are not included by default.
  section = newJObject()
  var valid_822085082 = query.getOrDefault("after")
  valid_822085082 = validateParameter(valid_822085082, JString,
                                      required = false, default = nil)
  if valid_822085082 != nil:
    section.add "after", valid_822085082
  var valid_822085083 = query.getOrDefault("limit")
  valid_822085083 = validateParameter(valid_822085083, JInt, required = false,
                                      default = newJInt(20))
  if valid_822085083 != nil:
    section.add "limit", valid_822085083
  var valid_822085084 = query.getOrDefault("include_archived")
  valid_822085084 = validateParameter(valid_822085084, JBool, required = false,
                                      default = newJBool(false))
  if valid_822085084 != nil:
    section.add "include_archived", valid_822085084
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085085: Call_ListProjects_822085079; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085085.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085085.makeUrl(scheme.get, call_822085085.host, call_822085085.base,
                                   call_822085085.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085085, uri, valid, content)

proc call*(call_822085086: Call_ListProjects_822085079; after: string = "";
           limit: int = 20; includeArchived: bool = false): Recallable =
  ## listProjects
  ##   after: string
  ##        : A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
  ## 
  ##   limit: int
  ##        : A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.
  ## 
  ##   includeArchived: bool
  ##                  : If `true` returns all projects including those that have been `archived`. Archived projects are not included by default.
  var query_822085087 = newJObject()
  add(query_822085087, "after", newJString(after))
  add(query_822085087, "limit", newJInt(limit))
  add(query_822085087, "include_archived", newJBool(includeArchived))
  result = call_822085086.call(nil, query_822085087, nil, nil, nil)

var listProjects* = Call_ListProjects_822085079(name: "listProjects",
    meth: HttpMethod.HttpGet, host: "api.openai.com",
    route: "/organization/projects", validator: validate_ListProjects_822085080,
    base: "/v1", makeUrl: url_ListProjects_822085081, schemes: {Scheme.Https})
type
  Call_ModifyProject_822085102 = ref object of OpenApiRestCall_822083995
proc url_ModifyProject_822085104(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project_id" in path, "`project_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/organization/projects/"),
                 (kind: VariableSegment, value: "project_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ModifyProject_822085103(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project_id: JString (required)
  ##             : The ID of the project.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `project_id` field"
  var valid_822085105 = path.getOrDefault("project_id")
  valid_822085105 = validateParameter(valid_822085105, JString, required = true,
                                      default = nil)
  if valid_822085105 != nil:
    section.add "project_id", valid_822085105
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : The project update request payload.
  if `==`(content, ""): assert body != nil, "body argument is necessary"
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085107: Call_ModifyProject_822085102; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085107.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085107.makeUrl(scheme.get, call_822085107.host, call_822085107.base,
                                   call_822085107.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085107, uri, valid, content)

proc call*(call_822085108: Call_ModifyProject_822085102; body: JsonNode;
           projectId: string): Recallable =
  ## modifyProject
  ##   body: JObject (required)
  ##       : The project update request payload.
  ##   projectId: string (required)
  ##            : The ID of the project.
  var path_822085109 = newJObject()
  var body_822085110 = newJObject()
  if body != nil:
    body_822085110 = body
  add(path_822085109, "project_id", newJString(projectId))
  result = call_822085108.call(path_822085109, nil, nil, nil, body_822085110)

var modifyProject* = Call_ModifyProject_822085102(name: "modifyProject",
    meth: HttpMethod.HttpPost, host: "api.openai.com",
    route: "/organization/projects/{project_id}",
    validator: validate_ModifyProject_822085103, base: "/v1",
    makeUrl: url_ModifyProject_822085104, schemes: {Scheme.Https})
type
  Call_RetrieveProject_822085095 = ref object of OpenApiRestCall_822083995
proc url_RetrieveProject_822085097(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode;
                                   query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project_id" in path, "`project_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/organization/projects/"),
                 (kind: VariableSegment, value: "project_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RetrieveProject_822085096(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project_id: JString (required)
  ##             : The ID of the project.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `project_id` field"
  var valid_822085098 = path.getOrDefault("project_id")
  valid_822085098 = validateParameter(valid_822085098, JString, required = true,
                                      default = nil)
  if valid_822085098 != nil:
    section.add "project_id", valid_822085098
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085099: Call_RetrieveProject_822085095; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085099.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085099.makeUrl(scheme.get, call_822085099.host, call_822085099.base,
                                   call_822085099.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085099, uri, valid, content)

proc call*(call_822085100: Call_RetrieveProject_822085095; projectId: string): Recallable =
  ## retrieveProject
  ##   projectId: string (required)
  ##            : The ID of the project.
  var path_822085101 = newJObject()
  add(path_822085101, "project_id", newJString(projectId))
  result = call_822085100.call(path_822085101, nil, nil, nil, nil)

var retrieveProject* = Call_RetrieveProject_822085095(name: "retrieveProject",
    meth: HttpMethod.HttpGet, host: "api.openai.com",
    route: "/organization/projects/{project_id}",
    validator: validate_RetrieveProject_822085096, base: "/v1",
    makeUrl: url_RetrieveProject_822085097, schemes: {Scheme.Https})
type
  Call_ListProjectApiKeys_822085111 = ref object of OpenApiRestCall_822083995
proc url_ListProjectApiKeys_822085113(protocol: Scheme; host: string;
                                      base: string; route: string;
                                      path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project_id" in path, "`project_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/organization/projects/"),
                 (kind: VariableSegment, value: "project_id"),
                 (kind: ConstantSegment, value: "/api_keys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ListProjectApiKeys_822085112(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project_id: JString (required)
  ##             : The ID of the project.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `project_id` field"
  var valid_822085114 = path.getOrDefault("project_id")
  valid_822085114 = validateParameter(valid_822085114, JString, required = true,
                                      default = nil)
  if valid_822085114 != nil:
    section.add "project_id", valid_822085114
  result.add "path", section
  ## parameters in `query` object:
  ##   after: JString
  ##        : A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
  ## 
  ##   limit: JInt
  ##        : A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.
  ## 
  section = newJObject()
  var valid_822085115 = query.getOrDefault("after")
  valid_822085115 = validateParameter(valid_822085115, JString,
                                      required = false, default = nil)
  if valid_822085115 != nil:
    section.add "after", valid_822085115
  var valid_822085116 = query.getOrDefault("limit")
  valid_822085116 = validateParameter(valid_822085116, JInt, required = false,
                                      default = newJInt(20))
  if valid_822085116 != nil:
    section.add "limit", valid_822085116
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085117: Call_ListProjectApiKeys_822085111;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085117.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085117.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085117.makeUrl(scheme.get, call_822085117.host, call_822085117.base,
                                   call_822085117.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085117, uri, valid, content)

proc call*(call_822085118: Call_ListProjectApiKeys_822085111; projectId: string;
           after: string = ""; limit: int = 20): Recallable =
  ## listProjectApiKeys
  ##   after: string
  ##        : A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
  ## 
  ##   projectId: string (required)
  ##            : The ID of the project.
  ##   limit: int
  ##        : A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.
  ## 
  var path_822085119 = newJObject()
  var query_822085120 = newJObject()
  add(query_822085120, "after", newJString(after))
  add(path_822085119, "project_id", newJString(projectId))
  add(query_822085120, "limit", newJInt(limit))
  result = call_822085118.call(path_822085119, query_822085120, nil, nil, nil)

var listProjectApiKeys* = Call_ListProjectApiKeys_822085111(
    name: "listProjectApiKeys", meth: HttpMethod.HttpGet,
    host: "api.openai.com",
    route: "/organization/projects/{project_id}/api_keys",
    validator: validate_ListProjectApiKeys_822085112, base: "/v1",
    makeUrl: url_ListProjectApiKeys_822085113, schemes: {Scheme.Https})
type
  Call_DeleteProjectApiKey_822085129 = ref object of OpenApiRestCall_822083995
proc url_DeleteProjectApiKey_822085131(protocol: Scheme; host: string;
                                       base: string; route: string;
                                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project_id" in path, "`project_id` is a required path parameter"
  assert "key_id" in path, "`key_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/organization/projects/"),
                 (kind: VariableSegment, value: "project_id"),
                 (kind: ConstantSegment, value: "/api_keys/"),
                 (kind: VariableSegment, value: "key_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DeleteProjectApiKey_822085130(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project_id: JString (required)
  ##             : The ID of the project.
  ##   key_id: JString (required)
  ##         : The ID of the API key.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `project_id` field"
  var valid_822085132 = path.getOrDefault("project_id")
  valid_822085132 = validateParameter(valid_822085132, JString, required = true,
                                      default = nil)
  if valid_822085132 != nil:
    section.add "project_id", valid_822085132
  var valid_822085133 = path.getOrDefault("key_id")
  valid_822085133 = validateParameter(valid_822085133, JString, required = true,
                                      default = nil)
  if valid_822085133 != nil:
    section.add "key_id", valid_822085133
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085134: Call_DeleteProjectApiKey_822085129;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085134.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085134.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085134.makeUrl(scheme.get, call_822085134.host, call_822085134.base,
                                   call_822085134.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085134, uri, valid, content)

proc call*(call_822085135: Call_DeleteProjectApiKey_822085129;
           projectId: string; keyId: string): Recallable =
  ## deleteProjectApiKey
  ##   projectId: string (required)
  ##            : The ID of the project.
  ##   keyId: string (required)
  ##        : The ID of the API key.
  var path_822085136 = newJObject()
  add(path_822085136, "project_id", newJString(projectId))
  add(path_822085136, "key_id", newJString(keyId))
  result = call_822085135.call(path_822085136, nil, nil, nil, nil)

var deleteProjectApiKey* = Call_DeleteProjectApiKey_822085129(
    name: "deleteProjectApiKey", meth: HttpMethod.HttpDelete,
    host: "api.openai.com",
    route: "/organization/projects/{project_id}/api_keys/{key_id}",
    validator: validate_DeleteProjectApiKey_822085130, base: "/v1",
    makeUrl: url_DeleteProjectApiKey_822085131, schemes: {Scheme.Https})
type
  Call_RetrieveProjectApiKey_822085121 = ref object of OpenApiRestCall_822083995
proc url_RetrieveProjectApiKey_822085123(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project_id" in path, "`project_id` is a required path parameter"
  assert "key_id" in path, "`key_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/organization/projects/"),
                 (kind: VariableSegment, value: "project_id"),
                 (kind: ConstantSegment, value: "/api_keys/"),
                 (kind: VariableSegment, value: "key_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RetrieveProjectApiKey_822085122(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project_id: JString (required)
  ##             : The ID of the project.
  ##   key_id: JString (required)
  ##         : The ID of the API key.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `project_id` field"
  var valid_822085124 = path.getOrDefault("project_id")
  valid_822085124 = validateParameter(valid_822085124, JString, required = true,
                                      default = nil)
  if valid_822085124 != nil:
    section.add "project_id", valid_822085124
  var valid_822085125 = path.getOrDefault("key_id")
  valid_822085125 = validateParameter(valid_822085125, JString, required = true,
                                      default = nil)
  if valid_822085125 != nil:
    section.add "key_id", valid_822085125
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085126: Call_RetrieveProjectApiKey_822085121;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085126.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085126.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085126.makeUrl(scheme.get, call_822085126.host, call_822085126.base,
                                   call_822085126.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085126, uri, valid, content)

proc call*(call_822085127: Call_RetrieveProjectApiKey_822085121;
           projectId: string; keyId: string): Recallable =
  ## retrieveProjectApiKey
  ##   projectId: string (required)
  ##            : The ID of the project.
  ##   keyId: string (required)
  ##        : The ID of the API key.
  var path_822085128 = newJObject()
  add(path_822085128, "project_id", newJString(projectId))
  add(path_822085128, "key_id", newJString(keyId))
  result = call_822085127.call(path_822085128, nil, nil, nil, nil)

var retrieveProjectApiKey* = Call_RetrieveProjectApiKey_822085121(
    name: "retrieveProjectApiKey", meth: HttpMethod.HttpGet,
    host: "api.openai.com",
    route: "/organization/projects/{project_id}/api_keys/{key_id}",
    validator: validate_RetrieveProjectApiKey_822085122, base: "/v1",
    makeUrl: url_RetrieveProjectApiKey_822085123, schemes: {Scheme.Https})
type
  Call_ArchiveProject_822085137 = ref object of OpenApiRestCall_822083995
proc url_ArchiveProject_822085139(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project_id" in path, "`project_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/organization/projects/"),
                 (kind: VariableSegment, value: "project_id"),
                 (kind: ConstantSegment, value: "/archive")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ArchiveProject_822085138(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project_id: JString (required)
  ##             : The ID of the project.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `project_id` field"
  var valid_822085140 = path.getOrDefault("project_id")
  valid_822085140 = validateParameter(valid_822085140, JString, required = true,
                                      default = nil)
  if valid_822085140 != nil:
    section.add "project_id", valid_822085140
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085141: Call_ArchiveProject_822085137; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085141.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085141.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085141.makeUrl(scheme.get, call_822085141.host, call_822085141.base,
                                   call_822085141.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085141, uri, valid, content)

proc call*(call_822085142: Call_ArchiveProject_822085137; projectId: string): Recallable =
  ## archiveProject
  ##   projectId: string (required)
  ##            : The ID of the project.
  var path_822085143 = newJObject()
  add(path_822085143, "project_id", newJString(projectId))
  result = call_822085142.call(path_822085143, nil, nil, nil, nil)

var archiveProject* = Call_ArchiveProject_822085137(name: "archiveProject",
    meth: HttpMethod.HttpPost, host: "api.openai.com",
    route: "/organization/projects/{project_id}/archive",
    validator: validate_ArchiveProject_822085138, base: "/v1",
    makeUrl: url_ArchiveProject_822085139, schemes: {Scheme.Https})
type
  Call_ListProjectCertificates_822085144 = ref object of OpenApiRestCall_822083995
proc url_ListProjectCertificates_822085146(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project_id" in path, "`project_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/organization/projects/"),
                 (kind: VariableSegment, value: "project_id"),
                 (kind: ConstantSegment, value: "/certificates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ListProjectCertificates_822085145(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project_id: JString (required)
  ##             : The ID of the project.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `project_id` field"
  var valid_822085147 = path.getOrDefault("project_id")
  valid_822085147 = validateParameter(valid_822085147, JString, required = true,
                                      default = nil)
  if valid_822085147 != nil:
    section.add "project_id", valid_822085147
  result.add "path", section
  ## parameters in `query` object:
  ##   after: JString
  ##        : A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
  ## 
  ##   order: JString
  ##        : Sort order by the `created_at` timestamp of the objects. `asc` for ascending order and `desc` for descending order.
  ## 
  ##   limit: JInt
  ##        : A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.
  ## 
  section = newJObject()
  var valid_822085148 = query.getOrDefault("after")
  valid_822085148 = validateParameter(valid_822085148, JString,
                                      required = false, default = nil)
  if valid_822085148 != nil:
    section.add "after", valid_822085148
  var valid_822085149 = query.getOrDefault("order")
  valid_822085149 = validateParameter(valid_822085149, JString,
                                      required = false,
                                      default = newJString("desc"))
  if valid_822085149 != nil:
    section.add "order", valid_822085149
  var valid_822085150 = query.getOrDefault("limit")
  valid_822085150 = validateParameter(valid_822085150, JInt, required = false,
                                      default = newJInt(20))
  if valid_822085150 != nil:
    section.add "limit", valid_822085150
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085151: Call_ListProjectCertificates_822085144;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085151.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085151.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085151.makeUrl(scheme.get, call_822085151.host, call_822085151.base,
                                   call_822085151.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085151, uri, valid, content)

proc call*(call_822085152: Call_ListProjectCertificates_822085144;
           projectId: string; after: string = ""; order: string = "desc";
           limit: int = 20): Recallable =
  ## listProjectCertificates
  ##   after: string
  ##        : A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
  ## 
  ##   order: string
  ##        : Sort order by the `created_at` timestamp of the objects. `asc` for ascending order and `desc` for descending order.
  ## 
  ##   projectId: string (required)
  ##            : The ID of the project.
  ##   limit: int
  ##        : A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.
  ## 
  var path_822085153 = newJObject()
  var query_822085154 = newJObject()
  add(query_822085154, "after", newJString(after))
  add(query_822085154, "order", newJString(order))
  add(path_822085153, "project_id", newJString(projectId))
  add(query_822085154, "limit", newJInt(limit))
  result = call_822085152.call(path_822085153, query_822085154, nil, nil, nil)

var listProjectCertificates* = Call_ListProjectCertificates_822085144(
    name: "listProjectCertificates", meth: HttpMethod.HttpGet,
    host: "api.openai.com",
    route: "/organization/projects/{project_id}/certificates",
    validator: validate_ListProjectCertificates_822085145, base: "/v1",
    makeUrl: url_ListProjectCertificates_822085146, schemes: {Scheme.Https})
type
  Call_ActivateProjectCertificates_822085155 = ref object of OpenApiRestCall_822083995
proc url_ActivateProjectCertificates_822085157(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project_id" in path, "`project_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/organization/projects/"),
                 (kind: VariableSegment, value: "project_id"),
                 (kind: ConstantSegment, value: "/certificates/activate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ActivateProjectCertificates_822085156(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode;
    content: string = ""): JsonNode {.nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project_id: JString (required)
  ##             : The ID of the project.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `project_id` field"
  var valid_822085158 = path.getOrDefault("project_id")
  valid_822085158 = validateParameter(valid_822085158, JString, required = true,
                                      default = nil)
  if valid_822085158 != nil:
    section.add "project_id", valid_822085158
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : The certificate activation payload.
  if `==`(content, ""): assert body != nil, "body argument is necessary"
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085160: Call_ActivateProjectCertificates_822085155;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085160.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085160.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085160.makeUrl(scheme.get, call_822085160.host, call_822085160.base,
                                   call_822085160.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085160, uri, valid, content)

proc call*(call_822085161: Call_ActivateProjectCertificates_822085155;
           body: JsonNode; projectId: string): Recallable =
  ## activateProjectCertificates
  ##   body: JObject (required)
  ##       : The certificate activation payload.
  ##   projectId: string (required)
  ##            : The ID of the project.
  var path_822085162 = newJObject()
  var body_822085163 = newJObject()
  if body != nil:
    body_822085163 = body
  add(path_822085162, "project_id", newJString(projectId))
  result = call_822085161.call(path_822085162, nil, nil, nil, body_822085163)

var activateProjectCertificates* = Call_ActivateProjectCertificates_822085155(
    name: "activateProjectCertificates", meth: HttpMethod.HttpPost,
    host: "api.openai.com",
    route: "/organization/projects/{project_id}/certificates/activate",
    validator: validate_ActivateProjectCertificates_822085156, base: "/v1",
    makeUrl: url_ActivateProjectCertificates_822085157, schemes: {Scheme.Https})
type
  Call_DeactivateProjectCertificates_822085164 = ref object of OpenApiRestCall_822083995
proc url_DeactivateProjectCertificates_822085166(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project_id" in path, "`project_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/organization/projects/"),
                 (kind: VariableSegment, value: "project_id"),
                 (kind: ConstantSegment, value: "/certificates/deactivate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DeactivateProjectCertificates_822085165(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode;
    content: string = ""): JsonNode {.nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project_id: JString (required)
  ##             : The ID of the project.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `project_id` field"
  var valid_822085167 = path.getOrDefault("project_id")
  valid_822085167 = validateParameter(valid_822085167, JString, required = true,
                                      default = nil)
  if valid_822085167 != nil:
    section.add "project_id", valid_822085167
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : The certificate deactivation payload.
  if `==`(content, ""): assert body != nil, "body argument is necessary"
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085169: Call_DeactivateProjectCertificates_822085164;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085169.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085169.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085169.makeUrl(scheme.get, call_822085169.host, call_822085169.base,
                                   call_822085169.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085169, uri, valid, content)

proc call*(call_822085170: Call_DeactivateProjectCertificates_822085164;
           body: JsonNode; projectId: string): Recallable =
  ## deactivateProjectCertificates
  ##   body: JObject (required)
  ##       : The certificate deactivation payload.
  ##   projectId: string (required)
  ##            : The ID of the project.
  var path_822085171 = newJObject()
  var body_822085172 = newJObject()
  if body != nil:
    body_822085172 = body
  add(path_822085171, "project_id", newJString(projectId))
  result = call_822085170.call(path_822085171, nil, nil, nil, body_822085172)

var deactivateProjectCertificates* = Call_DeactivateProjectCertificates_822085164(
    name: "deactivateProjectCertificates", meth: HttpMethod.HttpPost,
    host: "api.openai.com",
    route: "/organization/projects/{project_id}/certificates/deactivate",
    validator: validate_DeactivateProjectCertificates_822085165, base: "/v1",
    makeUrl: url_DeactivateProjectCertificates_822085166,
    schemes: {Scheme.Https})
type
  Call_ListProjectRateLimits_822085173 = ref object of OpenApiRestCall_822083995
proc url_ListProjectRateLimits_822085175(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project_id" in path, "`project_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/organization/projects/"),
                 (kind: VariableSegment, value: "project_id"),
                 (kind: ConstantSegment, value: "/rate_limits")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ListProjectRateLimits_822085174(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project_id: JString (required)
  ##             : The ID of the project.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `project_id` field"
  var valid_822085176 = path.getOrDefault("project_id")
  valid_822085176 = validateParameter(valid_822085176, JString, required = true,
                                      default = nil)
  if valid_822085176 != nil:
    section.add "project_id", valid_822085176
  result.add "path", section
  ## parameters in `query` object:
  ##   after: JString
  ##        : A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
  ## 
  ##   limit: JInt
  ##        : A limit on the number of objects to be returned. The default is 100.
  ## 
  ##   before: JString
  ##         : A cursor for use in pagination. `before` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, beginning with obj_foo, your subsequent call can include before=obj_foo in order to fetch the previous page of the list.
  ## 
  section = newJObject()
  var valid_822085177 = query.getOrDefault("after")
  valid_822085177 = validateParameter(valid_822085177, JString,
                                      required = false, default = nil)
  if valid_822085177 != nil:
    section.add "after", valid_822085177
  var valid_822085178 = query.getOrDefault("limit")
  valid_822085178 = validateParameter(valid_822085178, JInt, required = false,
                                      default = newJInt(100))
  if valid_822085178 != nil:
    section.add "limit", valid_822085178
  var valid_822085179 = query.getOrDefault("before")
  valid_822085179 = validateParameter(valid_822085179, JString,
                                      required = false, default = nil)
  if valid_822085179 != nil:
    section.add "before", valid_822085179
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085180: Call_ListProjectRateLimits_822085173;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085180.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085180.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085180.makeUrl(scheme.get, call_822085180.host, call_822085180.base,
                                   call_822085180.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085180, uri, valid, content)

proc call*(call_822085181: Call_ListProjectRateLimits_822085173;
           projectId: string; after: string = ""; limit: int = 100;
           before: string = ""): Recallable =
  ## listProjectRateLimits
  ##   after: string
  ##        : A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
  ## 
  ##   projectId: string (required)
  ##            : The ID of the project.
  ##   limit: int
  ##        : A limit on the number of objects to be returned. The default is 100.
  ## 
  ##   before: string
  ##         : A cursor for use in pagination. `before` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, beginning with obj_foo, your subsequent call can include before=obj_foo in order to fetch the previous page of the list.
  ## 
  var path_822085182 = newJObject()
  var query_822085183 = newJObject()
  add(query_822085183, "after", newJString(after))
  add(path_822085182, "project_id", newJString(projectId))
  add(query_822085183, "limit", newJInt(limit))
  add(query_822085183, "before", newJString(before))
  result = call_822085181.call(path_822085182, query_822085183, nil, nil, nil)

var listProjectRateLimits* = Call_ListProjectRateLimits_822085173(
    name: "listProjectRateLimits", meth: HttpMethod.HttpGet,
    host: "api.openai.com",
    route: "/organization/projects/{project_id}/rate_limits",
    validator: validate_ListProjectRateLimits_822085174, base: "/v1",
    makeUrl: url_ListProjectRateLimits_822085175, schemes: {Scheme.Https})
type
  Call_UpdateProjectRateLimits_822085184 = ref object of OpenApiRestCall_822083995
proc url_UpdateProjectRateLimits_822085186(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project_id" in path, "`project_id` is a required path parameter"
  assert "rate_limit_id" in path, "`rate_limit_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/organization/projects/"),
                 (kind: VariableSegment, value: "project_id"),
                 (kind: ConstantSegment, value: "/rate_limits/"),
                 (kind: VariableSegment, value: "rate_limit_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_UpdateProjectRateLimits_822085185(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   rate_limit_id: JString (required)
  ##                : The ID of the rate limit.
  ##   project_id: JString (required)
  ##             : The ID of the project.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `rate_limit_id` field"
  var valid_822085187 = path.getOrDefault("rate_limit_id")
  valid_822085187 = validateParameter(valid_822085187, JString, required = true,
                                      default = nil)
  if valid_822085187 != nil:
    section.add "rate_limit_id", valid_822085187
  var valid_822085188 = path.getOrDefault("project_id")
  valid_822085188 = validateParameter(valid_822085188, JString, required = true,
                                      default = nil)
  if valid_822085188 != nil:
    section.add "project_id", valid_822085188
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : The project rate limit update request payload.
  if `==`(content, ""): assert body != nil, "body argument is necessary"
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085190: Call_UpdateProjectRateLimits_822085184;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085190.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085190.makeUrl(scheme.get, call_822085190.host, call_822085190.base,
                                   call_822085190.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085190, uri, valid, content)

proc call*(call_822085191: Call_UpdateProjectRateLimits_822085184;
           body: JsonNode; rateLimitId: string; projectId: string): Recallable =
  ## updateProjectRateLimits
  ##   body: JObject (required)
  ##       : The project rate limit update request payload.
  ##   rateLimitId: string (required)
  ##              : The ID of the rate limit.
  ##   projectId: string (required)
  ##            : The ID of the project.
  var path_822085192 = newJObject()
  var body_822085193 = newJObject()
  if body != nil:
    body_822085193 = body
  add(path_822085192, "rate_limit_id", newJString(rateLimitId))
  add(path_822085192, "project_id", newJString(projectId))
  result = call_822085191.call(path_822085192, nil, nil, nil, body_822085193)

var updateProjectRateLimits* = Call_UpdateProjectRateLimits_822085184(
    name: "updateProjectRateLimits", meth: HttpMethod.HttpPost,
    host: "api.openai.com",
    route: "/organization/projects/{project_id}/rate_limits/{rate_limit_id}",
    validator: validate_UpdateProjectRateLimits_822085185, base: "/v1",
    makeUrl: url_UpdateProjectRateLimits_822085186, schemes: {Scheme.Https})
type
  Call_CreateProjectServiceAccount_822085204 = ref object of OpenApiRestCall_822083995
proc url_CreateProjectServiceAccount_822085206(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project_id" in path, "`project_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/organization/projects/"),
                 (kind: VariableSegment, value: "project_id"),
                 (kind: ConstantSegment, value: "/service_accounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CreateProjectServiceAccount_822085205(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode;
    content: string = ""): JsonNode {.nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project_id: JString (required)
  ##             : The ID of the project.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `project_id` field"
  var valid_822085207 = path.getOrDefault("project_id")
  valid_822085207 = validateParameter(valid_822085207, JString, required = true,
                                      default = nil)
  if valid_822085207 != nil:
    section.add "project_id", valid_822085207
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : The project service account create request payload.
  if `==`(content, ""): assert body != nil, "body argument is necessary"
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085209: Call_CreateProjectServiceAccount_822085204;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085209.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085209.makeUrl(scheme.get, call_822085209.host, call_822085209.base,
                                   call_822085209.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085209, uri, valid, content)

proc call*(call_822085210: Call_CreateProjectServiceAccount_822085204;
           body: JsonNode; projectId: string): Recallable =
  ## createProjectServiceAccount
  ##   body: JObject (required)
  ##       : The project service account create request payload.
  ##   projectId: string (required)
  ##            : The ID of the project.
  var path_822085211 = newJObject()
  var body_822085212 = newJObject()
  if body != nil:
    body_822085212 = body
  add(path_822085211, "project_id", newJString(projectId))
  result = call_822085210.call(path_822085211, nil, nil, nil, body_822085212)

var createProjectServiceAccount* = Call_CreateProjectServiceAccount_822085204(
    name: "createProjectServiceAccount", meth: HttpMethod.HttpPost,
    host: "api.openai.com",
    route: "/organization/projects/{project_id}/service_accounts",
    validator: validate_CreateProjectServiceAccount_822085205, base: "/v1",
    makeUrl: url_CreateProjectServiceAccount_822085206, schemes: {Scheme.Https})
type
  Call_ListProjectServiceAccounts_822085194 = ref object of OpenApiRestCall_822083995
proc url_ListProjectServiceAccounts_822085196(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project_id" in path, "`project_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/organization/projects/"),
                 (kind: VariableSegment, value: "project_id"),
                 (kind: ConstantSegment, value: "/service_accounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ListProjectServiceAccounts_822085195(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode;
    content: string = ""): JsonNode {.nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project_id: JString (required)
  ##             : The ID of the project.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `project_id` field"
  var valid_822085197 = path.getOrDefault("project_id")
  valid_822085197 = validateParameter(valid_822085197, JString, required = true,
                                      default = nil)
  if valid_822085197 != nil:
    section.add "project_id", valid_822085197
  result.add "path", section
  ## parameters in `query` object:
  ##   after: JString
  ##        : A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
  ## 
  ##   limit: JInt
  ##        : A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.
  ## 
  section = newJObject()
  var valid_822085198 = query.getOrDefault("after")
  valid_822085198 = validateParameter(valid_822085198, JString,
                                      required = false, default = nil)
  if valid_822085198 != nil:
    section.add "after", valid_822085198
  var valid_822085199 = query.getOrDefault("limit")
  valid_822085199 = validateParameter(valid_822085199, JInt, required = false,
                                      default = newJInt(20))
  if valid_822085199 != nil:
    section.add "limit", valid_822085199
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085200: Call_ListProjectServiceAccounts_822085194;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085200.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085200.makeUrl(scheme.get, call_822085200.host, call_822085200.base,
                                   call_822085200.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085200, uri, valid, content)

proc call*(call_822085201: Call_ListProjectServiceAccounts_822085194;
           projectId: string; after: string = ""; limit: int = 20): Recallable =
  ## listProjectServiceAccounts
  ##   after: string
  ##        : A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
  ## 
  ##   projectId: string (required)
  ##            : The ID of the project.
  ##   limit: int
  ##        : A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.
  ## 
  var path_822085202 = newJObject()
  var query_822085203 = newJObject()
  add(query_822085203, "after", newJString(after))
  add(path_822085202, "project_id", newJString(projectId))
  add(query_822085203, "limit", newJInt(limit))
  result = call_822085201.call(path_822085202, query_822085203, nil, nil, nil)

var listProjectServiceAccounts* = Call_ListProjectServiceAccounts_822085194(
    name: "listProjectServiceAccounts", meth: HttpMethod.HttpGet,
    host: "api.openai.com",
    route: "/organization/projects/{project_id}/service_accounts",
    validator: validate_ListProjectServiceAccounts_822085195, base: "/v1",
    makeUrl: url_ListProjectServiceAccounts_822085196, schemes: {Scheme.Https})
type
  Call_DeleteProjectServiceAccount_822085221 = ref object of OpenApiRestCall_822083995
proc url_DeleteProjectServiceAccount_822085223(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project_id" in path, "`project_id` is a required path parameter"
  assert "service_account_id" in path,
         "`service_account_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/organization/projects/"),
                 (kind: VariableSegment, value: "project_id"),
                 (kind: ConstantSegment, value: "/service_accounts/"),
                 (kind: VariableSegment, value: "service_account_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DeleteProjectServiceAccount_822085222(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode;
    content: string = ""): JsonNode {.nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   service_account_id: JString (required)
  ##                     : The ID of the service account.
  ##   project_id: JString (required)
  ##             : The ID of the project.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `service_account_id` field"
  var valid_822085224 = path.getOrDefault("service_account_id")
  valid_822085224 = validateParameter(valid_822085224, JString, required = true,
                                      default = nil)
  if valid_822085224 != nil:
    section.add "service_account_id", valid_822085224
  var valid_822085225 = path.getOrDefault("project_id")
  valid_822085225 = validateParameter(valid_822085225, JString, required = true,
                                      default = nil)
  if valid_822085225 != nil:
    section.add "project_id", valid_822085225
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085226: Call_DeleteProjectServiceAccount_822085221;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085226.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085226.makeUrl(scheme.get, call_822085226.host, call_822085226.base,
                                   call_822085226.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085226, uri, valid, content)

proc call*(call_822085227: Call_DeleteProjectServiceAccount_822085221;
           serviceAccountId: string; projectId: string): Recallable =
  ## deleteProjectServiceAccount
  ##   serviceAccountId: string (required)
  ##                   : The ID of the service account.
  ##   projectId: string (required)
  ##            : The ID of the project.
  var path_822085228 = newJObject()
  add(path_822085228, "service_account_id", newJString(serviceAccountId))
  add(path_822085228, "project_id", newJString(projectId))
  result = call_822085227.call(path_822085228, nil, nil, nil, nil)

var deleteProjectServiceAccount* = Call_DeleteProjectServiceAccount_822085221(
    name: "deleteProjectServiceAccount", meth: HttpMethod.HttpDelete,
    host: "api.openai.com", route: "/organization/projects/{project_id}/service_accounts/{service_account_id}",
    validator: validate_DeleteProjectServiceAccount_822085222, base: "/v1",
    makeUrl: url_DeleteProjectServiceAccount_822085223, schemes: {Scheme.Https})
type
  Call_RetrieveProjectServiceAccount_822085213 = ref object of OpenApiRestCall_822083995
proc url_RetrieveProjectServiceAccount_822085215(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project_id" in path, "`project_id` is a required path parameter"
  assert "service_account_id" in path,
         "`service_account_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/organization/projects/"),
                 (kind: VariableSegment, value: "project_id"),
                 (kind: ConstantSegment, value: "/service_accounts/"),
                 (kind: VariableSegment, value: "service_account_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RetrieveProjectServiceAccount_822085214(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode;
    content: string = ""): JsonNode {.nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   service_account_id: JString (required)
  ##                     : The ID of the service account.
  ##   project_id: JString (required)
  ##             : The ID of the project.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `service_account_id` field"
  var valid_822085216 = path.getOrDefault("service_account_id")
  valid_822085216 = validateParameter(valid_822085216, JString, required = true,
                                      default = nil)
  if valid_822085216 != nil:
    section.add "service_account_id", valid_822085216
  var valid_822085217 = path.getOrDefault("project_id")
  valid_822085217 = validateParameter(valid_822085217, JString, required = true,
                                      default = nil)
  if valid_822085217 != nil:
    section.add "project_id", valid_822085217
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085218: Call_RetrieveProjectServiceAccount_822085213;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
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

proc call*(call_822085219: Call_RetrieveProjectServiceAccount_822085213;
           serviceAccountId: string; projectId: string): Recallable =
  ## retrieveProjectServiceAccount
  ##   serviceAccountId: string (required)
  ##                   : The ID of the service account.
  ##   projectId: string (required)
  ##            : The ID of the project.
  var path_822085220 = newJObject()
  add(path_822085220, "service_account_id", newJString(serviceAccountId))
  add(path_822085220, "project_id", newJString(projectId))
  result = call_822085219.call(path_822085220, nil, nil, nil, nil)

var retrieveProjectServiceAccount* = Call_RetrieveProjectServiceAccount_822085213(
    name: "retrieveProjectServiceAccount", meth: HttpMethod.HttpGet,
    host: "api.openai.com", route: "/organization/projects/{project_id}/service_accounts/{service_account_id}",
    validator: validate_RetrieveProjectServiceAccount_822085214, base: "/v1",
    makeUrl: url_RetrieveProjectServiceAccount_822085215,
    schemes: {Scheme.Https})
type
  Call_CreateProjectUser_822085239 = ref object of OpenApiRestCall_822083995
proc url_CreateProjectUser_822085241(protocol: Scheme; host: string;
                                     base: string; route: string;
                                     path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project_id" in path, "`project_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/organization/projects/"),
                 (kind: VariableSegment, value: "project_id"),
                 (kind: ConstantSegment, value: "/users")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CreateProjectUser_822085240(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project_id: JString (required)
  ##             : The ID of the project.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `project_id` field"
  var valid_822085242 = path.getOrDefault("project_id")
  valid_822085242 = validateParameter(valid_822085242, JString, required = true,
                                      default = nil)
  if valid_822085242 != nil:
    section.add "project_id", valid_822085242
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : The project user create request payload.
  if `==`(content, ""): assert body != nil, "body argument is necessary"
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085244: Call_CreateProjectUser_822085239;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
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

proc call*(call_822085245: Call_CreateProjectUser_822085239; body: JsonNode;
           projectId: string): Recallable =
  ## createProjectUser
  ##   body: JObject (required)
  ##       : The project user create request payload.
  ##   projectId: string (required)
  ##            : The ID of the project.
  var path_822085246 = newJObject()
  var body_822085247 = newJObject()
  if body != nil:
    body_822085247 = body
  add(path_822085246, "project_id", newJString(projectId))
  result = call_822085245.call(path_822085246, nil, nil, nil, body_822085247)

var createProjectUser* = Call_CreateProjectUser_822085239(
    name: "createProjectUser", meth: HttpMethod.HttpPost,
    host: "api.openai.com", route: "/organization/projects/{project_id}/users",
    validator: validate_CreateProjectUser_822085240, base: "/v1",
    makeUrl: url_CreateProjectUser_822085241, schemes: {Scheme.Https})
type
  Call_ListProjectUsers_822085229 = ref object of OpenApiRestCall_822083995
proc url_ListProjectUsers_822085231(protocol: Scheme; host: string;
                                    base: string; route: string; path: JsonNode;
                                    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project_id" in path, "`project_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/organization/projects/"),
                 (kind: VariableSegment, value: "project_id"),
                 (kind: ConstantSegment, value: "/users")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ListProjectUsers_822085230(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project_id: JString (required)
  ##             : The ID of the project.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `project_id` field"
  var valid_822085232 = path.getOrDefault("project_id")
  valid_822085232 = validateParameter(valid_822085232, JString, required = true,
                                      default = nil)
  if valid_822085232 != nil:
    section.add "project_id", valid_822085232
  result.add "path", section
  ## parameters in `query` object:
  ##   after: JString
  ##        : A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
  ## 
  ##   limit: JInt
  ##        : A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.
  ## 
  section = newJObject()
  var valid_822085233 = query.getOrDefault("after")
  valid_822085233 = validateParameter(valid_822085233, JString,
                                      required = false, default = nil)
  if valid_822085233 != nil:
    section.add "after", valid_822085233
  var valid_822085234 = query.getOrDefault("limit")
  valid_822085234 = validateParameter(valid_822085234, JInt, required = false,
                                      default = newJInt(20))
  if valid_822085234 != nil:
    section.add "limit", valid_822085234
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085235: Call_ListProjectUsers_822085229;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085235.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085235.makeUrl(scheme.get, call_822085235.host, call_822085235.base,
                                   call_822085235.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085235, uri, valid, content)

proc call*(call_822085236: Call_ListProjectUsers_822085229; projectId: string;
           after: string = ""; limit: int = 20): Recallable =
  ## listProjectUsers
  ##   after: string
  ##        : A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
  ## 
  ##   projectId: string (required)
  ##            : The ID of the project.
  ##   limit: int
  ##        : A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.
  ## 
  var path_822085237 = newJObject()
  var query_822085238 = newJObject()
  add(query_822085238, "after", newJString(after))
  add(path_822085237, "project_id", newJString(projectId))
  add(query_822085238, "limit", newJInt(limit))
  result = call_822085236.call(path_822085237, query_822085238, nil, nil, nil)

var listProjectUsers* = Call_ListProjectUsers_822085229(
    name: "listProjectUsers", meth: HttpMethod.HttpGet, host: "api.openai.com",
    route: "/organization/projects/{project_id}/users",
    validator: validate_ListProjectUsers_822085230, base: "/v1",
    makeUrl: url_ListProjectUsers_822085231, schemes: {Scheme.Https})
type
  Call_DeleteProjectUser_822085266 = ref object of OpenApiRestCall_822083995
proc url_DeleteProjectUser_822085268(protocol: Scheme; host: string;
                                     base: string; route: string;
                                     path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project_id" in path, "`project_id` is a required path parameter"
  assert "user_id" in path, "`user_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/organization/projects/"),
                 (kind: VariableSegment, value: "project_id"),
                 (kind: ConstantSegment, value: "/users/"),
                 (kind: VariableSegment, value: "user_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DeleteProjectUser_822085267(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project_id: JString (required)
  ##             : The ID of the project.
  ##   user_id: JString (required)
  ##          : The ID of the user.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `project_id` field"
  var valid_822085269 = path.getOrDefault("project_id")
  valid_822085269 = validateParameter(valid_822085269, JString, required = true,
                                      default = nil)
  if valid_822085269 != nil:
    section.add "project_id", valid_822085269
  var valid_822085270 = path.getOrDefault("user_id")
  valid_822085270 = validateParameter(valid_822085270, JString, required = true,
                                      default = nil)
  if valid_822085270 != nil:
    section.add "user_id", valid_822085270
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085271: Call_DeleteProjectUser_822085266;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085271.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085271.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085271.makeUrl(scheme.get, call_822085271.host, call_822085271.base,
                                   call_822085271.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085271, uri, valid, content)

proc call*(call_822085272: Call_DeleteProjectUser_822085266; projectId: string;
           userId: string): Recallable =
  ## deleteProjectUser
  ##   projectId: string (required)
  ##            : The ID of the project.
  ##   userId: string (required)
  ##         : The ID of the user.
  var path_822085273 = newJObject()
  add(path_822085273, "project_id", newJString(projectId))
  add(path_822085273, "user_id", newJString(userId))
  result = call_822085272.call(path_822085273, nil, nil, nil, nil)

var deleteProjectUser* = Call_DeleteProjectUser_822085266(
    name: "deleteProjectUser", meth: HttpMethod.HttpDelete,
    host: "api.openai.com",
    route: "/organization/projects/{project_id}/users/{user_id}",
    validator: validate_DeleteProjectUser_822085267, base: "/v1",
    makeUrl: url_DeleteProjectUser_822085268, schemes: {Scheme.Https})
type
  Call_ModifyProjectUser_822085256 = ref object of OpenApiRestCall_822083995
proc url_ModifyProjectUser_822085258(protocol: Scheme; host: string;
                                     base: string; route: string;
                                     path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project_id" in path, "`project_id` is a required path parameter"
  assert "user_id" in path, "`user_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/organization/projects/"),
                 (kind: VariableSegment, value: "project_id"),
                 (kind: ConstantSegment, value: "/users/"),
                 (kind: VariableSegment, value: "user_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ModifyProjectUser_822085257(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project_id: JString (required)
  ##             : The ID of the project.
  ##   user_id: JString (required)
  ##          : The ID of the user.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `project_id` field"
  var valid_822085259 = path.getOrDefault("project_id")
  valid_822085259 = validateParameter(valid_822085259, JString, required = true,
                                      default = nil)
  if valid_822085259 != nil:
    section.add "project_id", valid_822085259
  var valid_822085260 = path.getOrDefault("user_id")
  valid_822085260 = validateParameter(valid_822085260, JString, required = true,
                                      default = nil)
  if valid_822085260 != nil:
    section.add "user_id", valid_822085260
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : The project user update request payload.
  if `==`(content, ""): assert body != nil, "body argument is necessary"
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085262: Call_ModifyProjectUser_822085256;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085262.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085262.makeUrl(scheme.get, call_822085262.host, call_822085262.base,
                                   call_822085262.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085262, uri, valid, content)

proc call*(call_822085263: Call_ModifyProjectUser_822085256; body: JsonNode;
           projectId: string; userId: string): Recallable =
  ## modifyProjectUser
  ##   body: JObject (required)
  ##       : The project user update request payload.
  ##   projectId: string (required)
  ##            : The ID of the project.
  ##   userId: string (required)
  ##         : The ID of the user.
  var path_822085264 = newJObject()
  var body_822085265 = newJObject()
  if body != nil:
    body_822085265 = body
  add(path_822085264, "project_id", newJString(projectId))
  add(path_822085264, "user_id", newJString(userId))
  result = call_822085263.call(path_822085264, nil, nil, nil, body_822085265)

var modifyProjectUser* = Call_ModifyProjectUser_822085256(
    name: "modifyProjectUser", meth: HttpMethod.HttpPost,
    host: "api.openai.com",
    route: "/organization/projects/{project_id}/users/{user_id}",
    validator: validate_ModifyProjectUser_822085257, base: "/v1",
    makeUrl: url_ModifyProjectUser_822085258, schemes: {Scheme.Https})
type
  Call_RetrieveProjectUser_822085248 = ref object of OpenApiRestCall_822083995
proc url_RetrieveProjectUser_822085250(protocol: Scheme; host: string;
                                       base: string; route: string;
                                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project_id" in path, "`project_id` is a required path parameter"
  assert "user_id" in path, "`user_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/organization/projects/"),
                 (kind: VariableSegment, value: "project_id"),
                 (kind: ConstantSegment, value: "/users/"),
                 (kind: VariableSegment, value: "user_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RetrieveProjectUser_822085249(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project_id: JString (required)
  ##             : The ID of the project.
  ##   user_id: JString (required)
  ##          : The ID of the user.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `project_id` field"
  var valid_822085251 = path.getOrDefault("project_id")
  valid_822085251 = validateParameter(valid_822085251, JString, required = true,
                                      default = nil)
  if valid_822085251 != nil:
    section.add "project_id", valid_822085251
  var valid_822085252 = path.getOrDefault("user_id")
  valid_822085252 = validateParameter(valid_822085252, JString, required = true,
                                      default = nil)
  if valid_822085252 != nil:
    section.add "user_id", valid_822085252
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085253: Call_RetrieveProjectUser_822085248;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085253.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085253.makeUrl(scheme.get, call_822085253.host, call_822085253.base,
                                   call_822085253.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085253, uri, valid, content)

proc call*(call_822085254: Call_RetrieveProjectUser_822085248;
           projectId: string; userId: string): Recallable =
  ## retrieveProjectUser
  ##   projectId: string (required)
  ##            : The ID of the project.
  ##   userId: string (required)
  ##         : The ID of the user.
  var path_822085255 = newJObject()
  add(path_822085255, "project_id", newJString(projectId))
  add(path_822085255, "user_id", newJString(userId))
  result = call_822085254.call(path_822085255, nil, nil, nil, nil)

var retrieveProjectUser* = Call_RetrieveProjectUser_822085248(
    name: "retrieveProjectUser", meth: HttpMethod.HttpGet,
    host: "api.openai.com",
    route: "/organization/projects/{project_id}/users/{user_id}",
    validator: validate_RetrieveProjectUser_822085249, base: "/v1",
    makeUrl: url_RetrieveProjectUser_822085250, schemes: {Scheme.Https})
type
  Call_UsageAudioSpeeches_822085274 = ref object of OpenApiRestCall_822083995
proc url_UsageAudioSpeeches_822085276(protocol: Scheme; host: string;
                                      base: string; route: string;
                                      path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_UsageAudioSpeeches_822085275(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   end_time: JInt
  ##           : End time (Unix seconds) of the query time range, exclusive.
  ##   group_by: JArray
  ##           : Group the usage data by the specified fields. Support fields include `project_id`, `user_id`, `api_key_id`, `model` or any combination of them.
  ##   project_ids: JArray
  ##              : Return only usage for these projects.
  ##   page: JString
  ##       : A cursor for use in pagination. Corresponding to the `next_page` field from the previous response.
  ##   bucket_width: JString
  ##               : Width of each time bucket in response. Currently `1m`, `1h` and `1d` are supported, default to `1d`.
  ##   limit: JInt
  ##        : Specifies the number of buckets to return.
  ## - `bucket_width=1d`: default: 7, max: 31
  ## - `bucket_width=1h`: default: 24, max: 168
  ## - `bucket_width=1m`: default: 60, max: 1440
  ## 
  ##   api_key_ids: JArray
  ##              : Return only usage for these API keys.
  ##   user_ids: JArray
  ##           : Return only usage for these users.
  ##   models: JArray
  ##         : Return only usage for these models.
  ##   start_time: JInt (required)
  ##             : Start time (Unix seconds) of the query time range, inclusive.
  section = newJObject()
  var valid_822085277 = query.getOrDefault("end_time")
  valid_822085277 = validateParameter(valid_822085277, JInt, required = false,
                                      default = nil)
  if valid_822085277 != nil:
    section.add "end_time", valid_822085277
  var valid_822085278 = query.getOrDefault("group_by")
  valid_822085278 = validateParameter(valid_822085278, JArray, required = false,
                                      default = nil)
  if valid_822085278 != nil:
    section.add "group_by", valid_822085278
  var valid_822085279 = query.getOrDefault("project_ids")
  valid_822085279 = validateParameter(valid_822085279, JArray, required = false,
                                      default = nil)
  if valid_822085279 != nil:
    section.add "project_ids", valid_822085279
  var valid_822085280 = query.getOrDefault("page")
  valid_822085280 = validateParameter(valid_822085280, JString,
                                      required = false, default = nil)
  if valid_822085280 != nil:
    section.add "page", valid_822085280
  var valid_822085281 = query.getOrDefault("bucket_width")
  valid_822085281 = validateParameter(valid_822085281, JString,
                                      required = false,
                                      default = newJString("1d"))
  if valid_822085281 != nil:
    section.add "bucket_width", valid_822085281
  var valid_822085282 = query.getOrDefault("limit")
  valid_822085282 = validateParameter(valid_822085282, JInt, required = false,
                                      default = nil)
  if valid_822085282 != nil:
    section.add "limit", valid_822085282
  var valid_822085283 = query.getOrDefault("api_key_ids")
  valid_822085283 = validateParameter(valid_822085283, JArray, required = false,
                                      default = nil)
  if valid_822085283 != nil:
    section.add "api_key_ids", valid_822085283
  var valid_822085284 = query.getOrDefault("user_ids")
  valid_822085284 = validateParameter(valid_822085284, JArray, required = false,
                                      default = nil)
  if valid_822085284 != nil:
    section.add "user_ids", valid_822085284
  var valid_822085285 = query.getOrDefault("models")
  valid_822085285 = validateParameter(valid_822085285, JArray, required = false,
                                      default = nil)
  if valid_822085285 != nil:
    section.add "models", valid_822085285
  assert query != nil,
         "query argument is necessary due to required `start_time` field"
  var valid_822085286 = query.getOrDefault("start_time")
  valid_822085286 = validateParameter(valid_822085286, JInt, required = true,
                                      default = nil)
  if valid_822085286 != nil:
    section.add "start_time", valid_822085286
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085287: Call_UsageAudioSpeeches_822085274;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085287.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085287.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085287.makeUrl(scheme.get, call_822085287.host, call_822085287.base,
                                   call_822085287.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085287, uri, valid, content)

proc call*(call_822085288: Call_UsageAudioSpeeches_822085274; startTime: int;
           endTime: int = 0; groupBy: JsonNode = nil;
           projectIds: JsonNode = nil; page: string = "";
           bucketWidth: string = "1d"; limit: int = 0;
           apiKeyIds: JsonNode = nil; userIds: JsonNode = nil;
           models: JsonNode = nil): Recallable =
  ## usageAudioSpeeches
  ##   endTime: int
  ##          : End time (Unix seconds) of the query time range, exclusive.
  ##   groupBy: JArray
  ##          : Group the usage data by the specified fields. Support fields include `project_id`, `user_id`, `api_key_id`, `model` or any combination of them.
  ##   projectIds: JArray
  ##             : Return only usage for these projects.
  ##   page: string
  ##       : A cursor for use in pagination. Corresponding to the `next_page` field from the previous response.
  ##   bucketWidth: string
  ##              : Width of each time bucket in response. Currently `1m`, `1h` and `1d` are supported, default to `1d`.
  ##   limit: int
  ##        : Specifies the number of buckets to return.
  ## - `bucket_width=1d`: default: 7, max: 31
  ## - `bucket_width=1h`: default: 24, max: 168
  ## - `bucket_width=1m`: default: 60, max: 1440
  ## 
  ##   apiKeyIds: JArray
  ##            : Return only usage for these API keys.
  ##   userIds: JArray
  ##          : Return only usage for these users.
  ##   models: JArray
  ##         : Return only usage for these models.
  ##   startTime: int (required)
  ##            : Start time (Unix seconds) of the query time range, inclusive.
  var query_822085289 = newJObject()
  add(query_822085289, "end_time", newJInt(endTime))
  if groupBy != nil:
    query_822085289.add "group_by", groupBy
  if projectIds != nil:
    query_822085289.add "project_ids", projectIds
  add(query_822085289, "page", newJString(page))
  add(query_822085289, "bucket_width", newJString(bucketWidth))
  add(query_822085289, "limit", newJInt(limit))
  if apiKeyIds != nil:
    query_822085289.add "api_key_ids", apiKeyIds
  if userIds != nil:
    query_822085289.add "user_ids", userIds
  if models != nil:
    query_822085289.add "models", models
  add(query_822085289, "start_time", newJInt(startTime))
  result = call_822085288.call(nil, query_822085289, nil, nil, nil)

var usageAudioSpeeches* = Call_UsageAudioSpeeches_822085274(
    name: "usageAudioSpeeches", meth: HttpMethod.HttpGet,
    host: "api.openai.com", route: "/organization/usage/audio_speeches",
    validator: validate_UsageAudioSpeeches_822085275, base: "/v1",
    makeUrl: url_UsageAudioSpeeches_822085276, schemes: {Scheme.Https})
type
  Call_UsageAudioTranscriptions_822085290 = ref object of OpenApiRestCall_822083995
proc url_UsageAudioTranscriptions_822085292(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_UsageAudioTranscriptions_822085291(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode;
    content: string = ""): JsonNode {.nosinks.} =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   end_time: JInt
  ##           : End time (Unix seconds) of the query time range, exclusive.
  ##   group_by: JArray
  ##           : Group the usage data by the specified fields. Support fields include `project_id`, `user_id`, `api_key_id`, `model` or any combination of them.
  ##   project_ids: JArray
  ##              : Return only usage for these projects.
  ##   page: JString
  ##       : A cursor for use in pagination. Corresponding to the `next_page` field from the previous response.
  ##   bucket_width: JString
  ##               : Width of each time bucket in response. Currently `1m`, `1h` and `1d` are supported, default to `1d`.
  ##   limit: JInt
  ##        : Specifies the number of buckets to return.
  ## - `bucket_width=1d`: default: 7, max: 31
  ## - `bucket_width=1h`: default: 24, max: 168
  ## - `bucket_width=1m`: default: 60, max: 1440
  ## 
  ##   api_key_ids: JArray
  ##              : Return only usage for these API keys.
  ##   user_ids: JArray
  ##           : Return only usage for these users.
  ##   models: JArray
  ##         : Return only usage for these models.
  ##   start_time: JInt (required)
  ##             : Start time (Unix seconds) of the query time range, inclusive.
  section = newJObject()
  var valid_822085293 = query.getOrDefault("end_time")
  valid_822085293 = validateParameter(valid_822085293, JInt, required = false,
                                      default = nil)
  if valid_822085293 != nil:
    section.add "end_time", valid_822085293
  var valid_822085294 = query.getOrDefault("group_by")
  valid_822085294 = validateParameter(valid_822085294, JArray, required = false,
                                      default = nil)
  if valid_822085294 != nil:
    section.add "group_by", valid_822085294
  var valid_822085295 = query.getOrDefault("project_ids")
  valid_822085295 = validateParameter(valid_822085295, JArray, required = false,
                                      default = nil)
  if valid_822085295 != nil:
    section.add "project_ids", valid_822085295
  var valid_822085296 = query.getOrDefault("page")
  valid_822085296 = validateParameter(valid_822085296, JString,
                                      required = false, default = nil)
  if valid_822085296 != nil:
    section.add "page", valid_822085296
  var valid_822085297 = query.getOrDefault("bucket_width")
  valid_822085297 = validateParameter(valid_822085297, JString,
                                      required = false,
                                      default = newJString("1d"))
  if valid_822085297 != nil:
    section.add "bucket_width", valid_822085297
  var valid_822085298 = query.getOrDefault("limit")
  valid_822085298 = validateParameter(valid_822085298, JInt, required = false,
                                      default = nil)
  if valid_822085298 != nil:
    section.add "limit", valid_822085298
  var valid_822085299 = query.getOrDefault("api_key_ids")
  valid_822085299 = validateParameter(valid_822085299, JArray, required = false,
                                      default = nil)
  if valid_822085299 != nil:
    section.add "api_key_ids", valid_822085299
  var valid_822085300 = query.getOrDefault("user_ids")
  valid_822085300 = validateParameter(valid_822085300, JArray, required = false,
                                      default = nil)
  if valid_822085300 != nil:
    section.add "user_ids", valid_822085300
  var valid_822085301 = query.getOrDefault("models")
  valid_822085301 = validateParameter(valid_822085301, JArray, required = false,
                                      default = nil)
  if valid_822085301 != nil:
    section.add "models", valid_822085301
  assert query != nil,
         "query argument is necessary due to required `start_time` field"
  var valid_822085302 = query.getOrDefault("start_time")
  valid_822085302 = validateParameter(valid_822085302, JInt, required = true,
                                      default = nil)
  if valid_822085302 != nil:
    section.add "start_time", valid_822085302
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085303: Call_UsageAudioTranscriptions_822085290;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085303.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085303.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085303.makeUrl(scheme.get, call_822085303.host, call_822085303.base,
                                   call_822085303.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085303, uri, valid, content)

proc call*(call_822085304: Call_UsageAudioTranscriptions_822085290;
           startTime: int; endTime: int = 0; groupBy: JsonNode = nil;
           projectIds: JsonNode = nil; page: string = "";
           bucketWidth: string = "1d"; limit: int = 0;
           apiKeyIds: JsonNode = nil; userIds: JsonNode = nil;
           models: JsonNode = nil): Recallable =
  ## usageAudioTranscriptions
  ##   endTime: int
  ##          : End time (Unix seconds) of the query time range, exclusive.
  ##   groupBy: JArray
  ##          : Group the usage data by the specified fields. Support fields include `project_id`, `user_id`, `api_key_id`, `model` or any combination of them.
  ##   projectIds: JArray
  ##             : Return only usage for these projects.
  ##   page: string
  ##       : A cursor for use in pagination. Corresponding to the `next_page` field from the previous response.
  ##   bucketWidth: string
  ##              : Width of each time bucket in response. Currently `1m`, `1h` and `1d` are supported, default to `1d`.
  ##   limit: int
  ##        : Specifies the number of buckets to return.
  ## - `bucket_width=1d`: default: 7, max: 31
  ## - `bucket_width=1h`: default: 24, max: 168
  ## - `bucket_width=1m`: default: 60, max: 1440
  ## 
  ##   apiKeyIds: JArray
  ##            : Return only usage for these API keys.
  ##   userIds: JArray
  ##          : Return only usage for these users.
  ##   models: JArray
  ##         : Return only usage for these models.
  ##   startTime: int (required)
  ##            : Start time (Unix seconds) of the query time range, inclusive.
  var query_822085305 = newJObject()
  add(query_822085305, "end_time", newJInt(endTime))
  if groupBy != nil:
    query_822085305.add "group_by", groupBy
  if projectIds != nil:
    query_822085305.add "project_ids", projectIds
  add(query_822085305, "page", newJString(page))
  add(query_822085305, "bucket_width", newJString(bucketWidth))
  add(query_822085305, "limit", newJInt(limit))
  if apiKeyIds != nil:
    query_822085305.add "api_key_ids", apiKeyIds
  if userIds != nil:
    query_822085305.add "user_ids", userIds
  if models != nil:
    query_822085305.add "models", models
  add(query_822085305, "start_time", newJInt(startTime))
  result = call_822085304.call(nil, query_822085305, nil, nil, nil)

var usageAudioTranscriptions* = Call_UsageAudioTranscriptions_822085290(
    name: "usageAudioTranscriptions", meth: HttpMethod.HttpGet,
    host: "api.openai.com", route: "/organization/usage/audio_transcriptions",
    validator: validate_UsageAudioTranscriptions_822085291, base: "/v1",
    makeUrl: url_UsageAudioTranscriptions_822085292, schemes: {Scheme.Https})
type
  Call_UsageCodeInterpreterSessions_822085306 = ref object of OpenApiRestCall_822083995
proc url_UsageCodeInterpreterSessions_822085308(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_UsageCodeInterpreterSessions_822085307(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode;
    content: string = ""): JsonNode {.nosinks.} =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   end_time: JInt
  ##           : End time (Unix seconds) of the query time range, exclusive.
  ##   group_by: JArray
  ##           : Group the usage data by the specified fields. Support fields include `project_id`.
  ##   project_ids: JArray
  ##              : Return only usage for these projects.
  ##   page: JString
  ##       : A cursor for use in pagination. Corresponding to the `next_page` field from the previous response.
  ##   bucket_width: JString
  ##               : Width of each time bucket in response. Currently `1m`, `1h` and `1d` are supported, default to `1d`.
  ##   limit: JInt
  ##        : Specifies the number of buckets to return.
  ## - `bucket_width=1d`: default: 7, max: 31
  ## - `bucket_width=1h`: default: 24, max: 168
  ## - `bucket_width=1m`: default: 60, max: 1440
  ## 
  ##   start_time: JInt (required)
  ##             : Start time (Unix seconds) of the query time range, inclusive.
  section = newJObject()
  var valid_822085309 = query.getOrDefault("end_time")
  valid_822085309 = validateParameter(valid_822085309, JInt, required = false,
                                      default = nil)
  if valid_822085309 != nil:
    section.add "end_time", valid_822085309
  var valid_822085310 = query.getOrDefault("group_by")
  valid_822085310 = validateParameter(valid_822085310, JArray, required = false,
                                      default = nil)
  if valid_822085310 != nil:
    section.add "group_by", valid_822085310
  var valid_822085311 = query.getOrDefault("project_ids")
  valid_822085311 = validateParameter(valid_822085311, JArray, required = false,
                                      default = nil)
  if valid_822085311 != nil:
    section.add "project_ids", valid_822085311
  var valid_822085312 = query.getOrDefault("page")
  valid_822085312 = validateParameter(valid_822085312, JString,
                                      required = false, default = nil)
  if valid_822085312 != nil:
    section.add "page", valid_822085312
  var valid_822085313 = query.getOrDefault("bucket_width")
  valid_822085313 = validateParameter(valid_822085313, JString,
                                      required = false,
                                      default = newJString("1d"))
  if valid_822085313 != nil:
    section.add "bucket_width", valid_822085313
  var valid_822085314 = query.getOrDefault("limit")
  valid_822085314 = validateParameter(valid_822085314, JInt, required = false,
                                      default = nil)
  if valid_822085314 != nil:
    section.add "limit", valid_822085314
  assert query != nil,
         "query argument is necessary due to required `start_time` field"
  var valid_822085315 = query.getOrDefault("start_time")
  valid_822085315 = validateParameter(valid_822085315, JInt, required = true,
                                      default = nil)
  if valid_822085315 != nil:
    section.add "start_time", valid_822085315
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085316: Call_UsageCodeInterpreterSessions_822085306;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085316.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085316.makeUrl(scheme.get, call_822085316.host, call_822085316.base,
                                   call_822085316.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085316, uri, valid, content)

proc call*(call_822085317: Call_UsageCodeInterpreterSessions_822085306;
           startTime: int; endTime: int = 0; groupBy: JsonNode = nil;
           projectIds: JsonNode = nil; page: string = "";
           bucketWidth: string = "1d"; limit: int = 0): Recallable =
  ## usageCodeInterpreterSessions
  ##   endTime: int
  ##          : End time (Unix seconds) of the query time range, exclusive.
  ##   groupBy: JArray
  ##          : Group the usage data by the specified fields. Support fields include `project_id`.
  ##   projectIds: JArray
  ##             : Return only usage for these projects.
  ##   page: string
  ##       : A cursor for use in pagination. Corresponding to the `next_page` field from the previous response.
  ##   bucketWidth: string
  ##              : Width of each time bucket in response. Currently `1m`, `1h` and `1d` are supported, default to `1d`.
  ##   limit: int
  ##        : Specifies the number of buckets to return.
  ## - `bucket_width=1d`: default: 7, max: 31
  ## - `bucket_width=1h`: default: 24, max: 168
  ## - `bucket_width=1m`: default: 60, max: 1440
  ## 
  ##   startTime: int (required)
  ##            : Start time (Unix seconds) of the query time range, inclusive.
  var query_822085318 = newJObject()
  add(query_822085318, "end_time", newJInt(endTime))
  if groupBy != nil:
    query_822085318.add "group_by", groupBy
  if projectIds != nil:
    query_822085318.add "project_ids", projectIds
  add(query_822085318, "page", newJString(page))
  add(query_822085318, "bucket_width", newJString(bucketWidth))
  add(query_822085318, "limit", newJInt(limit))
  add(query_822085318, "start_time", newJInt(startTime))
  result = call_822085317.call(nil, query_822085318, nil, nil, nil)

var usageCodeInterpreterSessions* = Call_UsageCodeInterpreterSessions_822085306(
    name: "usageCodeInterpreterSessions", meth: HttpMethod.HttpGet,
    host: "api.openai.com",
    route: "/organization/usage/code_interpreter_sessions",
    validator: validate_UsageCodeInterpreterSessions_822085307, base: "/v1",
    makeUrl: url_UsageCodeInterpreterSessions_822085308, schemes: {Scheme.Https})
type
  Call_UsageCompletions_822085319 = ref object of OpenApiRestCall_822083995
proc url_UsageCompletions_822085321(protocol: Scheme; host: string;
                                    base: string; route: string; path: JsonNode;
                                    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_UsageCompletions_822085320(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   end_time: JInt
  ##           : End time (Unix seconds) of the query time range, exclusive.
  ##   group_by: JArray
  ##           : Group the usage data by the specified fields. Support fields include `project_id`, `user_id`, `api_key_id`, `model`, `batch` or any combination of them.
  ##   project_ids: JArray
  ##              : Return only usage for these projects.
  ##   page: JString
  ##       : A cursor for use in pagination. Corresponding to the `next_page` field from the previous response.
  ##   bucket_width: JString
  ##               : Width of each time bucket in response. Currently `1m`, `1h` and `1d` are supported, default to `1d`.
  ##   limit: JInt
  ##        : Specifies the number of buckets to return.
  ## - `bucket_width=1d`: default: 7, max: 31
  ## - `bucket_width=1h`: default: 24, max: 168
  ## - `bucket_width=1m`: default: 60, max: 1440
  ## 
  ##   api_key_ids: JArray
  ##              : Return only usage for these API keys.
  ##   user_ids: JArray
  ##           : Return only usage for these users.
  ##   batch: JBool
  ##        : If `true`, return batch jobs only. If `false`, return non-batch jobs only. By default, return both.
  ## 
  ##   models: JArray
  ##         : Return only usage for these models.
  ##   start_time: JInt (required)
  ##             : Start time (Unix seconds) of the query time range, inclusive.
  section = newJObject()
  var valid_822085322 = query.getOrDefault("end_time")
  valid_822085322 = validateParameter(valid_822085322, JInt, required = false,
                                      default = nil)
  if valid_822085322 != nil:
    section.add "end_time", valid_822085322
  var valid_822085323 = query.getOrDefault("group_by")
  valid_822085323 = validateParameter(valid_822085323, JArray, required = false,
                                      default = nil)
  if valid_822085323 != nil:
    section.add "group_by", valid_822085323
  var valid_822085324 = query.getOrDefault("project_ids")
  valid_822085324 = validateParameter(valid_822085324, JArray, required = false,
                                      default = nil)
  if valid_822085324 != nil:
    section.add "project_ids", valid_822085324
  var valid_822085325 = query.getOrDefault("page")
  valid_822085325 = validateParameter(valid_822085325, JString,
                                      required = false, default = nil)
  if valid_822085325 != nil:
    section.add "page", valid_822085325
  var valid_822085326 = query.getOrDefault("bucket_width")
  valid_822085326 = validateParameter(valid_822085326, JString,
                                      required = false,
                                      default = newJString("1d"))
  if valid_822085326 != nil:
    section.add "bucket_width", valid_822085326
  var valid_822085327 = query.getOrDefault("limit")
  valid_822085327 = validateParameter(valid_822085327, JInt, required = false,
                                      default = nil)
  if valid_822085327 != nil:
    section.add "limit", valid_822085327
  var valid_822085328 = query.getOrDefault("api_key_ids")
  valid_822085328 = validateParameter(valid_822085328, JArray, required = false,
                                      default = nil)
  if valid_822085328 != nil:
    section.add "api_key_ids", valid_822085328
  var valid_822085329 = query.getOrDefault("user_ids")
  valid_822085329 = validateParameter(valid_822085329, JArray, required = false,
                                      default = nil)
  if valid_822085329 != nil:
    section.add "user_ids", valid_822085329
  var valid_822085330 = query.getOrDefault("batch")
  valid_822085330 = validateParameter(valid_822085330, JBool, required = false,
                                      default = nil)
  if valid_822085330 != nil:
    section.add "batch", valid_822085330
  var valid_822085331 = query.getOrDefault("models")
  valid_822085331 = validateParameter(valid_822085331, JArray, required = false,
                                      default = nil)
  if valid_822085331 != nil:
    section.add "models", valid_822085331
  assert query != nil,
         "query argument is necessary due to required `start_time` field"
  var valid_822085332 = query.getOrDefault("start_time")
  valid_822085332 = validateParameter(valid_822085332, JInt, required = true,
                                      default = nil)
  if valid_822085332 != nil:
    section.add "start_time", valid_822085332
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085333: Call_UsageCompletions_822085319;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085333.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085333.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085333.makeUrl(scheme.get, call_822085333.host, call_822085333.base,
                                   call_822085333.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085333, uri, valid, content)

proc call*(call_822085334: Call_UsageCompletions_822085319; startTime: int;
           endTime: int = 0; groupBy: JsonNode = nil;
           projectIds: JsonNode = nil; page: string = "";
           bucketWidth: string = "1d"; limit: int = 0;
           apiKeyIds: JsonNode = nil; userIds: JsonNode = nil;
           batch: bool = false; models: JsonNode = nil): Recallable =
  ## usageCompletions
  ##   endTime: int
  ##          : End time (Unix seconds) of the query time range, exclusive.
  ##   groupBy: JArray
  ##          : Group the usage data by the specified fields. Support fields include `project_id`, `user_id`, `api_key_id`, `model`, `batch` or any combination of them.
  ##   projectIds: JArray
  ##             : Return only usage for these projects.
  ##   page: string
  ##       : A cursor for use in pagination. Corresponding to the `next_page` field from the previous response.
  ##   bucketWidth: string
  ##              : Width of each time bucket in response. Currently `1m`, `1h` and `1d` are supported, default to `1d`.
  ##   limit: int
  ##        : Specifies the number of buckets to return.
  ## - `bucket_width=1d`: default: 7, max: 31
  ## - `bucket_width=1h`: default: 24, max: 168
  ## - `bucket_width=1m`: default: 60, max: 1440
  ## 
  ##   apiKeyIds: JArray
  ##            : Return only usage for these API keys.
  ##   userIds: JArray
  ##          : Return only usage for these users.
  ##   batch: bool
  ##        : If `true`, return batch jobs only. If `false`, return non-batch jobs only. By default, return both.
  ## 
  ##   models: JArray
  ##         : Return only usage for these models.
  ##   startTime: int (required)
  ##            : Start time (Unix seconds) of the query time range, inclusive.
  var query_822085335 = newJObject()
  add(query_822085335, "end_time", newJInt(endTime))
  if groupBy != nil:
    query_822085335.add "group_by", groupBy
  if projectIds != nil:
    query_822085335.add "project_ids", projectIds
  add(query_822085335, "page", newJString(page))
  add(query_822085335, "bucket_width", newJString(bucketWidth))
  add(query_822085335, "limit", newJInt(limit))
  if apiKeyIds != nil:
    query_822085335.add "api_key_ids", apiKeyIds
  if userIds != nil:
    query_822085335.add "user_ids", userIds
  add(query_822085335, "batch", newJBool(batch))
  if models != nil:
    query_822085335.add "models", models
  add(query_822085335, "start_time", newJInt(startTime))
  result = call_822085334.call(nil, query_822085335, nil, nil, nil)

var usageCompletions* = Call_UsageCompletions_822085319(
    name: "usageCompletions", meth: HttpMethod.HttpGet, host: "api.openai.com",
    route: "/organization/usage/completions",
    validator: validate_UsageCompletions_822085320, base: "/v1",
    makeUrl: url_UsageCompletions_822085321, schemes: {Scheme.Https})
type
  Call_UsageEmbeddings_822085336 = ref object of OpenApiRestCall_822083995
proc url_UsageEmbeddings_822085338(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode;
                                   query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_UsageEmbeddings_822085337(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   end_time: JInt
  ##           : End time (Unix seconds) of the query time range, exclusive.
  ##   group_by: JArray
  ##           : Group the usage data by the specified fields. Support fields include `project_id`, `user_id`, `api_key_id`, `model` or any combination of them.
  ##   project_ids: JArray
  ##              : Return only usage for these projects.
  ##   page: JString
  ##       : A cursor for use in pagination. Corresponding to the `next_page` field from the previous response.
  ##   bucket_width: JString
  ##               : Width of each time bucket in response. Currently `1m`, `1h` and `1d` are supported, default to `1d`.
  ##   limit: JInt
  ##        : Specifies the number of buckets to return.
  ## - `bucket_width=1d`: default: 7, max: 31
  ## - `bucket_width=1h`: default: 24, max: 168
  ## - `bucket_width=1m`: default: 60, max: 1440
  ## 
  ##   api_key_ids: JArray
  ##              : Return only usage for these API keys.
  ##   user_ids: JArray
  ##           : Return only usage for these users.
  ##   models: JArray
  ##         : Return only usage for these models.
  ##   start_time: JInt (required)
  ##             : Start time (Unix seconds) of the query time range, inclusive.
  section = newJObject()
  var valid_822085339 = query.getOrDefault("end_time")
  valid_822085339 = validateParameter(valid_822085339, JInt, required = false,
                                      default = nil)
  if valid_822085339 != nil:
    section.add "end_time", valid_822085339
  var valid_822085340 = query.getOrDefault("group_by")
  valid_822085340 = validateParameter(valid_822085340, JArray, required = false,
                                      default = nil)
  if valid_822085340 != nil:
    section.add "group_by", valid_822085340
  var valid_822085341 = query.getOrDefault("project_ids")
  valid_822085341 = validateParameter(valid_822085341, JArray, required = false,
                                      default = nil)
  if valid_822085341 != nil:
    section.add "project_ids", valid_822085341
  var valid_822085342 = query.getOrDefault("page")
  valid_822085342 = validateParameter(valid_822085342, JString,
                                      required = false, default = nil)
  if valid_822085342 != nil:
    section.add "page", valid_822085342
  var valid_822085343 = query.getOrDefault("bucket_width")
  valid_822085343 = validateParameter(valid_822085343, JString,
                                      required = false,
                                      default = newJString("1d"))
  if valid_822085343 != nil:
    section.add "bucket_width", valid_822085343
  var valid_822085344 = query.getOrDefault("limit")
  valid_822085344 = validateParameter(valid_822085344, JInt, required = false,
                                      default = nil)
  if valid_822085344 != nil:
    section.add "limit", valid_822085344
  var valid_822085345 = query.getOrDefault("api_key_ids")
  valid_822085345 = validateParameter(valid_822085345, JArray, required = false,
                                      default = nil)
  if valid_822085345 != nil:
    section.add "api_key_ids", valid_822085345
  var valid_822085346 = query.getOrDefault("user_ids")
  valid_822085346 = validateParameter(valid_822085346, JArray, required = false,
                                      default = nil)
  if valid_822085346 != nil:
    section.add "user_ids", valid_822085346
  var valid_822085347 = query.getOrDefault("models")
  valid_822085347 = validateParameter(valid_822085347, JArray, required = false,
                                      default = nil)
  if valid_822085347 != nil:
    section.add "models", valid_822085347
  assert query != nil,
         "query argument is necessary due to required `start_time` field"
  var valid_822085348 = query.getOrDefault("start_time")
  valid_822085348 = validateParameter(valid_822085348, JInt, required = true,
                                      default = nil)
  if valid_822085348 != nil:
    section.add "start_time", valid_822085348
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085349: Call_UsageEmbeddings_822085336; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085349.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085349.makeUrl(scheme.get, call_822085349.host, call_822085349.base,
                                   call_822085349.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085349, uri, valid, content)

proc call*(call_822085350: Call_UsageEmbeddings_822085336; startTime: int;
           endTime: int = 0; groupBy: JsonNode = nil;
           projectIds: JsonNode = nil; page: string = "";
           bucketWidth: string = "1d"; limit: int = 0;
           apiKeyIds: JsonNode = nil; userIds: JsonNode = nil;
           models: JsonNode = nil): Recallable =
  ## usageEmbeddings
  ##   endTime: int
  ##          : End time (Unix seconds) of the query time range, exclusive.
  ##   groupBy: JArray
  ##          : Group the usage data by the specified fields. Support fields include `project_id`, `user_id`, `api_key_id`, `model` or any combination of them.
  ##   projectIds: JArray
  ##             : Return only usage for these projects.
  ##   page: string
  ##       : A cursor for use in pagination. Corresponding to the `next_page` field from the previous response.
  ##   bucketWidth: string
  ##              : Width of each time bucket in response. Currently `1m`, `1h` and `1d` are supported, default to `1d`.
  ##   limit: int
  ##        : Specifies the number of buckets to return.
  ## - `bucket_width=1d`: default: 7, max: 31
  ## - `bucket_width=1h`: default: 24, max: 168
  ## - `bucket_width=1m`: default: 60, max: 1440
  ## 
  ##   apiKeyIds: JArray
  ##            : Return only usage for these API keys.
  ##   userIds: JArray
  ##          : Return only usage for these users.
  ##   models: JArray
  ##         : Return only usage for these models.
  ##   startTime: int (required)
  ##            : Start time (Unix seconds) of the query time range, inclusive.
  var query_822085351 = newJObject()
  add(query_822085351, "end_time", newJInt(endTime))
  if groupBy != nil:
    query_822085351.add "group_by", groupBy
  if projectIds != nil:
    query_822085351.add "project_ids", projectIds
  add(query_822085351, "page", newJString(page))
  add(query_822085351, "bucket_width", newJString(bucketWidth))
  add(query_822085351, "limit", newJInt(limit))
  if apiKeyIds != nil:
    query_822085351.add "api_key_ids", apiKeyIds
  if userIds != nil:
    query_822085351.add "user_ids", userIds
  if models != nil:
    query_822085351.add "models", models
  add(query_822085351, "start_time", newJInt(startTime))
  result = call_822085350.call(nil, query_822085351, nil, nil, nil)

var usageEmbeddings* = Call_UsageEmbeddings_822085336(name: "usageEmbeddings",
    meth: HttpMethod.HttpGet, host: "api.openai.com",
    route: "/organization/usage/embeddings",
    validator: validate_UsageEmbeddings_822085337, base: "/v1",
    makeUrl: url_UsageEmbeddings_822085338, schemes: {Scheme.Https})
type
  Call_UsageImages_822085352 = ref object of OpenApiRestCall_822083995
proc url_UsageImages_822085354(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_UsageImages_822085353(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   end_time: JInt
  ##           : End time (Unix seconds) of the query time range, exclusive.
  ##   group_by: JArray
  ##           : Group the usage data by the specified fields. Support fields include `project_id`, `user_id`, `api_key_id`, `model`, `size`, `source` or any combination of them.
  ##   project_ids: JArray
  ##              : Return only usage for these projects.
  ##   page: JString
  ##       : A cursor for use in pagination. Corresponding to the `next_page` field from the previous response.
  ##   bucket_width: JString
  ##               : Width of each time bucket in response. Currently `1m`, `1h` and `1d` are supported, default to `1d`.
  ##   sources: JArray
  ##          : Return only usages for these sources. Possible values are `image.generation`, `image.edit`, `image.variation` or any combination of them.
  ##   limit: JInt
  ##        : Specifies the number of buckets to return.
  ## - `bucket_width=1d`: default: 7, max: 31
  ## - `bucket_width=1h`: default: 24, max: 168
  ## - `bucket_width=1m`: default: 60, max: 1440
  ## 
  ##   api_key_ids: JArray
  ##              : Return only usage for these API keys.
  ##   user_ids: JArray
  ##           : Return only usage for these users.
  ##   sizes: JArray
  ##        : Return only usages for these image sizes. Possible values are `256x256`, `512x512`, `1024x1024`, `1792x1792`, `1024x1792` or any combination of them.
  ##   models: JArray
  ##         : Return only usage for these models.
  ##   start_time: JInt (required)
  ##             : Start time (Unix seconds) of the query time range, inclusive.
  section = newJObject()
  var valid_822085355 = query.getOrDefault("end_time")
  valid_822085355 = validateParameter(valid_822085355, JInt, required = false,
                                      default = nil)
  if valid_822085355 != nil:
    section.add "end_time", valid_822085355
  var valid_822085356 = query.getOrDefault("group_by")
  valid_822085356 = validateParameter(valid_822085356, JArray, required = false,
                                      default = nil)
  if valid_822085356 != nil:
    section.add "group_by", valid_822085356
  var valid_822085357 = query.getOrDefault("project_ids")
  valid_822085357 = validateParameter(valid_822085357, JArray, required = false,
                                      default = nil)
  if valid_822085357 != nil:
    section.add "project_ids", valid_822085357
  var valid_822085358 = query.getOrDefault("page")
  valid_822085358 = validateParameter(valid_822085358, JString,
                                      required = false, default = nil)
  if valid_822085358 != nil:
    section.add "page", valid_822085358
  var valid_822085359 = query.getOrDefault("bucket_width")
  valid_822085359 = validateParameter(valid_822085359, JString,
                                      required = false,
                                      default = newJString("1d"))
  if valid_822085359 != nil:
    section.add "bucket_width", valid_822085359
  var valid_822085360 = query.getOrDefault("sources")
  valid_822085360 = validateParameter(valid_822085360, JArray, required = false,
                                      default = nil)
  if valid_822085360 != nil:
    section.add "sources", valid_822085360
  var valid_822085361 = query.getOrDefault("limit")
  valid_822085361 = validateParameter(valid_822085361, JInt, required = false,
                                      default = nil)
  if valid_822085361 != nil:
    section.add "limit", valid_822085361
  var valid_822085362 = query.getOrDefault("api_key_ids")
  valid_822085362 = validateParameter(valid_822085362, JArray, required = false,
                                      default = nil)
  if valid_822085362 != nil:
    section.add "api_key_ids", valid_822085362
  var valid_822085363 = query.getOrDefault("user_ids")
  valid_822085363 = validateParameter(valid_822085363, JArray, required = false,
                                      default = nil)
  if valid_822085363 != nil:
    section.add "user_ids", valid_822085363
  var valid_822085364 = query.getOrDefault("sizes")
  valid_822085364 = validateParameter(valid_822085364, JArray, required = false,
                                      default = nil)
  if valid_822085364 != nil:
    section.add "sizes", valid_822085364
  var valid_822085365 = query.getOrDefault("models")
  valid_822085365 = validateParameter(valid_822085365, JArray, required = false,
                                      default = nil)
  if valid_822085365 != nil:
    section.add "models", valid_822085365
  assert query != nil,
         "query argument is necessary due to required `start_time` field"
  var valid_822085366 = query.getOrDefault("start_time")
  valid_822085366 = validateParameter(valid_822085366, JInt, required = true,
                                      default = nil)
  if valid_822085366 != nil:
    section.add "start_time", valid_822085366
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085367: Call_UsageImages_822085352; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085367.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085367.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085367.makeUrl(scheme.get, call_822085367.host, call_822085367.base,
                                   call_822085367.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085367, uri, valid, content)

proc call*(call_822085368: Call_UsageImages_822085352; startTime: int;
           endTime: int = 0; groupBy: JsonNode = nil;
           projectIds: JsonNode = nil; page: string = "";
           bucketWidth: string = "1d"; sources: JsonNode = nil; limit: int = 0;
           apiKeyIds: JsonNode = nil; userIds: JsonNode = nil;
           sizes: JsonNode = nil; models: JsonNode = nil): Recallable =
  ## usageImages
  ##   endTime: int
  ##          : End time (Unix seconds) of the query time range, exclusive.
  ##   groupBy: JArray
  ##          : Group the usage data by the specified fields. Support fields include `project_id`, `user_id`, `api_key_id`, `model`, `size`, `source` or any combination of them.
  ##   projectIds: JArray
  ##             : Return only usage for these projects.
  ##   page: string
  ##       : A cursor for use in pagination. Corresponding to the `next_page` field from the previous response.
  ##   bucketWidth: string
  ##              : Width of each time bucket in response. Currently `1m`, `1h` and `1d` are supported, default to `1d`.
  ##   sources: JArray
  ##          : Return only usages for these sources. Possible values are `image.generation`, `image.edit`, `image.variation` or any combination of them.
  ##   limit: int
  ##        : Specifies the number of buckets to return.
  ## - `bucket_width=1d`: default: 7, max: 31
  ## - `bucket_width=1h`: default: 24, max: 168
  ## - `bucket_width=1m`: default: 60, max: 1440
  ## 
  ##   apiKeyIds: JArray
  ##            : Return only usage for these API keys.
  ##   userIds: JArray
  ##          : Return only usage for these users.
  ##   sizes: JArray
  ##        : Return only usages for these image sizes. Possible values are `256x256`, `512x512`, `1024x1024`, `1792x1792`, `1024x1792` or any combination of them.
  ##   models: JArray
  ##         : Return only usage for these models.
  ##   startTime: int (required)
  ##            : Start time (Unix seconds) of the query time range, inclusive.
  var query_822085369 = newJObject()
  add(query_822085369, "end_time", newJInt(endTime))
  if groupBy != nil:
    query_822085369.add "group_by", groupBy
  if projectIds != nil:
    query_822085369.add "project_ids", projectIds
  add(query_822085369, "page", newJString(page))
  add(query_822085369, "bucket_width", newJString(bucketWidth))
  if sources != nil:
    query_822085369.add "sources", sources
  add(query_822085369, "limit", newJInt(limit))
  if apiKeyIds != nil:
    query_822085369.add "api_key_ids", apiKeyIds
  if userIds != nil:
    query_822085369.add "user_ids", userIds
  if sizes != nil:
    query_822085369.add "sizes", sizes
  if models != nil:
    query_822085369.add "models", models
  add(query_822085369, "start_time", newJInt(startTime))
  result = call_822085368.call(nil, query_822085369, nil, nil, nil)

var usageImages* = Call_UsageImages_822085352(name: "usageImages",
    meth: HttpMethod.HttpGet, host: "api.openai.com",
    route: "/organization/usage/images", validator: validate_UsageImages_822085353,
    base: "/v1", makeUrl: url_UsageImages_822085354, schemes: {Scheme.Https})
type
  Call_UsageModerations_822085370 = ref object of OpenApiRestCall_822083995
proc url_UsageModerations_822085372(protocol: Scheme; host: string;
                                    base: string; route: string; path: JsonNode;
                                    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_UsageModerations_822085371(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   end_time: JInt
  ##           : End time (Unix seconds) of the query time range, exclusive.
  ##   group_by: JArray
  ##           : Group the usage data by the specified fields. Support fields include `project_id`, `user_id`, `api_key_id`, `model` or any combination of them.
  ##   project_ids: JArray
  ##              : Return only usage for these projects.
  ##   page: JString
  ##       : A cursor for use in pagination. Corresponding to the `next_page` field from the previous response.
  ##   bucket_width: JString
  ##               : Width of each time bucket in response. Currently `1m`, `1h` and `1d` are supported, default to `1d`.
  ##   limit: JInt
  ##        : Specifies the number of buckets to return.
  ## - `bucket_width=1d`: default: 7, max: 31
  ## - `bucket_width=1h`: default: 24, max: 168
  ## - `bucket_width=1m`: default: 60, max: 1440
  ## 
  ##   api_key_ids: JArray
  ##              : Return only usage for these API keys.
  ##   user_ids: JArray
  ##           : Return only usage for these users.
  ##   models: JArray
  ##         : Return only usage for these models.
  ##   start_time: JInt (required)
  ##             : Start time (Unix seconds) of the query time range, inclusive.
  section = newJObject()
  var valid_822085373 = query.getOrDefault("end_time")
  valid_822085373 = validateParameter(valid_822085373, JInt, required = false,
                                      default = nil)
  if valid_822085373 != nil:
    section.add "end_time", valid_822085373
  var valid_822085374 = query.getOrDefault("group_by")
  valid_822085374 = validateParameter(valid_822085374, JArray, required = false,
                                      default = nil)
  if valid_822085374 != nil:
    section.add "group_by", valid_822085374
  var valid_822085375 = query.getOrDefault("project_ids")
  valid_822085375 = validateParameter(valid_822085375, JArray, required = false,
                                      default = nil)
  if valid_822085375 != nil:
    section.add "project_ids", valid_822085375
  var valid_822085376 = query.getOrDefault("page")
  valid_822085376 = validateParameter(valid_822085376, JString,
                                      required = false, default = nil)
  if valid_822085376 != nil:
    section.add "page", valid_822085376
  var valid_822085377 = query.getOrDefault("bucket_width")
  valid_822085377 = validateParameter(valid_822085377, JString,
                                      required = false,
                                      default = newJString("1d"))
  if valid_822085377 != nil:
    section.add "bucket_width", valid_822085377
  var valid_822085378 = query.getOrDefault("limit")
  valid_822085378 = validateParameter(valid_822085378, JInt, required = false,
                                      default = nil)
  if valid_822085378 != nil:
    section.add "limit", valid_822085378
  var valid_822085379 = query.getOrDefault("api_key_ids")
  valid_822085379 = validateParameter(valid_822085379, JArray, required = false,
                                      default = nil)
  if valid_822085379 != nil:
    section.add "api_key_ids", valid_822085379
  var valid_822085380 = query.getOrDefault("user_ids")
  valid_822085380 = validateParameter(valid_822085380, JArray, required = false,
                                      default = nil)
  if valid_822085380 != nil:
    section.add "user_ids", valid_822085380
  var valid_822085381 = query.getOrDefault("models")
  valid_822085381 = validateParameter(valid_822085381, JArray, required = false,
                                      default = nil)
  if valid_822085381 != nil:
    section.add "models", valid_822085381
  assert query != nil,
         "query argument is necessary due to required `start_time` field"
  var valid_822085382 = query.getOrDefault("start_time")
  valid_822085382 = validateParameter(valid_822085382, JInt, required = true,
                                      default = nil)
  if valid_822085382 != nil:
    section.add "start_time", valid_822085382
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085383: Call_UsageModerations_822085370;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085383.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085383.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085383.makeUrl(scheme.get, call_822085383.host, call_822085383.base,
                                   call_822085383.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085383, uri, valid, content)

proc call*(call_822085384: Call_UsageModerations_822085370; startTime: int;
           endTime: int = 0; groupBy: JsonNode = nil;
           projectIds: JsonNode = nil; page: string = "";
           bucketWidth: string = "1d"; limit: int = 0;
           apiKeyIds: JsonNode = nil; userIds: JsonNode = nil;
           models: JsonNode = nil): Recallable =
  ## usageModerations
  ##   endTime: int
  ##          : End time (Unix seconds) of the query time range, exclusive.
  ##   groupBy: JArray
  ##          : Group the usage data by the specified fields. Support fields include `project_id`, `user_id`, `api_key_id`, `model` or any combination of them.
  ##   projectIds: JArray
  ##             : Return only usage for these projects.
  ##   page: string
  ##       : A cursor for use in pagination. Corresponding to the `next_page` field from the previous response.
  ##   bucketWidth: string
  ##              : Width of each time bucket in response. Currently `1m`, `1h` and `1d` are supported, default to `1d`.
  ##   limit: int
  ##        : Specifies the number of buckets to return.
  ## - `bucket_width=1d`: default: 7, max: 31
  ## - `bucket_width=1h`: default: 24, max: 168
  ## - `bucket_width=1m`: default: 60, max: 1440
  ## 
  ##   apiKeyIds: JArray
  ##            : Return only usage for these API keys.
  ##   userIds: JArray
  ##          : Return only usage for these users.
  ##   models: JArray
  ##         : Return only usage for these models.
  ##   startTime: int (required)
  ##            : Start time (Unix seconds) of the query time range, inclusive.
  var query_822085385 = newJObject()
  add(query_822085385, "end_time", newJInt(endTime))
  if groupBy != nil:
    query_822085385.add "group_by", groupBy
  if projectIds != nil:
    query_822085385.add "project_ids", projectIds
  add(query_822085385, "page", newJString(page))
  add(query_822085385, "bucket_width", newJString(bucketWidth))
  add(query_822085385, "limit", newJInt(limit))
  if apiKeyIds != nil:
    query_822085385.add "api_key_ids", apiKeyIds
  if userIds != nil:
    query_822085385.add "user_ids", userIds
  if models != nil:
    query_822085385.add "models", models
  add(query_822085385, "start_time", newJInt(startTime))
  result = call_822085384.call(nil, query_822085385, nil, nil, nil)

var usageModerations* = Call_UsageModerations_822085370(
    name: "usageModerations", meth: HttpMethod.HttpGet, host: "api.openai.com",
    route: "/organization/usage/moderations",
    validator: validate_UsageModerations_822085371, base: "/v1",
    makeUrl: url_UsageModerations_822085372, schemes: {Scheme.Https})
type
  Call_UsageVectorStores_822085386 = ref object of OpenApiRestCall_822083995
proc url_UsageVectorStores_822085388(protocol: Scheme; host: string;
                                     base: string; route: string;
                                     path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_UsageVectorStores_822085387(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   end_time: JInt
  ##           : End time (Unix seconds) of the query time range, exclusive.
  ##   group_by: JArray
  ##           : Group the usage data by the specified fields. Support fields include `project_id`.
  ##   project_ids: JArray
  ##              : Return only usage for these projects.
  ##   page: JString
  ##       : A cursor for use in pagination. Corresponding to the `next_page` field from the previous response.
  ##   bucket_width: JString
  ##               : Width of each time bucket in response. Currently `1m`, `1h` and `1d` are supported, default to `1d`.
  ##   limit: JInt
  ##        : Specifies the number of buckets to return.
  ## - `bucket_width=1d`: default: 7, max: 31
  ## - `bucket_width=1h`: default: 24, max: 168
  ## - `bucket_width=1m`: default: 60, max: 1440
  ## 
  ##   start_time: JInt (required)
  ##             : Start time (Unix seconds) of the query time range, inclusive.
  section = newJObject()
  var valid_822085389 = query.getOrDefault("end_time")
  valid_822085389 = validateParameter(valid_822085389, JInt, required = false,
                                      default = nil)
  if valid_822085389 != nil:
    section.add "end_time", valid_822085389
  var valid_822085390 = query.getOrDefault("group_by")
  valid_822085390 = validateParameter(valid_822085390, JArray, required = false,
                                      default = nil)
  if valid_822085390 != nil:
    section.add "group_by", valid_822085390
  var valid_822085391 = query.getOrDefault("project_ids")
  valid_822085391 = validateParameter(valid_822085391, JArray, required = false,
                                      default = nil)
  if valid_822085391 != nil:
    section.add "project_ids", valid_822085391
  var valid_822085392 = query.getOrDefault("page")
  valid_822085392 = validateParameter(valid_822085392, JString,
                                      required = false, default = nil)
  if valid_822085392 != nil:
    section.add "page", valid_822085392
  var valid_822085393 = query.getOrDefault("bucket_width")
  valid_822085393 = validateParameter(valid_822085393, JString,
                                      required = false,
                                      default = newJString("1d"))
  if valid_822085393 != nil:
    section.add "bucket_width", valid_822085393
  var valid_822085394 = query.getOrDefault("limit")
  valid_822085394 = validateParameter(valid_822085394, JInt, required = false,
                                      default = nil)
  if valid_822085394 != nil:
    section.add "limit", valid_822085394
  assert query != nil,
         "query argument is necessary due to required `start_time` field"
  var valid_822085395 = query.getOrDefault("start_time")
  valid_822085395 = validateParameter(valid_822085395, JInt, required = true,
                                      default = nil)
  if valid_822085395 != nil:
    section.add "start_time", valid_822085395
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085396: Call_UsageVectorStores_822085386;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085396.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085396.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085396.makeUrl(scheme.get, call_822085396.host, call_822085396.base,
                                   call_822085396.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085396, uri, valid, content)

proc call*(call_822085397: Call_UsageVectorStores_822085386; startTime: int;
           endTime: int = 0; groupBy: JsonNode = nil;
           projectIds: JsonNode = nil; page: string = "";
           bucketWidth: string = "1d"; limit: int = 0): Recallable =
  ## usageVectorStores
  ##   endTime: int
  ##          : End time (Unix seconds) of the query time range, exclusive.
  ##   groupBy: JArray
  ##          : Group the usage data by the specified fields. Support fields include `project_id`.
  ##   projectIds: JArray
  ##             : Return only usage for these projects.
  ##   page: string
  ##       : A cursor for use in pagination. Corresponding to the `next_page` field from the previous response.
  ##   bucketWidth: string
  ##              : Width of each time bucket in response. Currently `1m`, `1h` and `1d` are supported, default to `1d`.
  ##   limit: int
  ##        : Specifies the number of buckets to return.
  ## - `bucket_width=1d`: default: 7, max: 31
  ## - `bucket_width=1h`: default: 24, max: 168
  ## - `bucket_width=1m`: default: 60, max: 1440
  ## 
  ##   startTime: int (required)
  ##            : Start time (Unix seconds) of the query time range, inclusive.
  var query_822085398 = newJObject()
  add(query_822085398, "end_time", newJInt(endTime))
  if groupBy != nil:
    query_822085398.add "group_by", groupBy
  if projectIds != nil:
    query_822085398.add "project_ids", projectIds
  add(query_822085398, "page", newJString(page))
  add(query_822085398, "bucket_width", newJString(bucketWidth))
  add(query_822085398, "limit", newJInt(limit))
  add(query_822085398, "start_time", newJInt(startTime))
  result = call_822085397.call(nil, query_822085398, nil, nil, nil)

var usageVectorStores* = Call_UsageVectorStores_822085386(
    name: "usageVectorStores", meth: HttpMethod.HttpGet, host: "api.openai.com",
    route: "/organization/usage/vector_stores",
    validator: validate_UsageVectorStores_822085387, base: "/v1",
    makeUrl: url_UsageVectorStores_822085388, schemes: {Scheme.Https})
type
  Call_ListUsers_822085399 = ref object of OpenApiRestCall_822083995
proc url_ListUsers_822085401(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_ListUsers_822085400(path: JsonNode; query: JsonNode;
                                  header: JsonNode; formData: JsonNode;
                                  body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   emails: JArray
  ##         : Filter by the email address of users.
  ##   after: JString
  ##        : A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
  ## 
  ##   limit: JInt
  ##        : A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.
  ## 
  section = newJObject()
  var valid_822085402 = query.getOrDefault("emails")
  valid_822085402 = validateParameter(valid_822085402, JArray, required = false,
                                      default = nil)
  if valid_822085402 != nil:
    section.add "emails", valid_822085402
  var valid_822085403 = query.getOrDefault("after")
  valid_822085403 = validateParameter(valid_822085403, JString,
                                      required = false, default = nil)
  if valid_822085403 != nil:
    section.add "after", valid_822085403
  var valid_822085404 = query.getOrDefault("limit")
  valid_822085404 = validateParameter(valid_822085404, JInt, required = false,
                                      default = newJInt(20))
  if valid_822085404 != nil:
    section.add "limit", valid_822085404
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085405: Call_ListUsers_822085399; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085405.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085405.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085405.makeUrl(scheme.get, call_822085405.host, call_822085405.base,
                                   call_822085405.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085405, uri, valid, content)

proc call*(call_822085406: Call_ListUsers_822085399; emails: JsonNode = nil;
           after: string = ""; limit: int = 20): Recallable =
  ## listUsers
  ##   emails: JArray
  ##         : Filter by the email address of users.
  ##   after: string
  ##        : A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
  ## 
  ##   limit: int
  ##        : A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.
  ## 
  var query_822085407 = newJObject()
  if emails != nil:
    query_822085407.add "emails", emails
  add(query_822085407, "after", newJString(after))
  add(query_822085407, "limit", newJInt(limit))
  result = call_822085406.call(nil, query_822085407, nil, nil, nil)

var listUsers* = Call_ListUsers_822085399(name: "listUsers",
    meth: HttpMethod.HttpGet, host: "api.openai.com",
    route: "/organization/users", validator: validate_ListUsers_822085400,
    base: "/v1", makeUrl: url_ListUsers_822085401, schemes: {Scheme.Https})
type
  Call_DeleteUser_822085424 = ref object of OpenApiRestCall_822083995
proc url_DeleteUser_822085426(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "user_id" in path, "`user_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/organization/users/"),
                 (kind: VariableSegment, value: "user_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DeleteUser_822085425(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   user_id: JString (required)
  ##          : The ID of the user.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `user_id` field"
  var valid_822085427 = path.getOrDefault("user_id")
  valid_822085427 = validateParameter(valid_822085427, JString, required = true,
                                      default = nil)
  if valid_822085427 != nil:
    section.add "user_id", valid_822085427
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085428: Call_DeleteUser_822085424; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085428.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085428.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085428.makeUrl(scheme.get, call_822085428.host, call_822085428.base,
                                   call_822085428.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085428, uri, valid, content)

proc call*(call_822085429: Call_DeleteUser_822085424; userId: string): Recallable =
  ## deleteUser
  ##   userId: string (required)
  ##         : The ID of the user.
  var path_822085430 = newJObject()
  add(path_822085430, "user_id", newJString(userId))
  result = call_822085429.call(path_822085430, nil, nil, nil, nil)

var deleteUser* = Call_DeleteUser_822085424(name: "deleteUser",
    meth: HttpMethod.HttpDelete, host: "api.openai.com",
    route: "/organization/users/{user_id}", validator: validate_DeleteUser_822085425,
    base: "/v1", makeUrl: url_DeleteUser_822085426, schemes: {Scheme.Https})
type
  Call_ModifyUser_822085415 = ref object of OpenApiRestCall_822083995
proc url_ModifyUser_822085417(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "user_id" in path, "`user_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/organization/users/"),
                 (kind: VariableSegment, value: "user_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ModifyUser_822085416(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   user_id: JString (required)
  ##          : The ID of the user.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `user_id` field"
  var valid_822085418 = path.getOrDefault("user_id")
  valid_822085418 = validateParameter(valid_822085418, JString, required = true,
                                      default = nil)
  if valid_822085418 != nil:
    section.add "user_id", valid_822085418
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : The new user role to modify. This must be one of `owner` or `member`.
  if `==`(content, ""): assert body != nil, "body argument is necessary"
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085420: Call_ModifyUser_822085415; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085420.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085420.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085420.makeUrl(scheme.get, call_822085420.host, call_822085420.base,
                                   call_822085420.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085420, uri, valid, content)

proc call*(call_822085421: Call_ModifyUser_822085415; body: JsonNode;
           userId: string): Recallable =
  ## modifyUser
  ##   body: JObject (required)
  ##       : The new user role to modify. This must be one of `owner` or `member`.
  ##   userId: string (required)
  ##         : The ID of the user.
  var path_822085422 = newJObject()
  var body_822085423 = newJObject()
  if body != nil:
    body_822085423 = body
  add(path_822085422, "user_id", newJString(userId))
  result = call_822085421.call(path_822085422, nil, nil, nil, body_822085423)

var modifyUser* = Call_ModifyUser_822085415(name: "modifyUser",
    meth: HttpMethod.HttpPost, host: "api.openai.com",
    route: "/organization/users/{user_id}", validator: validate_ModifyUser_822085416,
    base: "/v1", makeUrl: url_ModifyUser_822085417, schemes: {Scheme.Https})
type
  Call_RetrieveUser_822085408 = ref object of OpenApiRestCall_822083995
proc url_RetrieveUser_822085410(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "user_id" in path, "`user_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/organization/users/"),
                 (kind: VariableSegment, value: "user_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RetrieveUser_822085409(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   user_id: JString (required)
  ##          : The ID of the user.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `user_id` field"
  var valid_822085411 = path.getOrDefault("user_id")
  valid_822085411 = validateParameter(valid_822085411, JString, required = true,
                                      default = nil)
  if valid_822085411 != nil:
    section.add "user_id", valid_822085411
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085412: Call_RetrieveUser_822085408; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085412.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085412.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085412.makeUrl(scheme.get, call_822085412.host, call_822085412.base,
                                   call_822085412.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085412, uri, valid, content)

proc call*(call_822085413: Call_RetrieveUser_822085408; userId: string): Recallable =
  ## retrieveUser
  ##   userId: string (required)
  ##         : The ID of the user.
  var path_822085414 = newJObject()
  add(path_822085414, "user_id", newJString(userId))
  result = call_822085413.call(path_822085414, nil, nil, nil, nil)

var retrieveUser* = Call_RetrieveUser_822085408(name: "retrieveUser",
    meth: HttpMethod.HttpGet, host: "api.openai.com",
    route: "/organization/users/{user_id}", validator: validate_RetrieveUser_822085409,
    base: "/v1", makeUrl: url_RetrieveUser_822085410, schemes: {Scheme.Https})
type
  Call_CreateRealtimeSession_822085431 = ref object of OpenApiRestCall_822083995
proc url_CreateRealtimeSession_822085433(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CreateRealtimeSession_822085432(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Create an ephemeral API key with the given session configuration.
  if `==`(content, ""): assert body != nil, "body argument is necessary"
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085435: Call_CreateRealtimeSession_822085431;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085435.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085435.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085435.makeUrl(scheme.get, call_822085435.host, call_822085435.base,
                                   call_822085435.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085435, uri, valid, content)

proc call*(call_822085436: Call_CreateRealtimeSession_822085431; body: JsonNode): Recallable =
  ## createRealtimeSession
  ##   body: JObject (required)
  ##       : Create an ephemeral API key with the given session configuration.
  var body_822085437 = newJObject()
  if body != nil:
    body_822085437 = body
  result = call_822085436.call(nil, nil, nil, nil, body_822085437)

var createRealtimeSession* = Call_CreateRealtimeSession_822085431(
    name: "createRealtimeSession", meth: HttpMethod.HttpPost,
    host: "api.openai.com", route: "/realtime/sessions",
    validator: validate_CreateRealtimeSession_822085432, base: "/v1",
    makeUrl: url_CreateRealtimeSession_822085433, schemes: {Scheme.Https})
type
  Call_CreateRealtimeTranscriptionSession_822085438 = ref object of OpenApiRestCall_822083995
proc url_CreateRealtimeTranscriptionSession_822085440(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CreateRealtimeTranscriptionSession_822085439(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode;
    content: string = ""): JsonNode {.nosinks.} =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Create an ephemeral API key with the given session configuration.
  if `==`(content, ""): assert body != nil, "body argument is necessary"
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085442: Call_CreateRealtimeTranscriptionSession_822085438;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085442.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085442.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085442.makeUrl(scheme.get, call_822085442.host, call_822085442.base,
                                   call_822085442.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085442, uri, valid, content)

proc call*(call_822085443: Call_CreateRealtimeTranscriptionSession_822085438;
           body: JsonNode): Recallable =
  ## createRealtimeTranscriptionSession
  ##   body: JObject (required)
  ##       : Create an ephemeral API key with the given session configuration.
  var body_822085444 = newJObject()
  if body != nil:
    body_822085444 = body
  result = call_822085443.call(nil, nil, nil, nil, body_822085444)

var createRealtimeTranscriptionSession* = Call_CreateRealtimeTranscriptionSession_822085438(
    name: "createRealtimeTranscriptionSession", meth: HttpMethod.HttpPost,
    host: "api.openai.com", route: "/realtime/transcription_sessions",
    validator: validate_CreateRealtimeTranscriptionSession_822085439,
    base: "/v1", makeUrl: url_CreateRealtimeTranscriptionSession_822085440,
    schemes: {Scheme.Https})
type
  Call_CreateResponse_822085445 = ref object of OpenApiRestCall_822083995
proc url_CreateResponse_822085447(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CreateResponse_822085446(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  if `==`(content, ""): assert body != nil, "body argument is necessary"
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085449: Call_CreateResponse_822085445; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085449.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085449.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085449.makeUrl(scheme.get, call_822085449.host, call_822085449.base,
                                   call_822085449.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085449, uri, valid, content)

proc call*(call_822085450: Call_CreateResponse_822085445; body: JsonNode): Recallable =
  ## createResponse
  ##   body: JObject (required)
  var body_822085451 = newJObject()
  if body != nil:
    body_822085451 = body
  result = call_822085450.call(nil, nil, nil, nil, body_822085451)

var createResponse* = Call_CreateResponse_822085445(name: "createResponse",
    meth: HttpMethod.HttpPost, host: "api.openai.com", route: "/responses",
    validator: validate_CreateResponse_822085446, base: "/v1",
    makeUrl: url_CreateResponse_822085447, schemes: {Scheme.Https})
type
  Call_DeleteResponse_822085463 = ref object of OpenApiRestCall_822083995
proc url_DeleteResponse_822085465(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "response_id" in path, "`response_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/responses/"),
                 (kind: VariableSegment, value: "response_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DeleteResponse_822085464(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   response_id: JString (required)
  ##              : The ID of the response to delete.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `response_id` field"
  var valid_822085466 = path.getOrDefault("response_id")
  valid_822085466 = validateParameter(valid_822085466, JString, required = true,
                                      default = nil)
  if valid_822085466 != nil:
    section.add "response_id", valid_822085466
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085467: Call_DeleteResponse_822085463; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085467.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085467.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085467.makeUrl(scheme.get, call_822085467.host, call_822085467.base,
                                   call_822085467.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085467, uri, valid, content)

proc call*(call_822085468: Call_DeleteResponse_822085463; responseId: string): Recallable =
  ## deleteResponse
  ##   responseId: string (required)
  ##             : The ID of the response to delete.
  var path_822085469 = newJObject()
  add(path_822085469, "response_id", newJString(responseId))
  result = call_822085468.call(path_822085469, nil, nil, nil, nil)

var deleteResponse* = Call_DeleteResponse_822085463(name: "deleteResponse",
    meth: HttpMethod.HttpDelete, host: "api.openai.com",
    route: "/responses/{response_id}", validator: validate_DeleteResponse_822085464,
    base: "/v1", makeUrl: url_DeleteResponse_822085465, schemes: {Scheme.Https})
type
  Call_GetResponse_822085452 = ref object of OpenApiRestCall_822083995
proc url_GetResponse_822085454(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "response_id" in path, "`response_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/responses/"),
                 (kind: VariableSegment, value: "response_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GetResponse_822085453(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   response_id: JString (required)
  ##              : The ID of the response to retrieve.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `response_id` field"
  var valid_822085455 = path.getOrDefault("response_id")
  valid_822085455 = validateParameter(valid_822085455, JString, required = true,
                                      default = nil)
  if valid_822085455 != nil:
    section.add "response_id", valid_822085455
  result.add "path", section
  ## parameters in `query` object:
  ##   stream: JBool
  ##         : If set to true, the model response data will be streamed to the client
  ## as it is generated using [server-sent 
  ## events](https://developer.mozilla.org/en-US/docs/Web/API/Server-sent_events/Using_server-sent_events#Event_stream_format).
  ## See the [Streaming section below](/docs/api-reference/responses-streaming)
  ## for more information.
  ## 
  ##   starting_after: JInt
  ##                 : The sequence number of the event after which to start streaming.
  ## 
  ##   include: JArray
  ##          : Additional fields to include in the response. See the `include`
  ## parameter for Response creation above for more information.
  ## 
  section = newJObject()
  var valid_822085456 = query.getOrDefault("stream")
  valid_822085456 = validateParameter(valid_822085456, JBool, required = false,
                                      default = nil)
  if valid_822085456 != nil:
    section.add "stream", valid_822085456
  var valid_822085457 = query.getOrDefault("starting_after")
  valid_822085457 = validateParameter(valid_822085457, JInt, required = false,
                                      default = nil)
  if valid_822085457 != nil:
    section.add "starting_after", valid_822085457
  var valid_822085458 = query.getOrDefault("include")
  valid_822085458 = validateParameter(valid_822085458, JArray, required = false,
                                      default = nil)
  if valid_822085458 != nil:
    section.add "include", valid_822085458
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085459: Call_GetResponse_822085452; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085459.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085459.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085459.makeUrl(scheme.get, call_822085459.host, call_822085459.base,
                                   call_822085459.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085459, uri, valid, content)

proc call*(call_822085460: Call_GetResponse_822085452; responseId: string;
           stream: bool = false; startingAfter: int = 0;
           `include`: JsonNode = nil): Recallable =
  ## getResponse
  ##   stream: bool
  ##         : If set to true, the model response data will be streamed to the client
  ## as it is generated using [server-sent 
  ## events](https://developer.mozilla.org/en-US/docs/Web/API/Server-sent_events/Using_server-sent_events#Event_stream_format).
  ## See the [Streaming section below](/docs/api-reference/responses-streaming)
  ## for more information.
  ## 
  ##   startingAfter: int
  ##                : The sequence number of the event after which to start streaming.
  ## 
  ##   responseId: string (required)
  ##             : The ID of the response to retrieve.
  ##   include: JArray
  ##          : Additional fields to include in the response. See the `include`
  ## parameter for Response creation above for more information.
  ## 
  var path_822085461 = newJObject()
  var query_822085462 = newJObject()
  add(query_822085462, "stream", newJBool(stream))
  add(query_822085462, "starting_after", newJInt(startingAfter))
  add(path_822085461, "response_id", newJString(responseId))
  if `include` != nil:
    query_822085462.add "include", `include`
  result = call_822085460.call(path_822085461, query_822085462, nil, nil, nil)

var getResponse* = Call_GetResponse_822085452(name: "getResponse",
    meth: HttpMethod.HttpGet, host: "api.openai.com",
    route: "/responses/{response_id}", validator: validate_GetResponse_822085453,
    base: "/v1", makeUrl: url_GetResponse_822085454, schemes: {Scheme.Https})
type
  Call_CancelResponse_822085470 = ref object of OpenApiRestCall_822083995
proc url_CancelResponse_822085472(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "response_id" in path, "`response_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/responses/"),
                 (kind: VariableSegment, value: "response_id"),
                 (kind: ConstantSegment, value: "/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CancelResponse_822085471(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   response_id: JString (required)
  ##              : The ID of the response to cancel.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `response_id` field"
  var valid_822085473 = path.getOrDefault("response_id")
  valid_822085473 = validateParameter(valid_822085473, JString, required = true,
                                      default = nil)
  if valid_822085473 != nil:
    section.add "response_id", valid_822085473
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085474: Call_CancelResponse_822085470; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085474.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085474.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085474.makeUrl(scheme.get, call_822085474.host, call_822085474.base,
                                   call_822085474.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085474, uri, valid, content)

proc call*(call_822085475: Call_CancelResponse_822085470; responseId: string): Recallable =
  ## cancelResponse
  ##   responseId: string (required)
  ##             : The ID of the response to cancel.
  var path_822085476 = newJObject()
  add(path_822085476, "response_id", newJString(responseId))
  result = call_822085475.call(path_822085476, nil, nil, nil, nil)

var cancelResponse* = Call_CancelResponse_822085470(name: "cancelResponse",
    meth: HttpMethod.HttpPost, host: "api.openai.com",
    route: "/responses/{response_id}/cancel",
    validator: validate_CancelResponse_822085471, base: "/v1",
    makeUrl: url_CancelResponse_822085472, schemes: {Scheme.Https})
type
  Call_ListInputItems_822085477 = ref object of OpenApiRestCall_822083995
proc url_ListInputItems_822085479(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "response_id" in path, "`response_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/responses/"),
                 (kind: VariableSegment, value: "response_id"),
                 (kind: ConstantSegment, value: "/input_items")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ListInputItems_822085478(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   response_id: JString (required)
  ##              : The ID of the response to retrieve input items for.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `response_id` field"
  var valid_822085480 = path.getOrDefault("response_id")
  valid_822085480 = validateParameter(valid_822085480, JString, required = true,
                                      default = nil)
  if valid_822085480 != nil:
    section.add "response_id", valid_822085480
  result.add "path", section
  ## parameters in `query` object:
  ##   after: JString
  ##        : An item ID to list items after, used in pagination.
  ## 
  ##   order: JString
  ##        : The order to return the input items in. Default is `desc`.
  ## - `asc`: Return the input items in ascending order.
  ## - `desc`: Return the input items in descending order.
  ## 
  ##   limit: JInt
  ##        : A limit on the number of objects to be returned. Limit can range between
  ## 1 and 100, and the default is 20.
  ## 
  ##   include: JArray
  ##          : Additional fields to include in the response. See the `include`
  ## parameter for Response creation above for more information.
  ## 
  ##   before: JString
  ##         : An item ID to list items before, used in pagination.
  ## 
  section = newJObject()
  var valid_822085481 = query.getOrDefault("after")
  valid_822085481 = validateParameter(valid_822085481, JString,
                                      required = false, default = nil)
  if valid_822085481 != nil:
    section.add "after", valid_822085481
  var valid_822085482 = query.getOrDefault("order")
  valid_822085482 = validateParameter(valid_822085482, JString,
                                      required = false,
                                      default = newJString("asc"))
  if valid_822085482 != nil:
    section.add "order", valid_822085482
  var valid_822085483 = query.getOrDefault("limit")
  valid_822085483 = validateParameter(valid_822085483, JInt, required = false,
                                      default = newJInt(20))
  if valid_822085483 != nil:
    section.add "limit", valid_822085483
  var valid_822085484 = query.getOrDefault("include")
  valid_822085484 = validateParameter(valid_822085484, JArray, required = false,
                                      default = nil)
  if valid_822085484 != nil:
    section.add "include", valid_822085484
  var valid_822085485 = query.getOrDefault("before")
  valid_822085485 = validateParameter(valid_822085485, JString,
                                      required = false, default = nil)
  if valid_822085485 != nil:
    section.add "before", valid_822085485
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085486: Call_ListInputItems_822085477; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085486.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085486.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085486.makeUrl(scheme.get, call_822085486.host, call_822085486.base,
                                   call_822085486.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085486, uri, valid, content)

proc call*(call_822085487: Call_ListInputItems_822085477; responseId: string;
           after: string = ""; order: string = "asc"; limit: int = 20;
           `include`: JsonNode = nil; before: string = ""): Recallable =
  ## listInputItems
  ##   after: string
  ##        : An item ID to list items after, used in pagination.
  ## 
  ##   order: string
  ##        : The order to return the input items in. Default is `desc`.
  ## - `asc`: Return the input items in ascending order.
  ## - `desc`: Return the input items in descending order.
  ## 
  ##   limit: int
  ##        : A limit on the number of objects to be returned. Limit can range between
  ## 1 and 100, and the default is 20.
  ## 
  ##   responseId: string (required)
  ##             : The ID of the response to retrieve input items for.
  ##   include: JArray
  ##          : Additional fields to include in the response. See the `include`
  ## parameter for Response creation above for more information.
  ## 
  ##   before: string
  ##         : An item ID to list items before, used in pagination.
  ## 
  var path_822085488 = newJObject()
  var query_822085489 = newJObject()
  add(query_822085489, "after", newJString(after))
  add(query_822085489, "order", newJString(order))
  add(query_822085489, "limit", newJInt(limit))
  add(path_822085488, "response_id", newJString(responseId))
  if `include` != nil:
    query_822085489.add "include", `include`
  add(query_822085489, "before", newJString(before))
  result = call_822085487.call(path_822085488, query_822085489, nil, nil, nil)

var listInputItems* = Call_ListInputItems_822085477(name: "listInputItems",
    meth: HttpMethod.HttpGet, host: "api.openai.com",
    route: "/responses/{response_id}/input_items",
    validator: validate_ListInputItems_822085478, base: "/v1",
    makeUrl: url_ListInputItems_822085479, schemes: {Scheme.Https})
type
  Call_CreateThread_822085490 = ref object of OpenApiRestCall_822083995
proc url_CreateThread_822085492(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CreateThread_822085491(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085494: Call_CreateThread_822085490; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085494.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085494.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085494.makeUrl(scheme.get, call_822085494.host, call_822085494.base,
                                   call_822085494.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085494, uri, valid, content)

proc call*(call_822085495: Call_CreateThread_822085490; body: JsonNode = nil): Recallable =
  ## createThread
  ##   body: JObject
  var body_822085496 = newJObject()
  if body != nil:
    body_822085496 = body
  result = call_822085495.call(nil, nil, nil, nil, body_822085496)

var createThread* = Call_CreateThread_822085490(name: "createThread",
    meth: HttpMethod.HttpPost, host: "api.openai.com", route: "/threads",
    validator: validate_CreateThread_822085491, base: "/v1",
    makeUrl: url_CreateThread_822085492, schemes: {Scheme.Https})
type
  Call_CreateThreadAndRun_822085497 = ref object of OpenApiRestCall_822083995
proc url_CreateThreadAndRun_822085499(protocol: Scheme; host: string;
                                      base: string; route: string;
                                      path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CreateThreadAndRun_822085498(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  if `==`(content, ""): assert body != nil, "body argument is necessary"
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085501: Call_CreateThreadAndRun_822085497;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085501.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085501.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085501.makeUrl(scheme.get, call_822085501.host, call_822085501.base,
                                   call_822085501.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085501, uri, valid, content)

proc call*(call_822085502: Call_CreateThreadAndRun_822085497; body: JsonNode): Recallable =
  ## createThreadAndRun
  ##   body: JObject (required)
  var body_822085503 = newJObject()
  if body != nil:
    body_822085503 = body
  result = call_822085502.call(nil, nil, nil, nil, body_822085503)

var createThreadAndRun* = Call_CreateThreadAndRun_822085497(
    name: "createThreadAndRun", meth: HttpMethod.HttpPost,
    host: "api.openai.com", route: "/threads/runs",
    validator: validate_CreateThreadAndRun_822085498, base: "/v1",
    makeUrl: url_CreateThreadAndRun_822085499, schemes: {Scheme.Https})
type
  Call_DeleteThread_822085520 = ref object of OpenApiRestCall_822083995
proc url_DeleteThread_822085522(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "thread_id" in path, "`thread_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/threads/"),
                 (kind: VariableSegment, value: "thread_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DeleteThread_822085521(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   thread_id: JString (required)
  ##            : The ID of the thread to delete.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `thread_id` field"
  var valid_822085523 = path.getOrDefault("thread_id")
  valid_822085523 = validateParameter(valid_822085523, JString, required = true,
                                      default = nil)
  if valid_822085523 != nil:
    section.add "thread_id", valid_822085523
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085524: Call_DeleteThread_822085520; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085524.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085524.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085524.makeUrl(scheme.get, call_822085524.host, call_822085524.base,
                                   call_822085524.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085524, uri, valid, content)

proc call*(call_822085525: Call_DeleteThread_822085520; threadId: string): Recallable =
  ## deleteThread
  ##   threadId: string (required)
  ##           : The ID of the thread to delete.
  var path_822085526 = newJObject()
  add(path_822085526, "thread_id", newJString(threadId))
  result = call_822085525.call(path_822085526, nil, nil, nil, nil)

var deleteThread* = Call_DeleteThread_822085520(name: "deleteThread",
    meth: HttpMethod.HttpDelete, host: "api.openai.com",
    route: "/threads/{thread_id}", validator: validate_DeleteThread_822085521,
    base: "/v1", makeUrl: url_DeleteThread_822085522, schemes: {Scheme.Https})
type
  Call_ModifyThread_822085511 = ref object of OpenApiRestCall_822083995
proc url_ModifyThread_822085513(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "thread_id" in path, "`thread_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/threads/"),
                 (kind: VariableSegment, value: "thread_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ModifyThread_822085512(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   thread_id: JString (required)
  ##            : The ID of the thread to modify. Only the `metadata` can be modified.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `thread_id` field"
  var valid_822085514 = path.getOrDefault("thread_id")
  valid_822085514 = validateParameter(valid_822085514, JString, required = true,
                                      default = nil)
  if valid_822085514 != nil:
    section.add "thread_id", valid_822085514
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  if `==`(content, ""): assert body != nil, "body argument is necessary"
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085516: Call_ModifyThread_822085511; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085516.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085516.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085516.makeUrl(scheme.get, call_822085516.host, call_822085516.base,
                                   call_822085516.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085516, uri, valid, content)

proc call*(call_822085517: Call_ModifyThread_822085511; body: JsonNode;
           threadId: string): Recallable =
  ## modifyThread
  ##   body: JObject (required)
  ##   threadId: string (required)
  ##           : The ID of the thread to modify. Only the `metadata` can be modified.
  var path_822085518 = newJObject()
  var body_822085519 = newJObject()
  if body != nil:
    body_822085519 = body
  add(path_822085518, "thread_id", newJString(threadId))
  result = call_822085517.call(path_822085518, nil, nil, nil, body_822085519)

var modifyThread* = Call_ModifyThread_822085511(name: "modifyThread",
    meth: HttpMethod.HttpPost, host: "api.openai.com",
    route: "/threads/{thread_id}", validator: validate_ModifyThread_822085512,
    base: "/v1", makeUrl: url_ModifyThread_822085513, schemes: {Scheme.Https})
type
  Call_GetThread_822085504 = ref object of OpenApiRestCall_822083995
proc url_GetThread_822085506(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "thread_id" in path, "`thread_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/threads/"),
                 (kind: VariableSegment, value: "thread_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GetThread_822085505(path: JsonNode; query: JsonNode;
                                  header: JsonNode; formData: JsonNode;
                                  body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   thread_id: JString (required)
  ##            : The ID of the thread to retrieve.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `thread_id` field"
  var valid_822085507 = path.getOrDefault("thread_id")
  valid_822085507 = validateParameter(valid_822085507, JString, required = true,
                                      default = nil)
  if valid_822085507 != nil:
    section.add "thread_id", valid_822085507
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085508: Call_GetThread_822085504; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085508.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085508.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085508.makeUrl(scheme.get, call_822085508.host, call_822085508.base,
                                   call_822085508.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085508, uri, valid, content)

proc call*(call_822085509: Call_GetThread_822085504; threadId: string): Recallable =
  ## getThread
  ##   threadId: string (required)
  ##           : The ID of the thread to retrieve.
  var path_822085510 = newJObject()
  add(path_822085510, "thread_id", newJString(threadId))
  result = call_822085509.call(path_822085510, nil, nil, nil, nil)

var getThread* = Call_GetThread_822085504(name: "getThread",
    meth: HttpMethod.HttpGet, host: "api.openai.com",
    route: "/threads/{thread_id}", validator: validate_GetThread_822085505,
    base: "/v1", makeUrl: url_GetThread_822085506, schemes: {Scheme.Https})
type
  Call_CreateMessage_822085540 = ref object of OpenApiRestCall_822083995
proc url_CreateMessage_822085542(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "thread_id" in path, "`thread_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/threads/"),
                 (kind: VariableSegment, value: "thread_id"),
                 (kind: ConstantSegment, value: "/messages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CreateMessage_822085541(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   thread_id: JString (required)
  ##            : The ID of the [thread](/docs/api-reference/threads) to create a message for.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `thread_id` field"
  var valid_822085543 = path.getOrDefault("thread_id")
  valid_822085543 = validateParameter(valid_822085543, JString, required = true,
                                      default = nil)
  if valid_822085543 != nil:
    section.add "thread_id", valid_822085543
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  if `==`(content, ""): assert body != nil, "body argument is necessary"
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085545: Call_CreateMessage_822085540; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085545.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085545.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085545.makeUrl(scheme.get, call_822085545.host, call_822085545.base,
                                   call_822085545.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085545, uri, valid, content)

proc call*(call_822085546: Call_CreateMessage_822085540; body: JsonNode;
           threadId: string): Recallable =
  ## createMessage
  ##   body: JObject (required)
  ##   threadId: string (required)
  ##           : The ID of the [thread](/docs/api-reference/threads) to create a message for.
  var path_822085547 = newJObject()
  var body_822085548 = newJObject()
  if body != nil:
    body_822085548 = body
  add(path_822085547, "thread_id", newJString(threadId))
  result = call_822085546.call(path_822085547, nil, nil, nil, body_822085548)

var createMessage* = Call_CreateMessage_822085540(name: "createMessage",
    meth: HttpMethod.HttpPost, host: "api.openai.com",
    route: "/threads/{thread_id}/messages", validator: validate_CreateMessage_822085541,
    base: "/v1", makeUrl: url_CreateMessage_822085542, schemes: {Scheme.Https})
type
  Call_ListMessages_822085527 = ref object of OpenApiRestCall_822083995
proc url_ListMessages_822085529(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "thread_id" in path, "`thread_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/threads/"),
                 (kind: VariableSegment, value: "thread_id"),
                 (kind: ConstantSegment, value: "/messages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ListMessages_822085528(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   thread_id: JString (required)
  ##            : The ID of the [thread](/docs/api-reference/threads) the messages belong to.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `thread_id` field"
  var valid_822085530 = path.getOrDefault("thread_id")
  valid_822085530 = validateParameter(valid_822085530, JString, required = true,
                                      default = nil)
  if valid_822085530 != nil:
    section.add "thread_id", valid_822085530
  result.add "path", section
  ## parameters in `query` object:
  ##   after: JString
  ##        : A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
  ## 
  ##   run_id: JString
  ##         : Filter messages by the run ID that generated them.
  ## 
  ##   order: JString
  ##        : Sort order by the `created_at` timestamp of the objects. `asc` for ascending order and `desc` for descending order.
  ## 
  ##   limit: JInt
  ##        : A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.
  ## 
  ##   before: JString
  ##         : A cursor for use in pagination. `before` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, starting with obj_foo, your subsequent call can include before=obj_foo in order to fetch the previous page of the list.
  ## 
  section = newJObject()
  var valid_822085531 = query.getOrDefault("after")
  valid_822085531 = validateParameter(valid_822085531, JString,
                                      required = false, default = nil)
  if valid_822085531 != nil:
    section.add "after", valid_822085531
  var valid_822085532 = query.getOrDefault("run_id")
  valid_822085532 = validateParameter(valid_822085532, JString,
                                      required = false, default = nil)
  if valid_822085532 != nil:
    section.add "run_id", valid_822085532
  var valid_822085533 = query.getOrDefault("order")
  valid_822085533 = validateParameter(valid_822085533, JString,
                                      required = false,
                                      default = newJString("desc"))
  if valid_822085533 != nil:
    section.add "order", valid_822085533
  var valid_822085534 = query.getOrDefault("limit")
  valid_822085534 = validateParameter(valid_822085534, JInt, required = false,
                                      default = newJInt(20))
  if valid_822085534 != nil:
    section.add "limit", valid_822085534
  var valid_822085535 = query.getOrDefault("before")
  valid_822085535 = validateParameter(valid_822085535, JString,
                                      required = false, default = nil)
  if valid_822085535 != nil:
    section.add "before", valid_822085535
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085536: Call_ListMessages_822085527; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085536.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085536.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085536.makeUrl(scheme.get, call_822085536.host, call_822085536.base,
                                   call_822085536.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085536, uri, valid, content)

proc call*(call_822085537: Call_ListMessages_822085527; threadId: string;
           after: string = ""; runId: string = ""; order: string = "desc";
           limit: int = 20; before: string = ""): Recallable =
  ## listMessages
  ##   after: string
  ##        : A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
  ## 
  ##   runId: string
  ##        : Filter messages by the run ID that generated them.
  ## 
  ##   order: string
  ##        : Sort order by the `created_at` timestamp of the objects. `asc` for ascending order and `desc` for descending order.
  ## 
  ##   limit: int
  ##        : A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.
  ## 
  ##   threadId: string (required)
  ##           : The ID of the [thread](/docs/api-reference/threads) the messages belong to.
  ##   before: string
  ##         : A cursor for use in pagination. `before` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, starting with obj_foo, your subsequent call can include before=obj_foo in order to fetch the previous page of the list.
  ## 
  var path_822085538 = newJObject()
  var query_822085539 = newJObject()
  add(query_822085539, "after", newJString(after))
  add(query_822085539, "run_id", newJString(runId))
  add(query_822085539, "order", newJString(order))
  add(query_822085539, "limit", newJInt(limit))
  add(path_822085538, "thread_id", newJString(threadId))
  add(query_822085539, "before", newJString(before))
  result = call_822085537.call(path_822085538, query_822085539, nil, nil, nil)

var listMessages* = Call_ListMessages_822085527(name: "listMessages",
    meth: HttpMethod.HttpGet, host: "api.openai.com",
    route: "/threads/{thread_id}/messages", validator: validate_ListMessages_822085528,
    base: "/v1", makeUrl: url_ListMessages_822085529, schemes: {Scheme.Https})
type
  Call_DeleteMessage_822085567 = ref object of OpenApiRestCall_822083995
proc url_DeleteMessage_822085569(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "thread_id" in path, "`thread_id` is a required path parameter"
  assert "message_id" in path, "`message_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/threads/"),
                 (kind: VariableSegment, value: "thread_id"),
                 (kind: ConstantSegment, value: "/messages/"),
                 (kind: VariableSegment, value: "message_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DeleteMessage_822085568(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   thread_id: JString (required)
  ##            : The ID of the thread to which this message belongs.
  ##   message_id: JString (required)
  ##             : The ID of the message to delete.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `thread_id` field"
  var valid_822085570 = path.getOrDefault("thread_id")
  valid_822085570 = validateParameter(valid_822085570, JString, required = true,
                                      default = nil)
  if valid_822085570 != nil:
    section.add "thread_id", valid_822085570
  var valid_822085571 = path.getOrDefault("message_id")
  valid_822085571 = validateParameter(valid_822085571, JString, required = true,
                                      default = nil)
  if valid_822085571 != nil:
    section.add "message_id", valid_822085571
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085572: Call_DeleteMessage_822085567; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085572.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085572.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085572.makeUrl(scheme.get, call_822085572.host, call_822085572.base,
                                   call_822085572.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085572, uri, valid, content)

proc call*(call_822085573: Call_DeleteMessage_822085567; threadId: string;
           messageId: string): Recallable =
  ## deleteMessage
  ##   threadId: string (required)
  ##           : The ID of the thread to which this message belongs.
  ##   messageId: string (required)
  ##            : The ID of the message to delete.
  var path_822085574 = newJObject()
  add(path_822085574, "thread_id", newJString(threadId))
  add(path_822085574, "message_id", newJString(messageId))
  result = call_822085573.call(path_822085574, nil, nil, nil, nil)

var deleteMessage* = Call_DeleteMessage_822085567(name: "deleteMessage",
    meth: HttpMethod.HttpDelete, host: "api.openai.com",
    route: "/threads/{thread_id}/messages/{message_id}",
    validator: validate_DeleteMessage_822085568, base: "/v1",
    makeUrl: url_DeleteMessage_822085569, schemes: {Scheme.Https})
type
  Call_ModifyMessage_822085557 = ref object of OpenApiRestCall_822083995
proc url_ModifyMessage_822085559(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "thread_id" in path, "`thread_id` is a required path parameter"
  assert "message_id" in path, "`message_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/threads/"),
                 (kind: VariableSegment, value: "thread_id"),
                 (kind: ConstantSegment, value: "/messages/"),
                 (kind: VariableSegment, value: "message_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ModifyMessage_822085558(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   thread_id: JString (required)
  ##            : The ID of the thread to which this message belongs.
  ##   message_id: JString (required)
  ##             : The ID of the message to modify.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `thread_id` field"
  var valid_822085560 = path.getOrDefault("thread_id")
  valid_822085560 = validateParameter(valid_822085560, JString, required = true,
                                      default = nil)
  if valid_822085560 != nil:
    section.add "thread_id", valid_822085560
  var valid_822085561 = path.getOrDefault("message_id")
  valid_822085561 = validateParameter(valid_822085561, JString, required = true,
                                      default = nil)
  if valid_822085561 != nil:
    section.add "message_id", valid_822085561
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  if `==`(content, ""): assert body != nil, "body argument is necessary"
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085563: Call_ModifyMessage_822085557; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085563.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085563.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085563.makeUrl(scheme.get, call_822085563.host, call_822085563.base,
                                   call_822085563.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085563, uri, valid, content)

proc call*(call_822085564: Call_ModifyMessage_822085557; body: JsonNode;
           threadId: string; messageId: string): Recallable =
  ## modifyMessage
  ##   body: JObject (required)
  ##   threadId: string (required)
  ##           : The ID of the thread to which this message belongs.
  ##   messageId: string (required)
  ##            : The ID of the message to modify.
  var path_822085565 = newJObject()
  var body_822085566 = newJObject()
  if body != nil:
    body_822085566 = body
  add(path_822085565, "thread_id", newJString(threadId))
  add(path_822085565, "message_id", newJString(messageId))
  result = call_822085564.call(path_822085565, nil, nil, nil, body_822085566)

var modifyMessage* = Call_ModifyMessage_822085557(name: "modifyMessage",
    meth: HttpMethod.HttpPost, host: "api.openai.com",
    route: "/threads/{thread_id}/messages/{message_id}",
    validator: validate_ModifyMessage_822085558, base: "/v1",
    makeUrl: url_ModifyMessage_822085559, schemes: {Scheme.Https})
type
  Call_GetMessage_822085549 = ref object of OpenApiRestCall_822083995
proc url_GetMessage_822085551(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "thread_id" in path, "`thread_id` is a required path parameter"
  assert "message_id" in path, "`message_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/threads/"),
                 (kind: VariableSegment, value: "thread_id"),
                 (kind: ConstantSegment, value: "/messages/"),
                 (kind: VariableSegment, value: "message_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GetMessage_822085550(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   thread_id: JString (required)
  ##            : The ID of the [thread](/docs/api-reference/threads) to which this message belongs.
  ##   message_id: JString (required)
  ##             : The ID of the message to retrieve.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `thread_id` field"
  var valid_822085552 = path.getOrDefault("thread_id")
  valid_822085552 = validateParameter(valid_822085552, JString, required = true,
                                      default = nil)
  if valid_822085552 != nil:
    section.add "thread_id", valid_822085552
  var valid_822085553 = path.getOrDefault("message_id")
  valid_822085553 = validateParameter(valid_822085553, JString, required = true,
                                      default = nil)
  if valid_822085553 != nil:
    section.add "message_id", valid_822085553
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085554: Call_GetMessage_822085549; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085554.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085554.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085554.makeUrl(scheme.get, call_822085554.host, call_822085554.base,
                                   call_822085554.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085554, uri, valid, content)

proc call*(call_822085555: Call_GetMessage_822085549; threadId: string;
           messageId: string): Recallable =
  ## getMessage
  ##   threadId: string (required)
  ##           : The ID of the [thread](/docs/api-reference/threads) to which this message belongs.
  ##   messageId: string (required)
  ##            : The ID of the message to retrieve.
  var path_822085556 = newJObject()
  add(path_822085556, "thread_id", newJString(threadId))
  add(path_822085556, "message_id", newJString(messageId))
  result = call_822085555.call(path_822085556, nil, nil, nil, nil)

var getMessage* = Call_GetMessage_822085549(name: "getMessage",
    meth: HttpMethod.HttpGet, host: "api.openai.com",
    route: "/threads/{thread_id}/messages/{message_id}",
    validator: validate_GetMessage_822085550, base: "/v1",
    makeUrl: url_GetMessage_822085551, schemes: {Scheme.Https})
type
  Call_CreateRun_822085587 = ref object of OpenApiRestCall_822083995
proc url_CreateRun_822085589(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "thread_id" in path, "`thread_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/threads/"),
                 (kind: VariableSegment, value: "thread_id"),
                 (kind: ConstantSegment, value: "/runs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CreateRun_822085588(path: JsonNode; query: JsonNode;
                                  header: JsonNode; formData: JsonNode;
                                  body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   thread_id: JString (required)
  ##            : The ID of the thread to run.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `thread_id` field"
  var valid_822085590 = path.getOrDefault("thread_id")
  valid_822085590 = validateParameter(valid_822085590, JString, required = true,
                                      default = nil)
  if valid_822085590 != nil:
    section.add "thread_id", valid_822085590
  result.add "path", section
  ## parameters in `query` object:
  ##   include[]: JArray
  ##            : A list of additional fields to include in the response. Currently the only supported value is `step_details.tool_calls[*].file_search.results[*].content` to fetch the file search result content.
  ## 
  ## See the [file search tool 
  ## documentation](/docs/assistants/tools/file-search#customizing-file-search-settings) for more information.
  ## 
  section = newJObject()
  var valid_822085591 = query.getOrDefault("include[]")
  valid_822085591 = validateParameter(valid_822085591, JArray, required = false,
                                      default = nil)
  if valid_822085591 != nil:
    section.add "include[]", valid_822085591
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  if `==`(content, ""): assert body != nil, "body argument is necessary"
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085593: Call_CreateRun_822085587; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085593.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085593.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085593.makeUrl(scheme.get, call_822085593.host, call_822085593.base,
                                   call_822085593.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085593, uri, valid, content)

proc call*(call_822085594: Call_CreateRun_822085587; body: JsonNode;
           threadId: string; `include`: JsonNode = nil): Recallable =
  ## createRun
  ##   body: JObject (required)
  ##   threadId: string (required)
  ##           : The ID of the thread to run.
  ##   include: JArray
  ##          : A list of additional fields to include in the response. Currently the only supported value is `step_details.tool_calls[*].file_search.results[*].content` to fetch the file search result content.
  ## 
  ## See the [file search tool 
  ## documentation](/docs/assistants/tools/file-search#customizing-file-search-settings) for more information.
  ## 
  var path_822085595 = newJObject()
  var query_822085596 = newJObject()
  var body_822085597 = newJObject()
  if body != nil:
    body_822085597 = body
  add(path_822085595, "thread_id", newJString(threadId))
  if `include` != nil:
    query_822085596.add "include[]", `include`
  result = call_822085594.call(path_822085595, query_822085596, nil, nil, body_822085597)

var createRun* = Call_CreateRun_822085587(name: "createRun",
    meth: HttpMethod.HttpPost, host: "api.openai.com",
    route: "/threads/{thread_id}/runs", validator: validate_CreateRun_822085588,
    base: "/v1", makeUrl: url_CreateRun_822085589, schemes: {Scheme.Https})
type
  Call_ListRuns_822085575 = ref object of OpenApiRestCall_822083995
proc url_ListRuns_822085577(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "thread_id" in path, "`thread_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/threads/"),
                 (kind: VariableSegment, value: "thread_id"),
                 (kind: ConstantSegment, value: "/runs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ListRuns_822085576(path: JsonNode; query: JsonNode;
                                 header: JsonNode; formData: JsonNode;
                                 body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   thread_id: JString (required)
  ##            : The ID of the thread the run belongs to.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `thread_id` field"
  var valid_822085578 = path.getOrDefault("thread_id")
  valid_822085578 = validateParameter(valid_822085578, JString, required = true,
                                      default = nil)
  if valid_822085578 != nil:
    section.add "thread_id", valid_822085578
  result.add "path", section
  ## parameters in `query` object:
  ##   after: JString
  ##        : A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
  ## 
  ##   order: JString
  ##        : Sort order by the `created_at` timestamp of the objects. `asc` for ascending order and `desc` for descending order.
  ## 
  ##   limit: JInt
  ##        : A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.
  ## 
  ##   before: JString
  ##         : A cursor for use in pagination. `before` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, starting with obj_foo, your subsequent call can include before=obj_foo in order to fetch the previous page of the list.
  ## 
  section = newJObject()
  var valid_822085579 = query.getOrDefault("after")
  valid_822085579 = validateParameter(valid_822085579, JString,
                                      required = false, default = nil)
  if valid_822085579 != nil:
    section.add "after", valid_822085579
  var valid_822085580 = query.getOrDefault("order")
  valid_822085580 = validateParameter(valid_822085580, JString,
                                      required = false,
                                      default = newJString("desc"))
  if valid_822085580 != nil:
    section.add "order", valid_822085580
  var valid_822085581 = query.getOrDefault("limit")
  valid_822085581 = validateParameter(valid_822085581, JInt, required = false,
                                      default = newJInt(20))
  if valid_822085581 != nil:
    section.add "limit", valid_822085581
  var valid_822085582 = query.getOrDefault("before")
  valid_822085582 = validateParameter(valid_822085582, JString,
                                      required = false, default = nil)
  if valid_822085582 != nil:
    section.add "before", valid_822085582
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085583: Call_ListRuns_822085575; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085583.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085583.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085583.makeUrl(scheme.get, call_822085583.host, call_822085583.base,
                                   call_822085583.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085583, uri, valid, content)

proc call*(call_822085584: Call_ListRuns_822085575; threadId: string;
           after: string = ""; order: string = "desc"; limit: int = 20;
           before: string = ""): Recallable =
  ## listRuns
  ##   after: string
  ##        : A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
  ## 
  ##   order: string
  ##        : Sort order by the `created_at` timestamp of the objects. `asc` for ascending order and `desc` for descending order.
  ## 
  ##   limit: int
  ##        : A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.
  ## 
  ##   threadId: string (required)
  ##           : The ID of the thread the run belongs to.
  ##   before: string
  ##         : A cursor for use in pagination. `before` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, starting with obj_foo, your subsequent call can include before=obj_foo in order to fetch the previous page of the list.
  ## 
  var path_822085585 = newJObject()
  var query_822085586 = newJObject()
  add(query_822085586, "after", newJString(after))
  add(query_822085586, "order", newJString(order))
  add(query_822085586, "limit", newJInt(limit))
  add(path_822085585, "thread_id", newJString(threadId))
  add(query_822085586, "before", newJString(before))
  result = call_822085584.call(path_822085585, query_822085586, nil, nil, nil)

var listRuns* = Call_ListRuns_822085575(name: "listRuns",
                                        meth: HttpMethod.HttpGet,
                                        host: "api.openai.com",
                                        route: "/threads/{thread_id}/runs",
                                        validator: validate_ListRuns_822085576,
                                        base: "/v1", makeUrl: url_ListRuns_822085577,
                                        schemes: {Scheme.Https})
type
  Call_ModifyRun_822085606 = ref object of OpenApiRestCall_822083995
proc url_ModifyRun_822085608(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "thread_id" in path, "`thread_id` is a required path parameter"
  assert "run_id" in path, "`run_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/threads/"),
                 (kind: VariableSegment, value: "thread_id"),
                 (kind: ConstantSegment, value: "/runs/"),
                 (kind: VariableSegment, value: "run_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ModifyRun_822085607(path: JsonNode; query: JsonNode;
                                  header: JsonNode; formData: JsonNode;
                                  body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   run_id: JString (required)
  ##         : The ID of the run to modify.
  ##   thread_id: JString (required)
  ##            : The ID of the [thread](/docs/api-reference/threads) that was run.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `run_id` field"
  var valid_822085609 = path.getOrDefault("run_id")
  valid_822085609 = validateParameter(valid_822085609, JString, required = true,
                                      default = nil)
  if valid_822085609 != nil:
    section.add "run_id", valid_822085609
  var valid_822085610 = path.getOrDefault("thread_id")
  valid_822085610 = validateParameter(valid_822085610, JString, required = true,
                                      default = nil)
  if valid_822085610 != nil:
    section.add "thread_id", valid_822085610
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  if `==`(content, ""): assert body != nil, "body argument is necessary"
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085612: Call_ModifyRun_822085606; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085612.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085612.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085612.makeUrl(scheme.get, call_822085612.host, call_822085612.base,
                                   call_822085612.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085612, uri, valid, content)

proc call*(call_822085613: Call_ModifyRun_822085606; runId: string;
           body: JsonNode; threadId: string): Recallable =
  ## modifyRun
  ##   runId: string (required)
  ##        : The ID of the run to modify.
  ##   body: JObject (required)
  ##   threadId: string (required)
  ##           : The ID of the [thread](/docs/api-reference/threads) that was run.
  var path_822085614 = newJObject()
  var body_822085615 = newJObject()
  add(path_822085614, "run_id", newJString(runId))
  if body != nil:
    body_822085615 = body
  add(path_822085614, "thread_id", newJString(threadId))
  result = call_822085613.call(path_822085614, nil, nil, nil, body_822085615)

var modifyRun* = Call_ModifyRun_822085606(name: "modifyRun",
    meth: HttpMethod.HttpPost, host: "api.openai.com",
    route: "/threads/{thread_id}/runs/{run_id}", validator: validate_ModifyRun_822085607,
    base: "/v1", makeUrl: url_ModifyRun_822085608, schemes: {Scheme.Https})
type
  Call_GetRun_822085598 = ref object of OpenApiRestCall_822083995
proc url_GetRun_822085600(protocol: Scheme; host: string; base: string;
                          route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "thread_id" in path, "`thread_id` is a required path parameter"
  assert "run_id" in path, "`run_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/threads/"),
                 (kind: VariableSegment, value: "thread_id"),
                 (kind: ConstantSegment, value: "/runs/"),
                 (kind: VariableSegment, value: "run_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GetRun_822085599(path: JsonNode; query: JsonNode;
                               header: JsonNode; formData: JsonNode;
                               body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   run_id: JString (required)
  ##         : The ID of the run to retrieve.
  ##   thread_id: JString (required)
  ##            : The ID of the [thread](/docs/api-reference/threads) that was run.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `run_id` field"
  var valid_822085601 = path.getOrDefault("run_id")
  valid_822085601 = validateParameter(valid_822085601, JString, required = true,
                                      default = nil)
  if valid_822085601 != nil:
    section.add "run_id", valid_822085601
  var valid_822085602 = path.getOrDefault("thread_id")
  valid_822085602 = validateParameter(valid_822085602, JString, required = true,
                                      default = nil)
  if valid_822085602 != nil:
    section.add "thread_id", valid_822085602
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085603: Call_GetRun_822085598; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085603.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085603.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085603.makeUrl(scheme.get, call_822085603.host, call_822085603.base,
                                   call_822085603.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085603, uri, valid, content)

proc call*(call_822085604: Call_GetRun_822085598; runId: string;
           threadId: string): Recallable =
  ## getRun
  ##   runId: string (required)
  ##        : The ID of the run to retrieve.
  ##   threadId: string (required)
  ##           : The ID of the [thread](/docs/api-reference/threads) that was run.
  var path_822085605 = newJObject()
  add(path_822085605, "run_id", newJString(runId))
  add(path_822085605, "thread_id", newJString(threadId))
  result = call_822085604.call(path_822085605, nil, nil, nil, nil)

var getRun* = Call_GetRun_822085598(name: "getRun", meth: HttpMethod.HttpGet,
                                    host: "api.openai.com", route: "/threads/{thread_id}/runs/{run_id}",
                                    validator: validate_GetRun_822085599,
                                    base: "/v1", makeUrl: url_GetRun_822085600,
                                    schemes: {Scheme.Https})
type
  Call_CancelRun_822085616 = ref object of OpenApiRestCall_822083995
proc url_CancelRun_822085618(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "thread_id" in path, "`thread_id` is a required path parameter"
  assert "run_id" in path, "`run_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/threads/"),
                 (kind: VariableSegment, value: "thread_id"),
                 (kind: ConstantSegment, value: "/runs/"),
                 (kind: VariableSegment, value: "run_id"),
                 (kind: ConstantSegment, value: "/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CancelRun_822085617(path: JsonNode; query: JsonNode;
                                  header: JsonNode; formData: JsonNode;
                                  body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   run_id: JString (required)
  ##         : The ID of the run to cancel.
  ##   thread_id: JString (required)
  ##            : The ID of the thread to which this run belongs.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `run_id` field"
  var valid_822085619 = path.getOrDefault("run_id")
  valid_822085619 = validateParameter(valid_822085619, JString, required = true,
                                      default = nil)
  if valid_822085619 != nil:
    section.add "run_id", valid_822085619
  var valid_822085620 = path.getOrDefault("thread_id")
  valid_822085620 = validateParameter(valid_822085620, JString, required = true,
                                      default = nil)
  if valid_822085620 != nil:
    section.add "thread_id", valid_822085620
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085621: Call_CancelRun_822085616; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085621.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085621.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085621.makeUrl(scheme.get, call_822085621.host, call_822085621.base,
                                   call_822085621.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085621, uri, valid, content)

proc call*(call_822085622: Call_CancelRun_822085616; runId: string;
           threadId: string): Recallable =
  ## cancelRun
  ##   runId: string (required)
  ##        : The ID of the run to cancel.
  ##   threadId: string (required)
  ##           : The ID of the thread to which this run belongs.
  var path_822085623 = newJObject()
  add(path_822085623, "run_id", newJString(runId))
  add(path_822085623, "thread_id", newJString(threadId))
  result = call_822085622.call(path_822085623, nil, nil, nil, nil)

var cancelRun* = Call_CancelRun_822085616(name: "cancelRun",
    meth: HttpMethod.HttpPost, host: "api.openai.com",
    route: "/threads/{thread_id}/runs/{run_id}/cancel",
    validator: validate_CancelRun_822085617, base: "/v1",
    makeUrl: url_CancelRun_822085618, schemes: {Scheme.Https})
type
  Call_ListRunSteps_822085624 = ref object of OpenApiRestCall_822083995
proc url_ListRunSteps_822085626(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "thread_id" in path, "`thread_id` is a required path parameter"
  assert "run_id" in path, "`run_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/threads/"),
                 (kind: VariableSegment, value: "thread_id"),
                 (kind: ConstantSegment, value: "/runs/"),
                 (kind: VariableSegment, value: "run_id"),
                 (kind: ConstantSegment, value: "/steps")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ListRunSteps_822085625(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   run_id: JString (required)
  ##         : The ID of the run the run steps belong to.
  ##   thread_id: JString (required)
  ##            : The ID of the thread the run and run steps belong to.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `run_id` field"
  var valid_822085627 = path.getOrDefault("run_id")
  valid_822085627 = validateParameter(valid_822085627, JString, required = true,
                                      default = nil)
  if valid_822085627 != nil:
    section.add "run_id", valid_822085627
  var valid_822085628 = path.getOrDefault("thread_id")
  valid_822085628 = validateParameter(valid_822085628, JString, required = true,
                                      default = nil)
  if valid_822085628 != nil:
    section.add "thread_id", valid_822085628
  result.add "path", section
  ## parameters in `query` object:
  ##   after: JString
  ##        : A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
  ## 
  ##   order: JString
  ##        : Sort order by the `created_at` timestamp of the objects. `asc` for ascending order and `desc` for descending order.
  ## 
  ##   limit: JInt
  ##        : A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.
  ## 
  ##   before: JString
  ##         : A cursor for use in pagination. `before` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, starting with obj_foo, your subsequent call can include before=obj_foo in order to fetch the previous page of the list.
  ## 
  ##   include[]: JArray
  ##            : A list of additional fields to include in the response. Currently the only supported value is `step_details.tool_calls[*].file_search.results[*].content` to fetch the file search result content.
  ## 
  ## See the [file search tool 
  ## documentation](/docs/assistants/tools/file-search#customizing-file-search-settings) for more information.
  ## 
  section = newJObject()
  var valid_822085629 = query.getOrDefault("after")
  valid_822085629 = validateParameter(valid_822085629, JString,
                                      required = false, default = nil)
  if valid_822085629 != nil:
    section.add "after", valid_822085629
  var valid_822085630 = query.getOrDefault("order")
  valid_822085630 = validateParameter(valid_822085630, JString,
                                      required = false,
                                      default = newJString("desc"))
  if valid_822085630 != nil:
    section.add "order", valid_822085630
  var valid_822085631 = query.getOrDefault("limit")
  valid_822085631 = validateParameter(valid_822085631, JInt, required = false,
                                      default = newJInt(20))
  if valid_822085631 != nil:
    section.add "limit", valid_822085631
  var valid_822085632 = query.getOrDefault("before")
  valid_822085632 = validateParameter(valid_822085632, JString,
                                      required = false, default = nil)
  if valid_822085632 != nil:
    section.add "before", valid_822085632
  var valid_822085633 = query.getOrDefault("include[]")
  valid_822085633 = validateParameter(valid_822085633, JArray, required = false,
                                      default = nil)
  if valid_822085633 != nil:
    section.add "include[]", valid_822085633
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085634: Call_ListRunSteps_822085624; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085634.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085634.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085634.makeUrl(scheme.get, call_822085634.host, call_822085634.base,
                                   call_822085634.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085634, uri, valid, content)

proc call*(call_822085635: Call_ListRunSteps_822085624; runId: string;
           threadId: string; after: string = ""; order: string = "desc";
           limit: int = 20; before: string = ""; `include`: JsonNode = nil): Recallable =
  ## listRunSteps
  ##   runId: string (required)
  ##        : The ID of the run the run steps belong to.
  ##   after: string
  ##        : A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
  ## 
  ##   order: string
  ##        : Sort order by the `created_at` timestamp of the objects. `asc` for ascending order and `desc` for descending order.
  ## 
  ##   limit: int
  ##        : A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.
  ## 
  ##   threadId: string (required)
  ##           : The ID of the thread the run and run steps belong to.
  ##   before: string
  ##         : A cursor for use in pagination. `before` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, starting with obj_foo, your subsequent call can include before=obj_foo in order to fetch the previous page of the list.
  ## 
  ##   include: JArray
  ##          : A list of additional fields to include in the response. Currently the only supported value is `step_details.tool_calls[*].file_search.results[*].content` to fetch the file search result content.
  ## 
  ## See the [file search tool 
  ## documentation](/docs/assistants/tools/file-search#customizing-file-search-settings) for more information.
  ## 
  var path_822085636 = newJObject()
  var query_822085637 = newJObject()
  add(path_822085636, "run_id", newJString(runId))
  add(query_822085637, "after", newJString(after))
  add(query_822085637, "order", newJString(order))
  add(query_822085637, "limit", newJInt(limit))
  add(path_822085636, "thread_id", newJString(threadId))
  add(query_822085637, "before", newJString(before))
  if `include` != nil:
    query_822085637.add "include[]", `include`
  result = call_822085635.call(path_822085636, query_822085637, nil, nil, nil)

var listRunSteps* = Call_ListRunSteps_822085624(name: "listRunSteps",
    meth: HttpMethod.HttpGet, host: "api.openai.com",
    route: "/threads/{thread_id}/runs/{run_id}/steps",
    validator: validate_ListRunSteps_822085625, base: "/v1",
    makeUrl: url_ListRunSteps_822085626, schemes: {Scheme.Https})
type
  Call_GetRunStep_822085638 = ref object of OpenApiRestCall_822083995
proc url_GetRunStep_822085640(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "thread_id" in path, "`thread_id` is a required path parameter"
  assert "run_id" in path, "`run_id` is a required path parameter"
  assert "step_id" in path, "`step_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/threads/"),
                 (kind: VariableSegment, value: "thread_id"),
                 (kind: ConstantSegment, value: "/runs/"),
                 (kind: VariableSegment, value: "run_id"),
                 (kind: ConstantSegment, value: "/steps/"),
                 (kind: VariableSegment, value: "step_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GetRunStep_822085639(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   run_id: JString (required)
  ##         : The ID of the run to which the run step belongs.
  ##   thread_id: JString (required)
  ##            : The ID of the thread to which the run and run step belongs.
  ##   step_id: JString (required)
  ##          : The ID of the run step to retrieve.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `run_id` field"
  var valid_822085641 = path.getOrDefault("run_id")
  valid_822085641 = validateParameter(valid_822085641, JString, required = true,
                                      default = nil)
  if valid_822085641 != nil:
    section.add "run_id", valid_822085641
  var valid_822085642 = path.getOrDefault("thread_id")
  valid_822085642 = validateParameter(valid_822085642, JString, required = true,
                                      default = nil)
  if valid_822085642 != nil:
    section.add "thread_id", valid_822085642
  var valid_822085643 = path.getOrDefault("step_id")
  valid_822085643 = validateParameter(valid_822085643, JString, required = true,
                                      default = nil)
  if valid_822085643 != nil:
    section.add "step_id", valid_822085643
  result.add "path", section
  ## parameters in `query` object:
  ##   include[]: JArray
  ##            : A list of additional fields to include in the response. Currently the only supported value is `step_details.tool_calls[*].file_search.results[*].content` to fetch the file search result content.
  ## 
  ## See the [file search tool 
  ## documentation](/docs/assistants/tools/file-search#customizing-file-search-settings) for more information.
  ## 
  section = newJObject()
  var valid_822085644 = query.getOrDefault("include[]")
  valid_822085644 = validateParameter(valid_822085644, JArray, required = false,
                                      default = nil)
  if valid_822085644 != nil:
    section.add "include[]", valid_822085644
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085645: Call_GetRunStep_822085638; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085645.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085645.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085645.makeUrl(scheme.get, call_822085645.host, call_822085645.base,
                                   call_822085645.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085645, uri, valid, content)

proc call*(call_822085646: Call_GetRunStep_822085638; runId: string;
           threadId: string; stepId: string; `include`: JsonNode = nil): Recallable =
  ## getRunStep
  ##   runId: string (required)
  ##        : The ID of the run to which the run step belongs.
  ##   threadId: string (required)
  ##           : The ID of the thread to which the run and run step belongs.
  ##   stepId: string (required)
  ##         : The ID of the run step to retrieve.
  ##   include: JArray
  ##          : A list of additional fields to include in the response. Currently the only supported value is `step_details.tool_calls[*].file_search.results[*].content` to fetch the file search result content.
  ## 
  ## See the [file search tool 
  ## documentation](/docs/assistants/tools/file-search#customizing-file-search-settings) for more information.
  ## 
  var path_822085647 = newJObject()
  var query_822085648 = newJObject()
  add(path_822085647, "run_id", newJString(runId))
  add(path_822085647, "thread_id", newJString(threadId))
  add(path_822085647, "step_id", newJString(stepId))
  if `include` != nil:
    query_822085648.add "include[]", `include`
  result = call_822085646.call(path_822085647, query_822085648, nil, nil, nil)

var getRunStep* = Call_GetRunStep_822085638(name: "getRunStep",
    meth: HttpMethod.HttpGet, host: "api.openai.com",
    route: "/threads/{thread_id}/runs/{run_id}/steps/{step_id}",
    validator: validate_GetRunStep_822085639, base: "/v1",
    makeUrl: url_GetRunStep_822085640, schemes: {Scheme.Https})
type
  Call_SubmitToolOuputsToRun_822085649 = ref object of OpenApiRestCall_822083995
proc url_SubmitToolOuputsToRun_822085651(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "thread_id" in path, "`thread_id` is a required path parameter"
  assert "run_id" in path, "`run_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/threads/"),
                 (kind: VariableSegment, value: "thread_id"),
                 (kind: ConstantSegment, value: "/runs/"),
                 (kind: VariableSegment, value: "run_id"),
                 (kind: ConstantSegment, value: "/submit_tool_outputs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SubmitToolOuputsToRun_822085650(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   run_id: JString (required)
  ##         : The ID of the run that requires the tool output submission.
  ##   thread_id: JString (required)
  ##            : The ID of the [thread](/docs/api-reference/threads) to which this run belongs.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `run_id` field"
  var valid_822085652 = path.getOrDefault("run_id")
  valid_822085652 = validateParameter(valid_822085652, JString, required = true,
                                      default = nil)
  if valid_822085652 != nil:
    section.add "run_id", valid_822085652
  var valid_822085653 = path.getOrDefault("thread_id")
  valid_822085653 = validateParameter(valid_822085653, JString, required = true,
                                      default = nil)
  if valid_822085653 != nil:
    section.add "thread_id", valid_822085653
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  if `==`(content, ""): assert body != nil, "body argument is necessary"
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085655: Call_SubmitToolOuputsToRun_822085649;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085655.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085655.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085655.makeUrl(scheme.get, call_822085655.host, call_822085655.base,
                                   call_822085655.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085655, uri, valid, content)

proc call*(call_822085656: Call_SubmitToolOuputsToRun_822085649; runId: string;
           body: JsonNode; threadId: string): Recallable =
  ## submitToolOuputsToRun
  ##   runId: string (required)
  ##        : The ID of the run that requires the tool output submission.
  ##   body: JObject (required)
  ##   threadId: string (required)
  ##           : The ID of the [thread](/docs/api-reference/threads) to which this run belongs.
  var path_822085657 = newJObject()
  var body_822085658 = newJObject()
  add(path_822085657, "run_id", newJString(runId))
  if body != nil:
    body_822085658 = body
  add(path_822085657, "thread_id", newJString(threadId))
  result = call_822085656.call(path_822085657, nil, nil, nil, body_822085658)

var submitToolOuputsToRun* = Call_SubmitToolOuputsToRun_822085649(
    name: "submitToolOuputsToRun", meth: HttpMethod.HttpPost,
    host: "api.openai.com",
    route: "/threads/{thread_id}/runs/{run_id}/submit_tool_outputs",
    validator: validate_SubmitToolOuputsToRun_822085650, base: "/v1",
    makeUrl: url_SubmitToolOuputsToRun_822085651, schemes: {Scheme.Https})
type
  Call_CreateUpload_822085659 = ref object of OpenApiRestCall_822083995
proc url_CreateUpload_822085661(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CreateUpload_822085660(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  if `==`(content, ""): assert body != nil, "body argument is necessary"
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085663: Call_CreateUpload_822085659; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085663.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085663.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085663.makeUrl(scheme.get, call_822085663.host, call_822085663.base,
                                   call_822085663.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085663, uri, valid, content)

proc call*(call_822085664: Call_CreateUpload_822085659; body: JsonNode): Recallable =
  ## createUpload
  ##   body: JObject (required)
  var body_822085665 = newJObject()
  if body != nil:
    body_822085665 = body
  result = call_822085664.call(nil, nil, nil, nil, body_822085665)

var createUpload* = Call_CreateUpload_822085659(name: "createUpload",
    meth: HttpMethod.HttpPost, host: "api.openai.com", route: "/uploads",
    validator: validate_CreateUpload_822085660, base: "/v1",
    makeUrl: url_CreateUpload_822085661, schemes: {Scheme.Https})
type
  Call_CancelUpload_822085666 = ref object of OpenApiRestCall_822083995
proc url_CancelUpload_822085668(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "upload_id" in path, "`upload_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/uploads/"),
                 (kind: VariableSegment, value: "upload_id"),
                 (kind: ConstantSegment, value: "/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CancelUpload_822085667(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   upload_id: JString (required)
  ##            : The ID of the Upload.
  ## 
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `upload_id` field"
  var valid_822085669 = path.getOrDefault("upload_id")
  valid_822085669 = validateParameter(valid_822085669, JString, required = true,
                                      default = nil)
  if valid_822085669 != nil:
    section.add "upload_id", valid_822085669
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085670: Call_CancelUpload_822085666; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085670.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085670.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085670.makeUrl(scheme.get, call_822085670.host, call_822085670.base,
                                   call_822085670.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085670, uri, valid, content)

proc call*(call_822085671: Call_CancelUpload_822085666; uploadId: string): Recallable =
  ## cancelUpload
  ##   uploadId: string (required)
  ##           : The ID of the Upload.
  ## 
  var path_822085672 = newJObject()
  add(path_822085672, "upload_id", newJString(uploadId))
  result = call_822085671.call(path_822085672, nil, nil, nil, nil)

var cancelUpload* = Call_CancelUpload_822085666(name: "cancelUpload",
    meth: HttpMethod.HttpPost, host: "api.openai.com",
    route: "/uploads/{upload_id}/cancel", validator: validate_CancelUpload_822085667,
    base: "/v1", makeUrl: url_CancelUpload_822085668, schemes: {Scheme.Https})
type
  Call_CompleteUpload_822085673 = ref object of OpenApiRestCall_822083995
proc url_CompleteUpload_822085675(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "upload_id" in path, "`upload_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/uploads/"),
                 (kind: VariableSegment, value: "upload_id"),
                 (kind: ConstantSegment, value: "/complete")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CompleteUpload_822085674(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   upload_id: JString (required)
  ##            : The ID of the Upload.
  ## 
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `upload_id` field"
  var valid_822085676 = path.getOrDefault("upload_id")
  valid_822085676 = validateParameter(valid_822085676, JString, required = true,
                                      default = nil)
  if valid_822085676 != nil:
    section.add "upload_id", valid_822085676
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  if `==`(content, ""): assert body != nil, "body argument is necessary"
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085678: Call_CompleteUpload_822085673; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085678.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085678.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085678.makeUrl(scheme.get, call_822085678.host, call_822085678.base,
                                   call_822085678.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085678, uri, valid, content)

proc call*(call_822085679: Call_CompleteUpload_822085673; body: JsonNode;
           uploadId: string): Recallable =
  ## completeUpload
  ##   body: JObject (required)
  ##   uploadId: string (required)
  ##           : The ID of the Upload.
  ## 
  var path_822085680 = newJObject()
  var body_822085681 = newJObject()
  if body != nil:
    body_822085681 = body
  add(path_822085680, "upload_id", newJString(uploadId))
  result = call_822085679.call(path_822085680, nil, nil, nil, body_822085681)

var completeUpload* = Call_CompleteUpload_822085673(name: "completeUpload",
    meth: HttpMethod.HttpPost, host: "api.openai.com",
    route: "/uploads/{upload_id}/complete", validator: validate_CompleteUpload_822085674,
    base: "/v1", makeUrl: url_CompleteUpload_822085675, schemes: {Scheme.Https})
type
  Call_AddUploadPart_822085682 = ref object of OpenApiRestCall_822083995
proc url_AddUploadPart_822085684(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "upload_id" in path, "`upload_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/uploads/"),
                 (kind: VariableSegment, value: "upload_id"),
                 (kind: ConstantSegment, value: "/parts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_AddUploadPart_822085683(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   upload_id: JString (required)
  ##            : The ID of the Upload.
  ## 
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `upload_id` field"
  var valid_822085685 = path.getOrDefault("upload_id")
  valid_822085685 = validateParameter(valid_822085685, JString, required = true,
                                      default = nil)
  if valid_822085685 != nil:
    section.add "upload_id", valid_822085685
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  ## parameters in `formData` object:
  ##   data: JString (required)
  ##       : The chunk of bytes for this Part.
  ## 
  section = newJObject()
  assert formData != nil,
         "formData argument is necessary due to required `data` field"
  var valid_822085686 = formData.getOrDefault("data")
  valid_822085686 = validateParameter(valid_822085686, JString, required = true,
                                      default = nil)
  if valid_822085686 != nil:
    section.add "data", valid_822085686
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085687: Call_AddUploadPart_822085682; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085687.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085687.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085687.makeUrl(scheme.get, call_822085687.host, call_822085687.base,
                                   call_822085687.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085687, uri, valid, content)

proc call*(call_822085688: Call_AddUploadPart_822085682; uploadId: string;
           data: string): Recallable =
  ## addUploadPart
  ##   uploadId: string (required)
  ##           : The ID of the Upload.
  ## 
  ##   data: string (required)
  ##       : The chunk of bytes for this Part.
  ## 
  var path_822085689 = newJObject()
  var formData_822085690 = newJObject()
  add(path_822085689, "upload_id", newJString(uploadId))
  add(formData_822085690, "data", newJString(data))
  result = call_822085688.call(path_822085689, nil, nil, formData_822085690, nil)

var addUploadPart* = Call_AddUploadPart_822085682(name: "addUploadPart",
    meth: HttpMethod.HttpPost, host: "api.openai.com",
    route: "/uploads/{upload_id}/parts", validator: validate_AddUploadPart_822085683,
    base: "/v1", makeUrl: url_AddUploadPart_822085684, schemes: {Scheme.Https})
type
  Call_CreateVectorStore_822085701 = ref object of OpenApiRestCall_822083995
proc url_CreateVectorStore_822085703(protocol: Scheme; host: string;
                                     base: string; route: string;
                                     path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CreateVectorStore_822085702(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  if `==`(content, ""): assert body != nil, "body argument is necessary"
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085705: Call_CreateVectorStore_822085701;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085705.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085705.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085705.makeUrl(scheme.get, call_822085705.host, call_822085705.base,
                                   call_822085705.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085705, uri, valid, content)

proc call*(call_822085706: Call_CreateVectorStore_822085701; body: JsonNode): Recallable =
  ## createVectorStore
  ##   body: JObject (required)
  var body_822085707 = newJObject()
  if body != nil:
    body_822085707 = body
  result = call_822085706.call(nil, nil, nil, nil, body_822085707)

var createVectorStore* = Call_CreateVectorStore_822085701(
    name: "createVectorStore", meth: HttpMethod.HttpPost,
    host: "api.openai.com", route: "/vector_stores",
    validator: validate_CreateVectorStore_822085702, base: "/v1",
    makeUrl: url_CreateVectorStore_822085703, schemes: {Scheme.Https})
type
  Call_ListVectorStores_822085691 = ref object of OpenApiRestCall_822083995
proc url_ListVectorStores_822085693(protocol: Scheme; host: string;
                                    base: string; route: string; path: JsonNode;
                                    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  if base == "/" and route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_ListVectorStores_822085692(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   after: JString
  ##        : A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
  ## 
  ##   order: JString
  ##        : Sort order by the `created_at` timestamp of the objects. `asc` for ascending order and `desc` for descending order.
  ## 
  ##   limit: JInt
  ##        : A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.
  ## 
  ##   before: JString
  ##         : A cursor for use in pagination. `before` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, starting with obj_foo, your subsequent call can include before=obj_foo in order to fetch the previous page of the list.
  ## 
  section = newJObject()
  var valid_822085694 = query.getOrDefault("after")
  valid_822085694 = validateParameter(valid_822085694, JString,
                                      required = false, default = nil)
  if valid_822085694 != nil:
    section.add "after", valid_822085694
  var valid_822085695 = query.getOrDefault("order")
  valid_822085695 = validateParameter(valid_822085695, JString,
                                      required = false,
                                      default = newJString("desc"))
  if valid_822085695 != nil:
    section.add "order", valid_822085695
  var valid_822085696 = query.getOrDefault("limit")
  valid_822085696 = validateParameter(valid_822085696, JInt, required = false,
                                      default = newJInt(20))
  if valid_822085696 != nil:
    section.add "limit", valid_822085696
  var valid_822085697 = query.getOrDefault("before")
  valid_822085697 = validateParameter(valid_822085697, JString,
                                      required = false, default = nil)
  if valid_822085697 != nil:
    section.add "before", valid_822085697
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085698: Call_ListVectorStores_822085691;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085698.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085698.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085698.makeUrl(scheme.get, call_822085698.host, call_822085698.base,
                                   call_822085698.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085698, uri, valid, content)

proc call*(call_822085699: Call_ListVectorStores_822085691; after: string = "";
           order: string = "desc"; limit: int = 20; before: string = ""): Recallable =
  ## listVectorStores
  ##   after: string
  ##        : A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
  ## 
  ##   order: string
  ##        : Sort order by the `created_at` timestamp of the objects. `asc` for ascending order and `desc` for descending order.
  ## 
  ##   limit: int
  ##        : A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.
  ## 
  ##   before: string
  ##         : A cursor for use in pagination. `before` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, starting with obj_foo, your subsequent call can include before=obj_foo in order to fetch the previous page of the list.
  ## 
  var query_822085700 = newJObject()
  add(query_822085700, "after", newJString(after))
  add(query_822085700, "order", newJString(order))
  add(query_822085700, "limit", newJInt(limit))
  add(query_822085700, "before", newJString(before))
  result = call_822085699.call(nil, query_822085700, nil, nil, nil)

var listVectorStores* = Call_ListVectorStores_822085691(
    name: "listVectorStores", meth: HttpMethod.HttpGet, host: "api.openai.com",
    route: "/vector_stores", validator: validate_ListVectorStores_822085692,
    base: "/v1", makeUrl: url_ListVectorStores_822085693,
    schemes: {Scheme.Https})
type
  Call_DeleteVectorStore_822085724 = ref object of OpenApiRestCall_822083995
proc url_DeleteVectorStore_822085726(protocol: Scheme; host: string;
                                     base: string; route: string;
                                     path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "vector_store_id" in path,
         "`vector_store_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/vector_stores/"),
                 (kind: VariableSegment, value: "vector_store_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DeleteVectorStore_822085725(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vector_store_id: JString (required)
  ##                  : The ID of the vector store to delete.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `vector_store_id` field"
  var valid_822085727 = path.getOrDefault("vector_store_id")
  valid_822085727 = validateParameter(valid_822085727, JString, required = true,
                                      default = nil)
  if valid_822085727 != nil:
    section.add "vector_store_id", valid_822085727
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085728: Call_DeleteVectorStore_822085724;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085728.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085728.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085728.makeUrl(scheme.get, call_822085728.host, call_822085728.base,
                                   call_822085728.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085728, uri, valid, content)

proc call*(call_822085729: Call_DeleteVectorStore_822085724;
           vectorStoreId: string): Recallable =
  ## deleteVectorStore
  ##   vectorStoreId: string (required)
  ##                : The ID of the vector store to delete.
  var path_822085730 = newJObject()
  add(path_822085730, "vector_store_id", newJString(vectorStoreId))
  result = call_822085729.call(path_822085730, nil, nil, nil, nil)

var deleteVectorStore* = Call_DeleteVectorStore_822085724(
    name: "deleteVectorStore", meth: HttpMethod.HttpDelete,
    host: "api.openai.com", route: "/vector_stores/{vector_store_id}",
    validator: validate_DeleteVectorStore_822085725, base: "/v1",
    makeUrl: url_DeleteVectorStore_822085726, schemes: {Scheme.Https})
type
  Call_ModifyVectorStore_822085715 = ref object of OpenApiRestCall_822083995
proc url_ModifyVectorStore_822085717(protocol: Scheme; host: string;
                                     base: string; route: string;
                                     path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "vector_store_id" in path,
         "`vector_store_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/vector_stores/"),
                 (kind: VariableSegment, value: "vector_store_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ModifyVectorStore_822085716(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vector_store_id: JString (required)
  ##                  : The ID of the vector store to modify.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `vector_store_id` field"
  var valid_822085718 = path.getOrDefault("vector_store_id")
  valid_822085718 = validateParameter(valid_822085718, JString, required = true,
                                      default = nil)
  if valid_822085718 != nil:
    section.add "vector_store_id", valid_822085718
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  if `==`(content, ""): assert body != nil, "body argument is necessary"
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085720: Call_ModifyVectorStore_822085715;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085720.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085720.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085720.makeUrl(scheme.get, call_822085720.host, call_822085720.base,
                                   call_822085720.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085720, uri, valid, content)

proc call*(call_822085721: Call_ModifyVectorStore_822085715; body: JsonNode;
           vectorStoreId: string): Recallable =
  ## modifyVectorStore
  ##   body: JObject (required)
  ##   vectorStoreId: string (required)
  ##                : The ID of the vector store to modify.
  var path_822085722 = newJObject()
  var body_822085723 = newJObject()
  if body != nil:
    body_822085723 = body
  add(path_822085722, "vector_store_id", newJString(vectorStoreId))
  result = call_822085721.call(path_822085722, nil, nil, nil, body_822085723)

var modifyVectorStore* = Call_ModifyVectorStore_822085715(
    name: "modifyVectorStore", meth: HttpMethod.HttpPost,
    host: "api.openai.com", route: "/vector_stores/{vector_store_id}",
    validator: validate_ModifyVectorStore_822085716, base: "/v1",
    makeUrl: url_ModifyVectorStore_822085717, schemes: {Scheme.Https})
type
  Call_GetVectorStore_822085708 = ref object of OpenApiRestCall_822083995
proc url_GetVectorStore_822085710(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "vector_store_id" in path,
         "`vector_store_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/vector_stores/"),
                 (kind: VariableSegment, value: "vector_store_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GetVectorStore_822085709(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vector_store_id: JString (required)
  ##                  : The ID of the vector store to retrieve.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `vector_store_id` field"
  var valid_822085711 = path.getOrDefault("vector_store_id")
  valid_822085711 = validateParameter(valid_822085711, JString, required = true,
                                      default = nil)
  if valid_822085711 != nil:
    section.add "vector_store_id", valid_822085711
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085712: Call_GetVectorStore_822085708; path: JsonNode = nil;
           query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085712.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085712.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085712.makeUrl(scheme.get, call_822085712.host, call_822085712.base,
                                   call_822085712.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085712, uri, valid, content)

proc call*(call_822085713: Call_GetVectorStore_822085708; vectorStoreId: string): Recallable =
  ## getVectorStore
  ##   vectorStoreId: string (required)
  ##                : The ID of the vector store to retrieve.
  var path_822085714 = newJObject()
  add(path_822085714, "vector_store_id", newJString(vectorStoreId))
  result = call_822085713.call(path_822085714, nil, nil, nil, nil)

var getVectorStore* = Call_GetVectorStore_822085708(name: "getVectorStore",
    meth: HttpMethod.HttpGet, host: "api.openai.com",
    route: "/vector_stores/{vector_store_id}",
    validator: validate_GetVectorStore_822085709, base: "/v1",
    makeUrl: url_GetVectorStore_822085710, schemes: {Scheme.Https})
type
  Call_CreateVectorStoreFileBatch_822085731 = ref object of OpenApiRestCall_822083995
proc url_CreateVectorStoreFileBatch_822085733(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "vector_store_id" in path,
         "`vector_store_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/vector_stores/"),
                 (kind: VariableSegment, value: "vector_store_id"),
                 (kind: ConstantSegment, value: "/file_batches")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CreateVectorStoreFileBatch_822085732(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode;
    content: string = ""): JsonNode {.nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vector_store_id: JString (required)
  ##                  : The ID of the vector store for which to create a File Batch.
  ## 
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `vector_store_id` field"
  var valid_822085734 = path.getOrDefault("vector_store_id")
  valid_822085734 = validateParameter(valid_822085734, JString, required = true,
                                      default = nil)
  if valid_822085734 != nil:
    section.add "vector_store_id", valid_822085734
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  if `==`(content, ""): assert body != nil, "body argument is necessary"
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085736: Call_CreateVectorStoreFileBatch_822085731;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085736.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085736.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085736.makeUrl(scheme.get, call_822085736.host, call_822085736.base,
                                   call_822085736.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085736, uri, valid, content)

proc call*(call_822085737: Call_CreateVectorStoreFileBatch_822085731;
           body: JsonNode; vectorStoreId: string): Recallable =
  ## createVectorStoreFileBatch
  ##   body: JObject (required)
  ##   vectorStoreId: string (required)
  ##                : The ID of the vector store for which to create a File Batch.
  ## 
  var path_822085738 = newJObject()
  var body_822085739 = newJObject()
  if body != nil:
    body_822085739 = body
  add(path_822085738, "vector_store_id", newJString(vectorStoreId))
  result = call_822085737.call(path_822085738, nil, nil, nil, body_822085739)

var createVectorStoreFileBatch* = Call_CreateVectorStoreFileBatch_822085731(
    name: "createVectorStoreFileBatch", meth: HttpMethod.HttpPost,
    host: "api.openai.com",
    route: "/vector_stores/{vector_store_id}/file_batches",
    validator: validate_CreateVectorStoreFileBatch_822085732, base: "/v1",
    makeUrl: url_CreateVectorStoreFileBatch_822085733, schemes: {Scheme.Https})
type
  Call_GetVectorStoreFileBatch_822085740 = ref object of OpenApiRestCall_822083995
proc url_GetVectorStoreFileBatch_822085742(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "vector_store_id" in path,
         "`vector_store_id` is a required path parameter"
  assert "batch_id" in path, "`batch_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/vector_stores/"),
                 (kind: VariableSegment, value: "vector_store_id"),
                 (kind: ConstantSegment, value: "/file_batches/"),
                 (kind: VariableSegment, value: "batch_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GetVectorStoreFileBatch_822085741(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   batch_id: JString (required)
  ##           : The ID of the file batch being retrieved.
  ##   vector_store_id: JString (required)
  ##                  : The ID of the vector store that the file batch belongs to.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `batch_id` field"
  var valid_822085743 = path.getOrDefault("batch_id")
  valid_822085743 = validateParameter(valid_822085743, JString, required = true,
                                      default = nil)
  if valid_822085743 != nil:
    section.add "batch_id", valid_822085743
  var valid_822085744 = path.getOrDefault("vector_store_id")
  valid_822085744 = validateParameter(valid_822085744, JString, required = true,
                                      default = nil)
  if valid_822085744 != nil:
    section.add "vector_store_id", valid_822085744
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085745: Call_GetVectorStoreFileBatch_822085740;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085745.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085745.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085745.makeUrl(scheme.get, call_822085745.host, call_822085745.base,
                                   call_822085745.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085745, uri, valid, content)

proc call*(call_822085746: Call_GetVectorStoreFileBatch_822085740;
           batchId: string; vectorStoreId: string): Recallable =
  ## getVectorStoreFileBatch
  ##   batchId: string (required)
  ##          : The ID of the file batch being retrieved.
  ##   vectorStoreId: string (required)
  ##                : The ID of the vector store that the file batch belongs to.
  var path_822085747 = newJObject()
  add(path_822085747, "batch_id", newJString(batchId))
  add(path_822085747, "vector_store_id", newJString(vectorStoreId))
  result = call_822085746.call(path_822085747, nil, nil, nil, nil)

var getVectorStoreFileBatch* = Call_GetVectorStoreFileBatch_822085740(
    name: "getVectorStoreFileBatch", meth: HttpMethod.HttpGet,
    host: "api.openai.com",
    route: "/vector_stores/{vector_store_id}/file_batches/{batch_id}",
    validator: validate_GetVectorStoreFileBatch_822085741, base: "/v1",
    makeUrl: url_GetVectorStoreFileBatch_822085742, schemes: {Scheme.Https})
type
  Call_CancelVectorStoreFileBatch_822085748 = ref object of OpenApiRestCall_822083995
proc url_CancelVectorStoreFileBatch_822085750(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "vector_store_id" in path,
         "`vector_store_id` is a required path parameter"
  assert "batch_id" in path, "`batch_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/vector_stores/"),
                 (kind: VariableSegment, value: "vector_store_id"),
                 (kind: ConstantSegment, value: "/file_batches/"),
                 (kind: VariableSegment, value: "batch_id"),
                 (kind: ConstantSegment, value: "/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CancelVectorStoreFileBatch_822085749(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode;
    content: string = ""): JsonNode {.nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   batch_id: JString (required)
  ##           : The ID of the file batch to cancel.
  ##   vector_store_id: JString (required)
  ##                  : The ID of the vector store that the file batch belongs to.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `batch_id` field"
  var valid_822085751 = path.getOrDefault("batch_id")
  valid_822085751 = validateParameter(valid_822085751, JString, required = true,
                                      default = nil)
  if valid_822085751 != nil:
    section.add "batch_id", valid_822085751
  var valid_822085752 = path.getOrDefault("vector_store_id")
  valid_822085752 = validateParameter(valid_822085752, JString, required = true,
                                      default = nil)
  if valid_822085752 != nil:
    section.add "vector_store_id", valid_822085752
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085753: Call_CancelVectorStoreFileBatch_822085748;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085753.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085753.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085753.makeUrl(scheme.get, call_822085753.host, call_822085753.base,
                                   call_822085753.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085753, uri, valid, content)

proc call*(call_822085754: Call_CancelVectorStoreFileBatch_822085748;
           batchId: string; vectorStoreId: string): Recallable =
  ## cancelVectorStoreFileBatch
  ##   batchId: string (required)
  ##          : The ID of the file batch to cancel.
  ##   vectorStoreId: string (required)
  ##                : The ID of the vector store that the file batch belongs to.
  var path_822085755 = newJObject()
  add(path_822085755, "batch_id", newJString(batchId))
  add(path_822085755, "vector_store_id", newJString(vectorStoreId))
  result = call_822085754.call(path_822085755, nil, nil, nil, nil)

var cancelVectorStoreFileBatch* = Call_CancelVectorStoreFileBatch_822085748(
    name: "cancelVectorStoreFileBatch", meth: HttpMethod.HttpPost,
    host: "api.openai.com",
    route: "/vector_stores/{vector_store_id}/file_batches/{batch_id}/cancel",
    validator: validate_CancelVectorStoreFileBatch_822085749, base: "/v1",
    makeUrl: url_CancelVectorStoreFileBatch_822085750, schemes: {Scheme.Https})
type
  Call_ListFilesInVectorStoreBatch_822085756 = ref object of OpenApiRestCall_822083995
proc url_ListFilesInVectorStoreBatch_822085758(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "vector_store_id" in path,
         "`vector_store_id` is a required path parameter"
  assert "batch_id" in path, "`batch_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/vector_stores/"),
                 (kind: VariableSegment, value: "vector_store_id"),
                 (kind: ConstantSegment, value: "/file_batches/"),
                 (kind: VariableSegment, value: "batch_id"),
                 (kind: ConstantSegment, value: "/files")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ListFilesInVectorStoreBatch_822085757(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode;
    content: string = ""): JsonNode {.nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   batch_id: JString (required)
  ##           : The ID of the file batch that the files belong to.
  ##   vector_store_id: JString (required)
  ##                  : The ID of the vector store that the files belong to.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `batch_id` field"
  var valid_822085759 = path.getOrDefault("batch_id")
  valid_822085759 = validateParameter(valid_822085759, JString, required = true,
                                      default = nil)
  if valid_822085759 != nil:
    section.add "batch_id", valid_822085759
  var valid_822085760 = path.getOrDefault("vector_store_id")
  valid_822085760 = validateParameter(valid_822085760, JString, required = true,
                                      default = nil)
  if valid_822085760 != nil:
    section.add "vector_store_id", valid_822085760
  result.add "path", section
  ## parameters in `query` object:
  ##   after: JString
  ##        : A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
  ## 
  ##   order: JString
  ##        : Sort order by the `created_at` timestamp of the objects. `asc` for ascending order and `desc` for descending order.
  ## 
  ##   filter: JString
  ##         : Filter by file status. One of `in_progress`, `completed`, `failed`, `cancelled`.
  ##   limit: JInt
  ##        : A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.
  ## 
  ##   before: JString
  ##         : A cursor for use in pagination. `before` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, starting with obj_foo, your subsequent call can include before=obj_foo in order to fetch the previous page of the list.
  ## 
  section = newJObject()
  var valid_822085761 = query.getOrDefault("after")
  valid_822085761 = validateParameter(valid_822085761, JString,
                                      required = false, default = nil)
  if valid_822085761 != nil:
    section.add "after", valid_822085761
  var valid_822085762 = query.getOrDefault("order")
  valid_822085762 = validateParameter(valid_822085762, JString,
                                      required = false,
                                      default = newJString("desc"))
  if valid_822085762 != nil:
    section.add "order", valid_822085762
  var valid_822085763 = query.getOrDefault("filter")
  valid_822085763 = validateParameter(valid_822085763, JString,
                                      required = false,
                                      default = newJString("in_progress"))
  if valid_822085763 != nil:
    section.add "filter", valid_822085763
  var valid_822085764 = query.getOrDefault("limit")
  valid_822085764 = validateParameter(valid_822085764, JInt, required = false,
                                      default = newJInt(20))
  if valid_822085764 != nil:
    section.add "limit", valid_822085764
  var valid_822085765 = query.getOrDefault("before")
  valid_822085765 = validateParameter(valid_822085765, JString,
                                      required = false, default = nil)
  if valid_822085765 != nil:
    section.add "before", valid_822085765
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085766: Call_ListFilesInVectorStoreBatch_822085756;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085766.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085766.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085766.makeUrl(scheme.get, call_822085766.host, call_822085766.base,
                                   call_822085766.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085766, uri, valid, content)

proc call*(call_822085767: Call_ListFilesInVectorStoreBatch_822085756;
           batchId: string; vectorStoreId: string; after: string = "";
           order: string = "desc"; filter: string = "in_progress";
           limit: int = 20; before: string = ""): Recallable =
  ## listFilesInVectorStoreBatch
  ##   after: string
  ##        : A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
  ## 
  ##   order: string
  ##        : Sort order by the `created_at` timestamp of the objects. `asc` for ascending order and `desc` for descending order.
  ## 
  ##   batchId: string (required)
  ##          : The ID of the file batch that the files belong to.
  ##   filter: string
  ##         : Filter by file status. One of `in_progress`, `completed`, `failed`, `cancelled`.
  ##   limit: int
  ##        : A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.
  ## 
  ##   vectorStoreId: string (required)
  ##                : The ID of the vector store that the files belong to.
  ##   before: string
  ##         : A cursor for use in pagination. `before` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, starting with obj_foo, your subsequent call can include before=obj_foo in order to fetch the previous page of the list.
  ## 
  var path_822085768 = newJObject()
  var query_822085769 = newJObject()
  add(query_822085769, "after", newJString(after))
  add(query_822085769, "order", newJString(order))
  add(path_822085768, "batch_id", newJString(batchId))
  add(query_822085769, "filter", newJString(filter))
  add(query_822085769, "limit", newJInt(limit))
  add(path_822085768, "vector_store_id", newJString(vectorStoreId))
  add(query_822085769, "before", newJString(before))
  result = call_822085767.call(path_822085768, query_822085769, nil, nil, nil)

var listFilesInVectorStoreBatch* = Call_ListFilesInVectorStoreBatch_822085756(
    name: "listFilesInVectorStoreBatch", meth: HttpMethod.HttpGet,
    host: "api.openai.com",
    route: "/vector_stores/{vector_store_id}/file_batches/{batch_id}/files",
    validator: validate_ListFilesInVectorStoreBatch_822085757, base: "/v1",
    makeUrl: url_ListFilesInVectorStoreBatch_822085758, schemes: {Scheme.Https})
type
  Call_CreateVectorStoreFile_822085783 = ref object of OpenApiRestCall_822083995
proc url_CreateVectorStoreFile_822085785(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "vector_store_id" in path,
         "`vector_store_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/vector_stores/"),
                 (kind: VariableSegment, value: "vector_store_id"),
                 (kind: ConstantSegment, value: "/files")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CreateVectorStoreFile_822085784(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vector_store_id: JString (required)
  ##                  : The ID of the vector store for which to create a File.
  ## 
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `vector_store_id` field"
  var valid_822085786 = path.getOrDefault("vector_store_id")
  valid_822085786 = validateParameter(valid_822085786, JString, required = true,
                                      default = nil)
  if valid_822085786 != nil:
    section.add "vector_store_id", valid_822085786
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  if `==`(content, ""): assert body != nil, "body argument is necessary"
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085788: Call_CreateVectorStoreFile_822085783;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085788.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085788.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085788.makeUrl(scheme.get, call_822085788.host, call_822085788.base,
                                   call_822085788.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085788, uri, valid, content)

proc call*(call_822085789: Call_CreateVectorStoreFile_822085783; body: JsonNode;
           vectorStoreId: string): Recallable =
  ## createVectorStoreFile
  ##   body: JObject (required)
  ##   vectorStoreId: string (required)
  ##                : The ID of the vector store for which to create a File.
  ## 
  var path_822085790 = newJObject()
  var body_822085791 = newJObject()
  if body != nil:
    body_822085791 = body
  add(path_822085790, "vector_store_id", newJString(vectorStoreId))
  result = call_822085789.call(path_822085790, nil, nil, nil, body_822085791)

var createVectorStoreFile* = Call_CreateVectorStoreFile_822085783(
    name: "createVectorStoreFile", meth: HttpMethod.HttpPost,
    host: "api.openai.com", route: "/vector_stores/{vector_store_id}/files",
    validator: validate_CreateVectorStoreFile_822085784, base: "/v1",
    makeUrl: url_CreateVectorStoreFile_822085785, schemes: {Scheme.Https})
type
  Call_ListVectorStoreFiles_822085770 = ref object of OpenApiRestCall_822083995
proc url_ListVectorStoreFiles_822085772(protocol: Scheme; host: string;
                                        base: string; route: string;
                                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "vector_store_id" in path,
         "`vector_store_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/vector_stores/"),
                 (kind: VariableSegment, value: "vector_store_id"),
                 (kind: ConstantSegment, value: "/files")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ListVectorStoreFiles_822085771(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vector_store_id: JString (required)
  ##                  : The ID of the vector store that the files belong to.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `vector_store_id` field"
  var valid_822085773 = path.getOrDefault("vector_store_id")
  valid_822085773 = validateParameter(valid_822085773, JString, required = true,
                                      default = nil)
  if valid_822085773 != nil:
    section.add "vector_store_id", valid_822085773
  result.add "path", section
  ## parameters in `query` object:
  ##   after: JString
  ##        : A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
  ## 
  ##   order: JString
  ##        : Sort order by the `created_at` timestamp of the objects. `asc` for ascending order and `desc` for descending order.
  ## 
  ##   filter: JString
  ##         : Filter by file status. One of `in_progress`, `completed`, `failed`, `cancelled`.
  ##   limit: JInt
  ##        : A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.
  ## 
  ##   before: JString
  ##         : A cursor for use in pagination. `before` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, starting with obj_foo, your subsequent call can include before=obj_foo in order to fetch the previous page of the list.
  ## 
  section = newJObject()
  var valid_822085774 = query.getOrDefault("after")
  valid_822085774 = validateParameter(valid_822085774, JString,
                                      required = false, default = nil)
  if valid_822085774 != nil:
    section.add "after", valid_822085774
  var valid_822085775 = query.getOrDefault("order")
  valid_822085775 = validateParameter(valid_822085775, JString,
                                      required = false,
                                      default = newJString("desc"))
  if valid_822085775 != nil:
    section.add "order", valid_822085775
  var valid_822085776 = query.getOrDefault("filter")
  valid_822085776 = validateParameter(valid_822085776, JString,
                                      required = false,
                                      default = newJString("in_progress"))
  if valid_822085776 != nil:
    section.add "filter", valid_822085776
  var valid_822085777 = query.getOrDefault("limit")
  valid_822085777 = validateParameter(valid_822085777, JInt, required = false,
                                      default = newJInt(20))
  if valid_822085777 != nil:
    section.add "limit", valid_822085777
  var valid_822085778 = query.getOrDefault("before")
  valid_822085778 = validateParameter(valid_822085778, JString,
                                      required = false, default = nil)
  if valid_822085778 != nil:
    section.add "before", valid_822085778
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085779: Call_ListVectorStoreFiles_822085770;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085779.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085779.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085779.makeUrl(scheme.get, call_822085779.host, call_822085779.base,
                                   call_822085779.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085779, uri, valid, content)

proc call*(call_822085780: Call_ListVectorStoreFiles_822085770;
           vectorStoreId: string; after: string = ""; order: string = "desc";
           filter: string = "in_progress"; limit: int = 20; before: string = ""): Recallable =
  ## listVectorStoreFiles
  ##   after: string
  ##        : A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
  ## 
  ##   order: string
  ##        : Sort order by the `created_at` timestamp of the objects. `asc` for ascending order and `desc` for descending order.
  ## 
  ##   filter: string
  ##         : Filter by file status. One of `in_progress`, `completed`, `failed`, `cancelled`.
  ##   limit: int
  ##        : A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.
  ## 
  ##   vectorStoreId: string (required)
  ##                : The ID of the vector store that the files belong to.
  ##   before: string
  ##         : A cursor for use in pagination. `before` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, starting with obj_foo, your subsequent call can include before=obj_foo in order to fetch the previous page of the list.
  ## 
  var path_822085781 = newJObject()
  var query_822085782 = newJObject()
  add(query_822085782, "after", newJString(after))
  add(query_822085782, "order", newJString(order))
  add(query_822085782, "filter", newJString(filter))
  add(query_822085782, "limit", newJInt(limit))
  add(path_822085781, "vector_store_id", newJString(vectorStoreId))
  add(query_822085782, "before", newJString(before))
  result = call_822085780.call(path_822085781, query_822085782, nil, nil, nil)

var listVectorStoreFiles* = Call_ListVectorStoreFiles_822085770(
    name: "listVectorStoreFiles", meth: HttpMethod.HttpGet,
    host: "api.openai.com", route: "/vector_stores/{vector_store_id}/files",
    validator: validate_ListVectorStoreFiles_822085771, base: "/v1",
    makeUrl: url_ListVectorStoreFiles_822085772, schemes: {Scheme.Https})
type
  Call_DeleteVectorStoreFile_822085810 = ref object of OpenApiRestCall_822083995
proc url_DeleteVectorStoreFile_822085812(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "vector_store_id" in path,
         "`vector_store_id` is a required path parameter"
  assert "file_id" in path, "`file_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/vector_stores/"),
                 (kind: VariableSegment, value: "vector_store_id"),
                 (kind: ConstantSegment, value: "/files/"),
                 (kind: VariableSegment, value: "file_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DeleteVectorStoreFile_822085811(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   file_id: JString (required)
  ##          : The ID of the file to delete.
  ##   vector_store_id: JString (required)
  ##                  : The ID of the vector store that the file belongs to.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `file_id` field"
  var valid_822085813 = path.getOrDefault("file_id")
  valid_822085813 = validateParameter(valid_822085813, JString, required = true,
                                      default = nil)
  if valid_822085813 != nil:
    section.add "file_id", valid_822085813
  var valid_822085814 = path.getOrDefault("vector_store_id")
  valid_822085814 = validateParameter(valid_822085814, JString, required = true,
                                      default = nil)
  if valid_822085814 != nil:
    section.add "vector_store_id", valid_822085814
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085815: Call_DeleteVectorStoreFile_822085810;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085815.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085815.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085815.makeUrl(scheme.get, call_822085815.host, call_822085815.base,
                                   call_822085815.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085815, uri, valid, content)

proc call*(call_822085816: Call_DeleteVectorStoreFile_822085810; fileId: string;
           vectorStoreId: string): Recallable =
  ## deleteVectorStoreFile
  ##   fileId: string (required)
  ##         : The ID of the file to delete.
  ##   vectorStoreId: string (required)
  ##                : The ID of the vector store that the file belongs to.
  var path_822085817 = newJObject()
  add(path_822085817, "file_id", newJString(fileId))
  add(path_822085817, "vector_store_id", newJString(vectorStoreId))
  result = call_822085816.call(path_822085817, nil, nil, nil, nil)

var deleteVectorStoreFile* = Call_DeleteVectorStoreFile_822085810(
    name: "deleteVectorStoreFile", meth: HttpMethod.HttpDelete,
    host: "api.openai.com",
    route: "/vector_stores/{vector_store_id}/files/{file_id}",
    validator: validate_DeleteVectorStoreFile_822085811, base: "/v1",
    makeUrl: url_DeleteVectorStoreFile_822085812, schemes: {Scheme.Https})
type
  Call_UpdateVectorStoreFileAttributes_822085800 = ref object of OpenApiRestCall_822083995
proc url_UpdateVectorStoreFileAttributes_822085802(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "vector_store_id" in path,
         "`vector_store_id` is a required path parameter"
  assert "file_id" in path, "`file_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/vector_stores/"),
                 (kind: VariableSegment, value: "vector_store_id"),
                 (kind: ConstantSegment, value: "/files/"),
                 (kind: VariableSegment, value: "file_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_UpdateVectorStoreFileAttributes_822085801(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode;
    content: string = ""): JsonNode {.nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   file_id: JString (required)
  ##          : The ID of the file to update attributes.
  ##   vector_store_id: JString (required)
  ##                  : The ID of the vector store the file belongs to.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `file_id` field"
  var valid_822085803 = path.getOrDefault("file_id")
  valid_822085803 = validateParameter(valid_822085803, JString, required = true,
                                      default = nil)
  if valid_822085803 != nil:
    section.add "file_id", valid_822085803
  var valid_822085804 = path.getOrDefault("vector_store_id")
  valid_822085804 = validateParameter(valid_822085804, JString, required = true,
                                      default = nil)
  if valid_822085804 != nil:
    section.add "vector_store_id", valid_822085804
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  if `==`(content, ""): assert body != nil, "body argument is necessary"
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085806: Call_UpdateVectorStoreFileAttributes_822085800;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085806.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085806.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085806.makeUrl(scheme.get, call_822085806.host, call_822085806.base,
                                   call_822085806.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085806, uri, valid, content)

proc call*(call_822085807: Call_UpdateVectorStoreFileAttributes_822085800;
           body: JsonNode; fileId: string; vectorStoreId: string): Recallable =
  ## updateVectorStoreFileAttributes
  ##   body: JObject (required)
  ##   fileId: string (required)
  ##         : The ID of the file to update attributes.
  ##   vectorStoreId: string (required)
  ##                : The ID of the vector store the file belongs to.
  var path_822085808 = newJObject()
  var body_822085809 = newJObject()
  if body != nil:
    body_822085809 = body
  add(path_822085808, "file_id", newJString(fileId))
  add(path_822085808, "vector_store_id", newJString(vectorStoreId))
  result = call_822085807.call(path_822085808, nil, nil, nil, body_822085809)

var updateVectorStoreFileAttributes* = Call_UpdateVectorStoreFileAttributes_822085800(
    name: "updateVectorStoreFileAttributes", meth: HttpMethod.HttpPost,
    host: "api.openai.com",
    route: "/vector_stores/{vector_store_id}/files/{file_id}",
    validator: validate_UpdateVectorStoreFileAttributes_822085801, base: "/v1",
    makeUrl: url_UpdateVectorStoreFileAttributes_822085802,
    schemes: {Scheme.Https})
type
  Call_GetVectorStoreFile_822085792 = ref object of OpenApiRestCall_822083995
proc url_GetVectorStoreFile_822085794(protocol: Scheme; host: string;
                                      base: string; route: string;
                                      path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "vector_store_id" in path,
         "`vector_store_id` is a required path parameter"
  assert "file_id" in path, "`file_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/vector_stores/"),
                 (kind: VariableSegment, value: "vector_store_id"),
                 (kind: ConstantSegment, value: "/files/"),
                 (kind: VariableSegment, value: "file_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GetVectorStoreFile_822085793(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   file_id: JString (required)
  ##          : The ID of the file being retrieved.
  ##   vector_store_id: JString (required)
  ##                  : The ID of the vector store that the file belongs to.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `file_id` field"
  var valid_822085795 = path.getOrDefault("file_id")
  valid_822085795 = validateParameter(valid_822085795, JString, required = true,
                                      default = nil)
  if valid_822085795 != nil:
    section.add "file_id", valid_822085795
  var valid_822085796 = path.getOrDefault("vector_store_id")
  valid_822085796 = validateParameter(valid_822085796, JString, required = true,
                                      default = nil)
  if valid_822085796 != nil:
    section.add "vector_store_id", valid_822085796
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085797: Call_GetVectorStoreFile_822085792;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085797.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085797.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085797.makeUrl(scheme.get, call_822085797.host, call_822085797.base,
                                   call_822085797.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085797, uri, valid, content)

proc call*(call_822085798: Call_GetVectorStoreFile_822085792; fileId: string;
           vectorStoreId: string): Recallable =
  ## getVectorStoreFile
  ##   fileId: string (required)
  ##         : The ID of the file being retrieved.
  ##   vectorStoreId: string (required)
  ##                : The ID of the vector store that the file belongs to.
  var path_822085799 = newJObject()
  add(path_822085799, "file_id", newJString(fileId))
  add(path_822085799, "vector_store_id", newJString(vectorStoreId))
  result = call_822085798.call(path_822085799, nil, nil, nil, nil)

var getVectorStoreFile* = Call_GetVectorStoreFile_822085792(
    name: "getVectorStoreFile", meth: HttpMethod.HttpGet,
    host: "api.openai.com",
    route: "/vector_stores/{vector_store_id}/files/{file_id}",
    validator: validate_GetVectorStoreFile_822085793, base: "/v1",
    makeUrl: url_GetVectorStoreFile_822085794, schemes: {Scheme.Https})
type
  Call_RetrieveVectorStoreFileContent_822085818 = ref object of OpenApiRestCall_822083995
proc url_RetrieveVectorStoreFileContent_822085820(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "vector_store_id" in path,
         "`vector_store_id` is a required path parameter"
  assert "file_id" in path, "`file_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/vector_stores/"),
                 (kind: VariableSegment, value: "vector_store_id"),
                 (kind: ConstantSegment, value: "/files/"),
                 (kind: VariableSegment, value: "file_id"),
                 (kind: ConstantSegment, value: "/content")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RetrieveVectorStoreFileContent_822085819(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode;
    content: string = ""): JsonNode {.nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   file_id: JString (required)
  ##          : The ID of the file within the vector store.
  ##   vector_store_id: JString (required)
  ##                  : The ID of the vector store.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `file_id` field"
  var valid_822085821 = path.getOrDefault("file_id")
  valid_822085821 = validateParameter(valid_822085821, JString, required = true,
                                      default = nil)
  if valid_822085821 != nil:
    section.add "file_id", valid_822085821
  var valid_822085822 = path.getOrDefault("vector_store_id")
  valid_822085822 = validateParameter(valid_822085822, JString, required = true,
                                      default = nil)
  if valid_822085822 != nil:
    section.add "vector_store_id", valid_822085822
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_822085823: Call_RetrieveVectorStoreFileContent_822085818;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085823.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085823.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085823.makeUrl(scheme.get, call_822085823.host, call_822085823.base,
                                   call_822085823.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085823, uri, valid, content)

proc call*(call_822085824: Call_RetrieveVectorStoreFileContent_822085818;
           fileId: string; vectorStoreId: string): Recallable =
  ## retrieveVectorStoreFileContent
  ##   fileId: string (required)
  ##         : The ID of the file within the vector store.
  ##   vectorStoreId: string (required)
  ##                : The ID of the vector store.
  var path_822085825 = newJObject()
  add(path_822085825, "file_id", newJString(fileId))
  add(path_822085825, "vector_store_id", newJString(vectorStoreId))
  result = call_822085824.call(path_822085825, nil, nil, nil, nil)

var retrieveVectorStoreFileContent* = Call_RetrieveVectorStoreFileContent_822085818(
    name: "retrieveVectorStoreFileContent", meth: HttpMethod.HttpGet,
    host: "api.openai.com",
    route: "/vector_stores/{vector_store_id}/files/{file_id}/content",
    validator: validate_RetrieveVectorStoreFileContent_822085819, base: "/v1",
    makeUrl: url_RetrieveVectorStoreFileContent_822085820,
    schemes: {Scheme.Https})
type
  Call_SearchVectorStore_822085826 = ref object of OpenApiRestCall_822083995
proc url_SearchVectorStore_822085828(protocol: Scheme; host: string;
                                     base: string; route: string;
                                     path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "vector_store_id" in path,
         "`vector_store_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/vector_stores/"),
                 (kind: VariableSegment, value: "vector_store_id"),
                 (kind: ConstantSegment, value: "/search")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base == "/" and hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SearchVectorStore_822085827(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode; content: string = ""): JsonNode {.
    nosinks.} =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vector_store_id: JString (required)
  ##                  : The ID of the vector store to search.
  section = newJObject()
  assert path != nil,
         "path argument is necessary due to required `vector_store_id` field"
  var valid_822085829 = path.getOrDefault("vector_store_id")
  valid_822085829 = validateParameter(valid_822085829, JString, required = true,
                                      default = nil)
  if valid_822085829 != nil:
    section.add "vector_store_id", valid_822085829
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  if `==`(content, ""): assert body != nil, "body argument is necessary"
  if `==`(content, ""):
    section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_822085831: Call_SearchVectorStore_822085826;
           path: JsonNode = nil; query: JsonNode = nil; header: JsonNode = nil;
           formData: JsonNode = nil; body: JsonNode = nil; content: string = ""): Recallable =
  let valid = call_822085831.validator(path, query, header, formData, body,
                                       content)
  let scheme = call_822085831.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let uri = call_822085831.makeUrl(scheme.get, call_822085831.host, call_822085831.base,
                                   call_822085831.route,
                                   valid.getOrDefault("path"),
                                   valid.getOrDefault("query"))
  result = newRecallable(call_822085831, uri, valid, content)

proc call*(call_822085832: Call_SearchVectorStore_822085826; body: JsonNode;
           vectorStoreId: string): Recallable =
  ## searchVectorStore
  ##   body: JObject (required)
  ##   vectorStoreId: string (required)
  ##                : The ID of the vector store to search.
  var path_822085833 = newJObject()
  var body_822085834 = newJObject()
  if body != nil:
    body_822085834 = body
  add(path_822085833, "vector_store_id", newJString(vectorStoreId))
  result = call_822085832.call(path_822085833, nil, nil, nil, body_822085834)

var searchVectorStore* = Call_SearchVectorStore_822085826(
    name: "searchVectorStore", meth: HttpMethod.HttpPost,
    host: "api.openai.com", route: "/vector_stores/{vector_store_id}/search",
    validator: validate_SearchVectorStore_822085827, base: "/v1",
    makeUrl: url_SearchVectorStore_822085828, schemes: {Scheme.Https})
discard