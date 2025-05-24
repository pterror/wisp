import std/macros
import std/options

type
  Url* = distinct string
  ChatUserRoleId* = distinct int
  ChatServerUserId* = distinct int
  ChatUserId* = distinct int
  ChatMessageId* = distinct int
  ChatChannelId* = distinct int
  ChatServerId* = distinct int
  ChatRoleId* = distinct int

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
