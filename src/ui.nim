import types

enumTypes:
  type
    UiDirection* = enum
      udHorizontal
      udVertical

    UiElementKind* = enum
      uekText
      uekGrid
      uekStack

type
  UiElement* = object
    children*: seq[UiElement]
    case `type`*: UiElementKind
    of uekText:
      text*: string
    of uekStack:
      direction*: UiDirection
    else:
      discard
