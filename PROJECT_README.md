# 鸿蒙生活服务 App — 技术说明文档

## 项目概况

| 项目信息 | 值 |
|---------|---|
| 平台 | HarmonyOS 6.0.2 (API 22) |
| 语言 | ArkTS (TypeScript 超集) |
| UI 框架 | ArkUI 声明式 UI |
| 构建工具 | hvigor |
| 包管理 | ohpm (oh-package.json5) |
| 源文件数 | 39 个 .ets 文件 |
| 代码总量 | ~12,700 行 |
| 目标设备 | phone / tablet |

---

## 目录结构

```
entry/src/main/ets/
├── common/                          公共层（与页面无关的基础设施）
│   ├── api/                         接口层（按页面拆分）
│   │   ├── ApiConfig.ets            环境配置（dev/staging/prod + 开关 mock）
│   │   ├── HttpUtil.ets             网络请求封装（mock 延迟模拟 / 真实 http 预留）
│   │   ├── HomeApi.ets              首页接口
│   │   ├── DiscoverApi.ets          发现页接口
│   │   ├── MessageApi.ets           消息页接口
│   │   └── MineApi.ets              我的页接口
│   ├── mock/                        模拟数据（按页面拆分）
│   │   ├── HomeMock.ets             首页 mock 数据
│   │   ├── DiscoverMock.ets         发现页 mock 数据
│   │   ├── MessageMock.ets          消息页 mock 数据
│   │   └── MineMock.ets             我的页 mock 数据
│   ├── models/                      数据结构
│   │   ├── DataModels.ets           所有 interface 聚合（12 个接口类型）
│   │   └── ResponseModel.ets        统一 API 响应格式 ApiResponse<T>
│   ├── constants/
│   │   └── AppConstants.ets         主题色、尺寸等全局常量
│   └── utils/
│       └── CommonUtils.ets          工具函数（价格格式化、数字缩写、搜索过滤）
├── components/                      全局复用组件（跨页面共享）
│   ├── SearchBar.ets                搜索栏
│   ├── SectionHeader.ets            分区标题（标题 + "查看更多 >"）
│   ├── ProductCard.ets              商品卡片
│   └── EmptyState.ets               空状态占位
├── views/                           页面专属子组件（按页面分文件夹）
│   ├── home/
│   │   ├── BannerSwiper.ets         轮播图
│   │   ├── CategoryGrid.ets         分类宫格
│   │   ├── HotProductList.ets       热门推荐横向列表
│   │   ├── ActivitySection.ets      精选活动卡片
│   │   └── RankList.ets             人气排行榜
│   ├── discover/
│   │   ├── CategoryFilter.ets       分类标签筛选栏
│   │   └── DiscoverCard.ets         内容卡片
│   ├── message/
│   │   ├── ChatItem.ets             聊天会话行
│   │   └── NotifyItem.ets           通知消息行
│   └── mine/
│       ├── UserHeader.ets           用户信息头部
│       ├── QuickEntryGrid.ets       快捷入口宫格
│       └── SettingSection.ets       设置分组
├── pages/                           页面文件（只做状态管理 + 组装子组件）
│   ├── Index.ets                    根入口（底部 4 Tab 导航）
│   ├── HomePage.ets                 首页
│   ├── DiscoverPage.ets             发现页
│   ├── MessagePage.ets              消息页
│   ├── MinePage.ets                 我的页
│   ├── DetailPage.ets               商品详情页（路由跳转）
│   └── DiscoverDetailPage.ets       文章详情页（路由跳转）
├── entryability/
│   └── EntryAbility.ets             UIAbility 入口（系统生命周期）
└── entrybackupability/
    └── EntryBackupAbility.ets       备份扩展能力
```

---

## 纯血鸿蒙开发中的官方固定步骤与必备写法

> 适用范围：当前主流的 Stage 模型 + ArkTS/ArkUI（HarmonyOS NEXT / HarmonyOS 6.x 应用开发）
>
> 阅读重点：下面只总结“官方固定、绕不开、触发后必须做”的步骤，不把推荐写法和可选能力混进去。

### 一、工程级必有文件与固定目录

#### 1. 应用级一定有 `AppScope/app.json5`

- 每个应用工程必须有且只有一个 `AppScope/app.json5`，它是应用级全局配置文件。
- 这里不负责逐页注册页面，但它决定“这个应用是谁”。
- 常见不可缺省或实际开发中一定会出现的核心配置包括：
  - `bundleName`
  - `icon`
  - `label`
  - `versionCode`
  - `versionName`

