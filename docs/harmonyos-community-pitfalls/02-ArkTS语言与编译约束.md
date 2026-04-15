# ArkTS 语言与编译约束踩坑

ArkTS 在 TypeScript 基础上为运行时与性能做了裁剪与加强，社区反馈的「和写 Web TS 不一样」多集中在本节。

## 1. 与 TypeScript / Java 习惯的差异

- **不支持匿名类**：匿名内部类、匿名实现接口在 ArkTS 中受限；官方与社区建议用 **具名类**、**嵌套类**，或把接口成员写成 **属性 + 箭头函数** 形式以便对象字面量赋值。
- **接口两种写法**：带 **方法签名** 的 `interface`（如 `onStart(): void`）往往不能直接用对象字面量实现；改为 **属性形式**（如 `onStart: (id: string) => void`）时，对象字面量赋值更顺畅。
- **组件内嵌套类**：部分场景在 `@Component` 页面中使用嵌套类实现接口，开发者反馈 **不如箭头函数接口** 省心。

*来源：HarmonyOS 开发者社区《ArkTS 接口赋值与匿名实现》、IT 营论坛讨论等。*

## 2. 空安全与严格初始化（API 升级常见）

从较低 API 升到 API 11+ 时，社区常见报错与改法包括：

| 报错/现象 | 常见改法 |
|-----------|----------|
| `Type 'null' is not assignable to type 'T'` | 使用可空 `data?: T` 或明确联合类型，避免泛型直接等于 `null`。 |
| `Property 'xxx' has no initializer` | 属性赋默认值，或在构造函数中赋值；与 `strictPropertyInitialization` 类似。 |
| 可空返回值 | `getUser(): User` 若实际可能无值，改为 `User \| undefined` 并在调用方收窄。 |
| `Function lacks ending return statement` | 分支补全返回值，异步函数注意所有路径。 |
| `Function return type inference is limited` | 显式标注返回类型，如 `void`。 |
| `for..in` 不支持或行为不符 | 改用 `for..of` 等与 ArkTS 一致的遍历方式（需结合具体集合类型）。 |

*来源：掘金《api9 upgrade api11 问题记录》等。*

## 3. JSON 与大整数精度

- **`JSON.parse` 与 `number`**：后端 `long` / 大整数 id 在 JS 中可能 **精度丢失**。
- **对策**：接口用 **string** 传大整数；或使用 **`json-bigint`** 类库（如 OpenHarmony 三方库中心仓中的 `@ohmos/json-bigint` 等，以仓库实际包名为准），解析后用 **bigint** 处理。
- **`JSON.stringify` 与 Map**：ArkTS 对 JSON 序列化支持有限，社区做法包括 **Map → Record** 再 `JSON.stringify`。

*来源：HarmonyOS 开发者社区《ArkTS 开发中遇到的注意点》等。*

## 4. 定时器 id 与 clear 行为

- **`setTimeout` / `setInterval` 的 id**：若业务在启动新定时器前会 **clear** 旧 id，注意 **id 默认可能为 0**，易误清 **其他任务** 的 0 号定时器；社区建议 **初始 id 用 -1** 等哨兵值。
- **clearTimeout 与 clearInterval**：有讨论称存在 **互相影响** 的边缘情况，需以当前版本文档为准并做实测。

## 5. Promise 与异步

- **未捕获的 Promise 拒绝**：可能导致进程/Ability 异常退出；需 **`.catch()`** 或 **`async/await` + `try-catch`**。

## 6. 保留字与组件命名

- 社区案例：在父组件中声明变量名为 **`id`** 会与规则冲突，需改名（具体以编译器提示为准）。

## 7. 新手高频语法问题（社区归纳）

状态装饰器误用、组件嵌套规则、异步未处理、类型标注过宽/过窄、生命周期方法在错误时机调用等，均被多篇「新手 5 个语法错误」类文章强调——核心是 **先理解 ArkTS 状态与 UI 线程模型**，再对照官方「状态管理」章节。

---

**延伸阅读**

- [HarmonyOS ArkTS 状态管理指南](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-state-management)（以当前文档版本为准）  
- 腾讯云开发者社区转载：《从 ArkTS 到分布式调试》等（其中提到声明式链式属性顺序等需注意 IDE 提示）
