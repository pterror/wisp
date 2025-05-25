import std/json, std/macros, std/options
import types

stringType Url

dbTypes(Chat):
  type
    ChatUser* = ref object
      name*: string
      icon*: Option[Url]

    ChatServer* = ref object
      name*: string
      icon*: Option[Url]

    ChatChannel* = ref object
      serverId*: ChatServerId
      name*: string
      icon*: Option[Url]

    ChatMessage* = ref object
      authorId*: ChatUserId
      channelId*: ChatChannelId
      content*: string

    ChatRole* = ref object
      serverId*: ChatServerId
      name*: string
      icon*: Option[Url]

    ChatServerUser* = ref object
      userId*: ChatUserId
      serverId*: ChatServerId
      nickname*: string

    ChatUserRole* = ref object
      userId*: ChatUserId
      roleId*: ChatRoleId
