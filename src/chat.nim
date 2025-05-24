import debby/sqlite

type
  Url* = string
  ChatUserId* = string
  ChatMessageId* = string
  ChatChannelId* = string
  ChatServerId* = string
  ChatRoleId* = string

  ChatUser* = ref object
    userId: ChatUserId
    roleIds: seq[ChatRoleId]
    name: string
    icon: Url

  ChatServerUser* = ref object
    userId: ChatUserId
    nickname: string

  ChatMessage* = ref object
    messageId: ChatMessageId
    authorId: ChatUserId
    channelId: ChatChannelId
    content: string

  ChatChannel* = ref object
    channelId: ChatChannelId
    serverId: ChatServerId
    name: string
    icon: Url

  ChatServer* = ref object
    serverId: ChatServerId
    name: string
    icon: Url

  ChatRole* = ref object
    roleId: ChatRoleId
    name: string
    icon: Url
