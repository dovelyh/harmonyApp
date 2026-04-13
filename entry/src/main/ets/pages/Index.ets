import { router } from '@kit.ArkUI';

import {
  LEARNING_STAGES,
  LEARNING_TOPICS,
  PRACTICE_CASES,
  LearningStage,
  LearningTopic,
  PracticeCase
} from '../common/LearningData';
import {
  buildLearningSummary,
  filterLearningTopics,
  filterPracticeCases,
  LearningSummary
} from '../common/LearningHelpers';

/**
 * ╔══════════════════════════════════════════════════════════════════╗
 * ║              鸿蒙 ArkUI 学习手册 · Index.ets                     ║
 * ║  覆盖：学习地图 / 文本 / 交互 / 布局 / 动画 · HarmonyOS API 22   ║
 * ╚══════════════════════════════════════════════════════════════════╝
 *
 * 文件结构速览：
 *  1. 接口定义（interface）          —— ArkTS 数据类型声明
 *  2. @Styles 全局样式函数            —— 卡片通用样式复用
 *  3. @Extend 组件扩展函数            —— Text 专属样式扩展
 *  4. @Entry @Component struct Index —— 页面主体
 *     ├─ @State 状态变量              —— 驱动 UI 刷新的响应式数据
 *     ├─ private 普通数据             —— 不需要响应式的静态列表
 *     ├─ @Builder Tab 栏构建器        —— Tab 图标+文字
 *     ├─ @Builder TextTab()           —— 文本组件展示
 *     ├─ @Builder InteractiveTab()    —— 交互组件展示
 *     ├─ @Builder LayoutTab()         —— 布局组件展示
 *     ├─ @Builder AnimationTab()      —— 动画与事件展示
 *     └─ build()                      —— 页面根入口，组合 Header + Tabs
 */

// ═══════════════════════════════════════════════════════════════════
// 1. 接口定义 (interface)
//    ArkTS 是 TypeScript 的子集，支持 interface 作为对象类型约束。
//    将数据结构提前声明，在 ForEach 回调中就能获得类型推断和补全。
// ═══════════════════════════════════════════════════════════════════

/** 装饰器说明条目：tag=装饰器名，desc=用途说明 */
interface DecoratorItem {
  tag: string
  desc: string
}

/** Grid 网格条目：icon=emoji 图标，label=标签文字 */
interface GridEntry {
  icon: string
  label: string
}

/** 动画曲线条目：name=曲线名称，color=展示颜色 */
interface CurveEntry {
  name: string
  color: string
}

/** List 列表条目：title=主标题，sub=副标题 */
interface ListEntry {
  title: string
  sub: string
}

// ═══════════════════════════════════════════════════════════════════
// 2. @Styles —— 全局公共样式函数
//
//    语法：@Styles function 函数名() { .样式A() .样式B() ... }
//    作用：把多个通用样式打包成一个函数，避免在每个组件上重复写。
//    调用：Column() { ... }.cardStyle()   —— 像普通方法一样链式调用
//    限制：@Styles 函数不能带参数；只能设置"通用属性"（所有组件共有的）。
//    范围：写在 struct 外 = 全文件可用；写在 struct 内 = 仅本组件可用。
// ═══════════════════════════════════════════════════════════════════
@Styles
function cardStyle() {
  .width('100%')                                    // 宽度铺满父容器
  .padding(16)                                      // 内边距 16vp（上下左右相同）
  .backgroundColor(Color.White)                     // 白色背景
  .borderRadius(14)                                 // 圆角 14vp
  .shadow({ radius: 10, color: 'rgba(0,0,0,0.06)', offsetX: 0, offsetY: 3 }) // 投影
  .margin({ bottom: 12 })                           // 卡片底部间距
}

// ═══════════════════════════════════════════════════════════════════
// 3. @Extend —— 组件专属样式扩展
//
//    语法：@Extend(组件名) function 函数名() { .样式A() .样式B() ... }
//    作用：为特定组件追加链式样式，只能用于指定组件类型。
//    调用：Text('tag').tagChip()
//    与 @Styles 的区别：
//      - @Styles 适用于所有组件（只能用通用属性）
//      - @Extend  针对某一类组件（可用该组件专有属性，如 Text 的 fontSize）
//    范围：只能写在 struct 外（全局）。
// ═══════════════════════════════════════════════════════════════════
@Extend(Text)
function tagChip() {
  .fontSize(10)
  .fontColor('#667eea')
  .backgroundColor('#eff0ff')
  .padding({ left: 6, right: 6, top: 2, bottom: 2 })
  .borderRadius(4)
}

// ═══════════════════════════════════════════════════════════════════
// 4. 页面主体
//
//    @Entry   —— 标记此组件为页面入口（每个页面只能有一个 @Entry）
//    @Component —— 标记为 ArkUI 自定义组件，框架会管理其生命周期
//    struct   —— ArkTS 组件用 struct 而非 class 定义（不支持继承）
// ═══════════════════════════════════════════════════════════════════
@Entry
@Component
struct Index {

  // ─────────────────────────────────────────────────────────────────
  // @State —— 组件内部响应式状态
  //
  //  原理：被 @State 修饰的变量发生变化时，ArkUI 框架会自动
  //        重新执行 build() 中依赖该变量的局部子树，刷新 UI。
  //  规则：只能在本组件内读写；不能直接传给子组件当 @State（需用 @Prop/@Link）。
  //  支持类型：string / number / boolean / 对象 / 数组（数组需整体替换才触发刷新）
  // ─────────────────────────────────────────────────────────────────
  @State activeTab: number = 0          // 当前激活的 Tab 下标（0-4）
  @State portalKeyword: string = ''     // 首页总览 Tab 的搜索关键字
  @State selectedTopicLevel: string = '全部' // 首页总览中按难度筛选专题
  @State inputValue: string = ''        // TextInput 绑定的文字
  @State sliderVal: number = 50         // Slider 当前值，同时驱动 Progress
  @State toggleOn: boolean = false      // Toggle 开关状态
  @State checkA: boolean = true         // Checkbox A 是否选中
  @State checkB: boolean = false        // Checkbox B 是否选中
  @State radioVal: string = 'A'         // Radio 当前选中的值
  @State ratingVal: number = 3          // Rating 星级评分
  @State clickCount: number = 0         // 按钮点击次数计数器
  @State animScale: number = 1.0        // 控制缩放动画（1.0 = 原始大小）
  @State animRotate: number = 0         // 控制旋转动画（单位：度）
  @State animOpacity: number = 1.0      // 控制透明度动画（0~1）
  @State animTranslateY: number = 0     // 控制 Y 轴位移动画（单位：vp）
  @State touchText: string = '触摸这里体验 onTouch 事件'  // 触摸区域显示文字

  // ─────────────────────────────────────────────────────────────────
  // private —— 普通私有成员（非响应式）
  //
  //  这些数据只用于静态展示，不需要驱动 UI 刷新，
  //  因此用 private 而非 @State，避免不必要的性能开销。
  // ─────────────────────────────────────────────────────────────────

  /** 状态装饰器说明列表，用于"动画"Tab 最后的速查表 */
  private decorators: DecoratorItem[] = [
    { tag: '@State',   desc: '组件内部状态，变化驱动 UI 刷新' },
    { tag: '@Prop',    desc: '父→子单向传递，子不能修改' },
    { tag: '@Link',    desc: '父子双向绑定，同步更新' },
    { tag: '@Provide', desc: '跨层祖先提供共享数据' },
    { tag: '@Consume', desc: '跨层子孙消费祖先数据' },
    { tag: '@Builder', desc: '自定义构建函数，复用 UI 片段' },
    { tag: '@Styles',  desc: '抽取通用样式到独立函数' },
    { tag: '@Extend',  desc: '扩展特定组件的样式链' },
  ]

  /** Grid 展示数据，用于网格布局示例 */
  private gridEntries: GridEntry[] = [
    { icon: '📦', label: '组件' },
    { icon: '🎨', label: '样式' },
    { icon: '⚡', label: '事件' },
    { icon: '🔄', label: '状态' },
    { icon: '📐', label: '布局' },
    { icon: '🎬', label: '动画' },
  ]

  /** 动画曲线枚举速查，用于 Curve 卡片 */
  private curveEntries: CurveEntry[] = [
    { name: 'Linear',    color: '#667eea' }, // 匀速直线
    { name: 'Ease',      color: '#2ecc71' }, // 慢→快→慢（默认）
    { name: 'EaseIn',    color: '#e74c3c' }, // 慢→快（加速进入）
    { name: 'EaseOut',   color: '#f39c12' }, // 快→慢（减速结束）
    { name: 'EaseInOut', color: '#9b59b6' }, // 慢→快→慢（两端缓和）
    { name: 'Spring',    color: '#1abc9c' }, // 弹簧物理效果
    { name: 'Bounce',    color: '#e67e22' }, // 结束时弹跳回弹
    { name: 'Friction',  color: '#34495e' }, // 摩擦力阻尼效果
  ]

