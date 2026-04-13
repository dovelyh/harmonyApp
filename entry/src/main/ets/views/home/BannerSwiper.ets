import { BannerItem } from '../../common/models/DataModels'

/** @Prop 接收父组件传入的 banner 列表，单向只读 */
@Component
export struct BannerSwiper {
  @Prop banners: BannerItem[] = []

  build() {
    Swiper() {
      ForEach(this.banners, (item: BannerItem) => {
        Column({ space: 6 }) {
          Text(item.title).fontSize(22).fontWeight(FontWeight.Bold).fontColor(Color.White)
          Text(item.subtitle).fontSize(13).fontColor('rgba(255,255,255,0.85)')
        }
        .width('100%').height(150)
        .padding(20)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Start)
        .linearGradient({ angle: 135, colors: [[item.color, 0.0], ['rgba(0,0,0,0.15)', 1.0]] })
        .borderRadius(14)
      })
    }
    .autoPlay(true)
    .interval(4000)
    .indicator(Indicator.dot().color('rgba(255,255,255,0.4)').selectedColor(Color.White))
    .width('100%').height(150)
    .borderRadius(14)
  }
}
