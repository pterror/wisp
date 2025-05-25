import std/json, std/macros, std/options
import types

stringType Url

dbTypes(Chat):
  type
    User* = ref object
      name*: string
      icon*: Option[Url]

    Server* = ref object
      name*: string
      icon*: Option[Url]

    Channel* = ref object
      serverId*: ServerId
      name*: string
      icon*: Option[Url]

    Message* = ref object
      authorId*: UserId
      channelId*: ChannelId
      content*: string

    Role* = ref object
      serverId*: ServerId
      name*: string
      icon*: Option[Url]

    ServerUser* = ref object
      userId*: UserId
      serverId*: ServerId
      nickname*: string

    UserRole* = ref object
      userId*: UserId
      roleId*: RoleId
