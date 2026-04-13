@Component
export struct ProductCard {
  name: string = ''
  price: number = 0
  originalPrice: number = 0
  sales: number = 0
  bgColor: string = '#FFE4D6'
  tags: string[] = []
  onCardClick: () => void = () => {}

  build() {
    Column() {
      Stack({ alignContent: Alignment.TopStart }) {
        Column()
          .width('100%')
          .height(90)
          .backgroundColor(this.bgColor)
          .borderRadius({ topLeft: 10, topRight: 10 })
        if (this.tags.length > 0) {
          Text(this.tags[0])
            .fontSize(10)
            .fontColor(Color.White)
            .backgroundColor('rgba(255,107,53,0.85)')
            .padding({ left: 6, right: 6, top: 2, bottom: 2 })
            .borderRadius({ topLeft: 10, bottomRight: 8 })
        }
      }

      Column({ space: 4 }) {
        Text(this.name)
          .fontSize(13)
          .fontColor('#1A1A1A')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .width('100%')
        Row({ space: 4 }) {
          Text(`¥${this.price}`)
            .fontSize(15)
            .fontColor('#FF6B35')
            .fontWeight(FontWeight.Bold)
          if (this.originalPrice > this.price) {
            Text(`¥${this.originalPrice}`)
              .fontSize(10)
              .fontColor('#CCCCCC')
              .decoration({ type: TextDecorationType.LineThrough })
          }
        }
        .width('100%')
        Text(`${this.sales}人付款`)
          .fontSize(10)
          .fontColor('#999999')
          .width('100%')
      }
      .padding({ left: 8, right: 8, top: 6, bottom: 8 })
      .alignItems(HorizontalAlign.Start)
    }
    .width(140)
    .backgroundColor(Color.White)
    .borderRadius(10)
    .shadow({ radius: 4, color: 'rgba(0,0,0,0.06)', offsetX: 0, offsetY: 2 })
    .onClick(() => this.onCardClick())
  }
}
