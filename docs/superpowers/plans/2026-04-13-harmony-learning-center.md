# Harmony Learning Center Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [x]`) syntax for tracking.

**Goal:** Build a multi-page HarmonyOS learning project that extends the existing home page into a structured ArkTS learning center with topic pages, case-study pages, mock data, and a root-level change report.

**Architecture:** Keep the current `Index.ets` page as the main learning portal and preserve its existing component-lab tabs. Add shared data and filtering helpers under `common/`, then add multiple topic pages and business case pages under `pages/`. Route entries are registered in `main_pages.json`, and a root markdown report tracks every file addition and modification.

**Tech Stack:** HarmonyOS 6.0.2 (API 22), ArkTS, ArkUI declarative UI, Hypium unit tests, hvigor build.

---

### Task 1: Add shared learning data and helper functions

**Files:**
- Create: `entry/src/main/ets/common/LearningData.ets`
- Create: `entry/src/main/ets/common/LearningHelpers.ets`
- Create: `entry/src/test/LearningHelpers.test.ets`
- Modify: `entry/src/test/List.test.ets`

- [x] **Step 1: Write the failing test**

```ts
import {
  normalizeKeyword,
  filterLearningTopics,
  buildLearningSummary
} from '../main/ets/common/LearningHelpers'
import { LEARNING_TOPICS, PRACTICE_CASES } from '../main/ets/common/LearningData'

it('filters topics by keyword and builds summary counts', 0, () => {
  const result = filterLearningTopics(LEARNING_TOPICS, 'ArkTS')
  const summary = buildLearningSummary(LEARNING_TOPICS, PRACTICE_CASES)
  expect(result.length > 0).assertTrue()
  expect(summary.totalTopics).assertEqual(LEARNING_TOPICS.length)
})
```

- [x] **Step 2: Run test to verify it fails**

Run: `node /Applications/DevEco-Studio.app/Contents/tools/hvigor/bin/hvigorw.js --mode module -p module=entry@default -p product=default test`

Expected: test or compile fails because the helper/data modules do not exist yet.

- [x] **Step 3: Write minimal implementation**

```ts
export interface LearningTopic {
  id: string
  title: string
  subtitle: string
  route: string
  level: string
  tags: string[]
}

export function normalizeKeyword(keyword: string): string {
  return keyword.trim().toLowerCase()
}
```

- [x] **Step 4: Run test to verify it passes**

Run: `node /Applications/DevEco-Studio.app/Contents/tools/hvigor/bin/hvigorw.js --mode module -p module=entry@default -p product=default test`

Expected: helper test passes.

- [x] **Step 5: Commit**

```bash
git add entry/src/main/ets/common/LearningData.ets entry/src/main/ets/common/LearningHelpers.ets entry/src/test/LearningHelpers.test.ets entry/src/test/List.test.ets
git commit -m "feat: add learning data helpers"
```

### Task 2: Upgrade home page into a learning portal

**Files:**
- Modify: `entry/src/main/ets/pages/Index.ets`
- Modify: `entry/src/main/resources/base/profile/main_pages.json`

- [x] **Step 1: Add portal sections above the existing tabs**

```ts
@State searchKeyword: string = ''
@State selectedStage: string = '全部'
```

- [x] **Step 2: Add topic and case navigation cards**

```ts
router.pushUrl({ url: item.route, params: { title: item.title } })
```

- [x] **Step 3: Keep the old tabbed lab intact below the new portal area**

```ts
Tabs({ index: this.activeTab }) {
  TabContent() { this.TextTab() }.tabBar(this.TabBarText)
}
```

- [x] **Step 4: Verify preview build**

Run: `node /Applications/DevEco-Studio.app/Contents/tools/hvigor/bin/hvigorw.js --mode module -p module=entry@default -p product=default assembleHap`

Expected: build succeeds and the home page still loads.

- [x] **Step 5: Commit**

```bash
git add entry/src/main/ets/pages/Index.ets entry/src/main/resources/base/profile/main_pages.json
git commit -m "feat: turn home page into learning portal"
```

### Task 3: Add topic pages

