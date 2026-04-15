# ArkUI 与状态管理踩坑

## 1. @State 与「数据变了界面不变」

**核心机制（社区与官方文档一致方向）**：`@State` 对 **引用变化** 敏感；对 **数组/对象内部原地修改** 往往 **不触发** 重绘。

典型场景：

- 对 **`this.items[i] = x`**、**`array.push()`** 仅改变内容不改变数组引用 → UI 可能不更新。
- 修改 **对象属性** 但对象引用未变 → 同上。
- 从 **静态全局数组** 同步到 `@State` 数组时，若只比较 `length` 而内部是 `push` 更新，条件可能长期为 false 或引用未替换。

**常见对策**：

- 赋 **新数组引用**：`this.list = [...source]`、`map` 返回新数组、`splice` 整体替换等。
- 对嵌套对象使用 **`@Observed` + `@ObjectLink`**，或新版本中的 **`@ObservedV2` + `@Trace`** 做深度追踪（以当前 SDK 文档为准）。
- 必要时 **整体替换对象引用**（社区有「先置 null 再赋回」的强制刷新讨论，属权宜之计，优先用官方推荐状态方案）。

*来源：IT 营论坛、CSDN 问答、博客园《@State 到 ObservedV2》等。*

## 2. ForEach / LazyForEach 与列表

- **keyGenerator**：使用 **稳定唯一 id**，避免用 **index** 作为 key；增删排序后 index 变化会导致 **错误复用**、数据与 UI 错位。
- 长列表优先 **LazyForEach** 与 **`cachedCount`** 等配置，减少一次性构建开销。

## 3. 布局与单位

- **固定 `px`**：跨设备容易错位；多用 **`vp`**、**百分比**、**栅格/断点** 做响应式。
- **嵌套过深**：多层 `Stack`/`Column`/`Row` 叠加易导致 **重叠、截断、测量变慢**；社区建议 **扁平化**、控制深度。
- **Flex 属性**：`layoutWeight`、`align` 等与父容器类型强相关，错配会表现为「布局不符合直觉」。

## 4. 组件不显示与资源

- 图片 **未加载/路径错误**、条件渲染逻辑错误、**尺寸为 0**（未约束宽高）等都会导致「组件看不见」。
- **Swiper** 等组件不显示时，需检查数据源、子项尺寸与父布局约束。

## 5. 事件与手势

- **手势冲突**、**点击穿透**：同一区域多组件监听时，需理清 **优先级**（`gesture`、`parallelGesture` 等）与 **hitTestBehavior**。
- **点击延迟/卡顿**：可能与 **主线程阻塞**、过度重绘有关，需结合性能工具分析。

## 6. Context 与 getContext()

- 在 **UIAbility**（如 `EntryAbility`）中取上下文：社区文章指出 **`getContext()` 无参** 在部分时机会得到 **undefined**；Ability 内优先使用 **`this.context`**（类型为 `UIAbilityContext`）。
- 在 **组件树未就绪**（如 `loadContent` 之前）或 **组件已销毁** 后调用 `getContext(this)` 易出错；应在 **窗口与页面加载完成** 后再访问。

*来源：DEV Community《getContext Returning Undefined》等。*

## 7. 动画与性能

- **`Progress`** 修改 `value` 时有默认动画；需关闭时可查组件 **`enableSmoothEffect: false`**（以当前 API 文档为准）。
- **大面积 shadow / 高斯模糊**：GPU 压力大，易卡顿；社区建议 **简化阴影** 或用 **切图**。

## 8. 页面转场与黑屏

- 路由跳转 **黑屏**：检查是否未配置 **pageTransition**，或 **生命周期里同步耗时操作** 阻塞首帧。

## 9. 状态变量重构

- IDE 重构 **可能漏改字符串 key**（如 `AppStorage` 的键名），导致 **运行时** 才暴露错误，需全局搜索核对。

---

**延伸阅读**

- 掘金 / CSDN：《鸿蒙 UI 开发实战指南：布局错乱、组件不显示、事件响应异常》  
- 华为文档：ForEach、状态管理（`@Observed` / `@ObjectLink`）
