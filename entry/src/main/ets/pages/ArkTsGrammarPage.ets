import { router } from '@kit.ArkUI';

/**
 * 这个枚举用来演示 ArkTS 中 enum 的典型用法：
 * 1. 用一组可读性更高的命名值代替魔法字符串。
 * 2. 页面状态、请求状态、权限状态等场景都非常适合用 enum。
 */
enum RequestState {
  Idle = '空闲',
  Loading = '加载中',
  Success = '成功',
  Error = '失败'
}

/**
 * 课程条目结构：
 * 用 interface 约束对象字段，是 ArkTS 日常开发中非常高频的写法。
 */
interface CourseItem {
  title: string
  minutes: number
  done: boolean
}

@Styles
function topicCard() {
  .width('100%')
  .padding(16)
  .backgroundColor(Color.White)
  .borderRadius(18)
  .margin({ bottom: 12 })
  .shadow({ radius: 12, color: 'rgba(15, 23, 42, 0.08)', offsetX: 0, offsetY: 4 })
}

@Entry
@Component
struct ArkTsGrammarPage {
  /**
   * @State 管理当前页面中的交互结果。
   * 用户点击按钮后，这些值变化会自动刷新依赖它们的 UI。
   */
  @State counter: number = 1
  @State requestState: RequestState = RequestState.Idle
  @State requestMessage: string = '点击“模拟异步请求”体验 async / await'
  @State divideMessage: string = '点击“执行错误处理”体验 try / catch'

  /**
   * private 成员适合保存不需要响应式刷新的静态数据。
   */
  private courseItems: CourseItem[] = [
    { title: 'ArkTS 类型系统', minutes: 20, done: true },
    { title: '数组对象操作', minutes: 25, done: true },
    { title: '异步请求与错误处理', minutes: 32, done: false }
  ]

  /**
   * 默认参数 + 返回值类型：
   * 这是日常业务函数最常见的声明方式之一。
   */
  private buildGreeting(name: string = '鸿蒙开发者'): string {
    return `你好，${name}，欢迎来到 ArkTS 语法馆。`;
  }

  /**
   * reduce() 聚合数组：
   * 把多个课程时长累加成总学习时长，是非常经典的列表统计场景。
   */
  private sumDurations(items: CourseItem[]): number {
    return items.reduce((total: number, item: CourseItem) => total + item.minutes, 0);
  }

  /**
   * filter + map + join：
   * 这组链式调用在真实项目里特别常见，适合处理“筛选后再格式化”的需求。
   */
  private buildFinishedText(items: CourseItem[]): string {
    const finishedTitles: string[] = items
      .filter((item: CourseItem) => item.done)
      .map((item: CourseItem) => item.title);

    return finishedTitles.join('、');
  }

  /**
   * if / else 分支判断：
   * 根据课程时长给出学习难度提示。
   */
  private buildDifficultyText(minutes: number): string {
    if (minutes >= 30) {
      return '进阶练习';
    } else if (minutes >= 20) {
      return '标准练习';
    }

    return '轻量预习';
  }

  /**
   * switch 适合处理枚举态分支。
   * 相比多层 if，状态流转更清晰。
   */
  private buildStateTone(state: RequestState): string {
    switch (state) {
      case RequestState.Loading:
        return '正在整理模拟数据...';
      case RequestState.Success:
        return '异步流程完成，结果已经刷新到页面。';
      case RequestState.Error:
        return '发生异常，页面进入错误提示态。';
      default:
        return '当前还未触发异步流程。';
    }
  }

  /**
   * async / await 示例：
   * - async 表示函数返回 Promise
   * - await 等待 Promise 完成，再继续执行后续逻辑
   */
  private async simulateAsyncRequest(): Promise<void> {
    this.requestState = RequestState.Loading;
    this.requestMessage = '开始请求课程摘要...';

    try {
      await new Promise<void>((resolve: () => void) => {
        setTimeout(() => {
          resolve();
        }, 700);
      });

      const total: number = this.sumDurations(this.courseItems);
      const finishedText: string = this.buildFinishedText(this.courseItems);
      this.requestState = RequestState.Success;
      this.requestMessage = `共 ${total} 分钟，已完成：${finishedText}`;
    } catch (error) {
      this.requestState = RequestState.Error;
      this.requestMessage = `模拟请求失败：${JSON.stringify(error)}`;
    }
  }

  /**
   * try / catch 错误处理：
   * 真实开发中常用于接口调用、参数校验、JSON 解析等场景。
   */
  private handleDivideDemo(divisor: number): void {
    try {
      if (divisor === 0) {
        throw new Error('除数不能为 0');
      }

      const result: number = 120 / divisor;
      this.divideMessage = `120 / ${divisor} = ${result}`;
    } catch (error) {
      this.divideMessage = `捕获到异常：${(error as Error).message}`;
    }
  }

