import { router } from '@kit.ArkUI';

import {
  DASHBOARD_METRICS,
  DASHBOARD_RANKING,
  DASHBOARD_TASKS,
  DashboardMetric,
  DashboardRankItem,
  DashboardTask
} from '../common/LearningData';

@Styles
function dashboardCard() {
  .width('100%')
  .padding(16)
  .backgroundColor(Color.White)
  .borderRadius(18)
  .margin({ bottom: 12 })
  .shadow({ radius: 10, color: 'rgba(15, 23, 42, 0.08)', offsetX: 0, offsetY: 4 })
}

@Entry
@Component
struct DashboardCasePage {
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

      Text('数据看板案例')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor('#0f172a')

      Text('这个页面演示运营看板、学习面板、工作台中常见的指标卡、任务条和排行榜写法。')
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
          Text('核心指标')
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .fontColor('#0f172a')

          ForEach(DASHBOARD_METRICS, (item: DashboardMetric) => {
            Row() {
              Column({ space: 4 }) {
                Text(item.title)
                  .fontSize(13)
                  .fontColor('#64748b')
                Text(item.value)
                  .fontSize(22)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#0f172a')
              }
              .alignItems(HorizontalAlign.Start)
              .layoutWeight(1)

              Text(item.trend)
                .fontSize(13)
                .fontColor(item.color)
                .backgroundColor('#f8fafc')
                .padding({ left: 10, right: 10, top: 6, bottom: 6 })
                .borderRadius(999)
            }
            .width('100%')
            .padding(14)
            .backgroundColor('#f8fafc')
            .borderRadius(14)
          })
        }
        .dashboardCard()

        Column({ space: 12 }) {
          Text('任务进度')
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .fontColor('#0f172a')

          ForEach(DASHBOARD_TASKS, (item: DashboardTask) => {
            Column({ space: 8 }) {
              Row() {
                Column({ space: 4 }) {
                  Text(item.title)
                    .fontSize(14)
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#0f172a')
                  Text(`${item.owner} · ${item.status}`)
                    .fontSize(12)
                    .fontColor('#64748b')
                }
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(1)

                Text(`${item.progress}%`)
                  .fontSize(12)
                  .fontColor('#2563eb')
              }
              .width('100%')

              Progress({ value: item.progress, total: 100, type: ProgressType.Linear })
                .width('100%')
                .color('#2563eb')
                .backgroundColor('#dbeafe')
            }
            .width('100%')
            .padding(14)
            .backgroundColor('#f8fafc')
            .borderRadius(14)
          })
        }
        .dashboardCard()

        Column({ space: 12 }) {
          Text('专题热度排行')
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .fontColor('#0f172a')

          ForEach(DASHBOARD_RANKING, (item: DashboardRankItem, index: number) => {
            Row({ space: 12 }) {
              Text(`${index + 1}`)
                .fontSize(15)
                .fontWeight(FontWeight.Bold)
                .fontColor('#2563eb')
                .width(22)

              Column({ space: 4 }) {
                Text(item.name)
                  .fontSize(14)
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#0f172a')
                Text(item.label)
                  .fontSize(12)
                  .fontColor('#64748b')
              }
              .alignItems(HorizontalAlign.Start)
              .layoutWeight(1)

              Text(`${item.score}`)
                .fontSize(14)
                .fontColor('#0f172a')
            }
            .width('100%')
            .padding(14)
            .backgroundColor('#f8fafc')
            .borderRadius(14)
          })
        }
        .dashboardCard()
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 20, bottom: 32 })
    }
    .scrollBar(BarState.Off)
    .backgroundColor('#f1f5f9')
  }
}
