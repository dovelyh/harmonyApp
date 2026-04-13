import { DiscoverItem } from '../common/models/DataModels'
import { DiscoverApi } from '../common/api/DiscoverApi'

/**
 * 发现详情页 —— 演示：
 * 1. router.getParams() 接收列表页传入的参数
 * 2. aboutToAppear 中根据 id 调用详情接口
 * 3. @Entry 独立路由页面
 */
@Entry
@Component
struct DiscoverDetailPage {
  @State articleId: number = 0
  @State title: string = ''
  @State detail: DiscoverItem | null = null
  @State loading: boolean = true

  aboutToAppear(): void {
    const params = this.getUIContext().getRouter().getParams() as Record<string, Object>
    if (params) {
      this.articleId = (params['id'] as number) || 0
      this.title = (params['title'] as string) || '详情'
    }
    this.loadDetail()
  }

  private async loadDetail(): Promise<void> {
    this.loading = true
    const result = await DiscoverApi.getDetail(this.articleId)
    if (result) {
      this.detail = result
    }
    this.loading = false
  }

  build() {
    Column() {
      Row({ space: 12 }) {
        Text('←').fontSize(22).fontColor('#1A1A1A')
          .width(36).height(36).textAlign(TextAlign.Center)
          .backgroundColor('#F5F5F5').borderRadius(18)
          .onClick(() => { this.getUIContext().getRouter().back() })
        Text('文章详情').fontSize(18).fontWeight(FontWeight.Bold).fontColor('#1A1A1A')
          .layoutWeight(1)
      }
      .width('100%').padding({ left: 16, right: 16, top: 12, bottom: 12 })

      if (this.detail !== null) {
        Scroll() {
          Column({ space: 16 }) {
            Text(this.detail.title)
              .fontSize(20).fontWeight(FontWeight.Bold).fontColor('#1A1A1A').width('100%')

            Row({ space: 8 }) {
              Text(this.detail.avatar).fontSize(20)
              Text(this.detail.author).fontSize(14).fontColor('#666666')
              Blank()
              Text(this.detail.time).fontSize(12).fontColor('#999999')
            }.width('100%')

            Text(this.detail.content)
              .fontSize(15).fontColor('#333333').lineHeight(26).width('100%')

            Text(this.detail.content + '\n\n（此处为模拟的完整文章内容，实际项目中详情接口会返回更多字段如富文本 HTML、图片列表等。）')
              .fontSize(15).fontColor('#333333').lineHeight(26).width('100%')

            Row({ space: 24 }) {
              Row({ space: 4 }) {
                Text('❤️').fontSize(16)
                Text(`${this.detail.likes}`).fontSize(14).fontColor('#666666')
              }
              Row({ space: 4 }) {
                Text('💬').fontSize(16)
                Text(`${this.detail.comments}`).fontSize(14).fontColor('#666666')
              }
              Row({ space: 4 }) {
                Text('⭐').fontSize(16)
                Text('收藏').fontSize(14).fontColor('#666666')
              }
            }
            .width('100%').padding({ top: 16 })
          }
          .padding({ left: 16, right: 16, bottom: 40 })
        }
        .scrollBar(BarState.Off).layoutWeight(1)
      }
    }
    .width('100%').height('100%')
    .backgroundColor('#FFFFFF')
  }
}
