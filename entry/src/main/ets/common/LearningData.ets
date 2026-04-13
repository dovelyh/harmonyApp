/**
 * 这个文件集中维护整个“鸿蒙学习中心”用到的模拟数据和数据结构。
 * 好处有三个：
 * 1. 首页、专题页、案例页都能复用同一份数据模型。
 * 2. 用户以后想继续扩展页面时，只需要先补数据，再补 UI。
 * 3. 这些 interface 本身就是 ArkTS 常见类型声明示例，适合作为学习参考。
 */

/**
 * 学习专题条目：
 * - 首页会把它渲染成学习卡片。
 * - 搜索框会基于 title / subtitle / tags 做过滤。
 */
export interface LearningTopic {
  id: string
  title: string
  subtitle: string
  route: string
  category: string
  level: string
  estimatedTime: string
  tags: string[]
  highlights: string[]
}

/**
 * 学习阶段条目：
 * - 用于首页学习路径展示。
 * - value 可以理解为阶段代号，便于后续筛选或埋点。
 */
export interface LearningStage {
  title: string
  value: string
  description: string
  target: string
}

/**
 * 案例市场条目：
 * - 首页会展示精选案例。
 * - 案例市场页会展示更完整的卡片列表。
 */
export interface PracticeCase {
  id: string
  title: string
  summary: string
  route: string
  scene: string
  difficulty: string
  badge: string
  skills: string[]
}

/**
 * 资讯案例的文章结构。
 * - category 用于分类切换
 * - readTime 用于模拟阅读时长
 */
export interface NewsArticle {
  id: number
  title: string
  summary: string
  category: string
  author: string
  readTime: string
  hot: boolean
  tags: string[]
}

/**
 * 商城案例的商品结构。
 * - stock 用于演示库存标签
 * - rating 用于演示评分展示
 */
export interface ProductItem {
  id: number
  name: string
  category: string
  price: number
  rating: number
  stock: number
  desc: string
  featured: boolean
}

/**
 * 设置项结构：
 * - type 决定是跳转项、开关项还是危险操作
 */
export interface SettingItem {
  id: string
  title: string
  desc: string
  type: string
  valueText: string
}

/**
 * 数据看板指标卡结构：
 * - trend 用来描述增长/下降趋势
 * - color 用来驱动卡片强调色
 */
export interface DashboardMetric {
  id: string
  title: string
  value: string
  trend: string
  color: string
}

/**
 * 数据看板任务结构：
 * - progress 用于 Progress 组件展示完成度
 */
export interface DashboardTask {
  id: string
  title: string
  owner: string
  progress: number
  status: string
}

/**
 * 排行榜结构：
 * - score 用来模拟项目成绩、活跃度或转化指标
 */
export interface DashboardRankItem {
  id: string
  name: string
  score: number
  label: string
}

/**
 * 首页学习阶段：
 * 这里故意把目标写得偏实战一些，帮助学习者建立“为什么学这一组内容”的认知。
 */
export const LEARNING_STAGES: LearningStage[] = [
  {
    title: '阶段 1 · 打基础',
    value: 'foundation',
    description: '先掌握 ArkTS 语法、状态装饰器、基础组件和常见布局。',
    target: '能独立写出中小页面和简单组件。'
  },
  {
    title: '阶段 2 · 做页面',
    value: 'page',
    description: '理解路由、生命周期、表单交互、数据渲染和页面结构组织。',
    target: '能完成设置页、列表页、详情页这类常见页面。'
  },
  {
    title: '阶段 3 · 做业务',
    value: 'business',
    description: '通过资讯、商城、看板等案例，学习真实业务页面的拆分方式。',
    target: '能把技术点拼成完整业务场景。'
  }
]

/**
 * 首页专题卡片：
 * 这里的 route 必须和 pages 目录中的页面路径保持一致。
 */
