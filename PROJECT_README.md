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
