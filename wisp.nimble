version = "0.1.0"
author = "pterror"
description = ":3"
license = "ISC"
srcDir = "src"
installExt = @["nim"]
bin = @["wisp", "codegen"]

requires "nim >= 2.2.4"
requires "mummy >= 0.4.7"
requires "openapi >= 4.0.1"
requires "https://github.com/ire4ever1190/tree >= 0.1.0"
requires "https://github.com/pterror/debby >= 0.6.2"
requires "https://github.com/pterror/jsony >= 1.1.5"

task codegen, "Run the OpenAPI codegen script":
  exec "sh -c 'pnpm dlx api-spec-converter --from=openapi_3 --to=swagger_2 ./src/world/google/generativelanguage/openapi3.json > ./src/world/google/generativelanguage/swagger2.json'"
  exec "nim c -o:src/world/google/generativelanguage/codegen src/world/google/generativelanguage/codegen.nim"
  exec "./src/world/google/generativelanguage/codegen"
  exec "rm src/world/google/generativelanguage/codegen"
  exec "curl https://app.stainless.com/api/spec/documented/openai/openapi.documented.yml > ./src/world/openai/openapi3.yml"
  exec "sed -i 's/openapi: 3.1.0/openapi: 3.0.0/' ./src/world/openai/openapi3.yml"
  exec "sh -c 'pnpm dlx api-spec-converter --from=openapi_3 --to=swagger_2 ./src/world/openai/openapi3.yml > ./src/world/openai/swagger2.tmp.json'"
  exec "sh -c 'cat ./src/world/openai/swagger2.tmp.json | jq \"del(.webhooks) | walk(if type == \\\"object\\\" and .[\\\"x-oaiTypeLabel\\\"] == \\\"string\\\" then .type = \\\"string\\\" else . end) | .paths[\\\"/images/edits\\\"].post.parameters[0].type = \\\"object\\\" \" > ./src/world/openai/swagger2.json'"
  exec "rm ./src/world/openai/swagger2.tmp.json"
  exec "sed -i 's/openapi: 3.0.0/openapi: 3.1.0/' ./src/world/openai/openapi3.yml"
  exec "nim c -o:src/world/openai/codegen src/world/openai/codegen.nim"
  exec "./src/world/openai/codegen"
  exec "rm src/world/openai/codegen"