export const LEARNING_TOPICS: LearningTopic[] = [
  {
    id: 'arkts',
    title: 'ArkTS 语法馆',
    subtitle: '变量、类型、函数、枚举、数组对象、异步与错误处理',
    route: 'pages/ArkTsGrammarPage',
    category: '语言基础',
    level: '入门',
    estimatedTime: '25 min',
    tags: ['ArkTS', '类型', '函数', 'async'],
    highlights: ['常见语法速查', '数组对象操作', 'Promise 与 await']
  },
  {
    id: 'state',
    title: '状态管理馆',
    subtitle: '@State / @Prop / @Link / @Provide / @Consume 体系化示例',
    route: 'pages/StateManagementPage',
    category: '组件通信',
    level: '入门',
    estimatedTime: '30 min',
    tags: ['状态', '装饰器', '通信', '组件'],
    highlights: ['父子通信', '跨层共享', '双向联动']
  },
  {
    id: 'components',
    title: '高频组件馆',
    subtitle: 'Image、TextArea、Swiper、LoadingProgress 等常见 UI 用法',
    route: 'pages/ComponentsPage',
    category: '组件',
    level: '入门',
    estimatedTime: '28 min',
    tags: ['组件', 'Image', 'Swiper', '表单'],
    highlights: ['缺失组件补齐', '组合式卡片', '空状态与加载态']
  },
  {
    id: 'navigation',
    title: '页面导航与生命周期',
    subtitle: 'router 跳转、参数传递、返回、aboutToAppear 等日常页面知识',
    route: 'pages/NavigationLifecyclePage',
    category: '页面组织',
    level: '进阶',
    estimatedTime: '22 min',
    tags: ['路由', '生命周期', 'router', '参数'],
    highlights: ['页面跳转', '参数读取', '生命周期日志']
  },
  {
    id: 'data',
    title: '数据与业务页',
    subtitle: '模拟接口、加载状态、错误状态、筛选与统计卡片',
    route: 'pages/DataBusinessPage',
    category: '业务开发',
    level: '进阶',
    estimatedTime: '30 min',
    tags: ['数据流', '加载', '筛选', '列表'],
    highlights: ['Promise 模拟请求', '分类筛选', '空状态与错误状态']
  },
  {
    id: 'market',
    title: '功能市场案例',
    subtitle: '把多个知识点拼成完整业务页面，建立实战开发视角',
    route: 'pages/CaseMarketPage',
    category: '综合实战',
    level: '进阶',
    estimatedTime: '35 min',
    tags: ['案例', '资讯', '商城', '设置'],
    highlights: ['多场景练习', '页面结构拆分', '综合 UI 组合']
  }
]

/**
 * 案例市场卡片数据。
 */
export const PRACTICE_CASES: PracticeCase[] = [
  {
    id: 'news',
    title: '资讯流案例',
    summary: '学习分类切换、热门标签、文章列表和推荐区布局。',
    route: 'pages/NewsCasePage',
    scene: '内容产品',
    difficulty: '入门',
    badge: '推荐',
    skills: ['List', 'Badge', '搜索筛选', '标签布局']
  },
  {
    id: 'shop',
    title: '商城列表案例',
    summary: '学习商品卡片、分类过滤、价格信息和购物车数量联动。',
    route: 'pages/ShopCasePage',
    scene: '电商',
    difficulty: '进阶',
    badge: '高频',
    skills: ['Grid', '卡片布局', 'Stepper 逻辑', 'Progress']
  },
  {
    id: 'settings',
    title: '设置中心案例',
    summary: '学习设置分组、开关项、详情项、风险操作和主题反馈。',
    route: 'pages/SettingsCasePage',
    scene: '工具应用',
    difficulty: '入门',
    badge: '常用',
    skills: ['Toggle', 'List', '状态反馈', '表单体验']
  },
  {
    id: 'dashboard',
    title: '数据看板案例',
    summary: '学习指标卡、任务进度、排行列表和运营信息密集页面。',
    route: 'pages/DashboardCasePage',
    scene: '工作台',
    difficulty: '进阶',
    badge: '综合',
    skills: ['统计卡片', 'Progress', '列表排行', '信息分组']
  }
]

/**
 * 资讯案例数据。
 */
export const NEWS_ARTICLES: NewsArticle[] = [
  {
    id: 1,
    title: 'HarmonyOS 首页重构时，先做信息架构还是先写组件？',
    summary: '从业务目标反推页面结构，再决定组件粒度，会比直接堆 UI 更稳。',
    category: '设计',
    author: '学习编辑部',
    readTime: '6 分钟',
    hot: true,
    tags: ['首页', '信息架构']
  },
  {
    id: 2,
    title: 'ArkTS 状态装饰器如何组合使用才不会混乱',
    summary: '通过父子组件、跨层共享和双向联动三个场景，拆清常见装饰器边界。',
    category: '开发',
    author: 'ArkTS Lab',
    readTime: '8 分钟',
    hot: true,
    tags: ['@State', '@Link']
  },
  {
    id: 3,
    title: 'List 与 Column + ForEach 什么时候该切换',
    summary: '数据量、性能诉求和交互复杂度，是选择列表容器时最重要的三个标准。',
    category: '开发',
    author: '组件周刊',
    readTime: '5 分钟',
    hot: false,
    tags: ['List', '性能']
  },
  {
    id: 4,
    title: '做设置页时，如何把看似琐碎的控件组织得更清晰',
    summary: '通过分组标题、辅助说明和风险区隔离，提升设置页的可读性。',
    category: '体验',
    author: '交互观察',
    readTime: '4 分钟',
    hot: false,
    tags: ['设置页', '交互']
  },
  {
    id: 5,
    title: '动画不应该只是花哨，应该承担反馈职责',
    summary: '用缩放、位移、透明度变化来表达状态切换，而不是仅仅为了酷炫。',
    category: '体验',
    author: '动效手册',
    readTime: '7 分钟',
    hot: true,
    tags: ['动画', '反馈']
  },
  {
    id: 6,
    title: '模拟数据页面怎么写，才能更接近真实项目',
    summary: '加载、失败、空态、筛选、统计卡片，缺一不可。',
    category: '设计',
    author: '业务训练营',
    readTime: '5 分钟',
    hot: false,
    tags: ['模拟数据', '业务页']
  }
]

