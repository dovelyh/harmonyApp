import { router } from '@kit.ArkUI';

import { NEWS_ARTICLES, NewsArticle } from '../common/LearningData';
import { normalizeKeyword } from '../common/LearningHelpers';

@Styles
function newsCard() {
  .width('100%')
  .padding(16)
  .backgroundColor(Color.White)
  .borderRadius(18)
  .margin({ bottom: 12 })
  .shadow({ radius: 10, color: 'rgba(15, 23, 42, 0.08)', offsetX: 0, offsetY: 4 })
}

@Entry
@Component
struct NewsCasePage {
  @State category: string = '全部'
  @State keyword: string = ''
  @State onlyHot: boolean = false

  private categories: string[] = ['全部', '开发', '设计', '体验']

  private getVisibleArticles(): NewsArticle[] {
    const normalized = normalizeKeyword(this.keyword);

    return NEWS_ARTICLES.filter((item: NewsArticle) => {
      const matchesCategory: boolean = this.category === '全部' || item.category === this.category;
      const matchesHot: boolean = !this.onlyHot || item.hot;
      const matchesKeyword: boolean = normalized.length === 0 ||
        item.title.toLowerCase().includes(normalized) ||
        item.summary.toLowerCase().includes(normalized) ||
        item.tags.some((tag: string) => tag.toLowerCase().includes(normalized));

      return matchesCategory && matchesHot && matchesKeyword;
    });
  }

  @Builder
  PageHeader() {
    Column({ space: 12 }) {
      Button('返回案例市场')
        .fontSize(13)
        .fontColor('#5b6ee1')
        .backgroundColor('#eef1ff')
        .onClick(() => {
          router.back();
        })

      Text('资讯流案例')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor('#0f172a')

      Text('这个页面模拟内容类产品中最常见的“分类 + 热门 + 列表流”组合。')
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
          Text('今日推荐')
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .fontColor('#0f172a')

          Column({ space: 8 }) {
            Text('把 ArkTS 语法、状态管理和业务结构串起来学')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor('#0f172a')
            Text('如果你已经学完首页基础实验区，建议按“语法 -> 状态 -> 案例”的顺序继续推进。')
              .fontSize(13)
              .fontColor('#475569')
              .lineHeight(20)
          }
          .width('100%')
          .padding(18)
          .backgroundColor('#dbeafe')
          .borderRadius(18)
          .alignItems(HorizontalAlign.Start)
        }
        .newsCard()

        Column({ space: 12 }) {
          TextInput({ placeholder: '搜索资讯标题或标签', text: this.keyword })
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

          Toggle({ type: ToggleType.Switch, isOn: this.onlyHot })
            .onChange((value: boolean) => {
              this.onlyHot = value;
            })
            .selectedColor('#2563eb')

          Text(this.onlyHot ? '当前仅显示热门内容' : '当前显示全部内容')
            .fontSize(12)
            .fontColor('#64748b')
        }
        .newsCard()

        Column({ space: 10 }) {
          Text('资讯列表')
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .fontColor('#0f172a')

          ForEach(this.getVisibleArticles(), (item: NewsArticle) => {
            Column({ space: 10 }) {
              Row() {
                Text(item.category)
                  .fontSize(11)
                  .fontColor('#2563eb')
                  .backgroundColor('#eff6ff')
                  .padding({ left: 8, right: 8, top: 4, bottom: 4 })
                  .borderRadius(999)

                if (item.hot) {
                  Text('HOT')
                    .fontSize(11)
                    .fontColor('#ef4444')
                    .backgroundColor('#fef2f2')
                    .padding({ left: 8, right: 8, top: 4, bottom: 4 })
                    .borderRadius(999)
                    .margin({ left: 8 })
                }
              }

              Text(item.title)
                .fontSize(15)
                .fontWeight(FontWeight.Bold)
                .fontColor('#0f172a')
              Text(item.summary)
                .fontSize(13)
                .fontColor('#64748b')
                .lineHeight(20)
              Text(`${item.author} · ${item.readTime}`)
                .fontSize(12)
                .fontColor('#94a3b8')
            }
            .newsCard()
          })
        }
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 20, bottom: 32 })
    }
    .scrollBar(BarState.Off)
    .backgroundColor('#f1f5f9')
  }
}
