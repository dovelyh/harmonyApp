import { ActivityItem } from '../../common/models/DataModels'

@Component
export struct ActivitySection {
  @Prop activities: ActivityItem[] = []

  build() {
    Column() {
      ForEach(this.activities, (item: ActivityItem) => {
        Row() {
          Column({ space: 4 }) {
            Text(item.title).fontSize(16).fontWeight(FontWeight.Bold).fontColor(Color.White)
            Text(item.description).fontSize(12).fontColor('rgba(255,255,255,0.8)')
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)

          Text(item.tag)
            .fontSize(11).fontColor(Color.White)
            .backgroundColor('rgba(255,255,255,0.25)')
            .padding({ left: 10, right: 10, top: 4, bottom: 4 })
            .borderRadius(12)
        }
        .width('100%').padding(16)
        .backgroundColor(item.color)
        .borderRadius(12)
        .alignItems(VerticalAlign.Center)
        .margin({ bottom: 10 })
      })
    }
  }
}
