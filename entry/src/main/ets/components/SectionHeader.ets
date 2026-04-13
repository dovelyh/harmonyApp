@Component
export struct SectionHeader {
  title: string = ''
  showMore: boolean = true
  onMoreClick: () => void = () => {}

  build() {
    Row() {
      Text(this.title)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1A1A1A')
      Blank()
      if (this.showMore) {
        Row({ space: 2 }) {
          Text('查看更多').fontSize(13).fontColor('#999999')
          Text('>').fontSize(13).fontColor('#999999')
        }
        .onClick(() => this.onMoreClick())
      }
    }
    .width('100%')
    .padding({ top: 18, bottom: 12 })
  }
}