#### 2. 每个模块一定有 `src/main/module.json5`

- 每个模块下都必须包含一个 `module.json5`，路径固定为 `模块名/src/main/module.json5`。
- 这个文件负责串起模块入口、页面清单、Ability 配置以及按场景需要的权限信息。
- 对普通应用开发来说，最关键的固定字段是：
  - `module.name`
  - `module.type`
  - `module.deviceTypes`
  - `module.abilities`
  - `abilities[].name`
  - `abilities[].srcEntry`

#### 3. 代码和资源目录有固定放置方式

- ArkTS 代码固定在 `模块名/src/main/ets`
- 模块资源固定在 `模块名/src/main/resources`
- 应用级资源固定在 `AppScope/resources`
- `AppScope` 是 DevEco Studio 自动生成的目录，官方明确不建议重命名，否则可能影响构建和资源加载

### 二、最像“小程序 pages 注册”的硬步骤

这是纯血鸿蒙里最接近“小程序每加一个页面都要进 `pages` 配置”的地方。

#### 1. `module.json5` 通过 `pages` 指向页面清单

常见写法如下：

```json5
"pages": "$profile:main_pages"
```

- 它表示当前模块的页面信息放在 `resources/base/profile/main_pages.json` 之类的 profile 文件中。
- profile 文件名可以自定义，但必须与 `pages` 字段的引用保持一致。

#### 2. `main_pages.json` 必须列出可被页面路径加载的页面

典型格式如下：

```json
{
  "src": [
    "pages/Index",
    "pages/DetailPage"
  ]
}
```

- `src` 里的路径是相对于当前模块 `src/main/ets` 的页面路径。
- 路径不带 `.ets` 后缀。
- 只有登记在这里的页面，才能被基于页面路径的加载方式识别。

#### 3. 只要你这样加载页面，就必须先注册到 `main_pages.json`

下面这些官方入口都要求路径已经存在于 `main_pages.json`：

- `windowStage.loadContent('pages/Index')`
- `window.setUIContent('pages/Index')`

所以新增一个“真正要被打开的页面”时，固定动作通常是：

1. 新建页面文件，例如 `entry/src/main/ets/pages/ProfilePage.ets`
2. 在 `entry/src/main/resources/base/profile/main_pages.json` 的 `src` 中加入 `pages/ProfilePage`
3. 确认 `entry/src/main/module.json5` 的 `pages` 正确指向这个 profile 文件
4. 在 `EntryAbility`、窗口代码或路由代码中使用这个页面路径

#### 4. 不是每个 `.ets` 文件都要注册

- 只有要作为“页面入口 / 路由目标 / 被窗口加载的页面”的文件，才需要进入 `main_pages.json`
- 普通子组件只需要 `export / import`，不需要注册到页面清单

### 三、页面结构和组件写法里的硬规则

#### 1. 页面入口通常是 `@Entry + @Component + struct + build()`

典型页面骨架如下：

```ts
@Entry
@Component
struct Index {
  build() {
    Column() {
      Text('Hello HarmonyOS')
    }
  }
}
```

这里面有几条官方硬规则：

- 自定义组件基于 `struct` 定义，不能走继承体系
- 每个自定义组件都必须实现 `build()`
- 作为页面入口的组件通常要加 `@Entry`
- 单个 UI 页面中，只允许存在一个 `@Entry` 入口组件

#### 2. `build()` 下的根节点有严格要求

- `@Entry` 页面组件的 `build()` 下必须有且只有一个根节点
- 这个根节点必须是容器组件
- `ForEach` 不能作为根节点
- `@Component` 普通自定义组件的根节点同样必须唯一且必要，但可以不是容器组件

#### 3. UI 描述语法不是普通 TS，存在官方限制

在 `build()` 的 UI 描述里，官方明确限制较多，常见“不能这样写”的点包括：

- 不能在 UI 描述里声明本地变量
- 不能在 UI 描述里直接写 `console.info`
- 不能在 UI 描述里直接创建本地作用域
- 不能使用 `switch` 做渲染分支
- 不能直接用表达式或三元表达式替代条件渲染，应使用 `if`
- 不能在 `build()` 或 `@Builder` 内直接修改状态，否则有循环渲染风险

#### 4. 跨文件复用组件有固定导入导出要求

- 如果一个自定义组件要在其他文件里使用，必须先 `export`
- 使用方页面或组件必须 `import` 它

### 四、应用启动链路中的固定步骤