  /**
   * 页面头部：
   * 所有专题页都保留统一的“返回 + 标题 + 说明”结构，方便学习者建立稳定认知。
   */
  @Builder
  PageHeader() {
    Column({ space: 12 }) {
      Row({ space: 12 }) {
        Button('返回首页')
          .fontSize(13)
          .fontColor('#5b6ee1')
          .backgroundColor('#eef1ff')
          .onClick(() => {
            router.back();
          })

        Column({ space: 4 }) {
          Text('ArkTS 语法馆')
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .fontColor('#0f172a')
          Text('通过可运行的页面状态和函数示例，理解鸿蒙开发里最常用的 ArkTS 语法。')
            .fontSize(13)
            .fontColor('#64748b')
            .lineHeight(20)
        }
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')
      .alignItems(VerticalAlign.Top)
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }

  build() {
    Scroll() {
      Column() {
        this.PageHeader()

        /**
         * 卡片 1：基础类型、模板字符串、默认参数。
         */
        Column({ space: 10 }) {
          Text('1. 基础类型与模板字符串')
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .fontColor('#0f172a')

          Text('页面里的 `counter` 是 number，`requestMessage` 是 string，这就是最常见的显式类型标注。')
            .fontSize(13)
            .fontColor('#475569')
            .lineHeight(20)

          Text(this.buildGreeting('正在学习鸿蒙的你'))
            .fontSize(14)
            .fontColor('#5b21b6')
            .backgroundColor('#f5f3ff')
            .padding(12)
            .borderRadius(10)

          Row({ space: 10 }) {
            Button('counter + 1')
              .backgroundColor('#5b6ee1')
              .fontColor(Color.White)
              .onClick(() => {
                this.counter += 1;
              })

            Text(`当前 counter：${this.counter}`)
              .fontSize(14)
              .fontColor('#334155')
          }
        }
        .topicCard()

        /**
         * 卡片 2：数组对象、forEach / filter / map / reduce。
         */
        Column({ space: 12 }) {
          Text('2. 数组与对象操作')
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .fontColor('#0f172a')

          Text('下面这个列表同时演示了 interface、ForEach 渲染和数组聚合统计。')
            .fontSize(13)
            .fontColor('#475569')

          Column({ space: 8 }) {
            ForEach(this.courseItems, (item: CourseItem) => {
              Row() {
                Column({ space: 4 }) {
                  Text(item.title)
                    .fontSize(14)
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#0f172a')
                  Text(`${item.minutes} 分钟 · ${this.buildDifficultyText(item.minutes)}`)
                    .fontSize(12)
                    .fontColor('#64748b')
                }
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(1)

                Text(item.done ? '已完成' : '未完成')
                  .fontSize(12)
                  .fontColor(item.done ? '#16a34a' : '#f97316')
                  .backgroundColor(item.done ? '#ecfdf3' : '#fff7ed')
                  .padding({ left: 8, right: 8, top: 4, bottom: 4 })
                  .borderRadius(999)
              }
              .width('100%')
              .padding(12)
              .backgroundColor('#f8fafc')
              .borderRadius(12)
            })
          }

          Text(`课程总时长：${this.sumDurations(this.courseItems)} 分钟`)
            .fontSize(13)
            .fontColor('#475569')
          Text(`已完成课程：${this.buildFinishedText(this.courseItems)}`)
            .fontSize(13)
            .fontColor('#475569')
        }
        .topicCard()

        /**
         * 卡片 3：async / await 与枚举状态。
         */
        Column({ space: 12 }) {
          Text('3. async / await 与 enum')
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .fontColor('#0f172a')

          Text(`当前请求状态：${this.requestState}`)
            .fontSize(14)
            .fontColor('#1d4ed8')
          Text(this.buildStateTone(this.requestState))
            .fontSize(13)
            .fontColor('#64748b')
          Text(this.requestMessage)
            .fontSize(13)
            .fontColor('#334155')
            .lineHeight(20)

          Button('模拟异步请求')
            .width('100%')
            .backgroundColor('#0f766e')
            .fontColor(Color.White)
            .onClick(() => {
              this.simulateAsyncRequest();
            })
        }
        .topicCard()

        /**
         * 卡片 4：try / catch 错误处理。
         */
        Column({ space: 12 }) {
          Text('4. try / catch 错误处理')
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .fontColor('#0f172a')

          Text('点击不同按钮，观察正常计算和抛出异常时的反馈差异。')
            .fontSize(13)
            .fontColor('#475569')

          Row({ space: 10 }) {
            Button('正常执行')
              .layoutWeight(1)
              .backgroundColor('#2563eb')
              .fontColor(Color.White)
              .onClick(() => {
                this.handleDivideDemo(6);
              })

            Button('触发异常')
              .layoutWeight(1)
              .backgroundColor('#dc2626')
              .fontColor(Color.White)
              .onClick(() => {
                this.handleDivideDemo(0);
              })
          }
          .width('100%')

          Text(this.divideMessage)
            .fontSize(13)
            .fontColor('#334155')
            .backgroundColor('#f8fafc')
            .padding(12)
            .borderRadius(10)
        }
        .topicCard()
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 20, bottom: 32 })
    }
    .scrollBar(BarState.Off)
    .backgroundColor('#f1f5f9')
  }
}
