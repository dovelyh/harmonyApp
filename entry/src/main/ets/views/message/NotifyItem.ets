import { NotificationItem } from '../../common/models/DataModels'

const EMPTY_NOTIFY: NotificationItem = { id: 0, title: '', content: '', time: '', read: true, type: 'system' }

@Component
export struct NotifyItem {
  @Prop item: NotificationItem = EMPTY_NOTIFY

  build() {
    Row({ space: 12 }) {
      Text(this.item.type === 'order' ? '📦' : this.item.type === 'activity' ? '🎉' : '🔔')
        .fontSize(20).width(40).height(40)
        .textAlign(TextAlign.Center)
        .backgroundColor(this.item.read ? '#F5F5F5' : '#FFF3ED')
        .borderRadius(20)

      Column({ space: 3 }) {
        Row() {
          Text(this.item.title).fontSize(14)
            .fontColor(this.item.read ? '#999999' : '#1A1A1A')
            .fontWeight(this.item.read ? FontWeight.Normal : FontWeight.Medium)
            .layoutWeight(1)
          Text(this.item.time).fontSize(11).fontColor('#CCCCCC')
        }.width('100%')
        Text(this.item.content).fontSize(12).fontColor('#999999')
          .maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis }).width('100%')
      }.layoutWeight(1)
    }
    .width('100%').padding({ left: 16, right: 16, top: 12, bottom: 12 })
  }
}
