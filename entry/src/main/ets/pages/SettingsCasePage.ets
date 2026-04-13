import { router } from '@kit.ArkUI';

import { SETTING_ITEMS, SettingItem } from '../common/LearningData';

@Styles
function settingsCard() {
  .width('100%')
  .padding(16)
  .backgroundColor(Color.White)
  .borderRadius(18)
  .margin({ bottom: 12 })
  .shadow({ radius: 10, color: 'rgba(15, 23, 42, 0.08)', offsetX: 0, offsetY: 4 })
}

@Entry
@Component
struct SettingsCasePage {
  @State syncEnabled: boolean = true
  @State noticeEnabled: boolean = true
  @State protectMode: boolean = false
  @State themeLabel: string = '标准蓝'

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

      Text('设置中心案例')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor('#0f172a')

      Text('这个页面强调“信息分组 + 控件反馈 + 风险隔离”，是工具类应用最常见的页面之一。')
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
          Text('账号与通用设置')
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .fontColor('#0f172a')

          ForEach(SETTING_ITEMS, (item: SettingItem) => {
            if (item.id === 'sync') {
              Row() {
                Column({ space: 4 }) {
                  Text(item.title)
                    .fontSize(14)
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#0f172a')
                  Text(item.desc)
                    .fontSize(12)
                    .fontColor('#64748b')
                }
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(1)

                Toggle({ type: ToggleType.Switch, isOn: this.syncEnabled })
                  .selectedColor('#2563eb')
                  .onChange((value: boolean) => {
                    this.syncEnabled = value;
                  })
              }
              .width('100%')
            } else if (item.id === 'notification') {
              Row() {
                Column({ space: 4 }) {
                  Text(item.title)
                    .fontSize(14)
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#0f172a')
                  Text(item.desc)
                    .fontSize(12)
                    .fontColor('#64748b')
                }
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(1)

                Toggle({ type: ToggleType.Switch, isOn: this.noticeEnabled })
                  .selectedColor('#2563eb')
                  .onChange((value: boolean) => {
                    this.noticeEnabled = value;
                  })
              }
              .width('100%')
            } else {
              Row() {
                Column({ space: 4 }) {
                  Text(item.title)
                    .fontSize(14)
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#0f172a')
                  Text(item.desc)
                    .fontSize(12)
                    .fontColor('#64748b')
                }
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(1)

                Text(item.valueText)
                  .fontSize(12)
                  .fontColor('#94a3b8')
              }
              .width('100%')
            }

            Divider().margin({ top: 12, bottom: 12 }).color('#f1f5f9')
          })
        }
        .settingsCard()

        Column({ space: 12 }) {
          Text('主题与保护模式')
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .fontColor('#0f172a')

          Row({ space: 10 }) {
            Button('标准蓝')
              .layoutWeight(1)
              .backgroundColor(this.themeLabel === '标准蓝' ? '#2563eb' : '#eef2ff')
              .fontColor(this.themeLabel === '标准蓝' ? Color.White : '#475569')
              .onClick(() => {
                this.themeLabel = '标准蓝';
              })

            Button('清新绿')
              .layoutWeight(1)
              .backgroundColor(this.themeLabel === '清新绿' ? '#16a34a' : '#ecfdf3')
              .fontColor(this.themeLabel === '清新绿' ? Color.White : '#166534')
              .onClick(() => {
                this.themeLabel = '清新绿';
              })
          }
          .width('100%')

          Row() {
            Column({ space: 4 }) {
              Text('专注保护模式')
                .fontSize(14)
                .fontWeight(FontWeight.Medium)
                .fontColor('#0f172a')
              Text('打开后会减少页面中的干扰信息，适合沉浸式学习。')
                .fontSize(12)
                .fontColor('#64748b')
            }
            .alignItems(HorizontalAlign.Start)
            .layoutWeight(1)

            Toggle({ type: ToggleType.Switch, isOn: this.protectMode })
              .selectedColor('#2563eb')
              .onChange((value: boolean) => {
                this.protectMode = value;
              })
          }
          .width('100%')
        }
        .settingsCard()
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 20, bottom: 32 })
    }
    .scrollBar(BarState.Off)
    .backgroundColor('#f1f5f9')
  }
}
