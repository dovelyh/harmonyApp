import { SettingGroup, SettingItem } from '../../common/models/DataModels'

/**
 * 设置分组。
 * @Link darkMode：与父组件 MinePage 双向绑定。
 * 用户在子组件中切换 Toggle，@Link 的值直接同步回父组件的 @State，
 * 不需要事件回调，这就是 @Link 双向绑定的核心用法。
 */
@Component
export struct SettingSection {
  @Prop group: SettingGroup = { title: '', items: [] }
  @Link darkMode: boolean

  build() {
    Column() {
      Text(this.group.title).fontSize(13).fontColor('#999999').width('100%').margin({ bottom: 8 })

      Column() {
        ForEach(this.group.items, (item: SettingItem, idx: number) => {
          Row() {
            Text(item.icon).fontSize(18).width(28)
            Text(item.title).fontSize(15).fontColor('#1A1A1A').layoutWeight(1)

            if (item.title === '深色模式') {
              Toggle({ type: ToggleType.Switch, isOn: this.darkMode })
                .onChange((value: boolean) => { this.darkMode = value })
                .selectedColor('#FF6B35')
            } else {
              if (item.value.length > 0) {
                Text(item.value).fontSize(13).fontColor('#CCCCCC').margin({ right: 4 })
              }
              if (item.hasArrow) {
                Text('›').fontSize(18).fontColor('#CCCCCC')
              }
            }
          }
          .width('100%').height(50).alignItems(VerticalAlign.Center)
          .padding({ left: 12, right: 12 })

          if (idx < this.group.items.length - 1) {
            Divider().color('#F5F5F5').margin({ left: 40 })
          }
        })
      }
      .backgroundColor(Color.White).borderRadius(12)
    }
    .width('100%').padding({ left: 16, right: 16 }).margin({ top: 16 })
  }
}