  /** List 展示数据，用于列表布局示例 */
  private listEntries: ListEntry[] = [
    { title: 'EntryAbility',  sub: 'UIAbility 入口类' },
    { title: 'WindowStage',   sub: '窗口管理器' },
    { title: 'Want',          sub: '意图描述对象' },
    { title: 'hilog',         sub: '系统日志工具' },
    { title: 'promptAction',  sub: 'Toast / Dialog 弹窗' },
  ]

  /** 首页总览统计信息，由公共 helper 统一计算 */
  private learningSummary: LearningSummary = buildLearningSummary(LEARNING_TOPICS, PRACTICE_CASES)

  /** 首页专题筛选项 */
  private levelFilters: string[] = ['全部', '入门', '进阶']

  // ═══════════════════════════════════════════════════════════════════
  // @Builder —— 自定义构建函数
  //
  //  作用：把一段可复用的 UI 片段封装成函数，减少 build() 的臃肿。
  //  调用：this.函数名()  或  this.函数名(参数)
  //  与组件的区别：@Builder 不创建独立组件实例，不拥有独立状态，
  //                更轻量；适合局部 UI 片段复用。
  //  注意：当作 CustomBuilder 传给组件参数（如 tabBar）时，
  //        用 this.方法名 引用（不加括号），框架自动处理 this 绑定。
  // ═══════════════════════════════════════════════════════════════════

  // ── Tab Bar：每个 Tab 对应一个无参数的 @Builder，内部调用公共的 TabItem ──

  /** Tab 0：首页学习总览 */
  @Builder TabBarOverview(){ this.TabItem(0, '🧭', '总览') }
  /** Tab 1：文本组件 */
  @Builder TabBarText()    { this.TabItem(1, '📝', '文本') }
  /** Tab 2：交互组件 */
  @Builder TabBarInteract(){ this.TabItem(2, '🎛️', '交互') }
  /** Tab 3：布局组件 */
  @Builder TabBarLayout()  { this.TabItem(3, '📐', '布局') }
  /** Tab 4：动画与事件 */
  @Builder TabBarAnim()    { this.TabItem(4, '✨', '动画') }

  /**
   * 公共 Tab 图标+文字布局（带参数的 @Builder）
   *
   * @param idx   - 本 Tab 的下标，用于对比 activeTab 判断是否激活
   * @param icon  - emoji 图标字符串
   * @param label - 标签文字
   *
   * 知识点：三元运算符在样式中动态切换颜色/字重，
   *         this.activeTab 是 @State，变化时会触发本 Builder 重新渲染。
   */
  @Builder
  TabItem(idx: number, icon: string, label: string) {
    Column({ space: 4 }) {
      Text(icon).fontSize(18)
      Text(label)
        .fontSize(10)
        // 激活状态用粗体，未激活用普通字重
        .fontWeight(this.activeTab === idx ? FontWeight.Bold : FontWeight.Normal)
        // 激活状态用主题色，未激活用灰色
        .fontColor(this.activeTab === idx ? '#667eea' : '#bbb')
    }
    .padding({ top: 6, bottom: 6 })
  }

  /**
   * 每个 Section 的标题行（带参数的 @Builder）
   *
   * @param title - 标题文字
   * @param tag   - 右侧小标签（如"基础"、"布局"），调用 @Extend 的 tagChip()
   */
  @Builder
  SectionHeader(title: string, tag: string) {
    Row({ space: 8 }) {
      // fontSize/fontWeight/fontColor 是 Text 专有属性，不能放进 @Styles
      Text(title).fontSize(16).fontWeight(FontWeight.Bold).fontColor('#1a1a1a')
      // tagChip() 是上方 @Extend(Text) 定义的扩展函数，可以直接链式调用
      Text(tag).tagChip()
    }
    .width('100%')
    .alignItems(VerticalAlign.Center) // Row 内子组件垂直居中对齐
    .margin({ bottom: 12 })           // 与下方内容保持间距
  }

  /**
   * 首页总览里，专题卡片和案例卡片都要跳转到其他页面。
   * 抽成方法后，不仅复用更方便，也更利于学习者理解“事件回调里做页面跳转”这种常见模式。
   */
  private navigateTo(url: string, title: string): void {
    router.pushUrl({
      url,
      params: {
        source: 'index-overview',
        title
      }
    });
  }

  /**
   * 根据搜索词和难度，筛出首页总览中真正要展示的专题列表。
   */
  private getVisibleTopics(): LearningTopic[] {
    const filteredByKeyword: LearningTopic[] = filterLearningTopics(LEARNING_TOPICS, this.portalKeyword);

    if (this.selectedTopicLevel === '全部') {
      return filteredByKeyword;
    }

    return filteredByKeyword.filter((item: LearningTopic) => item.level === this.selectedTopicLevel);
  }

  /**
   * 案例市场预览也走同一套搜索词，便于用户在首页快速定位自己想练的场景。
   */
  private getVisibleCases(): PracticeCase[] {
    return filterPracticeCases(PRACTICE_CASES, this.portalKeyword);
  }

  // ═══════════════════════════════════════════════════════════════════
  // Tab 0 —— 学习总览（OverviewTab）
  // ═══════════════════════════════════════════════════════════════════
  @Builder
  OverviewTab() {
    Scroll() {
      Column() {

        // ── 卡片 1：学习入口总览 ────────────────────────────────────────
        Column() {
          this.SectionHeader('学习总控台', '首页')

          Text('这个 Tab 负责把当前项目升级成一个完整学习入口：先看学习路径，再按专题学习，最后进入业务案例练习。')
            .fontSize(13)
            .fontColor('#64748b')
            .lineHeight(22)
            .margin({ bottom: 14 })

          Row({ space: 10 }) {
            Column({ space: 4 }) {
              Text(`${this.learningSummary.totalTopics}`)
                .fontSize(22).fontWeight(FontWeight.Bold).fontColor('#667eea')
              Text('专题页').fontSize(12).fontColor('#94a3b8')
            }
            .width('30%')
            .padding(12)
            .backgroundColor('#eef2ff')
            .borderRadius(12)

            Column({ space: 4 }) {
              Text(`${this.learningSummary.totalCases}`)
                .fontSize(22).fontWeight(FontWeight.Bold).fontColor('#16a34a')
              Text('案例页').fontSize(12).fontColor('#94a3b8')
            }
            .width('30%')
            .padding(12)
            .backgroundColor('#ecfdf3')
            .borderRadius(12)

            Column({ space: 4 }) {
              Text(`${this.learningSummary.beginnerCount + this.learningSummary.intermediateCount}`)
                .fontSize(22).fontWeight(FontWeight.Bold).fontColor('#f97316')
              Text('日常高频').fontSize(12).fontColor('#94a3b8')
            }
            .width('30%')
            .padding(12)
            .backgroundColor('#fff7ed')
            .borderRadius(12)
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
        }
        .cardStyle()

        // ── 卡片 2：学习阶段路线图 ──────────────────────────────────────
        Column() {
          this.SectionHeader('学习路径', '路线')

          Column({ space: 10 }) {
            ForEach(LEARNING_STAGES, (item: LearningStage, index: number) => {
              Row({ space: 12 }) {
                Text(`${index + 1}`)
                  .width(28).height(28)
                  .fontSize(13).fontWeight(FontWeight.Bold).fontColor(Color.White)
                  .textAlign(TextAlign.Center)
                  .backgroundColor('#667eea')
                  .borderRadius(14)

                Column({ space: 4 }) {
                  Text(item.title)
                    .fontSize(14).fontWeight(FontWeight.Bold).fontColor('#1f2937')
                  Text(item.description)
                    .fontSize(12).fontColor('#64748b').lineHeight(18)
                  Text(item.target)
                    .fontSize(12).fontColor('#4f46e5')
                }
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(1)
              }
              .width('100%')
              .padding(12)
              .backgroundColor('#f8fafc')
              .borderRadius(12)
            })
          }
        }
        .cardStyle()

        // ── 卡片 3：搜索与专题筛选 ──────────────────────────────────────
        Column() {
          this.SectionHeader('专题检索', '筛选')

          TextInput({ placeholder: '搜索 ArkTS、状态、动画、设置页、商城等关键词', text: this.portalKeyword })
            .onChange((value: string) => { this.portalKeyword = value })
            .backgroundColor('#f8fafc')
            .borderRadius(12)

          Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Start }) {
            ForEach(this.levelFilters, (level: string) => {
              Button(level)
                .fontSize(12)
                .margin({ right: 8, top: 12, bottom: 4 })
                .backgroundColor(this.selectedTopicLevel === level ? '#667eea' : '#eef2ff')
                .fontColor(this.selectedTopicLevel === level ? Color.White : '#475569')
                .onClick(() => { this.selectedTopicLevel = level })
            })
          }
          .width('100%')

          Text(`当前命中 ${this.getVisibleTopics().length} 个专题、${this.getVisibleCases().length} 个案例`)
            .fontSize(12).fontColor('#94a3b8').margin({ top: 6 })
        }
        .cardStyle()

        // ── 卡片 4：专题页入口 ──────────────────────────────────────────
        Column() {
          this.SectionHeader('专题学习馆', '专题')

          Column({ space: 10 }) {
            ForEach(this.getVisibleTopics(), (item: LearningTopic) => {
              Column({ space: 10 }) {
                Row() {
                  Column({ space: 4 }) {
                    Text(item.title)
                      .fontSize(15).fontWeight(FontWeight.Bold).fontColor('#1f2937')
                    Text(item.subtitle)
                      .fontSize(12).fontColor('#64748b').lineHeight(18)
                  }
                  .alignItems(HorizontalAlign.Start)
                  .layoutWeight(1)

                  Text(item.level)
                    .fontSize(11)
                    .fontColor(item.level === '入门' ? '#2563eb' : '#7c3aed')
                    .backgroundColor(item.level === '入门' ? '#eff6ff' : '#f5f3ff')
                    .padding({ left: 8, right: 8, top: 4, bottom: 4 })
                    .borderRadius(999)
                }
                .width('100%')

                Row({ space: 8 }) {
                  Text(item.category).tagChip()
                  Text(item.estimatedTime).fontSize(11).fontColor('#94a3b8')
                }

                Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Start }) {
                  ForEach(item.highlights, (text: string) => {
                    Text(text)
                      .fontSize(11)
                      .fontColor('#475569')
                      .backgroundColor('#f8fafc')
                      .padding({ left: 8, right: 8, top: 4, bottom: 4 })
                      .borderRadius(999)
                      .margin({ right: 6, bottom: 6 })
                  })
                }
                .width('100%')

                Button('进入专题')
                  .width('100%')
                  .backgroundColor('#667eea')
                  .fontColor(Color.White)
                  .onClick(() => {
                    this.navigateTo(item.route, item.title)
                  })
              }
              .width('100%')
              .padding(14)
              .backgroundColor('#f8fafc')
              .borderRadius(14)
            })
          }
        }
        .cardStyle()

