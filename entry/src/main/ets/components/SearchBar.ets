@Component
export struct SearchBar {
  placeholder: string = '搜索'
  onTextChange: (value: string) => void = () => {}

  build() {
    Row({ space: 8 }) {
      Text('🔍').fontSize(15)
      TextInput({ placeholder: this.placeholder })
        .layoutWeight(1)
        .backgroundColor(Color.Transparent)
        .fontSize(14)
        .placeholderColor('#999999')
        .onChange((value: string) => this.onTextChange(value))
    }
    .width('100%')
    .height(40)
    .padding({ left: 14, right: 14 })
    .backgroundColor('#F5F5F5')
    .borderRadius(20)
  }
}
