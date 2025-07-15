import std/dom, std/jsformdata, std/jscore

proc consoleLog*[T](x: T) {.importjs: "console.log(#)".}
proc newFormData*(x: FormElement): FormData {.importjs: "new FormData(#)".}
proc newDate*(date: cstring): DateTime {.importjs: "new Date(#)".}
