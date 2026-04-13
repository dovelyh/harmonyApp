# Harmony Learning Center — 变更说明文档

> 生成日期：2026-04-13
> 技术栈：HarmonyOS 6.0.2 · API 22 · ArkTS · ArkUI 声明式 UI

---

## 一、总览

本次扩展将原始单页演示工程升级为「鸿蒙 ArkTS 学习中心」，形成 **基础实验 / 专题学习 / 业务案例** 三层学习结构。

| 维度 | 数量 |
|------|------|
| 新增源文件 | 13 |
| 修改源文件 | 2 |
| 新增路由 | 10 |
| 覆盖 ArkTS/ArkUI 知识点 | 50+ |
| 源文件总行数（pages + common）| ~5 700 行 |

---

## 二、新增文件

### 公共数据与逻辑层

| 文件 | 行数 | 说明 |
|------|------|------|
| `entry/src/main/ets/common/LearningData.ets` | 479 | 统一维护全部学习模块、阶段、案例、资讯、商品、任务等 mock 数据结构及常量 |
| `entry/src/main/ets/common/LearningHelpers.ets` | 95 | 纯函数工具：`normalizeKeyword` / `filterLearningTopics` / `filterPracticeCases` / `buildLearningSummary` |

### 单元测试

| 文件 | 行数 | 说明 |
|------|------|------|
| `entry/src/test/LearningHelpers.test.ets` | 37 | 覆盖 normalizeKeyword、filterLearningTopics、buildLearningSummary 三个纯函数 |

### 专题学习页

| 文件 | 行数 | 路由 | 主题 |
|------|------|------|------|
| `entry/src/main/ets/pages/ArkTsGrammarPage.ets` | 362 | `pages/ArkTsGrammarPage` | ArkTS 语法：类型、接口、枚举、数组操作、模板字符串、异步、错误处理 |
| `entry/src/main/ets/pages/StateManagementPage.ets` | 300 | `pages/StateManagementPage` | 状态管理：@State / @Prop / @Link / @Provide / @Consume 对比演示 |
| `entry/src/main/ets/pages/ComponentsPage.ets` | 215 | `pages/ComponentsPage` | 高频组件补充：Swiper / LoadingProgress / Image / Select |
| `entry/src/main/ets/pages/NavigationLifecyclePage.ets` | 165 | `pages/NavigationLifecyclePage` | 页面路由、参数传递、返回、onPageShow / onPageHide 生命周期 |
| `entry/src/main/ets/pages/DataBusinessPage.ets` | 254 | `pages/DataBusinessPage` | 列表筛选、排序、加载态、空态、错误态、统计汇总 |

### 业务案例页

| 文件 | 行数 | 路由 | 场景 |
|------|------|------|------|
| `entry/src/main/ets/pages/CaseMarketPage.ets` | 139 | `pages/CaseMarketPage` | 案例市场：所有案例的导航列表，支持关键字搜索 |
| `entry/src/main/ets/pages/NewsCasePage.ets` | 178 | `pages/NewsCasePage` | 资讯案例：分类切换、文章列表、热门标签、阅读时长 |
| `entry/src/main/ets/pages/ShopCasePage.ets` | 184 | `pages/ShopCasePage` | 商城案例：商品卡片、分类过滤、购物车计数、评分展示 |
| `entry/src/main/ets/pages/SettingsCasePage.ets` | 182 | `pages/SettingsCasePage` | 设置案例：分组列表、Toggle 项、导航项、风险操作区 |
| `entry/src/main/ets/pages/DashboardCasePage.ets` | 174 | `pages/DashboardCasePage` | 数据看板：指标卡、任务进度、趋势条、排行榜 |

---

## 三、修改文件

### `entry/src/main/ets/pages/Index.ets`

**变更内容：**