        // ── 卡片 5：案例市场入口 ────────────────────────────────────────
        Column() {
          this.SectionHeader('案例市场', '实战')

          Column({ space: 10 }) {
            ForEach(this.getVisibleCases(), (item: PracticeCase) => {
              Column({ space: 10 }) {
                Row() {
                  Text(item.badge)
                    .fontSize(11)
                    .fontColor('#16a34a')
                    .backgroundColor('#ecfdf3')
                    .padding({ left: 8, right: 8, top: 4, bottom: 4 })
                    .borderRadius(999)

                  Blank()

                  Text(item.scene).fontSize(12).fontColor('#94a3b8')
                }
                .width('100%')

                Text(item.title)
                  .fontSize(15).fontWeight(FontWeight.Bold).fontColor('#1f2937')
                Text(item.summary)
                  .fontSize(12).fontColor('#64748b').lineHeight(18)

                Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Start }) {
                  ForEach(item.skills, (skill: string) => {
                    Text(skill)
                      .fontSize(11)
                      .fontColor('#475569')
                      .backgroundColor('#f8fafc')
                      .padding({ left: 8, right: 8, top: 4, bottom: 4 })
                      .borderRadius(999)
                      .margin({ right: 6, bottom: 6 })
                  })
                }
                .width('100%')

                Button('打开案例')
                  .width('100%')
                  .backgroundColor('#16a34a')
                  .fontColor(Color.White)
                  .onClick(() => {
                    this.navigateTo(item.route, item.title)
                  })
              }
              .width('100%')
              .padding(14)
              .backgroundColor('#f8fafc')
              .borderRadius(14)
            })
          }

          Button('进入完整案例市场')
            .width('100%')
            .backgroundColor('#0f766e')
            .fontColor(Color.White)
            .margin({ top: 10 })
            .onClick(() => {
              this.navigateTo('pages/CaseMarketPage', '功能市场案例')
            })
        }
        .cardStyle()
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 16, bottom: 32 })
    }
    .scrollBar(BarState.Off)
    .height('100%')
  }

  // ═══════════════════════════════════════════════════════════════════
  // Tab 1 —— 文本组件（TextTab）
  // ═══════════════════════════════════════════════════════════════════
  @Builder
  TextTab() {
    /**
     * Scroll —— 可滚动容器
     *  方向默认为垂直滚动（ScrollDirection.Vertical）。
     *  scrollBar(BarState.Off) —— 隐藏系统默认滚动条。
     *  height('100%') —— 撑满 Tab 内容区高度，配合 layoutWeight 使用。
     */
    Scroll() {
      Column() {

        // ── 卡片 1：Text 基础样式 ────────────────────────────────────────
        Column() {
          this.SectionHeader('Text 文本组件', '基础')
          /**
           * Column({ space: N }) —— 子组件之间自动保留 N vp 的垂直间距，
           * 比在每个子组件上写 margin({ bottom: N }) 更简洁。
           */
          Column({ space: 8 }) {
            // fontSize: 字号，单位 fp（跟随系统字体缩放）
            Text('默认文本 16px').fontSize(16).fontColor('#333')

            // fontWeight: 字重。枚举值：Lighter / Normal / Regular / Medium / Bold / Bolder
            Text('Bold 加粗').fontSize(16).fontWeight(FontWeight.Bold).fontColor('#333')

            // fontStyle: 字形。枚举值：Normal（默认）/ Italic（斜体）
            Text('Italic 斜体').fontSize(16).fontStyle(FontStyle.Italic).fontColor('#555')

            // 字号越大，视觉层级越突出
            Text('大号 24px 主色').fontSize(24).fontColor('#667eea')

            /**
             * decoration —— 文字装饰线
             *   type: TextDecorationType.Underline    下划线
             *         TextDecorationType.LineThrough  删除线
             *         TextDecorationType.Overline     上划线
             *         TextDecorationType.None         无（默认）
             *   color: 装饰线颜色（可独立于字体颜色）
             */
            Text('下划线').fontSize(16)
              .decoration({ type: TextDecorationType.Underline, color: '#667eea' })
            Text('删除线').fontSize(16)
              .decoration({ type: TextDecorationType.LineThrough, color: '#e74c3c' })

            /**
             * letterSpacing —— 字间距，单位 fp
             *   正数：字间距扩大；负数：字间距收窄；0：默认
             */
            Text('字间距  l e t t e r S p a c i n g').fontSize(15).letterSpacing(4).fontColor('#444')

            /**
             * lineHeight —— 行高，单位 fp
             *   设置比默认行高更大的值可改善多行文本的可读性。
             *   注意：lineHeight 必须 >= fontSize，否则文字会被裁剪。
             */
            Text('增大行高，多行文字在这里展示行高效果，lineHeight 设为 28。')
              .fontSize(14).lineHeight(28).fontColor('#555')
          }
          // alignItems(HorizontalAlign.Start) —— Column 内子组件左对齐
          .alignItems(HorizontalAlign.Start)
          .width('100%')
        }
        // 调用全局 @Styles 函数，等价于把 cardStyle 内的所有属性直接写在这里
        .cardStyle()

        // ── 卡片 2：TextOverflow 文本截断 ────────────────────────────────
        Column() {
          this.SectionHeader('TextOverflow 文本截断', '文本')
          /**
           * maxLines —— 最大显示行数。超出部分根据 textOverflow 决定如何处理。
           * textOverflow —— 超出策略：
           *   TextOverflow.Clip     截断（不加省略号）
           *   TextOverflow.Ellipsis 末尾加 "..."（最常用）
           *   TextOverflow.None     不截断，溢出显示
           *
           * 注意：textOverflow 必须配合 maxLines 一起使用才生效。
           */
          Text('单行（maxLines: 1）：这是一段很长的说明文字，超出后显示省略号，这是 TextOverflow.Ellipsis 的典型用法。')
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .fontSize(14).fontColor('#444')

          /**
           * Divider —— 分割线组件
           *   .color()       线条颜色
           *   .strokeWidth() 线条粗细（默认 1vp）
           *   .vertical()    是否为竖向分割线（默认 false = 横向）
           *   .margin()      通过通用 margin 属性控制上下间距
           */
          Divider().margin({ top: 10, bottom: 10 }).color('#f0f0f0')

          Text('双行（maxLines: 2）：这是一段很长的说明文字，超出两行后显示省略号，在列表摘要、卡片简介等场景中极为常用，建议配合 lineHeight 一起使用。')
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .fontSize(14).fontColor('#444')
        }
        .cardStyle()

        // ── 卡片 3：Span 行内混排 + textAlign ────────────────────────────
        Column() {
          this.SectionHeader('Span 行内混排', '文本')
          /**
           * Span —— Text 的子组件，用于在同一行内实现不同样式的文字片段。
           *   Text() { Span('...') Span('...') }
           *   每个 Span 可单独设置 fontColor / fontWeight / fontStyle / decoration 等。
           *   fontSize 设置在外层 Text 上作为默认值，Span 可覆盖。
           *
           * 使用场景：富文本、关键词高亮、混合颜色标签等。
           */
          Text() {
            Span('混排效果：').fontWeight(FontWeight.Bold).fontColor('#1a1a1a')
            Span('红色').fontColor('#e74c3c')
            Span('  ·  ').fontColor('#ccc')
            Span('蓝色加粗').fontColor('#667eea').fontWeight(FontWeight.Bold)
            Span('  ·  ').fontColor('#ccc')
            Span('绿色斜体').fontColor('#2ecc71').fontStyle(FontStyle.Italic)
          }
          .fontSize(15) // 外层 Text 设置默认字号，Span 内没有设置 fontSize 的将继承此值

          Divider().margin({ top: 10, bottom: 10 }).color('#f0f0f0')

          Text('textAlign 对齐方式').fontSize(12).fontColor('#999').margin({ bottom: 8 })
          /**
           * textAlign —— 文字在组件内部的水平对齐方式。
           *   TextAlign.Start  左对齐（国际化语境下跟随文字方向）
           *   TextAlign.Center 居中
           *   TextAlign.End    右对齐
           * 注意：Text 需要有足够的宽度（如 .width('100%')）才能看出对齐差异。
           */
          Text('左对齐文本内容示例').fontSize(14).width('100%').textAlign(TextAlign.Start)
            .backgroundColor('#fafafa').padding(6).borderRadius(4)
          Text('居中对齐文本内容').fontSize(14).width('100%').textAlign(TextAlign.Center)
            .backgroundColor('#fafafa').padding(6).borderRadius(4).margin({ top: 4 })
          Text('右对齐文本内容示例').fontSize(14).width('100%').textAlign(TextAlign.End)
            .backgroundColor('#fafafa').padding(6).borderRadius(4).margin({ top: 4 })
        }
        .cardStyle()

        // ── 卡片 4：Badge 徽标 ────────────────────────────────────────────
        Column() {
          this.SectionHeader('Badge 徽标组件', '容器')
          /**
           * Badge —— 在子组件右上角叠加一个徽标（数字或文字）。
           *
           *  两种用法：
           *   1. 数字模式：{ count: number, maxCount?: number, style: BadgeStyle }
           *      - count    显示的数字
           *      - maxCount 超出此数显示 "99+"（默认 99）
           *   2. 文字模式：{ value: string, style: BadgeStyle }
           *
           *  BadgeStyle 参数：
           *   - fontSize  徽标内文字大小
           *   - badgeSize 徽标圆圈直径
           *   - badgeColor 徽标背景色
           *
           *  子组件写在 Badge 的花括号内（trailing builder 语法）。
           */
          Row({ space: 20 }) {
            // 数字徽标：显示 5
            Badge({ count: 5, style: { fontSize: 11, badgeSize: 18, badgeColor: '#e74c3c' } }) {
              Text('消息').fontSize(14).fontColor('#333')
                .padding({ left: 14, right: 14, top: 7, bottom: 7 })
                .backgroundColor('#f5f5f5').borderRadius(20)
            }
            // 超出上限：maxCount: 99，超过后显示 "99+"
            Badge({ count: 99, maxCount: 99, style: { fontSize: 11, badgeSize: 18, badgeColor: '#e74c3c' } }) {
              Text('通知').fontSize(14).fontColor('#333')
                .padding({ left: 14, right: 14, top: 7, bottom: 7 })
                .backgroundColor('#f5f5f5').borderRadius(20)
            }
            // 文字徽标：显示自定义字符串
            Badge({ value: 'NEW', style: { fontSize: 10, badgeSize: 16, badgeColor: '#2ecc71' } }) {
              Text('新品').fontSize(14).fontColor('#333')
                .padding({ left: 14, right: 14, top: 7, bottom: 7 })
                .backgroundColor('#f5f5f5').borderRadius(20)
            }
          }
        }
        .cardStyle()

      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 16, bottom: 32 })
    }
    .scrollBar(BarState.Off) // 隐藏滚动条
    .height('100%')          // 占满 TabContent 剩余高度
  }

  // ═══════════════════════════════════════════════════════════════════
  // Tab 2 —— 交互组件（InteractiveTab）
  // ═══════════════════════════════════════════════════════════════════
  @Builder
  InteractiveTab() {
    Scroll() {
      Column() {

        // ── 卡片 1：Button ────────────────────────────────────────────────
        Column() {
          this.SectionHeader('Button 按钮', '交互')
          /**
           * Flex —— 弹性布局容器（横向默认）
           *   wrap: FlexWrap.Wrap     内容超出时自动换行
           *   justifyContent: ...     主轴（横向）对齐方式
           *
           * 此处用 Flex wrap 代替 Row，使按钮数量多时自动折行。
           */
          Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Start }) {
            /**
             * Button(label, options?)
             *   label   —— 按钮文字
             *   options.type —— 按钮形状：
             *     ButtonType.Normal   默认圆角矩形
             *     ButtonType.Capsule  胶囊形（两端半圆）
             *     ButtonType.Circle   正圆（需手动设置 width/height 相等）
             *
             * 通用样式：backgroundColor / fontColor / fontSize / border / enabled
             * onClick —— 点击事件，箭头函数内修改 @State 触发刷新
             */
            Button('普通按钮')
              .backgroundColor('#667eea').fontColor(Color.White).fontSize(14)
              .margin({ right: 8, bottom: 8 })
              .onClick(() => { this.clickCount++ }) // 箭头函数，直接修改 @State

            Button('胶囊', { type: ButtonType.Capsule })
              .backgroundColor('#2ecc71').fontColor(Color.White).fontSize(14)
              .margin({ right: 8, bottom: 8 })

            Button('+', { type: ButtonType.Circle })
              .width(40).height(40).fontSize(18)   // Circle 类型必须 width = height
              .backgroundColor('#e74c3c').fontColor(Color.White)
              .margin({ right: 8, bottom: 8 })

            // 线框按钮：背景透明 + border + 文字用主题色
            Button('线框样式')
              .backgroundColor(Color.Transparent)
              .border({ width: 1, color: '#667eea' }) // border: { width, color, style?, radius? }
              .fontColor('#667eea').fontSize(14)
              .margin({ right: 8, bottom: 8 })

            /**
             * enabled(false) —— 禁用按钮，用户无法点击，视觉上变灰。
             * 注意：禁用后 onClick 不会被触发。
             */
            Button('禁用状态')
              .backgroundColor('#eee').fontColor('#bbb').fontSize(14)
              .enabled(false)
              .margin({ bottom: 8 })
          }
          .width('100%')

          // 模板字符串（反引号）动态插值，@State 变化后此 Text 自动刷新
          Text(`"普通按钮" 已点击 ${this.clickCount} 次`)
            .fontSize(13).fontColor('#888').margin({ top: 4 })
        }
        .cardStyle()

        // ── 卡片 2：TextInput ──────────────────────────────────────────────
        Column() {
          this.SectionHeader('TextInput 输入框', '输入')
          /**
           * TextInput({ placeholder?, text? })
           *   placeholder —— 占位符文字
           *   text        —— 当前文本内容（受控绑定）
           *
           * 关键方法：
           *   .onChange((v: string) => {}) —— 内容变化时回调，必须在此更新 @State
           *   .type(InputType.xxx)         —— 键盘/输入类型：
           *       Normal       普通文本
           *       Password     密码（字符隐藏）
           *       Email        邮箱（弹出带 @ 的键盘）
           *       PhoneNumber  手机号（数字键盘）
           *       Number       纯数字
           *   .placeholderColor() —— 占位符文字颜色
           *   .maxLength()        —— 最大字符数限制
           *   .showPasswordIcon() —— 是否显示密码眼睛图标（Password 类型）
           *
           * 受控组件模式：text 绑定 @State，onChange 更新 @State，
           *   任何对 @State 的修改都会同步回输入框。
           */
          TextInput({ placeholder: '用户名 (type: Normal)', text: this.inputValue })
            .onChange((v: string) => { this.inputValue = v }) // 受控：每次输入都同步 @State
            .placeholderColor('#bbb').fontSize(15)
            .backgroundColor('#f8f8f8').borderRadius(8)

          TextInput({ placeholder: '密码 (type: Password)' })
            .type(InputType.Password)
            .backgroundColor('#f8f8f8').borderRadius(8).margin({ top: 10 })

          TextInput({ placeholder: '邮箱 (type: Email)' })
            .type(InputType.Email)
            .backgroundColor('#f8f8f8').borderRadius(8).margin({ top: 10 })

          TextInput({ placeholder: '手机号 (type: PhoneNumber)' })
            .type(InputType.PhoneNumber)
            .backgroundColor('#f8f8f8').borderRadius(8).margin({ top: 10 })

          /**
           * if/else 条件渲染 —— ArkUI 支持在 build/builder 中写 if/else 控制 UI 显隐。
           * 原理：框架在状态变化时重新执行 build，if 条件为 false 时该节点从树中移除。
           * 与 .visibility() 的区别：
           *   if 渲染控制：条件为 false 时节点不存在，不占用布局空间。
           *   .visibility(Visibility.Hidden)：节点存在，仍占空间，只是不可见。
           */
          if (this.inputValue.length > 0) {
            Row({ space: 4 }) {
              Text('当前值：').fontSize(13).fontColor('#999')
              Text(this.inputValue).fontSize(13).fontColor('#667eea').fontWeight(FontWeight.Medium)
            }
            .margin({ top: 8 })
          }
        }
        .cardStyle()

        // ── 卡片 3：Toggle / Checkbox / Radio ─────────────────────────────
        Column() {
          this.SectionHeader('Toggle / Checkbox / Radio', '选择')

          /**
           * Toggle({ type: ToggleType.Switch, isOn: bool })
           *   type:
           *     ToggleType.Switch   开关拨动（最常用）
           *     ToggleType.Checkbox 方形复选框样式
           *     ToggleType.Button   按钮切换样式
           *   isOn —— 当前开关状态（受控）
           *   .onChange((on: boolean) => {}) —— 状态变化回调
           *   .selectedColor() —— 开启时的颜色
           *
           * Row + Blank：Blank 是弹性占位组件，自动撑满剩余空间，
           *   实现"左侧文字 + 右侧开关"的两端对齐效果。
           */
          Row() {
            Text('夜间模式').fontSize(14).fontColor('#333').layoutWeight(1)
            // layoutWeight(1) 与 Blank() 效果相同：占据剩余空间
            Toggle({ type: ToggleType.Switch, isOn: this.toggleOn })
              .onChange((on: boolean) => { this.toggleOn = on })
              .selectedColor('#667eea')
          }
          .width('100%').alignItems(VerticalAlign.Center)

          Divider().margin({ top: 12, bottom: 12 }).color('#f0f0f0')

          Text('Checkbox 多选（可多选）').fontSize(12).fontColor('#999').margin({ bottom: 8 })
          /**
           * Checkbox({ name: string, group: string })
           *   name  —— 本 Checkbox 的唯一标识
           *   group —— 所属分组名（同组 Checkbox 之间相互独立，均可选中）
           *   .select(bool)           —— 受控：当前是否选中
           *   .onChange((v: bool)=>{}) —— 选中状态变化回调
           *   .selectedColor()        —— 选中时的颜色
           *
           * 注意：Checkbox 是多选组件，同组内可同时选中多个。
           *       与 Radio 的核心区别：Radio 是互斥单选。
           */
          Row({ space: 20 }) {
            Row({ space: 6 }) {
              Checkbox({ name: 'a', group: 'g1' }).select(this.checkA)
                .onChange((v: boolean) => { this.checkA = v })
                .selectedColor('#667eea')
              Text('ArkTS').fontSize(14)
            }
            Row({ space: 6 }) {
              Checkbox({ name: 'b', group: 'g1' }).select(this.checkB)
                .onChange((v: boolean) => { this.checkB = v })
                .selectedColor('#667eea')
              Text('ArkUI').fontSize(14)
            }
          }

          Divider().margin({ top: 12, bottom: 12 }).color('#f0f0f0')

          Text('Radio 单选（互斥）').fontSize(12).fontColor('#999').margin({ bottom: 8 })
          /**
           * Radio({ value: string, group: string })
           *   value —— 本 Radio 代表的值（选中时赋给 @State）
           *   group —— 所属分组（同组只能选中一个）
           *   .checked(bool)              —— 受控：是否选中（与 @State 对比判断）
           *   .onChange((checked: bool)=>{}) —— 选中状态变化回调
           *                                   注意：取消选中时也会触发（checked=false），
           *                                   因此要加 if (checked) 判断。
           *
           * ForEach(['A','B','C'], ...) —— 遍历数组动态生成组件，
           *   第一个参数：数据数组
           *   第二个参数：(item, index) => {} 渲染函数
           *   第三个参数（可选）：key 生成函数，提升列表更新性能
           */
          Row({ space: 16 }) {
            ForEach(['A', 'B', 'C'], (val: string) => {
              Row({ space: 6 }) {
                Radio({ value: val, group: 'rg' })
                  .checked(this.radioVal === val)           // 与当前选中值对比
                  .onChange((checked: boolean) => {
                    if (checked) this.radioVal = val        // 仅在"变为选中"时更新
                  })
                Text(`选项 ${val}`).fontSize(14)
              }
            })
          }
          Text(`已选：选项 ${this.radioVal}`).fontSize(13).fontColor('#667eea').margin({ top: 8 })
        }
        .cardStyle()

        // ── 卡片 4：Slider / Progress / Rating ────────────────────────────
        Column() {
          this.SectionHeader('Slider / Progress / Rating', '控件')

          /**
           * Slider({ value, min, max, step?, style? })
           *   value —— 当前值（受控）
           *   min   —— 最小值
           *   max   —— 最大值
           *   step  —— 步进值（默认 1）
           *   style —— SliderStyle.OutSet（拇指在轨道外）
           *             SliderStyle.InSet（拇指在轨道内，细线风格）
           *
           * .onChange((v: number) => {}) —— 拖动时持续回调
           *   Math.round(v) 将浮点数四舍五入为整数
           * .selectedColor()  —— 已选中部分（左侧）的颜色
           * .trackColor()     —— 轨道背景色
           * .layoutWeight(1)  —— 在 Row 中占据剩余宽度（弹性布局权重）
           */
          Row({ space: 8 }) {
            Text('进度').fontSize(14).fontColor('#444').width(32)
            Slider({ value: this.sliderVal, min: 0, max: 100 })
              .onChange((v: number) => { this.sliderVal = Math.round(v) })
              .selectedColor('#667eea').trackColor('#e0e0e0')
              .layoutWeight(1)   // 撑满 Row 剩余空间
            Text(`${this.sliderVal}%`)
              .fontSize(13).fontColor('#667eea').width(36).textAlign(TextAlign.End)
          }
          .width('100%').alignItems(VerticalAlign.Center)

          Divider().margin({ top: 12, bottom: 12 }).color('#f0f0f0')

          /**
           * Progress({ value, total, type })
           *   value —— 当前进度值（此处绑定 sliderVal，拖 Slider 时同步变化）
           *   total —— 总量（通常为 100）
           *   type  —— 进度条样式：
           *     ProgressType.Linear  线性横条（最常用）
           *     ProgressType.Ring    环形圆圈
           *     ProgressType.Eclipse 月食（圆形填充）
           *     ProgressType.Capsule 胶囊形
           *     ProgressType.ScaleRing 刻度环
           *
           * .color()           进度已完成部分颜色
           * .backgroundColor() 进度未完成部分颜色（轨道色）
           */
          Row({ space: 16 }) {
            Column({ space: 6 }) {
              Text('Linear 线性').fontSize(11).fontColor('#888')
              Progress({ value: this.sliderVal, total: 100, type: ProgressType.Linear })
                .color('#667eea').backgroundColor('#e0e0e0').width(100)
            }
            Column({ space: 6 }) {
              Text('Ring 环形').fontSize(11).fontColor('#888')
              Progress({ value: this.sliderVal, total: 100, type: ProgressType.Ring })
                .color('#2ecc71').backgroundColor('#e0e0e0').width(50).height(50)
            }
            Column({ space: 6 }) {
              Text('Capsule').fontSize(11).fontColor('#888')
              Progress({ value: this.sliderVal, total: 100, type: ProgressType.Capsule })
                .color('#e74c3c').backgroundColor('#ffe0e0').width(72).height(22)
            }
          }

          Divider().margin({ top: 12, bottom: 12 }).color('#f0f0f0')

          Text('Rating 星级评分').fontSize(12).fontColor('#888').margin({ bottom: 6 })
          /**
           * Rating({ rating: number, indicator?: bool })
           *   rating    —— 当前评分（受控）
           *   indicator —— true 表示只读展示；false 表示可交互（默认 false）
           *
           * .stars(n)       —— 总星数（默认 5）
           * .stepSize(n)    —— 最小步进（0.5 = 支持半星评分）
           * .onChange(v=>{}) —— 评分变化回调
           */
          Rating({ rating: this.ratingVal, indicator: false })
            .onChange((v: number) => { this.ratingVal = v })
            .stars(5).stepSize(0.5)
          Text(`当前评分：${this.ratingVal} ⭐`).fontSize(13).fontColor('#888').margin({ top: 6 })
        }
        .cardStyle()

      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 16, bottom: 32 })
    }
    .scrollBar(BarState.Off)
    .height('100%')
  }

  // ═══════════════════════════════════════════════════════════════════
  // Tab 3 —— 布局组件（LayoutTab）
  // ═══════════════════════════════════════════════════════════════════
  @Builder
  LayoutTab() {
    Scroll() {
      Column() {

        // ── 卡片 1：Row 水平布局 ──────────────────────────────────────────
        Column() {
          this.SectionHeader('Row 水平布局', '布局')
          /**
           * Row —— 水平方向线性布局容器（主轴=横轴）
           *   Row({ space: N }) —— 子组件横向间距
           *
           * justifyContent —— 主轴（横向）对齐方式（与 CSS flexbox 一致）：
           *   FlexAlign.Start        靠左（默认）
           *   FlexAlign.Center       居中
           *   FlexAlign.End          靠右
           *   FlexAlign.SpaceBetween 两端对齐，子组件等间距
           *   FlexAlign.SpaceAround  子组件两侧等间距（包含边缘）
           *   FlexAlign.SpaceEvenly  所有间距完全相等（含首尾）
           *
           * alignItems —— 交叉轴（纵向）对齐方式：
           *   VerticalAlign.Top    顶对齐
           *   VerticalAlign.Center 居中（默认）
           *   VerticalAlign.Bottom 底对齐
           */
          Column({ space: 8 }) {
            Text('justifyContent: Start').fontSize(11).fontColor('#999')
            Row({ space: 6 }) {
              /**
               * ForEach 动态生成三个色块
               * idx 是下标（0/1/2），用三元运算符选择不同背景色
               */
              ForEach(['Box1', 'Box2', 'Box3'], (item: string, idx: number) => {
                Text(item).fontSize(13).fontColor(Color.White)
                  .padding({ left: 10, right: 10, top: 6, bottom: 6 })
                  .backgroundColor(idx === 0 ? '#667eea' : idx === 1 ? '#2ecc71' : '#e74c3c')
                  .borderRadius(6)
              })
            }
            .width('100%').justifyContent(FlexAlign.Start)

            Text('justifyContent: SpaceBetween').fontSize(11).fontColor('#999').margin({ top: 4 })
            Row() {
              Text('Left').fontSize(13).padding(8).backgroundColor('#f0f0ff').borderRadius(6)
              Text('Mid').fontSize(13).padding(8).backgroundColor('#f0fff0').borderRadius(6)
              Text('Right').fontSize(13).padding(8).backgroundColor('#fff0f0').borderRadius(6)
            }
            .width('100%').justifyContent(FlexAlign.SpaceBetween)

            // 演示 alignItems：三个不同高度的色块底部对齐
            Text('alignItems: Bottom / Center / Top').fontSize(11).fontColor('#999').margin({ top: 4 })
            Row({ space: 6 }) {
              Text('高').fontSize(14).fontColor(Color.White)
                .width(48).height(60).textAlign(TextAlign.Center)
                .backgroundColor('#667eea').borderRadius(6)
              Text('中').fontSize(14).fontColor(Color.White)
                .width(48).height(40).textAlign(TextAlign.Center)
                .backgroundColor('#9b59b6').borderRadius(6)
              Text('低').fontSize(14).fontColor(Color.White)
                .width(48).height(24).textAlign(TextAlign.Center)
                .backgroundColor('#2ecc71').borderRadius(6)
            }
            .width('100%').alignItems(VerticalAlign.Bottom) // 三个色块底部对齐
          }
        }
        .cardStyle()

        // ── 卡片 2：Stack 层叠布局 ────────────────────────────────────────
        Column() {
          this.SectionHeader('Stack 层叠布局', '布局')
          /**
           * Stack —— 层叠容器，子组件按声明顺序堆叠（后声明的在上层）。
           *   alignContent —— 子组件的默认对齐位置：
           *     Alignment.TopStart / Top / TopEnd
           *     Alignment.Start / Center / End
           *     Alignment.BottomStart / Bottom / BottomEnd
           *
           * 应用场景：背景图 + 文字叠加、图标角标、弹层遮罩等。
           * 子组件可用 .zIndex(n) 手动控制叠放层级（值越大越靠上）。
           */
          Stack() {
            // 最底层：最大的矩形
            Text('').width(160).height(100).backgroundColor('#e8eaf6').borderRadius(14)
            // 中间层：居中叠加
            Text('').width(110).height(70).backgroundColor('#c5cae9').borderRadius(14)
            // 次上层：最小矩形
            Text('').width(60).height(40).backgroundColor('#7986cb').borderRadius(14)
            // 最上层：文字标签
            Text('STACK').fontSize(13).fontColor(Color.White).fontWeight(FontWeight.Bold)
          }
          .height(110).alignContent(Alignment.Center) // 所有子组件默认居中对齐

          Text('通过 alignContent 控制子组件的默认对齐').fontSize(12).fontColor('#999').margin({ top: 8 })
        }
        .cardStyle()

        // ── 卡片 3：Flex 弹性换行 ─────────────────────────────────────────
        Column() {
          this.SectionHeader('Flex 弹性换行', '布局')
          /**
           * Flex —— 弹性布局容器，类似 CSS Flexbox。
           *   direction     主轴方向：FlexDirection.Row(默认) / Column
           *   wrap          换行模式：
           *     FlexWrap.NoWrap  不换行（默认），子组件可能溢出或压缩
           *     FlexWrap.Wrap    超出自动换行（从左到右再折行）
           *     FlexWrap.WrapReverse 反向换行
           *   justifyContent 主轴对齐方式（FlexAlign.xxx）
           *   alignItems     交叉轴对齐方式（ItemAlign.xxx）
           *   alignContent   多行时行间对齐（FlexAlign.xxx）
           *
           * Row / Column 是 Flex 的语法糖（简化版），
           * 当需要换行或精细控制时改用 Flex。
           */
          Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Start }) {
            ForEach(
              ['ArkTS', 'ArkUI', 'UIAbility', 'Want', 'hilog', 'Scroll', 'Column', 'Row', 'Grid', 'Tabs', 'Flex', 'Stack'],
              (tag: string) => {
                Text(tag).fontSize(12).fontColor('#667eea')
                  .padding({ left: 8, right: 8, top: 4, bottom: 4 })
                  .backgroundColor('#f0f0ff').borderRadius(20)
                  .margin({ right: 6, bottom: 6 }) // 标签之间的间距
              }
            )
          }
          .width('100%')
          Text('FlexWrap.Wrap 自动换行，FlexAlign.Start 左对齐').fontSize(11).fontColor('#999').margin({ top: 6 })
        }
        .cardStyle()

        // ── 卡片 4：Grid 网格布局 ─────────────────────────────────────────
        Column() {
          this.SectionHeader('Grid 网格布局', '布局')
          Text('columnsTemplate: \'1fr 1fr 1fr\'').fontSize(11).fontColor('#999').margin({ bottom: 8 })
          /**
           * Grid —— 网格容器，子组件必须是 GridItem。
           *
           * columnsTemplate —— 列定义字符串（类似 CSS grid-template-columns）
           *   '1fr 1fr 1fr'    3 列等宽
           *   '100 1fr 2fr'    第1列固定 100vp，第2/3列按 1:2 分配剩余空间
           *   'repeat(4, 1fr)' 4 列等宽（简写）
           *
           * rowsTemplate    —— 行定义（不设则根据内容自动增加行数）
           * rowsGap         —— 行间距
           * columnsGap      —— 列间距
           *
           * GridItem —— Grid 的子组件
           *   .columnStart/columnEnd —— 跨列（合并单元格）
           *   .rowStart/rowEnd       —— 跨行
           */
          Grid() {
            ForEach(this.gridEntries, (item: GridEntry) => {
              GridItem() {
                Column({ space: 6 }) {
                  Text(item.icon).fontSize(26)
                  Text(item.label).fontSize(12).fontColor('#555')
                }
                .width('100%').height(72)
                .justifyContent(FlexAlign.Center)
                .backgroundColor('#f8f9ff')
                .borderRadius(10)
                .border({ width: 1, color: '#e8eaf6' })
              }
            })
          }
          .columnsTemplate('1fr 1fr 1fr') // 三列等宽
          .rowsGap(8)                     // 行间距
          .columnsGap(8)                  // 列间距
        }
        .cardStyle()

        // ── 卡片 5：List 列表 ─────────────────────────────────────────────
        Column() {
          this.SectionHeader('List 列表', '布局')
          /**
           * List —— 高性能列表容器（虚拟化渲染，适合长列表）。
           *   子组件必须是 ListItem。
           *
           * .divider() —— 列表项之间的分割线：
           *   { strokeWidth: 线宽, color: 颜色, startMargin?: 左缩进, endMargin?: 右缩进 }
           *
           * List vs Column + ForEach：
           *   - 数据量少（< 20条）：Column + ForEach 即可
           *   - 数据量大：List 会懒加载（只渲染可视区域），性能更好
           *
           * 其他常用 List 属性：
           *   .scrollBar()     滚动条显示
           *   .listDirection() 列表方向（Axis.Vertical / Horizontal）
           *   .lanes()         多列显示
           *   .onScrollIndex() 滚动位置回调
           */
          List() {
            ForEach(this.listEntries, (item: ListEntry) => {
              ListItem() {
                Row() {
                  Column({ space: 3 }) {
                    Text(item.title)
                      .fontSize(14).fontColor('#222').fontWeight(FontWeight.Medium)
                    Text(item.sub)
                      .fontSize(12).fontColor('#aaa')
                  }
                  .alignItems(HorizontalAlign.Start)
                  /**
                   * layoutWeight(1) —— 在 Row/Column 中按权重分配剩余空间。
                   * 等同于 CSS flex: 1。此处让左侧文字区域占满剩余宽度，
                   * 右侧箭头图标保持固定宽度。
                   */
                  .layoutWeight(1)

                  Text('›').fontSize(18).fontColor('#ddd')
                }
                .width('100%')
                .padding({ top: 12, bottom: 12 })
                .alignItems(VerticalAlign.Center)
              }
            })
          }
          .divider({ strokeWidth: 1, color: '#f5f5f5' }) // 列表项分割线
        }
        .cardStyle()

      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 16, bottom: 32 })
    }
    .scrollBar(BarState.Off)
    .height('100%')
  }

  // ═══════════════════════════════════════════════════════════════════
  // Tab 4 —— 动画 & 事件（AnimationTab）
  // ═══════════════════════════════════════════════════════════════════
  @Builder
  AnimationTab() {
    Scroll() {
      Column() {

        // ── 卡片 1：animateTo 属性动画 ────────────────────────────────────
        Column() {
          this.SectionHeader('animateTo 属性动画', '动画')
          /**
           * animateTo(options, callback) —— ArkUI 属性动画的核心 API。
           *
           *   options 参数：
           *     duration: number  动画时长（毫秒）
           *     curve: Curve.xxx  动画曲线（影响加速/减速节奏）
           *     delay?: number    延迟时间（毫秒，默认 0）
           *     iterations?: number 重复次数（-1 = 无限循环）
           *     playMode?: PlayMode.Normal / Reverse / Alternate
           *     onFinish?: () => void  动画结束回调
           *
           *   callback —— 在此函数内修改 @State 变量，框架自动对
           *               变化前后的属性值做插值动画。
           *
           * 原理：animateTo 告诉框架"下一次状态变化要用动画过渡"，
           *        callback 内的 @State 赋值触发 UI 树对比，
           *        框架对属性差值做帧间插值（类似 CSS transition）。
           *
           * 支持动画的属性（部分）：
           *   .scale() .rotate() .translate() .opacity()
           *   .width() .height() .margin() .padding()
           *   .backgroundColor() .borderRadius()
           */
          Row({ space: 10 }) {

            // 缩放动画：.scale({ x, y }) 控制 X/Y 轴缩放比例（1.0 = 原始大小）
            Column({ space: 8 }) {
              Text('缩放').fontSize(13).fontColor(Color.White)
                .width(68).height(38).textAlign(TextAlign.Center)
                .backgroundColor('#667eea').borderRadius(8)
                .scale({ x: this.animScale, y: this.animScale }) // 绑定 @State
                .onClick(() => {
                  animateTo({ duration: 400, curve: Curve.EaseInOut }, () => {
                    // 三元运算切换：1.0 ↔ 1.4（放大 40%）
                    this.animScale = this.animScale === 1.0 ? 1.4 : 1.0
                  })
                })
              Text('scale').fontSize(11).fontColor('#999')
            }

            // 旋转动画：.rotate({ angle }) 控制旋转角度（度，顺时针为正）
            Column({ space: 8 }) {
              Text('旋转').fontSize(13).fontColor(Color.White)
                .width(68).height(38).textAlign(TextAlign.Center)
                .backgroundColor('#2ecc71').borderRadius(8)
                .rotate({ angle: this.animRotate }) // 绑定 @State
                .onClick(() => {
                  animateTo({ duration: 500, curve: Curve.Linear }, () => {
                    this.animRotate += 180 // 每次点击累加 180°，连续点击持续旋转
                  })
                })
              Text('rotate').fontSize(11).fontColor('#999')
            }

            // 透明度动画：.opacity(0~1)
            Column({ space: 8 }) {
              Text('透明').fontSize(13).fontColor(Color.White)
                .width(68).height(38).textAlign(TextAlign.Center)
                .backgroundColor('#e74c3c').borderRadius(8)
                .opacity(this.animOpacity) // 0 = 全透明，1 = 完全不透明
                .onClick(() => {
                  animateTo({ duration: 300, curve: Curve.EaseOut }, () => {
                    this.animOpacity = this.animOpacity === 1.0 ? 0.15 : 1.0
                  })
                })
              Text('opacity').fontSize(11).fontColor('#999')
            }

            // 位移动画：.translate({ x?, y?, z? }) 相对当前位置偏移（不影响布局）
            Column({ space: 8 }) {
              Text('弹跳').fontSize(13).fontColor('#764ba2')
                .width(68).height(38).textAlign(TextAlign.Center)
                .backgroundColor('#f0e6ff').borderRadius(8)
                .translate({ y: this.animTranslateY }) // Y 轴位移（负值=向上）
                .onClick(() => {
                  animateTo({ duration: 600, curve: Curve.EaseInOut }, () => {
                    this.animTranslateY = this.animTranslateY === 0 ? -16 : 0
                  })
                })
              Text('translate').fontSize(11).fontColor('#999')
            }
          }
          .width('100%').justifyContent(FlexAlign.SpaceEvenly) // 四个按钮均匀分布

          Text('点击上方卡片体验对应动画效果').fontSize(12).fontColor('#bbb').margin({ top: 12 })
        }
        .cardStyle()

        // ── 卡片 2：Curve 动画曲线速查 ────────────────────────────────────
        Column() {
          this.SectionHeader('Curve 动画曲线速查', '参考')
          /**
           * Curve 枚举值速查（传给 animateTo 的 curve 参数）：
           *
           *  Curve.Linear     匀速，适合持续旋转/匀速移动
           *  Curve.Ease       慢→快→慢，通用场景默认选择
           *  Curve.EaseIn     慢入→快出，元素"飞出"效果
           *  Curve.EaseOut    快入→慢出，元素"落地"效果
           *  Curve.EaseInOut  慢→快→慢（比 Ease 更平缓）
           *  Curve.Spring     弹簧物理效果（超调后回弹），最生动
           *  Curve.Bounce     结束时弹跳，类似球落地
           *  Curve.Friction   摩擦力阻尼，类似手指滑动松开后减速停止
           *
           * 还可用 cubicBezierCurve(x1,y1,x2,y2) 自定义贝塞尔曲线。
           */
          Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Start }) {
            ForEach(this.curveEntries, (item: CurveEntry) => {
              Text(item.name).fontSize(12).fontColor(item.color)
                .padding({ left: 8, right: 8, top: 4, bottom: 4 })
                .border({ width: 1, color: item.color }).borderRadius(6)
                .margin({ right: 6, bottom: 6 })
            })
          }
          .width('100%')
          Text('传入 animateTo({ curve: Curve.xxx }) 使用').fontSize(11).fontColor('#bbb').margin({ top: 6 })
        }
        .cardStyle()

        // ── 卡片 3：onTouch 触摸事件 ──────────────────────────────────────
        Column() {
          this.SectionHeader('onTouch 触摸事件', '事件')
          /**
           * onTouch(e: TouchEvent) —— 底层触摸事件，比 onClick 更细粒度。
           *
           * TouchEvent 属性：
           *   e.type —— 触摸类型枚举：
           *     TouchType.Down   手指按下屏幕
           *     TouchType.Move   手指在屏幕上滑动
           *     TouchType.Up     手指抬起离开屏幕
           *     TouchType.Cancel 触摸被系统取消（如来电打断）
           *
           *   e.touches      —— 当前所有接触点（多指触控）
           *   e.changedTouches —— 本次事件中发生变化的触点
           *   每个触点包含：x, y（相对组件坐标），screenX, screenY（屏幕坐标）
           *
           * 事件冒泡：触摸事件默认向父组件冒泡，
           *   若要阻止冒泡：return true（stopPropagation）
           *
           * 常用通用事件（任何组件均可绑定）：
           *   onClick()         单击
           *   onTouch()         触摸
           *   onHover()         悬停（鼠标/手写笔）
           *   onFocus()         获取焦点
           *   onBlur()          失去焦点
           *   onKeyEvent()      键盘按键
           *   onAppear()        组件挂载到 UI 树时
           *   onDisAppear()     组件从 UI 树移除时
           */
          Column() {
            Text(this.touchText).fontSize(14).fontColor('#555').textAlign(TextAlign.Center)
          }
          .width('100%').height(80)
          .justifyContent(FlexAlign.Center)
          .backgroundColor('#f8f9ff').borderRadius(12)
          .border({ width: 1.5, color: '#e0e3ff', style: BorderStyle.Dashed })
          .onTouch((e: TouchEvent) => {
            if (e.type === TouchType.Down) {
              this.touchText = '👇  手指按下 (TouchType.Down)'
            } else if (e.type === TouchType.Move) {
              this.touchText = '👆  手指滑动 (TouchType.Move)'
            } else {
              this.touchText = '✅  手指抬起 (TouchType.Up)'
            }
          })

          Text('onClick / onTouch / onFocus / onBlur / onKeyEvent 均为通用事件')
            .fontSize(11).fontColor('#bbb').margin({ top: 10 })
        }
        .cardStyle()

        // ── 卡片 4：状态装饰器速查表 ──────────────────────────────────────
        Column() {
          this.SectionHeader('状态装饰器速查表', '参考')
          /**
           * ArkUI 状态管理装饰器汇总：
           *
           * @State      组件内部状态，变化触发本组件 UI 刷新。
           *             初始化：= 初始值；不可跨组件直接访问。
           *
           * @Prop       父组件 → 子组件 单向传递。
           *             子组件内部可修改，但不会同步回父组件。
           *             父组件变化时会覆盖子组件的本地修改。
           *
           * @Link       父子组件双向绑定（$变量名 传入）。
           *             任何一方修改，双方同步更新。
           *
           * @Provide    祖先组件向后代注入数据（跨多层）。
           *             用法：@Provide('key') val = xxx
           *
           * @Consume    后代组件消费祖先注入的数据。
           *             用法：@Consume('key') val: Type
           *             不需要显式 props 传递，自动查找最近的 @Provide。
           *
           * @Builder    自定义构建函数（UI 片段复用，非独立组件）。
           *
           * @Styles     通用样式抽取（所有组件通用属性）。
           *
           * @Extend     特定组件样式扩展（可用组件专有属性）。
           *
           * 其他进阶：
           *   @ObjectLink    引用类型跨组件共享（配合 @Observed）
           *   @Observed      标记类，使其属性变化可被检测
           *   @Watch         监听 @State/@Prop 变化后执行回调
           *                  用法：@State @Watch('onXxxChange') val = xxx
           */
          Column({ space: 10 }) {
            ForEach(this.decorators, (item: DecoratorItem) => {
              Row({ space: 10 }) {
                Text(item.tag).fontSize(12).fontColor('#764ba2')
                  .backgroundColor('#f5e6ff')
                  .padding({ left: 6, right: 6, top: 3, bottom: 3 })
                  .borderRadius(4).width(86).textAlign(TextAlign.Center)
                Text(item.desc).fontSize(13).fontColor('#555').layoutWeight(1)
              }
              .width('100%').alignItems(VerticalAlign.Center)
            })
          }
        }
        .cardStyle()

      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 16, bottom: 32 })
    }
    .scrollBar(BarState.Off)
    .height('100%')
  }

  // ═══════════════════════════════════════════════════════════════════
  // build() —— 页面根入口
  //
  //  每个 @Component struct 都必须实现 build() 方法。
  //  build() 描述组件的 UI 结构，框架在首次渲染和状态更新时调用。
  //  规则：
  //   1. build() 内只能写 UI 描述，不能有 if 以外的流程控制（不能用 for 循环，用 ForEach）
  //   2. 不能有 console.log 等副作用（放在事件回调中）
  //   3. 必须有且只有一个根组件
  // ═══════════════════════════════════════════════════════════════════
  build() {
    /**
     * Column —— 垂直方向线性布局（主轴=纵轴），页面根容器。
     * .width('100%').height('100%') —— 铺满整个屏幕。
     * .backgroundColor('#f2f3f7')  —— 页面背景色（浅灰），
     *   卡片白色背景与此形成对比，产生层次感。
     */
    Column() {

      // ── Header 顶部横幅 ────────────────────────────────────────────────
      Row() {
        Column({ space: 4 }) {
          Text('鸿蒙学习手册')
            .fontSize(22).fontWeight(FontWeight.Bold).fontColor(Color.White)
          Text('ArkUI 组件全览 · HarmonyOS 6.0.2')
            .fontSize(11).fontColor('rgba(255,255,255,0.75)') // RGBA 颜色字符串
        }
        .alignItems(HorizontalAlign.Start) // 左侧文字左对齐

        /**
         * Blank —— 弹性空白占位组件。
         *   在 Row 中撑满两侧组件之间的剩余空间，
         *   实现"左侧内容 + 右侧内容"两端对齐，等同于 flex: 1 空 div。
         */
        Blank()

        // 右上角版本标签
        Text('API 22').fontSize(11).fontColor(Color.White)
          .padding({ left: 8, right: 8, top: 4, bottom: 4 })
          .backgroundColor('rgba(255,255,255,0.2)') // 半透明白色
          .borderRadius(12)
      }
      .width('100%')
      .padding({ left: 20, right: 20, top: 52, bottom: 20 }) // top: 52 为状态栏预留空间
      /**
       * linearGradient —— 线性渐变背景。
       *   angle: 135  渐变角度（0=向下，90=向右，135=右下角）
       *   colors: [ [颜色, 位置], ... ]
       *     颜色可以是字符串 '#RRGGBB' 或 Color 枚举
       *     位置是 0.0~1.0 的浮点数（渐变停止点）
       */
      .linearGradient({ angle: 135, colors: [['#667eea', 0.0], ['#764ba2', 1.0]] })

      // ── Tabs 选项卡 ────────────────────────────────────────────────────
      /**
       * Tabs({ index, controller? }) —— 选项卡容器
       *   index —— 当前显示的 Tab 下标（受控），绑定 @State activeTab
       *
       * TabContent() { ... }.tabBar(builder) —— 每个 Tab 页
       *   tabBar 参数类型：
       *     string              纯文字标签
       *     Resource            图片资源
       *     CustomBuilder       自定义 @Builder 函数（本例使用此方式）
       *
       * Tabs 关键属性：
       *   .barPosition(BarPosition.Start)  Tab 栏位于顶部（End=底部）
       *   .barMode(BarMode.Fixed)          等宽固定分布；Scrollable=可滚动
       *   .barBackgroundColor()            Tab 栏背景色
       *   .onChange((index: number) => {}) Tab 切换回调，更新 activeTab
       *   .layoutWeight(1)                 在 Column 中占据剩余所有高度
       *
       * 注意：.onChange 回调中更新 activeTab，
       *       TabBarText/Interact/Layout/Anim 内的 this.TabItem 依赖 activeTab，
       *       切换时 Tab 栏图标颜色/字重会自动刷新（响应式渲染）。
       */
      Tabs({ index: this.activeTab }) {
        // this.TabBarText 传递 @Builder 方法引用（不加括号），框架负责调用
        TabContent() { this.OverviewTab() }.tabBar(this.TabBarOverview)
        TabContent() { this.TextTab() }.tabBar(this.TabBarText)
        TabContent() { this.InteractiveTab() }.tabBar(this.TabBarInteract)
        TabContent() { this.LayoutTab() }.tabBar(this.TabBarLayout)
        TabContent() { this.AnimationTab() }.tabBar(this.TabBarAnim)
      }
      .barPosition(BarPosition.Start)               // Tab 栏在顶部
      .barMode(BarMode.Fixed)                        // 固定等宽布局
      .barBackgroundColor(Color.White)               // Tab 栏白色背景
      .onChange((index: number) => { this.activeTab = index }) // 同步选中下标
      .layoutWeight(1)                               // 占满 Column 剩余高度
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f2f3f7') // 浅灰页面背景
  }
}
