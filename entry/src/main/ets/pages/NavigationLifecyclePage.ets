import { router } from '@kit.ArkUI';

interface RouteLogItem {
  id: number
  text: string
}

@Styles
function navCard() {
  .width('100%')
  .padding(16)
  .backgroundColor(Color.White)
  .borderRadius(18)
  .margin({ bottom: 12 })
  .shadow({ radius: 10, color: 'rgba(15, 23, 42, 0.08)', offsetX: 0, offsetY: 4 })
}

@Entry
@Component
struct NavigationLifecyclePage {
  @State sourceText: string = '未携带来源参数'
  @State routeLogs: RouteLogItem[] = []

  private logSeed: number = 1

  /**
   * aboutToAppear 是 ArkUI 组件生命周期中最常见的页面初始化入口。
   * 页面第一次显示时，通常会在这里读取参数、拉取数据、初始化状态。
   */
  aboutToAppear(): void {
    const params = router.getParams() as Record<string, string>;
    this.sourceText = params && params.source ? `来源：${params.source}` : '来源：默认进入';
    this.addLog('aboutToAppear 已触发');
  }

  /**
   * aboutToDisappear 在页面即将离开时触发。
   * 真实项目里可用于埋点、清理定时器、释放资源。
   */
  aboutToDisappear(): void {
    this.addLog('aboutToDisappear 已触发');
  }

  private addLog(text: string): void {
    this.routeLogs = [
      {
        id: this.logSeed++,
        text: `${this.logSeed}. ${text}`
      },
      ...this.routeLogs
    ];
  }

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

      Text('页面导航与生命周期')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor('#0f172a')

      Text('这里聚焦 router 跳转、参数读取、返回行为，以及页面常见生命周期的理解方式。')
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

        Column({ space: 10 }) {
          Text('1. 当前路由参数')
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .fontColor('#0f172a')

          Text(this.sourceText)
            .fontSize(14)
            .fontColor('#1d4ed8')
            .backgroundColor('#eff6ff')
            .padding(12)
            .borderRadius(12)

          Text('通过 `router.getParams()` 可以读取上一个页面 push 时携带的参数。')
            .fontSize(13)
            .fontColor('#64748b')
        }
        .navCard()

        Column({ space: 12 }) {
          Text('2. 常见跳转动作')
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .fontColor('#0f172a')

          Button('跳转到资讯案例，并携带来源参数')
            .width('100%')
            .backgroundColor('#2563eb')
            .fontColor(Color.White)
            .onClick(() => {
              this.addLog('执行 router.pushUrl -> NewsCasePage');
              router.pushUrl({
                url: 'pages/NewsCasePage',
                params: { source: 'navigation-page' }
              });
            })

          Button('重新打开本页，观察参数变化')
            .width('100%')
            .backgroundColor('#7c3aed')
            .fontColor(Color.White)
            .onClick(() => {
              this.addLog('再次 push 当前页面');
              router.pushUrl({
                url: 'pages/NavigationLifecyclePage',
                params: { source: 'self-router-push' }
              });
            })
        }
        .navCard()

        Column({ space: 12 }) {
          Text('3. 生命周期日志')
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .fontColor('#0f172a')

          Text('页面初始化、离开、再次进入时，日志会帮助你确认生命周期发生顺序。')
            .fontSize(13)
            .fontColor('#64748b')

          Column({ space: 8 }) {
            ForEach(this.routeLogs, (item: RouteLogItem) => {
              Text(item.text)
                .width('100%')
                .fontSize(13)
                .fontColor('#334155')
                .padding(12)
                .backgroundColor('#f8fafc')
                .borderRadius(12)
            })
          }
        }
        .navCard()
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 20, bottom: 32 })
    }
    .scrollBar(BarState.Off)
    .backgroundColor('#f1f5f9')
  }
}