1. 新增 `import` 引用 `LearningData` 和 `LearningHelpers`
2. 新增 `@State portalKeyword` / `selectedTopicLevel` 等门户状态变量
3. 顶部 Tab 从 4 个扩展为 5 个，第 0 个 Tab 新增"学习地图"门户区：
   - 统计摘要卡（总专题数、总案例数、难度分布）
   - 关键字搜索框（`filterLearningTopics` 驱动实时过滤）
   - 难度阶段筛选标签（`全部 / 入门 / 进阶 / 实战`）
   - 专题学习卡片列表（点击跳转各专题页）
   - 案例市场入口卡（跳转 `CaseMarketPage`）
4. 原有 4 个组件实验 Tab（文本 / 交互 / 布局 / 动画）全部保留，顺移为 Tab 1-4
5. 全文补充详细中文注释（每个 API / 装饰器 / 属性均有说明）

**行数变化：** 原始单页约 26 行 → 现在 1 606 行

### `entry/src/main/resources/base/profile/main_pages.json`

**变更内容：** 追加 10 条路由注册，使所有新增页面均可通过 `router.pushUrl` 访问。

```json
{
  "src": [
    "pages/Index",
    "pages/ArkTsGrammarPage",
    "pages/StateManagementPage",
    "pages/ComponentsPage",
    "pages/NavigationLifecyclePage",
    "pages/DataBusinessPage",
    "pages/CaseMarketPage",
    "pages/NewsCasePage",
    "pages/ShopCasePage",
    "pages/SettingsCasePage",
    "pages/DashboardCasePage"
  ]
}
```

---

## 四、删除文件

无。

---

## 五、知识点覆盖范围

### ArkTS 语法
- 基础类型（string / number / boolean / null / undefined）
- interface / enum / 类型别名
- 函数：箭头函数、可选参数、返回类型标注
- 数组操作：filter / map / reduce / some / find
- 模板字符串、可选链、空值合并
- async / await / Promise、try-catch

### ArkUI 状态能力
- `@State` `@Prop` `@Link` `@Provide` `@Consume`
- `@Builder` `@Styles` `@Extend`
- 条件渲染（if / else）
- 列表渲染（ForEach）

### 高频 UI 组件
- 文本：Text / Span / Badge / TextOverflow
- 输入：TextInput（Normal / Password / Email / PhoneNumber）
- 选择：Toggle / Checkbox / Radio
- 控件：Slider / Progress（Linear / Ring / Capsule）/ Rating
- 容器：Column / Row / Stack / Flex / Grid / List / Scroll / Tabs
- 其他：Button（Normal / Capsule / Circle）/ Divider / Blank

### 页面能力
- `router.pushUrl({ url, params })` 跳转
- `router.back()` 返回
- `router.getParams()` 接收参数
- 页面生命周期：`onPageShow` / `onPageHide`

### 动画与交互
- `animateTo({ duration, curve })` 属性动画
- `.scale()` `.rotate()` `.opacity()` `.translate()` 动画属性
- `onTouch(e: TouchEvent)` 触摸事件（Down / Move / Up）
- `Curve` 枚举速查（Linear / Spring / Bounce 等 8 种）

---

## 六、验收状态

| 验收项 | 状态 |
|--------|------|
| 单元测试（LearningHelpers）| ✅ 测试文件就绪，逻辑覆盖 3 个纯函数 |
| 路由注册完整 | ✅ main_pages.json 已包含全部 11 条路由 |
| 首页可导航至专题页 | ✅ 卡片 onClick 调用 router.pushUrl |
| 首页可导航至案例市场 | ✅ 专属入口卡跳转 CaseMarketPage |
| 各页面包含中文注释 | ✅ Index.ets 注释密度最高，其余页面均含关键说明 |
| 三层学习结构完整 | ✅ 基础实验 / 专题知识 / 业务案例 |

---

## 七、后续可扩展方向

1. **更多专题**：网络请求（fetch / axios）、持久化（Preferences / RelationalStore）、通知推送
2. **更多案例**：地图、音视频、扫码、蓝牙
3. **深化测试**：对 UI 行为补充 UI 自动化测试（UITest）
4. **主题切换**：实现整包暗色模式，演示 `ConfigurationConstant.ColorMode` 用法
