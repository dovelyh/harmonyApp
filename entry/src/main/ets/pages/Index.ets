import { HomePage } from './HomePage'
import { DiscoverPage } from './DiscoverPage'
import { ShowroomPage } from './ShowroomPage'
import { MessagePage } from './MessagePage'
import { MinePage } from './MinePage'

@Entry
@Component
struct Index {
  @State activeTab: number = 0

  @Builder
  TabIcon(idx: number, icon: string, label: string) {
    Column({ space: 2 }) {
      Text(icon).fontSize(22)
      Text(label)
        .fontSize(10)
        .fontWeight(this.activeTab === idx ? FontWeight.Medium : FontWeight.Normal)
        .fontColor(this.activeTab === idx ? '#FF6B35' : '#999999')
    }
    .width('100%')
    .height(56)
    .justifyContent(FlexAlign.Center)
  }

  @Builder TabHome() { this.TabIcon(0, '🏠', '首页') }
  @Builder TabDiscover() { this.TabIcon(1, '🔍', '发现') }
  @Builder TabShowroom() { this.TabIcon(2, '🚗', '展馆') }
  @Builder TabMessage() { this.TabIcon(3, '💬', '消息') }
  @Builder TabMine() { this.TabIcon(4, '👤', '我的') }

  build() {
    Tabs({ barPosition: BarPosition.End, index: this.activeTab }) {
      TabContent() { HomePage() }.tabBar(this.TabHome)
      TabContent() { DiscoverPage() }.tabBar(this.TabDiscover)
      TabContent() { ShowroomPage() }.tabBar(this.TabShowroom)
      TabContent() { MessagePage() }.tabBar(this.TabMessage)
      TabContent() { MinePage() }.tabBar(this.TabMine)
    }
    .barMode(BarMode.Fixed)
    .barBackgroundColor(Color.White)
    .onChange((index: number) => { this.activeTab = index })
    .width('100%')
    .height('100%')
  }
}