#### 1. `UIAbility` 是 Stage 模型的界面能力入口

- `module.json5` 中的 `abilities` 用来声明 UIAbility
- `abilities[].name` 和 `abilities[].srcEntry` 属于关键必备配置
- `mainElement` 用来指定模块入口 UIAbility；如果有多个入口 UIAbility，桌面图标、名称和启动入口以它为准

#### 2. 首页通常在 `EntryAbility.ets` 中加载

标准写法通常是：

```ts
export default class EntryAbility extends UIAbility {
  onWindowStageCreate(windowStage: window.WindowStage): void {
    windowStage.loadContent('pages/Index')
  }
}
```

这条链要成立，必须同时满足：

1. `EntryAbility` 已在 `module.json5` 的 `abilities` 里声明
2. `mainElement` 指向正确的入口 UIAbility
3. `'pages/Index'` 已经写进 `main_pages.json`
4. `pages/Index.ets` 本身是合法页面入口组件

### 五、命名路由与 Navigation 的额外“注册链”

如果项目使用官方推荐的 `Navigation` 命名路由方式，还会多一条固定配置链：

```text
module.json5 -> routerMap -> router_map.json
```

也就是：

- `module.json5` 中配置 `"routerMap": "$profile:router_map"`
- `resources/base/profile/router_map.json` 中定义命名路由表

路由表中常见必备字段包括：

- `name`
- `pageSourceFile`
- `buildFunction`

其中：

- `name` 是路由名
- `pageSourceFile` 是页面源码文件
- `buildFunction` 要指向带 `@Builder` 的构建函数

这部分不是所有项目都无条件必须有，但只要你用的是命名路由，它就会变成“少不了的死步骤”。

### 六、按场景触发后必须做的配置

下面这些不是“所有应用一上来都必配”，但一旦涉及对应场景，就属于必须补齐的官方步骤。

#### 1. 使用受保护能力时，要在 `module.json5` 声明 `requestPermissions`

- 例如蓝牙、悬浮窗、定位、相机、麦克风等能力
- 相关权限需要在 `module.json5` 中通过 `requestPermissions` 声明
- 常见结构包括：
  - `name`
  - `reason`
  - `usedScene`

也就是说，权限不是“默认就有”，而是“你一旦用了对应能力，就必须补权限声明链”。

#### 2. 需要接收 Want 或被外部匹配拉起时，要配置 `skills`

- `skills` 用来描述 UIAbility 或 ExtensionAbility 能接收什么样的 Want
- 典型场景包括文件打开、深链匹配、外部拉起、分享或其他隐式匹配场景
- `skills` 里常见的是：
  - `actions`
  - `entities`
  - `uris`
  - `permissions`

它不是所有页面都必须配，但一旦你的 Ability 需要参与 Want 匹配，它就属于条件触发后的必做项。

### 七、当前工程里这套规则对应到哪些文件

这个项目当前走的就是最标准的一条纯血鸿蒙启动链：

- `AppScope/app.json5`：应用级全局配置
- `entry/src/main/module.json5`：模块配置、入口 Ability、页面清单入口
- `entry/src/main/resources/base/profile/main_pages.json`：页面注册清单
- `entry/src/main/ets/entryability/EntryAbility.ets`：应用启动后加载首页
- `entry/src/main/ets/pages/Index.ets`：首页页面入口组件

当前工程里的关键对应关系可以直接理解成：

```text
app.json5
  -> module.json5
    -> pages: $profile:main_pages
      -> main_pages.json
        -> EntryAbility.loadContent('pages/Index')
          -> pages/Index.ets
```

这条链是项目里最值得记住的“官方固定步骤总链路”。

### 八、最容易混淆，但其实不是“每次都必须做”的事

- 不是每个 `.ets` 文件都要去 `main_pages.json` 注册，普通子组件不用
- 不是每个页面都要单独创建一个 `UIAbility`，常见做法是一个 `UIAbility` 承载多个页面
- 不是所有项目都必须配置 `routerMap`，只有命名路由 / Navigation 场景才需要
- 不是所有项目都必须一开始就声明权限，只有使用到对应系统能力时才需要补 `requestPermissions`
- 不是所有 Ability 都必须配置 `skills`，只有参与 Want 匹配时才需要

### 九、一句话记忆版

如果只记一套最小链路，可以直接背下面这句：

```text
纯血鸿蒙里最像“小程序新增页面后必须去 pages 注册”的硬步骤，
就是 module.json5 -> pages -> main_pages.json -> EntryAbility/loadContent。
如果再用命名路由，就再加一条 module.json5 -> routerMap -> router_map.json。
```