/**
 * 商城案例数据。
 */
export const PRODUCT_ITEMS: ProductItem[] = [
  {
    id: 101,
    name: 'ArkUI 组件速查卡',
    category: '学习资料',
    price: 29.9,
    rating: 4.8,
    stock: 92,
    desc: '适合放在桌面旁边，快速记忆常用组件属性和典型写法。',
    featured: true
  },
  {
    id: 102,
    name: 'HarmonyOS 页面拆解模板',
    category: '项目模板',
    price: 49,
    rating: 4.7,
    stock: 38,
    desc: '包含首页、列表页、设置页、数据看板等通用页面骨架。',
    featured: true
  },
  {
    id: 103,
    name: '状态管理练习集',
    category: '练习题',
    price: 19.9,
    rating: 4.6,
    stock: 135,
    desc: '通过一组练习，理解 @State / @Prop / @Link 的边界和选择标准。',
    featured: false
  },
  {
    id: 104,
    name: '动画参数示例包',
    category: '项目模板',
    price: 36.5,
    rating: 4.5,
    stock: 66,
    desc: '收录常见的缩放、位移、淡入淡出和列表入场动画组合。',
    featured: false
  },
  {
    id: 105,
    name: '业务页面配色参考',
    category: '设计资源',
    price: 12.8,
    rating: 4.3,
    stock: 200,
    desc: '为学习项目准备的浅色卡片风配色方案和状态色建议。',
    featured: false
  },
  {
    id: 106,
    name: '数据卡片组件方案',
    category: '组件方案',
    price: 42,
    rating: 4.9,
    stock: 24,
    desc: '聚焦工作台、看板、运营后台常用的数据卡片布局组合。',
    featured: true
  }
]

/**
 * 设置项数据。
 */
export const SETTING_ITEMS: SettingItem[] = [
  {
    id: 'profile',
    title: '账号与资料',
    desc: '管理头像、昵称、手机号与安全信息',
    type: 'link',
    valueText: '已绑定'
  },
  {
    id: 'sync',
    title: '学习进度同步',
    desc: '将收藏与进度同步到多端设备',
    type: 'toggle',
    valueText: '已开启'
  },
  {
    id: 'notification',
    title: '学习提醒',
    desc: '每天固定时间提醒复盘和练习',
    type: 'toggle',
    valueText: '晚间 21:00'
  },
  {
    id: 'theme',
    title: '主题与显示',
    desc: '调整卡片密度、强调色和字号大小',
    type: 'link',
    valueText: '标准'
  },
  {
    id: 'cache',
    title: '清理缓存',
    desc: '删除模拟图片和临时页面缓存',
    type: 'danger',
    valueText: '128 MB'
  }
]

/**
 * 数据看板指标。
 */
export const DASHBOARD_METRICS: DashboardMetric[] = [
  { id: 'm1', title: '本周学习时长', value: '12.5 h', trend: '+18%', color: '#667eea' },
  { id: 'm2', title: '完成专题数', value: '8', trend: '+2', color: '#2ecc71' },
  { id: 'm3', title: '案例练习次数', value: '14', trend: '+35%', color: '#f39c12' },
  { id: 'm4', title: '组件熟悉度', value: '86%', trend: '+6%', color: '#e74c3c' }
]

/**
 * 数据看板任务。
 */
export const DASHBOARD_TASKS: DashboardTask[] = [
  { id: 't1', title: '补完 ArkTS 异步与错误处理示例', owner: '你自己', progress: 88, status: '进行中' },
  { id: 't2', title: '把设置页拆成可复用分组组件', owner: '页面模块', progress: 64, status: '进行中' },
  { id: 't3', title: '整理商城案例中的筛选逻辑', owner: '业务层', progress: 100, status: '已完成' },
  { id: 't4', title: '增加动画案例的注释密度', owner: '教学页', progress: 42, status: '待完善' }
]

/**
 * 数据看板排行榜。
 */
export const DASHBOARD_RANKING: DashboardRankItem[] = [
  { id: 'r1', name: '状态管理馆', score: 96, label: '最常回看' },
  { id: 'r2', name: '高频组件馆', score: 91, label: '最高实用度' },
  { id: 'r3', name: '商城列表案例', score: 88, label: '业务组合强' },
  { id: 'r4', name: '页面导航与生命周期', score: 84, label: '容易忽视' }
]
