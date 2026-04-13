import { MessageItem } from '../../common/models/DataModels'

const EMPTY_MSG: MessageItem = { id: 0, name: '', avatar: '', lastMessage: '', time: '', unread: 0 }

@Component
export struct ChatItem {
  @Prop item: MessageItem = EMPTY_MSG

  build() {
    Row({ space: 12 }) {
      Stack() {
        Text(this.item.avatar)
          .fontSize(24).width(46).height(46)
          .textAlign(TextAlign.Center)
          .backgroundColor('#F5F5F5').borderRadius(23)
        if (this.item.unread > 0) {
          Text(`${this.item.unread}`)
            .fontSize(10).fontColor(Color.White)
            .backgroundColor('#FF4D4F')
            .width(18).height(18)
            .textAlign(TextAlign.Center).borderRadius(9)
            .position({ x: 30, y: 0 })
        }
      }.width(46).height(46)

      Column({ space: 4 }) {
        Row() {
          Text(this.item.name).fontSize(15).fontColor('#1A1A1A')
            .fontWeight(FontWeight.Medium).layoutWeight(1)
          Text(this.item.time).fontSize(11).fontColor('#CCCCCC')
        }.width('100%')
        Text(this.item.lastMessage).fontSize(13).fontColor('#999999')
          .maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis }).width('100%')
      }.layoutWeight(1)
    }
    .width('100%').padding({ left: 16, right: 16, top: 12, bottom: 12 })
  }
}
