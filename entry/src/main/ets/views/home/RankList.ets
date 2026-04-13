import { ProductItem } from '../../common/models/DataModels'

@Component
export struct RankList {
  @Prop products: ProductItem[] = []
  onItemClick: (item: ProductItem) => void = () => {}

  build() {
    Column() {
      ForEach(this.products.slice(0, 5), (item: ProductItem, idx: number) => {
        Row({ space: 12 }) {
          Text(`${idx + 1}`)
            .fontSize(16).fontWeight(FontWeight.Bold)
            .fontColor(idx < 3 ? '#FF6B35' : '#999999')
            .width(24).textAlign(TextAlign.Center)

          Column().width(50).height(50).backgroundColor(item.color).borderRadius(8)

          Column({ space: 3 }) {
            Text(item.name).fontSize(14).fontColor('#1A1A1A')
              .maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis })
            Text(`${item.sales}人付款 · 好评${item.rating}`)
              .fontSize(11).fontColor('#999999')
          }
          .alignItems(HorizontalAlign.Start).layoutWeight(1)

          Text(`¥${item.price}`).fontSize(15).fontColor('#FF6B35').fontWeight(FontWeight.Bold)
        }
        .width('100%').padding(12)
        .backgroundColor(Color.White).borderRadius(10)
        .margin({ bottom: 8 })
        .onClick(() => this.onItemClick(item))
      })
    }
  }
}
