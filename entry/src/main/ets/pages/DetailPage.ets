import { HomeApi } from '../common/api/HomeApi'

@Entry
@Component
struct DetailPage {
  @State title: string = '详情'
  @State price: number = 0
  @State color: string = '#FFE4D6'
  @State productId: number = 0
  @State detailContent: string = ''
  @State detailRules: string = ''
  @State detailTips: string = ''
  @State cartCount: number = 0

  aboutToAppear(): void {
    const params = this.getUIContext().getRouter().getParams() as Record<string, Object>
    if (params) {
      this.title = (params['name'] as string) || '详情'
      this.price = (params['price'] as number) || 0
      this.color = (params['color'] as string) || '#FFE4D6'
      this.productId = (params['id'] as number) || 0
    }
    this.loadDetail()
  }

  private async loadDetail(): Promise<void> {
    const data = await HomeApi.getProductDetail(this.productId)
    this.detailContent = data.content
    this.detailRules = data.rules
    this.detailTips = data.tips
  }

  build() {
    Column() {
      Row({ space: 12 }) {
        Text('←').fontSize(22).fontColor('#1A1A1A')
          .width(36).height(36).textAlign(TextAlign.Center)
          .backgroundColor('#F5F5F5').borderRadius(18)
          .onClick(() => { this.getUIContext().getRouter().back() })
        Text(this.title).fontSize(18).fontWeight(FontWeight.Bold).fontColor('#1A1A1A')
          .layoutWeight(1).maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis })
        Text('📤').fontSize(18).width(36).height(36).textAlign(TextAlign.Center)
      }
      .width('100%').padding({ left: 16, right: 16, top: 12, bottom: 12 })

      Scroll() {
        Column({ space: 16 }) {
          Column().width('100%').height(220).backgroundColor(this.color).borderRadius(16)

          Column({ space: 8 }) {
            Text(this.title).fontSize(20).fontWeight(FontWeight.Bold).fontColor('#1A1A1A').width('100%')
            Row({ space: 6 }) {
              Text(`¥${this.price}`).fontSize(24).fontColor('#FF6B35').fontWeight(FontWeight.Bold)
              Text('门市价 ¥328').fontSize(13).fontColor('#CCCCCC')
                .decoration({ type: TextDecorationType.LineThrough })
            }.width('100%')
            Row({ space: 8 }) {
              Text('好评 98%').fontSize(11).fontColor('#52C41A')
                .backgroundColor('#F0FFF0').padding({ left: 8, right: 8, top: 3, bottom: 3 }).borderRadius(4)
              Text('销量 2000+').fontSize(11).fontColor('#FF6B35')
                .backgroundColor('#FFF3ED').padding({ left: 8, right: 8, top: 3, bottom: 3 }).borderRadius(4)
            }
          }
          .width('100%').padding(16).backgroundColor(Color.White).borderRadius(12)

          Column({ space: 10 }) {
            Text('商品详情').fontSize(16).fontWeight(FontWeight.Bold).fontColor('#1A1A1A').width('100%')
            Text(this.detailContent).fontSize(14).fontColor('#666666').lineHeight(22).width('100%')
            Text(`【使用规则】\n${this.detailRules}`).fontSize(13).fontColor('#666666').lineHeight(22).width('100%')
            Text(`【温馨提示】\n${this.detailTips}`).fontSize(13).fontColor('#999999').lineHeight(22).width('100%')
          }
          .width('100%').padding(16).backgroundColor(Color.White).borderRadius(12)
        }
        .padding({ left: 16, right: 16, bottom: 100 })
      }
      .scrollBar(BarState.Off).layoutWeight(1)

      Row({ space: 12 }) {
        Column({ space: 2 }) {
          Text('🏠').fontSize(18)
          Text('首页').fontSize(10).fontColor('#999999')
        }.width(56).onClick(() => { this.getUIContext().getRouter().back() })

        Column({ space: 2 }) {
          Stack() {
            Text('🛒').fontSize(18)
            if (this.cartCount > 0) {
              Text(`${this.cartCount}`).fontSize(9).fontColor(Color.White)
                .backgroundColor('#FF4D4F').width(16).height(16)
                .textAlign(TextAlign.Center).borderRadius(8)
                .position({ x: 14, y: -6 })
            }
          }
          Text('购物车').fontSize(10).fontColor('#999999')
        }.width(56)

        Button('加入购物车')
          .layoutWeight(1).height(44)
          .backgroundColor('#FF6B35').fontColor(Color.White)
          .fontSize(16).fontWeight(FontWeight.Bold).borderRadius(22)
          .onClick(() => { this.cartCount++ })
      }
      .width('100%').padding({ left: 16, right: 16, top: 10, bottom: 10 })
      .backgroundColor(Color.White)
      .shadow({ radius: 8, color: 'rgba(0,0,0,0.08)', offsetX: 0, offsetY: -2 })
    }
    .width('100%').height('100%').backgroundColor('#F5F6FA')
  }
}
