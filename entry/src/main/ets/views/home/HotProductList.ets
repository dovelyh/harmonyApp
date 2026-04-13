import { ProductItem } from '../../common/models/DataModels'
import { ProductCard } from '../../components/ProductCard'

/**
 * 横向滚动商品列表。
 * @Prop 接收商品数据。
 * onItemClick 回调把点击的商品 id 抛给父组件，由父组件处理路由跳转。
 */
@Component
export struct HotProductList {
  @Prop products: ProductItem[] = []
  onItemClick: (item: ProductItem) => void = () => {}

  build() {
    List({ space: 10 }) {
      ForEach(this.products, (item: ProductItem) => {
        ListItem() {
          ProductCard({
            name: item.name,
            price: item.price,
            originalPrice: item.originalPrice,
            sales: item.sales,
            bgColor: item.color,
            tags: item.tags,
            onCardClick: () => this.onItemClick(item)
          })
        }
      })
    }
    .listDirection(Axis.Horizontal)
    .scrollBar(BarState.Off)
    .width('100%').height(185)
  }
}