### 十、官方参考文档

- [Stage模型应用程序包结构](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/application-package-structure-stage)
- [app.json5配置文件](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/app-configuration-file)
- [module.json5配置文件](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/module-configuration-file)
- [管理应用窗口（Stage模型）](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/application-window-stage)
- [UIAbility组件生命周期](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/uiability-lifecycle)
- [组件导航 Navigation（推荐）](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-navigation-navigation)
- [创建自定义组件](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-create-custom-components)

---

## 使用的鸿蒙技术栈

### 一、ArkTS 语言特性

| 特性 | 使用位置 | 说明 |
|------|---------|------|
| interface 类型声明 | DataModels.ets | 12 个业务 interface，所有对象字面量严格匹配 |
| export / import 模块化 | 全部文件 | 跨文件导入导出，模块化分层 |
| 泛型 `<T>` | HttpUtil.ets / ResponseModel.ets | 请求封装和响应结构使用泛型 |
| async / await | 所有 API 文件 + 页面 | 异步数据获取 |
| Promise | HttpUtil.ets | setTimeout 包装模拟网络延迟 |
| 箭头函数 | 事件回调、数组方法 | onClick / filter / reduce / map 等 |
| 模板字符串 | 页面 UI | 动态拼接文字内容 |
| 类型断言 as | DetailPage / DiscoverDetailPage | router.getParams() 返回值断言 |
| 数组方法 | filter / reduce / slice / find / some | 数据过滤、统计、截取 |

### 二、ArkUI 声明式 UI

#### 布局组件

| 组件 | 使用位置 | 说明 |
|------|---------|------|
| Column | 几乎所有页面 | 垂直线性布局，最常用的容器 |
| Row | 列表项、标题栏、标签栏 | 水平线性布局 |
| Stack | Tab 角标、未读数叠加 | 层叠布局，子组件堆叠 |
| Flex | CategoryFilter 标签换行 | 弹性布局，支持自动换行 |
| Grid / GridItem | CategoryGrid / QuickEntryGrid | 网格布局，columnsTemplate 定义列 |
| Scroll | HomePage / MinePage / DetailPage | 可滚动容器（垂直方向） |
| List / ListItem | 商品列表、消息列表、通知列表 | 高性能列表（虚拟化渲染） |
| Tabs / TabContent | Index 底部导航、MessagePage 内部 Tab | 选项卡容器 |
| Swiper | BannerSwiper 轮播图 | 自动轮播 + 指示器 |
| Blank | 标题栏两端对齐 | 弹性空白占位 |
| Divider | 列表分割线 | 水平分割线 |

#### 基础组件

| 组件 | 使用场景 |
|------|---------|
| Text | 文字展示、emoji 图标 |
| TextInput | SearchBar 搜索输入框 |
| Button | 退出登录、加入购物车、分类标签 |
| Toggle | SettingSection 深色模式开关 |
| Image | 品牌图片（$r('app.media.xxx')）|

#### 常用属性方法

| 属性 | 说明 |
|------|------|
| .fontSize() / .fontColor() / .fontWeight() | 文字样式 |
| .backgroundColor() / .borderRadius() | 背景与圆角 |
| .padding() / .margin() | 内外边距 |
| .width() / .height() / .layoutWeight() | 尺寸与弹性权重 |
| .maxLines() / .textOverflow() | 文本截断 |
| .decoration() | 删除线（原价展示） |
| .linearGradient() | 渐变背景（Banner、用户头部） |
| .shadow() | 卡片阴影 |
| .position() | 绝对定位（角标） |
| .onClick() | 点击事件 |
| .onChange() | 输入变化 / Tab 切换回调 |

### 三、状态管理装饰器

| 装饰器 | 使用位置 | 说明 |
|--------|---------|------|
| @State | 所有页面和组件 | 组件内部响应式状态，变化驱动 UI 刷新 |
| @Prop | BannerSwiper / CategoryGrid / ProductCard / DiscoverCard / ChatItem / NotifyItem / UserHeader / QuickEntryGrid / SettingSection | 父 → 子单向传递，子组件只读消费 |
| @Link | CategoryFilter (activeCategory) / SettingSection (darkMode) | 父 ↔ 子双向绑定，子组件修改自动同步回父组件 |
| @Entry | Index / DetailPage / DiscoverDetailPage | 标记为页面入口，注册在 main_pages.json 中 |
| @Component | 所有 struct | 标记为 ArkUI 自定义组件 |
| @Builder | Index Tab 栏、MessagePage Tab 栏、HomePage 各区块 | 自定义构建函数，复用 UI 片段 |

