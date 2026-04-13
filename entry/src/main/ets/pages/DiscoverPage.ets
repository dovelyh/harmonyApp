import { router } from '@kit.ArkUI'
import { DiscoverItem } from '../common/models/DataModels'
import { DiscoverApi } from '../common/api/DiscoverApi'
import { DISCOVER_CATEGORIES } from '../common/mock/DiscoverMock'
import { CategoryFilter } from '../views/discover/CategoryFilter'
import { DiscoverCard } from '../views/discover/DiscoverCard'

@Component
export struct DiscoverPage {
  @State activeCategory: string = '全部'
  @State items: DiscoverItem[] = []
  @State loading: boolean = true

  aboutToAppear(): void {
    this.loadData()
  }

  private async loadData(): Promise<void> {
    this.loading = true
    this.items = await DiscoverApi.getList()
    this.loading = false
  }

  private getFilteredItems(): DiscoverItem[] {
    if (this.activeCategory === '全部') return this.items
    return this.items.filter((d: DiscoverItem) => d.category === this.activeCategory)
  }

  build() {
    Column() {
      Row() {
        Text('发现').fontSize(22).fontWeight(FontWeight.Bold).fontColor('#1A1A1A')
        Blank()
        Text('🔔').fontSize(20)
      }
      .width('100%').padding({ left: 16, right: 16, top: 12, bottom: 8 })

      Column() {
        CategoryFilter({
          categories: DISCOVER_CATEGORIES,
          activeCategory: this.activeCategory
        })
      }
      .padding({ left: 16, right: 16 })

      List() {
        ForEach(this.getFilteredItems(), (item: DiscoverItem) => {
          ListItem() {
            DiscoverCard({
              item: item,
              onCardClick: () => {
                router.pushUrl({
                  url: 'pages/DiscoverDetailPage',
                  params: { id: item.id, title: item.title }
                })
              }
            })
          }
        })
      }
      .scrollBar(BarState.Off)
      .padding({ left: 16, right: 16, bottom: 16 })
      .layoutWeight(1)
    }
    .width('100%').height('100%')
    .backgroundColor('#F5F6FA')
  }
}
