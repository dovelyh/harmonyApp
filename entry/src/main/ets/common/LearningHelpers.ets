import { LearningTopic, PracticeCase } from './LearningData';

/**
 * 首页统计卡片会用到这个结构。
 * 单独定义 interface 有两个好处：
 * 1. 调用方能获得完整类型提示。
 * 2. 学习者能看到“函数返回对象”在 ArkTS 里的常见写法。
 */
export interface LearningSummary {
  totalTopics: number
  totalCases: number
  beginnerCount: number
  intermediateCount: number
  advancedCount: number
}

/**
 * 统一清洗用户输入的搜索关键字。
 * trim() 去掉首尾空格，toLowerCase() 让搜索逻辑大小写无关。
 */
export function normalizeKeyword(keyword: string): string {
  return keyword.trim().toLowerCase();
}

/**
 * 判断一个字符串数组里，是否存在包含关键字的字段。
 * some() 的返回值是 boolean，十分适合用来实现“命中任一项即可”的搜索逻辑。
 */
function matchesAny(values: string[], keyword: string): boolean {
  return values.some((item: string) => item.toLowerCase().includes(keyword));
}

/**
 * 首页专题搜索：
 * - 空关键字时，直接返回全部数据
 * - 非空时，从标题、副标题、分类和标签中查找
 */
export function filterLearningTopics(topics: LearningTopic[], keyword: string): LearningTopic[] {
  const normalized: string = normalizeKeyword(keyword);

  if (normalized.length === 0) {
    return topics;
  }

  return topics.filter((item: LearningTopic) => {
    return matchesAny([item.title, item.subtitle, item.category], normalized) ||
      matchesAny(item.tags, normalized) ||
      matchesAny(item.highlights, normalized);
  });
}

/**
 * 案例市场搜索：
 * 逻辑和专题搜索保持一致，方便复用和维护。
 */
export function filterPracticeCases(cases: PracticeCase[], keyword: string): PracticeCase[] {
  const normalized: string = normalizeKeyword(keyword);

  if (normalized.length === 0) {
    return cases;
  }

  return cases.filter((item: PracticeCase) => {
    return matchesAny([item.title, item.summary, item.scene, item.badge], normalized) ||
      matchesAny(item.skills, normalized);
  });
}

/**
 * 首页概览统计：
 * reduce() 是数组聚合里非常常见的写法，这里用来演示统计场景。
 */
export function buildLearningSummary(topics: LearningTopic[], cases: PracticeCase[]): LearningSummary {
  const initialSummary: LearningSummary = {
    totalTopics: 0,
    totalCases: cases.length,
    beginnerCount: 0,
    intermediateCount: 0,
    advancedCount: 0
  };

  return topics.reduce((summary: LearningSummary, item: LearningTopic) => {
    summary.totalTopics += 1;

    if (item.level === '入门') {
      summary.beginnerCount += 1;
    } else if (item.level === '进阶') {
      summary.intermediateCount += 1;
    } else {
      summary.advancedCount += 1;
    }

    return summary;
  }, initialSummary);
}