**Files:**
- Create: `entry/src/main/ets/pages/ArkTsGrammarPage.ets`
- Create: `entry/src/main/ets/pages/StateManagementPage.ets`
- Create: `entry/src/main/ets/pages/ComponentsPage.ets`
- Create: `entry/src/main/ets/pages/NavigationLifecyclePage.ets`
- Create: `entry/src/main/ets/pages/DataBusinessPage.ets`

- [x] **Step 1: Create one page per topic with a shared visual rhythm**

```ts
import { router } from '@kit.ArkUI'

@Entry
@Component
struct ArkTsGrammarPage {
  build() {
    Column() {
      Text('ArkTS 语法馆')
    }
  }
}
```

- [x] **Step 2: Fill each page with commented examples and simulated interactions**

```ts
async loadMockData(): Promise<void> {
  this.loading = true
  const rows = await mockFetchArticles()
  this.list = rows
  this.loading = false
}
```

- [x] **Step 3: Register all routes in `main_pages.json`**

```json
{
  "src": [
    "pages/Index",
    "pages/ArkTsGrammarPage"
  ]
}
```

- [x] **Step 4: Verify build**

Run: `node /Applications/DevEco-Studio.app/Contents/tools/hvigor/bin/hvigorw.js --mode module -p module=entry@default -p product=default assembleHap`

Expected: all pages compile.

- [x] **Step 5: Commit**

```bash
git add entry/src/main/ets/pages/ArkTsGrammarPage.ets entry/src/main/ets/pages/StateManagementPage.ets entry/src/main/ets/pages/ComponentsPage.ets entry/src/main/ets/pages/NavigationLifecyclePage.ets entry/src/main/ets/pages/DataBusinessPage.ets entry/src/main/resources/base/profile/main_pages.json
git commit -m "feat: add topic learning pages"
```

### Task 4: Add business case pages

**Files:**
- Create: `entry/src/main/ets/pages/CaseMarketPage.ets`
- Create: `entry/src/main/ets/pages/NewsCasePage.ets`
- Create: `entry/src/main/ets/pages/ShopCasePage.ets`
- Create: `entry/src/main/ets/pages/SettingsCasePage.ets`
- Create: `entry/src/main/ets/pages/DashboardCasePage.ets`

- [x] **Step 1: Create case-market navigation page**

```ts
ForEach(PRACTICE_CASES, (item) => {
  this.CaseCard(item)
})
```

- [x] **Step 2: Implement four business pages with mock data**

```ts
@State cartCount: number = 0
@State enableNotification: boolean = true
```

- [x] **Step 3: Verify route links from the home page and market page**

```ts
router.pushUrl({ url: 'pages/ShopCasePage', params: { source: 'market' } })
```

- [x] **Step 4: Verify build**

Run: `node /Applications/DevEco-Studio.app/Contents/tools/hvigor/bin/hvigorw.js --mode module -p module=entry@default -p product=default assembleHap`

Expected: business pages compile and route entries are valid.

- [x] **Step 5: Commit**

```bash
git add entry/src/main/ets/pages/CaseMarketPage.ets entry/src/main/ets/pages/NewsCasePage.ets entry/src/main/ets/pages/ShopCasePage.ets entry/src/main/ets/pages/SettingsCasePage.ets entry/src/main/ets/pages/DashboardCasePage.ets entry/src/main/resources/base/profile/main_pages.json
git commit -m "feat: add business case pages"
```

### Task 5: Add root-level change report and final verification

**Files:**
- Create: `HARMONY_LEARNING_CHANGELOG.md`

- [x] **Step 1: Summarize added, modified, and deleted files**

```md
## 新增文件
- entry/src/main/ets/pages/ArkTsGrammarPage.ets
```

- [x] **Step 2: Include verification evidence and known follow-up items**

```md
## 验证结果
- 单元测试：通过
- 构建：通过
```

- [x] **Step 3: Run final verification**

Run: `node /Applications/DevEco-Studio.app/Contents/tools/hvigor/bin/hvigorw.js --mode module -p module=entry@default -p product=default test && node /Applications/DevEco-Studio.app/Contents/tools/hvigor/bin/hvigorw.js --mode module -p module=entry@default -p product=default assembleHap`

Expected: both test and build commands exit with code 0.

- [x] **Step 4: Commit**

```bash
git add HARMONY_LEARNING_CHANGELOG.md
git commit -m "docs: add harmony learning expansion report"
```
