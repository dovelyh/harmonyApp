import { router } from '@kit.ArkUI';

/**
 * 子组件 1：
 * 用 @Prop 接收父组件的数据。
 * 这是“父传子”的基础形式，适合展示型、只读型的组件。
 */
@Component
struct PropDisplayCard {
  @Prop title: string = ''
  @Prop desc: string = ''

  build() {
    Column({ space: 6 }) {
      Text(this.title)
        .fontSize(15)
        .fontWeight(FontWeight.Bold)
        .fontColor('#0f172a')
      Text(this.desc)
        .fontSize(13)
        .fontColor('#64748b')
        .lineHeight(20)
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
    .padding(14)
    .backgroundColor('#f8fafc')
    .borderRadius(12)
  }
}

/**
 * 子组件 2：
 * 用 @Link 接收父组件的响应式状态，实现双向联动。
 */
@Component
struct LinkCounterCard {
  @Link score: number

  build() {
    Column({ space: 10 }) {
      Text(`子组件中的 score：${this.score}`)
        .fontSize(14)
        .fontColor('#0f172a')

      Row({ space: 10 }) {
        Button('+5')
          .backgroundColor('#2563eb')
          .fontColor(Color.White)
          .onClick(() => {
            this.score += 5;
          })

        Button('-5')
          .backgroundColor('#f97316')
          .fontColor(Color.White)
          .onClick(() => {
            this.score -= 5;
          })
      }
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
    .padding(14)
    .backgroundColor('#eff6ff')
    .borderRadius(12)
  }
}

/**
 * 子组件 3：
 * 用 @Consume 消费祖先组件通过 @Provide 提供的数据。
 */
@Component
struct ThemePreviewCard {
  @Consume('themeName') themeName: string
  @Consume('themeColor') themeColor: string

  build() {
    Column({ space: 8 }) {
      Text('跨层共享预览')
        .fontSize(15)
        .fontWeight(FontWeight.Bold)
        .fontColor('#0f172a')

      Text(`当前主题：${this.themeName}`)
        .fontSize(13)
        .fontColor('#475569')

      Text('这个子组件没有接收 props，但仍然拿到了祖先组件提供的主题信息。')
        .fontSize(12)
        .fontColor('#64748b')
        .lineHeight(18)
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
    .padding(14)
    .backgroundColor(this.themeColor)
    .borderRadius(14)
  }
}

@Styles
function stateCard() {
  .width('100%')
  .padding(16)
  .backgroundColor(Color.White)
  .borderRadius(18)
  .margin({ bottom: 12 })
  .shadow({ radius: 10, color: 'rgba(15, 23, 42, 0.08)', offsetX: 0, offsetY: 4 })
}

@Entry
@Component
struct StateManagementPage {
  /**
   * @Provide 把祖先组件中的值提供给后代。
   * 这里用主题名称和颜色来演示跨层共享。
   */
  @Provide('themeName') providedThemeName: string = '蓝色学习主题'
  @Provide('themeColor') providedThemeColor: string = '#dbeafe'

  /**
   * @Watch 会在被监听状态变化时，自动执行指定方法。
   * 适合做日志记录、二次计算、埋点等副作用。
   */
  @State @Watch('onScoreChanged') linkedScore: number = 80
  @State watchLog: string = '等待 score 变化...'
  @State localTitle: string = '状态管理核心装饰器'

  private onScoreChanged(): void {
    this.watchLog = `score 已变化为 ${this.linkedScore}`;
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

      Text('状态管理馆')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor('#0f172a')

      Text('把日常鸿蒙开发里最重要的装饰器通信方式放进一个页面，直接观察数据如何驱动 UI。')
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
          Text('1. @State：组件内部状态')
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .fontColor('#0f172a')

          Text('linkedScore 就是当前页面自己的响应式状态，父组件修改它后，依赖它的 Text、子组件都会刷新。')
            .fontSize(13)
            .fontColor('#475569')
            .lineHeight(20)

          Row({ space: 10 }) {
            Button('父组件 +10')
              .layoutWeight(1)
              .backgroundColor('#2563eb')
              .fontColor(Color.White)
              .onClick(() => {
                this.linkedScore += 10;
              })

            Button('父组件 -10')
              .layoutWeight(1)
              .backgroundColor('#f97316')
              .fontColor(Color.White)
              .onClick(() => {
                this.linkedScore -= 10;
              })
          }
          .width('100%')

          Text(`父组件中的 score：${this.linkedScore}`)
            .fontSize(14)
            .fontColor('#0f172a')
        }
        .stateCard()

        Column({ space: 12 }) {
          Text('2. @Prop：父传子的只读展示')
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .fontColor('#0f172a')

          Text('Prop 更适合“父组件把数据喂给子组件展示”的场景。')
            .fontSize(13)
            .fontColor('#475569')

          PropDisplayCard({
            title: this.localTitle,
            desc: '这个子组件通过 @Prop 接收标题和说明，保持展示逻辑简单清晰。'
          })

          Button('修改父组件标题')
            .width('100%')
            .backgroundColor('#7c3aed')
            .fontColor(Color.White)
            .onClick(() => {
              this.localTitle = '状态管理要点已经更新';
            })
        }
        .stateCard()

        Column({ space: 12 }) {
          Text('3. @Link：父子双向联动')
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .fontColor('#0f172a')

          Text('下面的子组件通过 @Link 直接修改父组件的 linkedScore。')
            .fontSize(13)
            .fontColor('#475569')

          LinkCounterCard({ score: $linkedScore })
        }
        .stateCard()

        Column({ space: 12 }) {
          Text('4. @Provide / @Consume：跨层共享')
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .fontColor('#0f172a')

          Text('当数据要跨越多层组件传递时，比一层层传 props 更方便。')
            .fontSize(13)
            .fontColor('#475569')

          Row({ space: 10 }) {
            Button('切换为蓝色主题')
              .layoutWeight(1)
              .backgroundColor('#2563eb')
              .fontColor(Color.White)
              .onClick(() => {
                this.providedThemeName = '蓝色学习主题';
                this.providedThemeColor = '#dbeafe';
              })

            Button('切换为绿色主题')
              .layoutWeight(1)
              .backgroundColor('#16a34a')
              .fontColor(Color.White)
              .onClick(() => {
                this.providedThemeName = '绿色专注主题';
                this.providedThemeColor = '#dcfce7';
              })
          }
          .width('100%')

          ThemePreviewCard()
        }
        .stateCard()

        Column({ space: 12 }) {
          Text('5. @Watch：监听状态变化')
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .fontColor('#0f172a')

          Text('watch 非常适合把“数据变化后要做的额外动作”集中起来。')
            .fontSize(13)
            .fontColor('#475569')

          Text(this.watchLog)
            .fontSize(13)
            .fontColor('#334155')
            .backgroundColor('#f8fafc')
            .padding(12)
            .borderRadius(12)
        }
        .stateCard()
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 20, bottom: 32 })
    }
    .scrollBar(BarState.Off)
    .backgroundColor('#f1f5f9')
  }
}
