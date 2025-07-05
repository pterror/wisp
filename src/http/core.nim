import jsony
import mummy

type Error = object
  message: string

proc httpOkJson*[T](req: Request, value: T) {.gcsafe.} =
  var headers: HttpHeaders
  headers["Content-Type"] = "application/json"
  req.respond(200, headers, value.toJson)

proc httpErrorJson*(req: Request, message: string) {.gcsafe.} =
  var headers: HttpHeaders
  headers["Content-Type"] = "application/json"
  req.respond(400, headers, Error(message: message).toJson)