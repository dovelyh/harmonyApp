/**
 * 分类筛选标签栏。
 * @Link activeCategory：与父组件双向绑定，
 * 点击标签后直接修改 @Link 变量，父组件的 @State 同步更新，
 * 进而触发列表数据重新过滤。
 */
@Component
export struct CategoryFilter {
  categories: string[] = []
  @Link activeCategory: string

  build() {
    Scroll() {
      Row({ space: 8 }) {
        ForEach(this.categories, (cat: string) => {
          Text(cat)
            .fontSize(13)
            .fontColor(this.activeCategory === cat ? Color.White : '#666666')
            .backgroundColor(this.activeCategory === cat ? '#FF6B35' : '#F0F0F0')
            .padding({ left: 14, right: 14, top: 7, bottom: 7 })
            .borderRadius(18)
            .onClick(() => { this.activeCategory = cat })
        })
      }
    }
    .scrollable(ScrollDirection.Horizontal)
    .scrollBar(BarState.Off)
    .width('100%')
    .margin({ bottom: 12 })
  }
}
