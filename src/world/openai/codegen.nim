import std/macros, std/os, std/strutils
import openapi/codegen

const jsonPath = currentSourcePath.parentDir / "swagger2.json"

generate myApi, jsonPath, currentSourcePath.parentDir / "api.nim":
  let callId = ident "call"
  let urlId = ident "url"
  let inputId = ident "input"
  let contentId = ident "content"
  generator.ast.add quote do:
    method newRecallable(`callId`: RestCall; `urlId`: Uri; `inputId`: JsonNode; `contentId`: string): Recallable {.base.} =
      newRecallable(`callId`, `urlId`, `inputId`.getOrDefault("header").massageHeaders, `contentId`)
render myApi:
  discard
    