### 四、页面路由

| API | 使用位置 | 说明 |
|-----|---------|------|
| router.pushUrl({ url, params }) | HomePage → DetailPage、DiscoverPage → DiscoverDetailPage | 携带参数跳转到新页面 |
| router.getParams() | DetailPage / DiscoverDetailPage 的 aboutToAppear() | 接收前一个页面传入的参数 |
| router.back() | DetailPage / DiscoverDetailPage 返回按钮 | 返回上一页 |

### 五、组件生命周期

| 回调 | 使用位置 | 说明 |
|------|---------|------|
| aboutToAppear() | HomePage / DiscoverPage / MessagePage / MinePage / DetailPage / DiscoverDetailPage | 组件即将显示时调用，用于发起数据请求 |

### 六、组件通信模式

| 模式 | 方向 | 示例 |
|------|------|------|
| @Prop | 父 → 子（只读） | HomePage 传 banners 给 BannerSwiper |
| @Link | 父 ↔ 子（双向） | DiscoverPage 与 CategoryFilter 共享 activeCategory |
| 事件回调 | 子 → 父（行为通知） | CategoryGrid.onCategoryClick / ProductCard.onCardClick |
| router params | 页面 → 页面 | 列表页把 id/name/price 传给详情页 |

### 七、网络请求架构

```
页面 (aboutToAppear)
  ↓ 调用
XxxApi.getXxx()
  ↓ 内部调用
HttpUtil.request(url, mockData)
  ↓ 判断
ApiConfig.USE_MOCK === true ?
  ├── true  → setTimeout 模拟延迟 → 返回 mockData
  └── false → http.createHttp() 发真实请求 → 解析 ApiResponse<T> → 返回 data
```

**后端对接只需改 ApiConfig.ets 一个文件：**

```typescript
static readonly USE_MOCK: boolean = false   // 关闭 mock
static readonly ENV: string = 'prod'        // 切换环境
```

### 八、数据结构（DataModels.ets 中定义的 12 个 interface）

| interface | 用途 |
|-----------|------|
| BannerItem | 首页轮播图 |
| CategoryItem | 首页分类宫格 |
| ProductItem | 商品（推荐列表 / 排行榜 / 详情页） |
| ActivityItem | 活动卡片 |
| ProductDetail | 商品详情内容 |
| DiscoverItem | 发现页内容卡片 |
| MessageItem | 聊天会话 |
| NotificationItem | 系统通知 |
| UserProfile | 用户信息 |
| QuickEntry | 快捷入口（订单/收藏/记录/券） |
| SettingItem | 设置项 |
| SettingGroup | 设置分组 |

---

## 页面功能

| 页面 | 路由 | 核心交互 |
|------|------|---------|
| 首页 | Index (Tab 0) | 搜索栏 + Swiper 轮播 + 分类宫格 + 横向商品列表 + 活动卡片 + 排行榜 |
| 发现 | Index (Tab 1) | 分类标签筛选（@Link 双向绑定） + 内容卡片流 + 点击进详情 |
| 消息 | Index (Tab 2) | 聊天/通知双 Tab + 未读角标 + 消息列表 |
| 我的 | Index (Tab 3) | 渐变头部 + 快捷入口宫格 + 设置分组 + Toggle 开关 + 退出登录 |
| 商品详情 | pages/DetailPage | 路由接参 + 接口请求 + 商品信息 + 底部购买栏 |
| 文章详情 | pages/DiscoverDetailPage | 路由接参 + 按 id 查询 + 文章全文 + 互动栏 |

---

## 设计原则

1. **按页面拆分**：mock 数据、API 接口、子组件都按页面维度独立文件，不混在一起
2. **页面只做组装**：pages/ 下的文件只负责状态管理和组合子组件，不堆砌 UI 细节
3. **子组件只管展示**：views/ 下的组件通过 @Prop 接收数据、通过回调通知父组件，不关心业务逻辑
4. **全局组件跨页复用**：components/ 下的 SearchBar / ProductCard 等在多个页面使用
5. **接口层统一收口**：所有数据获取都走 XxxApi → HttpUtil，切换 mock/真实请求只改一个开关
6. **ArkTS 严格模式兼容**：所有对象字面量匹配已声明的 interface，import 全部在文件顶部
