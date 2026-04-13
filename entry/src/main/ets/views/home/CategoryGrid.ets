import { CategoryItem } from '../../common/models/DataModels'

/**
 * @Prop 接收分类列表。
 * onCategoryClick 事件回调：子组件告知父组件"用户点了哪个分类"，
 * 由父组件决定后续行为（跳转或筛选），子组件不关心业务逻辑。
 */
@Component
export struct CategoryGrid {
  @Prop categories: CategoryItem[] = []
  onCategoryClick: (cat: CategoryItem) => void = () => {}

  build() {
    Grid() {
      ForEach(this.categories, (item: CategoryItem) => {
        GridItem() {
          Column({ space: 6 }) {
            Text(item.icon).fontSize(28)
            Text(item.name).fontSize(12).fontColor('#333333')
          }
          .width('100%').height(70)
          .justifyContent(FlexAlign.Center)
          .onClick(() => this.onCategoryClick(item))
        }
      })
    }
    .columnsTemplate('1fr 1fr 1fr 1fr')
    .rowsGap(4)
    .width('100%').height(152)
    .backgroundColor(Color.White)
    .borderRadius(12)
    .padding(8)
  }
}
