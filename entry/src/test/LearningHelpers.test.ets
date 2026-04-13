import { describe, it, expect } from '@ohos/hypium';

import {
  buildLearningSummary,
  filterLearningTopics,
  normalizeKeyword
} from '../main/ets/common/LearningHelpers';
import { LEARNING_TOPICS, PRACTICE_CASES } from '../main/ets/common/LearningData';

/**
 * 这组测试不关心 UI 细节，专门验证首页和案例市场会复用的纯函数逻辑。
 * 这样我们就能用更稳定的单元测试方式，为后续筛选、统计和搜索提供回归保护。
 */
export default function learningHelpersTest() {
  describe('learningHelpersTest', () => {
    it('normalizeKeyword trims spaces and lowercases text', 0, () => {
      expect(normalizeKeyword('  ArkTS  ')).assertEqual('arkts');
    });

    it('filterLearningTopics matches title subtitle and tags', 0, () => {
      const byTitle = filterLearningTopics(LEARNING_TOPICS, 'ArkTS');
      const byTag = filterLearningTopics(LEARNING_TOPICS, '动画');

      expect(byTitle.length > 0).assertTrue();
      expect(byTag.length > 0).assertTrue();
    });

    it('buildLearningSummary counts topics cases and levels', 0, () => {
      const summary = buildLearningSummary(LEARNING_TOPICS, PRACTICE_CASES);

      expect(summary.totalTopics).assertEqual(LEARNING_TOPICS.length);
      expect(summary.totalCases).assertEqual(PRACTICE_CASES.length);
      expect(summary.beginnerCount > 0).assertTrue();
      expect(summary.intermediateCount > 0).assertTrue();
    });
  });
}
