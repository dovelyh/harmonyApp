import { DiscoverItem } from '../../common/models/DataModels'
import { formatLikes } from '../../common/utils/CommonUtils'

const EMPTY_DISCOVER: DiscoverItem = { id: 0, title: '', content: '', author: '', avatar: '', likes: 0, comments: 0, time: '', category: '' }

@Component
export struct DiscoverCard {
  @Prop item: DiscoverItem = EMPTY_DISCOVER
  onCardClick: () => void = () => {}

  build() {
    Column({ space: 10 }) {
      Row({ space: 8 }) {
        Text(this.item.avatar).fontSize(20)
        Column({ space: 2 }) {
          Text(this.item.author).fontSize(13).fontColor('#1A1A1A').fontWeight(FontWeight.Medium)
          Text(this.item.time).fontSize(11).fontColor('#999999')
        }
        .alignItems(HorizontalAlign.Start).layoutWeight(1)
        Text(this.item.category).fontSize(10).fontColor('#FF6B35')
          .backgroundColor('#FFF3ED')
          .padding({ left: 8, right: 8, top: 3, bottom: 3 }).borderRadius(10)
      }
      .width('100%').alignItems(VerticalAlign.Center)

      Text(this.item.title).fontSize(16).fontWeight(FontWeight.Bold).fontColor('#1A1A1A').width('100%')

      Text(this.item.content).fontSize(13).fontColor('#666666').lineHeight(20)
        .maxLines(2).textOverflow({ overflow: TextOverflow.Ellipsis }).width('100%')

      Row() {
        Row({ space: 4 }) {
          Text('❤️').fontSize(13)
          Text(formatLikes(this.item.likes)).fontSize(12).fontColor('#999999')
        }
        Row({ space: 4 }) {
          Text('💬').fontSize(13)
          Text(`${this.item.comments}`).fontSize(12).fontColor('#999999')
        }.margin({ left: 20 })
        Blank()
        Text('📤').fontSize(13)
      }
      .width('100%').alignItems(VerticalAlign.Center)
    }
    .width('100%').padding(16)
    .backgroundColor(Color.White).borderRadius(12)
    .margin({ bottom: 10 })
    .shadow({ radius: 4, color: 'rgba(0,0,0,0.04)', offsetX: 0, offsetY: 2 })
    .onClick(() => this.onCardClick())
  }
}
