import { QuickEntry } from '../../common/models/DataModels'

@Component
export struct QuickEntryGrid {
  @Prop entries: QuickEntry[] = []

  build() {
    Row() {
      ForEach(this.entries, (item: QuickEntry) => {
        Column({ space: 6 }) {
          Text(`${item.count}`).fontSize(18).fontWeight(FontWeight.Bold).fontColor('#1A1A1A')
          Text(item.label).fontSize(12).fontColor('#666666')
        }
        .layoutWeight(1).justifyContent(FlexAlign.Center)
      })
    }
    .width('100%')
    .padding({ top: 18, bottom: 18 })
    .backgroundColor(Color.White).borderRadius(12)
    .margin({ left: 16, right: 16, top: -16 })
    .shadow({ radius: 8, color: 'rgba(0,0,0,0.06)', offsetX: 0, offsetY: 2 })
  }
}
