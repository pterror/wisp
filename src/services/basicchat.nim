import std/options, std/macros, ../types

stringType Url

dbTypes(Chat):
  type
    Entity* = ref object
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
      authorId*: EntityId
      channelId*: ChannelId
      content*: string

    Role* = ref object
      serverId*: ServerId
      name*: string
      icon*: Option[Url]

    ServerEntity* = ref object
      entityId*: EntityId
      serverId*: ServerId
      nickname*: string

    EntityRole* = ref object
      entityId*: EntityId
      roleId*: RoleId
