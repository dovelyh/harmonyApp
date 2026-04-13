import { MessageItem, NotificationItem } from '../models/DataModels'
import { MESSAGE_LIST, NOTIFICATION_LIST } from '../mock/MessageMock'
import { HttpUtil } from './HttpUtil'

export class MessageApi {
  static async getMessages(): Promise<MessageItem[]> {
    return HttpUtil.request<MessageItem[]>('/api/message/chats', MESSAGE_LIST)
  }

  static async getNotifications(): Promise<NotificationItem[]> {
    return HttpUtil.request<NotificationItem[]>('/api/message/notifications', NOTIFICATION_LIST)
  }
}
