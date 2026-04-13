import { router } from '@kit.ArkUI';

import { NEWS_ARTICLES, NewsArticle } from '../common/LearningData';
import { normalizeKeyword } from '../common/LearningHelpers';

@Styles
function dataCard() {
  .width('100%')
  .padding(16)
  .backgroundColor(Color.White)
  .borderRadius(18)
  .margin({ bottom: 12 })
  .shadow({ radius: 10, color: 'rgba(15, 23, 42, 0.08)', offsetX: 0, offsetY: 4 })
}

@Entry
@Component
struct DataBusinessPage {
  @State loading: boolean = false
  @State errorText: string = ''
  @State keyword: string = ''
  @State category: string = '全部'
  @State articles: NewsArticle[] = []

  private categories: string[] = ['全部', '开发', '设计', '体验']

  aboutToAppear(): void {
    this.loadArticles(false);
  }

  /**
   * 用 Promise + setTimeout 模拟异步请求。
   * 这样既不依赖后端，又能演示业务页面最常见的“加载 -> 成功/失败”流程。
   */
  private async loadArticles(forceError: boolean): Promise<void> {
    this.loading = true;
    this.errorText = '';

    try {
      const response: NewsArticle[] = await new Promise<NewsArticle[]>((resolve, reject) => {
        setTimeout(() => {
          if (forceError) {
            reject(new Error('模拟接口异常：网络状态不稳定'));
            return;
          }

          resolve(NEWS_ARTICLES);
        }, 700);
      });

      this.articles = response;
    } catch (error) {
      this.errorText = (error as Error).message;
      this.articles = [];
    } finally {
      this.loading = false;
    }
  }

  /**
   * 根据分类 + 关键字过滤列表。
   */
  private getVisibleArticles(): NewsArticle[] {
    const normalized: string = normalizeKeyword(this.keyword);

    return this.articles.filter((item: NewsArticle) => {
      const matchesCategory: boolean = this.category === '全部' || item.category === this.category;
      const matchesKeyword: boolean = normalized.length === 0 ||
        item.title.toLowerCase().includes(normalized) ||
        item.summary.toLowerCase().includes(normalized) ||
        item.tags.some((tag: string) => tag.toLowerCase().includes(normalized));

      return matchesCategory && matchesKeyword;
    });
  }

  @Builder
  PageHeader() {
    Column({ space: 12 }) {
      Button('返回首页')
        .fontSize(13)
        .fontColor('#5b6ee1')
        .backgroundColor('#eef1ff')
        .onClick(() => {
          router.back();
        })

      Text('数据与业务页')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor('#0f172a')

      Text('把模拟请求、加载态、错误态、空态和筛选逻辑放进同一个页面，练习最贴近业务开发的流程。')
        .fontSize(13)
        .fontColor('#64748b')
        .lineHeight(20)
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }

  build() {
    Scroll() {
      Column() {
        this.PageHeader()

        Column({ space: 12 }) {
          Text('1. 数据请求控制台')
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .fontColor('#0f172a')

          Row({ space: 10 }) {
            Button('重新加载')
              .layoutWeight(1)
              .backgroundColor('#2563eb')
              .fontColor(Color.White)
              .onClick(() => {
                this.loadArticles(false);
              })

            Button('模拟失败')
              .layoutWeight(1)
              .backgroundColor('#dc2626')
              .fontColor(Color.White)
              .onClick(() => {
                this.loadArticles(true);
              })
          }
          .width('100%')

          if (this.loading) {
            Row({ space: 10 }) {
              LoadingProgress()
                .width(24)
                .height(24)
                .color('#2563eb')
              Text('数据加载中...')
                .fontSize(13)
                .fontColor('#64748b')
            }
          }

          if (this.errorText.length > 0) {
            Text(this.errorText)
              .fontSize(13)
              .fontColor('#b91c1c')
              .backgroundColor('#fef2f2')
              .padding(12)
              .borderRadius(12)
          }
        }
        .dataCard()

        Column({ space: 12 }) {
          Text('2. 分类与关键字筛选')
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .fontColor('#0f172a')

          TextInput({ placeholder: '输入关键字过滤文章', text: this.keyword })
            .onChange((value: string) => {
              this.keyword = value;
            })
            .backgroundColor('#f8fafc')
            .borderRadius(12)

          Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Start }) {
            ForEach(this.categories, (item: string) => {
              Button(item)
                .margin({ right: 8, bottom: 8 })
                .backgroundColor(this.category === item ? '#2563eb' : '#eef2ff')
                .fontColor(this.category === item ? Color.White : '#475569')
                .onClick(() => {
                  this.category = item;
                })
            })
          }
          .width('100%')

          Text(`筛选结果：${this.getVisibleArticles().length} 条`)
            .fontSize(12)
            .fontColor('#64748b')
        }
        .dataCard()

        Column({ space: 12 }) {
          Text('3. 列表渲染与空态处理')
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .fontColor('#0f172a')

          if (!this.loading && this.errorText.length === 0 && this.getVisibleArticles().length === 0) {
            Column({ space: 8 }) {
              Text('没有匹配内容')
                .fontSize(15)
                .fontWeight(FontWeight.Bold)
                .fontColor('#0f172a')
              Text('你可以尝试切换分类，或者清空关键字后重新筛选。')
                .fontSize(13)
                .fontColor('#64748b')
                .lineHeight(20)
            }
            .width('100%')
            .padding(18)
            .backgroundColor('#f8fafc')
            .borderRadius(14)
            .alignItems(HorizontalAlign.Start)
          } else {
            Column({ space: 10 }) {
              ForEach(this.getVisibleArticles(), (item: NewsArticle) => {
                Column({ space: 8 }) {
                  Row() {
                    Text(item.category)
                      .fontSize(11)
                      .fontColor('#2563eb')
                      .backgroundColor('#eff6ff')
                      .padding({ left: 8, right: 8, top: 4, bottom: 4 })
                      .borderRadius(999)

                    Blank()

                    Text(item.readTime)
                      .fontSize(12)
                      .fontColor('#64748b')
                  }
                  .width('100%')

                  Text(item.title)
                    .fontSize(15)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#0f172a')
                  Text(item.summary)
                    .fontSize(13)
                    .fontColor('#64748b')
                    .lineHeight(20)
                }
                .width('100%')
                .padding(14)
                .backgroundColor('#f8fafc')
                .borderRadius(14)
              })
            }
          }
        }
        .dataCard()
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 20, bottom: 32 })
    }
    .scrollBar(BarState.Off)
    .backgroundColor('#f1f5f9')
  }
}
