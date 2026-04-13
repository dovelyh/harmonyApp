import { UserProfile } from '../../common/models/DataModels'

const EMPTY_USER: UserProfile = { nickname: '', avatar: '', level: '', points: 0, orderCount: 0, favoriteCount: 0, historyCount: 0, couponCount: 0 }

@Component
export struct UserHeader {
  @Prop user: UserProfile = EMPTY_USER
  @Prop isLoggedIn: boolean = true

  build() {
    Row({ space: 14 }) {
      Text(this.isLoggedIn ? this.user.avatar : '🔒')
        .fontSize(36).width(60).height(60)
        .textAlign(TextAlign.Center)
        .backgroundColor('rgba(255,255,255,0.25)').borderRadius(30)

      Column({ space: 4 }) {
        Text(this.isLoggedIn ? this.user.nickname : '点击登录')
          .fontSize(20).fontWeight(FontWeight.Bold).fontColor(Color.White)
        if (this.isLoggedIn) {
          Row({ space: 8 }) {
            Text(this.user.level).fontSize(11).fontColor('#FF6B35')
              .backgroundColor('rgba(255,255,255,0.9)')
              .padding({ left: 8, right: 8, top: 3, bottom: 3 }).borderRadius(10)
            Text(`${this.user.points} 积分`).fontSize(12).fontColor('rgba(255,255,255,0.8)')
          }
        }
      }.alignItems(HorizontalAlign.Start)
      Blank()
      Text('⚙️').fontSize(20)
    }
    .width('100%')
    .padding({ left: 20, right: 20, top: 50, bottom: 24 })
    .linearGradient({ angle: 135, colors: [['#FF6B35', 0.0], ['#FF8F5E', 1.0]] })
  }
}
