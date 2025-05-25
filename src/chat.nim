import std/json, std/macros, std/options
import newtype

idType ChatUserRoleId
idType ChatServerUserId
idType ChatUserId
idType ChatMessageId
idType ChatChannelId
idType ChatServerId
idType ChatRoleId

stringType Url

type
  ChatUserRole* = ref object
    id*: ChatUserRoleId
    userId*: ChatUserId
    roleId*: ChatRoleId

  ChatUser* = ref object
    id*: ChatUserId
    name*: string
    icon*: Option[Url]

  ChatServerUser* = ref object
    id*: ChatServerUserId
    userId: ChatUserId
    serverId*: ChatServerId
    nickname*: string

  ChatMessage* = ref object
    id*: ChatMessageId
    authorId*: ChatUserId
    channelId*: ChatChannelId
    content*: string

  ChatChannel* = ref object
    id*: ChatChannelId
    serverId*: ChatServerId
    name*: string
    icon*: Option[Url]

  ChatServer* = ref object
    id*: ChatServerId
    name*: string
    icon*: Option[Url]

  ChatRole* = ref object
    id*: ChatRoleId
    roleId*: ChatRoleId
    name*: string
    icon*: Option[Url]

macro registerChatTypes*(register) =
  quote:
    `register`(ChatUserRole)
    `register`(ChatUser)
    `register`(ChatServerUser)
    `register`(ChatMessage)
    `register`(ChatChannel)
    `register`(ChatServer)
    `register`(ChatRole)
