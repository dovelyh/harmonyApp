import { UserProfile, QuickEntry, SettingGroup } from '../common/models/DataModels'
import { MineApi } from '../common/api/MineApi'
import { UserHeader } from '../views/mine/UserHeader'
import { QuickEntryGrid } from '../views/mine/QuickEntryGrid'
import { SettingSection } from '../views/mine/SettingSection'

const EMPTY_USER: UserProfile = { nickname: '', avatar: '', level: '', points: 0, orderCount: 0, favoriteCount: 0, historyCount: 0, couponCount: 0 }

@Component
export struct MinePage {
  @State cartCount: number = 0
  @State isLoggedIn: boolean = true
  @State user: UserProfile = EMPTY_USER
  @State entries: QuickEntry[] = []
  @State settings: SettingGroup[] = []
  @State darkMode: boolean = false

  aboutToAppear(): void {
    this.loadData()
  }

  private async loadData(): Promise<void> {
    this.user = await MineApi.getProfile()
    this.entries = await MineApi.getQuickEntries()
    this.settings = await MineApi.getSettings()
  }

  build() {
    Scroll() {
      Column() {
        UserHeader({ user: this.user, isLoggedIn: this.isLoggedIn })
        QuickEntryGrid({ entries: this.entries })

        if (this.cartCount > 0) {
          Row({ space: 6 }) {
            Text('🛒').fontSize(15)
            Text(`购物车中有 ${this.cartCount} 件商品`).fontSize(13).fontColor('#FF6B35')
          }
          .width('100%').padding({ left: 16, right: 16, top: 16 })
        }

        ForEach(this.settings, (group: SettingGroup) => {
          SettingSection({ group: group, darkMode: this.darkMode })
        })

        Button('退出登录')
          .width('100%').height(44)
          .margin({ left: 16, right: 16, top: 24, bottom: 40 })
          .backgroundColor(Color.White).fontColor('#FF4D4F')
          .fontSize(15).borderRadius(12)
          .onClick(() => { this.isLoggedIn = false })
      }.width('100%')
    }
    .scrollBar(BarState.Off)
    .width('100%').height('100%')
    .backgroundColor('#F5F6FA')
  }
}
