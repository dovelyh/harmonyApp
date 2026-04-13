import { router } from '@kit.ArkUI';

interface BannerItem {
  title: string
  desc: string
  color: string
}

@Styles
function componentCard() {
  .width('100%')
  .padding(16)
  .backgroundColor(Color.White)
  .borderRadius(18)
  .margin({ bottom: 12 })
  .shadow({ radius: 10, color: 'rgba(15, 23, 42, 0.08)', offsetX: 0, offsetY: 4 })
}

@Entry
@Component
struct ComponentsPage {
  @State noteText: string = '这里演示 TextArea 的多行输入。'
  @State selectedBanner: number = 0
  @State loadingVisible: boolean = true

  private banners: BannerItem[] = [
    { title: '组件组合', desc: '把多个基础控件组合成更像业务页的模块。', color: '#dbeafe' },
    { title: '加载反馈', desc: 'LoadingProgress 经常和列表、卡片一起出现。', color: '#dcfce7' },
    { title: '轮播信息', desc: 'Swiper 很适合用于首页推荐区和运营区。', color: '#fef3c7' }
  ]

  @Builder
  PageHeader() {
    Column({ space: 12 }) {
      Button('返回首页')
        .fontSize(13)
        .fontColor('#5b6ee1')
        .backgroundColor('#eef1ff')
        .onClick(() => {
          router.back();
        })

      Text('高频组件馆')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor('#0f172a')

      Text('补上首页基础实验区里没有展开的高频组件，让你看到更贴近日常业务组合的写法。')
        .fontSize(13)
        .fontColor('#64748b')
        .lineHeight(20)
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }

  build() {
    Scroll() {
      Column() {
        this.PageHeader()

        Column({ space: 12 }) {
          Text('1. Image：图片资源加载')
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .fontColor('#0f172a')

          Text('Image 常用于头像、商品图、图标区块，最常见的数据源是本地资源和网络地址。')
            .fontSize(13)
            .fontColor('#475569')

          Row({ space: 12 }) {
            Image($r('app.media.foreground'))
              .width(72)
              .height(72)
              .borderRadius(18)

            Column({ space: 6 }) {
              Text('本地资源示例')
                .fontSize(15)
                .fontWeight(FontWeight.Bold)
                .fontColor('#0f172a')
              Text('这里直接读取了 `resources/base/media/foreground.png`。')
                .fontSize(13)
                .fontColor('#64748b')
                .lineHeight(20)
            }
            .alignItems(HorizontalAlign.Start)
            .layoutWeight(1)
          }
          .width('100%')
        }
        .componentCard()

        Column({ space: 12 }) {
          Text('2. TextArea：多行输入')
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .fontColor('#0f172a')

          TextArea({ placeholder: '请输入你今天学到的 ArkTS 知识点', text: this.noteText })
            .onChange((value: string) => {
              this.noteText = value;
            })
            .backgroundColor('#f8fafc')
            .borderRadius(14)
            .height(110)

          Text(`当前字数：${this.noteText.length}`)
            .fontSize(12)
            .fontColor('#64748b')
        }
        .componentCard()

        Column({ space: 12 }) {
          Text('3. Swiper：轮播推荐区')
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .fontColor('#0f172a')

          Swiper() {
            ForEach(this.banners, (item: BannerItem, index: number) => {
              Column({ space: 8 }) {
                Text(item.title)
                  .fontSize(18)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#0f172a')
                Text(item.desc)
                  .fontSize(13)
                  .fontColor('#475569')
                  .lineHeight(20)
                Text(`第 ${index + 1} 张轮播卡片`)
                  .fontSize(12)
                  .fontColor('#64748b')
              }
              .width('100%')
              .height(150)
              .padding(18)
              .alignItems(HorizontalAlign.Start)
              .justifyContent(FlexAlign.Center)
              .backgroundColor(item.color)
              .borderRadius(18)
            })
          }
          .height(150)
          .indicator(true)
          .autoPlay(false)
          .onChange((index: number) => {
            this.selectedBanner = index;
          })

          Text(`当前轮播索引：${this.selectedBanner}`)
            .fontSize(12)
            .fontColor('#64748b')
        }
        .componentCard()

        Column({ space: 12 }) {
          Text('4. LoadingProgress：加载反馈')
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .fontColor('#0f172a')

          Text('当页面请求数据、切换 tab、等待提交时，应该及时给用户可视化反馈。')
            .fontSize(13)
            .fontColor('#475569')

          if (this.loadingVisible) {
            Column({ space: 10 }) {
              LoadingProgress()
                .color('#2563eb')
                .width(36)
                .height(36)
              Text('模拟加载中...')
                .fontSize(13)
                .fontColor('#64748b')
            }
            .width('100%')
            .padding(20)
            .backgroundColor('#eff6ff')
            .borderRadius(14)
          } else {
            Column({ space: 8 }) {
              Text('加载完成')
                .fontSize(15)
                .fontWeight(FontWeight.Bold)
                .fontColor('#0f172a')
              Text('这里可以替换成列表、卡片或详情内容。')
                .fontSize(13)
                .fontColor('#64748b')
            }
            .width('100%')
            .padding(18)
            .backgroundColor('#ecfdf3')
            .borderRadius(14)
            .alignItems(HorizontalAlign.Start)
          }

          Button(this.loadingVisible ? '切换为加载完成' : '重新显示加载态')
            .width('100%')
            .backgroundColor('#0f766e')
            .fontColor(Color.White)
            .onClick(() => {
              this.loadingVisible = !this.loadingVisible;
            })
        }
        .componentCard()
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 20, bottom: 32 })
    }
    .scrollBar(BarState.Off)
    .backgroundColor('#f1f5f9')
  }
}
