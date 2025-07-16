import std/macros, std/os, std/strutils
import openapi/codegen

const jsonPath = currentSourcePath.parentDir / "swagger2.json"

generate googleGenerativeLanguageApi, jsonPath, currentSourcePath.parentDir / "api.nim":
  discard
render googleGenerativeLanguageApi:
  discard
