import { router } from '@kit.ArkUI';

import { PRACTICE_CASES, PracticeCase } from '../common/LearningData';
import { filterPracticeCases } from '../common/LearningHelpers';

@Styles
function marketCard() {
  .width('100%')
  .padding(16)
  .backgroundColor(Color.White)
  .borderRadius(18)
  .margin({ bottom: 12 })
  .shadow({ radius: 10, color: 'rgba(15, 23, 42, 0.08)', offsetX: 0, offsetY: 4 })
}

@Entry
@Component
struct CaseMarketPage {
  @State keyword: string = ''

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

      Text('功能市场案例')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor('#0f172a')

      Text('把资讯、商城、设置、看板这些高频页面放在一起练习，学习如何把零散技术点组织成完整页面。')
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
          Text('案例检索')
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .fontColor('#0f172a')

          TextInput({ placeholder: '搜索案例名称、场景或技能关键词', text: this.keyword })
            .onChange((value: string) => {
              this.keyword = value;
            })
            .backgroundColor('#f8fafc')
            .borderRadius(12)

          Text(`当前展示 ${filterPracticeCases(PRACTICE_CASES, this.keyword).length} 个案例`)
            .fontSize(12)
            .fontColor('#64748b')
        }
        .marketCard()

        Column({ space: 12 }) {
          Text('案例列表')
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .fontColor('#0f172a')

          ForEach(filterPracticeCases(PRACTICE_CASES, this.keyword), (item: PracticeCase) => {
            Column({ space: 10 }) {
              Row() {
                Text(item.badge)
                  .fontSize(11)
                  .fontColor('#2563eb')
                  .backgroundColor('#eff6ff')
                  .padding({ left: 8, right: 8, top: 4, bottom: 4 })
                  .borderRadius(999)

                Blank()

                Text(item.scene)
                  .fontSize(12)
                  .fontColor('#64748b')
              }
              .width('100%')

              Text(item.title)
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor('#0f172a')
              Text(item.summary)
                .fontSize(13)
                .fontColor('#64748b')
                .lineHeight(20)

              Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Start }) {
                ForEach(item.skills, (skill: string) => {
                  Text(skill)
                    .fontSize(11)
                    .fontColor('#475569')
                    .backgroundColor('#f8fafc')
                    .padding({ left: 8, right: 8, top: 4, bottom: 4 })
                    .borderRadius(999)
                    .margin({ right: 8, bottom: 8 })
                })
              }
              .width('100%')

              Button('进入案例')
                .width('100%')
                .backgroundColor('#2563eb')
                .fontColor(Color.White)
                .onClick(() => {
                  router.pushUrl({
                    url: item.route,
                    params: { source: 'case-market' }
                  });
                })
            }
            .marketCard()
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
