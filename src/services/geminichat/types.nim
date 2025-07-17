import std/options, std/macros, ../../types

stringType Url

dbTypes(GeminiChat):
  type
    # Typically a bot or persona
    Entity* = ref object
      name*: string
      icon*: Option[Url]

    # A single chat/conversation
    WorldInstance* = ref object
      name*: string
      icon*: Option[Url]

    # A table to determine which characters are currently attached to a given chat
    WorldInstanceParticipant* = ref object
      entityId*: EntityId
      worldInstanceId*: WorldInstanceId

    # A message in a conversation
    Message* = ref object
      # Messages in a conversation form a tree
      parentMessageId*: Option[MessageId]
      # The speaker of the message
      entityId*: EntityId
      worldInstanceId*: WorldInstanceId
      # Typically HTML
      content*: string
