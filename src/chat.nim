import std/macros

type
  Url* = distinct string
  ChatUserId* = distinct int
  ChatMessageId* = distinct int
  ChatChannelId* = distinct int
  ChatServerId* = distinct int
  ChatRoleId* = distinct int

  ChatUserRole* = ref object
    id: int
    userId*: ChatUserId
    roleId*: ChatRoleId

  ChatUser* = ref object
    id: int
    name*: string
    icon*: Url

  ChatServerUser* = ref object
    id: int
    nickname*: string

  ChatMessage* = ref object
    id: int
    authorId*: ChatUserId
    channelId*: ChatChannelId
    content*: string

  ChatChannel* = ref object
    id: int
    serverId*: ChatServerId
    name*: string
    icon*: Url

  ChatServer* = ref object
    id: int
    name*: string
    icon*: Url

  ChatRole* = ref object
    id: int
    roleId*: ChatRoleId
    name*: string
    icon*: Url

func userId*(user: ChatUser): ChatUserId =
  ChatUserId(user.id)

func userId*(user: ChatServerUser): ChatUserId =
  ChatUserId(user.id)

func messageId*(message: ChatMessage): ChatMessageId =
  ChatMessageId(message.id)

func channelId*(channel: ChatChannel): ChatChannelId =
  ChatChannelId(channel.id)

func serverId*(server: ChatServer): ChatServerId =
  ChatServerId(server.id)

func roleId*(role: ChatRole): ChatRoleId =
  ChatRoleId(role.id)

macro registerChatTypes*(register) =
  quote:
    `register`(ChatUserRole)
    `register`(ChatUser)
    `register`(ChatServerUser)
    `register`(ChatMessage)
    `register`(ChatChannel)
    `register`(ChatServer)
    `register`(ChatRole)
