@Component
export struct EmptyState {
  icon: string = '📭'
  message: string = '暂无数据'

  build() {
    Column({ space: 12 }) {
      Text(this.icon).fontSize(48)
      Text(this.message).fontSize(14).fontColor('#999999')
    }
    .width('100%')
    .padding({ top: 80, bottom: 80 })
    .justifyContent(FlexAlign.Center)
  }
}
