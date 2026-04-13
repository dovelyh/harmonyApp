import { MessageItem, NotificationItem } from '../common/models/DataModels'
import { MessageApi } from '../common/api/MessageApi'
import { ChatItem } from '../views/message/ChatItem'
import { NotifyItem } from '../views/message/NotifyItem'

@Component
export struct MessagePage {
  @State unreadCount: number = 0
  @State msgTab: number = 0
  @State messages: MessageItem[] = []
  @State notifications: NotificationItem[] = []

  aboutToAppear(): void {
    this.loadData()
  }

  private async loadData(): Promise<void> {
    this.messages = await MessageApi.getMessages()
    this.notifications = await MessageApi.getNotifications()
    this.unreadCount = this.messages.reduce((s: number, m: MessageItem) => s + m.unread, 0)
  }

  @Builder MsgTabLabel(idx: number, label: string) {
    Text(label).fontSize(15)
      .fontWeight(this.msgTab === idx ? FontWeight.Bold : FontWeight.Normal)
      .fontColor(this.msgTab === idx ? '#FF6B35' : '#666666')
      .padding({ top: 8, bottom: 8 })
  }
  @Builder TabChat() { this.MsgTabLabel(0, '聊天') }
  @Builder TabNotify() { this.MsgTabLabel(1, '通知') }

  build() {
    Column() {
      Row() {
        Text('消息').fontSize(22).fontWeight(FontWeight.Bold).fontColor('#1A1A1A')
        Blank()
        if (this.unreadCount > 0) {
          Text(`${this.unreadCount} 条未读`).fontSize(12).fontColor('#FF6B35')
            .backgroundColor('#FFF3ED')
            .padding({ left: 8, right: 8, top: 3, bottom: 3 }).borderRadius(10)
        }
      }
      .width('100%').padding({ left: 16, right: 16, top: 12, bottom: 8 })

      Tabs({ index: this.msgTab }) {
        TabContent() {
          List() {
            ForEach(this.messages, (item: MessageItem) => {
              ListItem() { ChatItem({ item: item }) }
            })
          }
          .divider({ strokeWidth: 0.5, color: '#F5F5F5', startMargin: 74 })
          .scrollBar(BarState.Off)
          .backgroundColor(Color.White).borderRadius(12)
          .margin({ left: 16, right: 16 })
        }.tabBar(this.TabChat)

        TabContent() {
          List() {
            ForEach(this.notifications, (item: NotificationItem) => {
              ListItem() { NotifyItem({ item: item }) }
            })
          }
          .divider({ strokeWidth: 0.5, color: '#F5F5F5', startMargin: 68 })
          .scrollBar(BarState.Off)
          .backgroundColor(Color.White).borderRadius(12)
          .margin({ left: 16, right: 16 })
        }.tabBar(this.TabNotify)
      }
      .barMode(BarMode.Fixed)
      .barBackgroundColor(Color.Transparent)
      .onChange((i: number) => { this.msgTab = i })
      .layoutWeight(1)
    }
    .width('100%').height('100%')
    .backgroundColor('#F5F6FA')
  }
}
