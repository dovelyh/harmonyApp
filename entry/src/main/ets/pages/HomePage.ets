import { router } from '@kit.ArkUI'
import { BannerItem, CategoryItem, ProductItem, ActivityItem } from '../common/models/DataModels'
import { HomeApi } from '../common/api/HomeApi'
import { SearchBar } from '../components/SearchBar'
import { SectionHeader } from '../components/SectionHeader'
import { BannerSwiper } from '../views/home/BannerSwiper'
import { CategoryGrid } from '../views/home/CategoryGrid'
import { HotProductList } from '../views/home/HotProductList'
import { ActivitySection } from '../views/home/ActivitySection'
import { RankList } from '../views/home/RankList'

/**
 * 首页 —— 作为 Index 的 TabContent 子组件。
 *
 * 数据获取：aboutToAppear 中调用各 API（当前走 mock 延迟模拟）。
 * 子组件通信：通过 @Prop 传数据 + 事件回调传行为。
 * 路由跳转：在事件回调中调用 router.pushUrl 并携带参数。
 */
@Component
export struct HomePage {
  @State banners: BannerItem[] = []
  @State categories: CategoryItem[] = []
  @State products: ProductItem[] = []
  @State activities: ActivityItem[] = []
  @State loading: boolean = true

  aboutToAppear(): void {
    this.loadData()
  }

  private async loadData(): Promise<void> {
    this.loading = true
    this.banners = await HomeApi.getBanners()
    this.categories = await HomeApi.getCategories()
    this.products = await HomeApi.getProducts()
    this.activities = await HomeApi.getActivities()
    this.loading = false
  }

  private goDetail(item: ProductItem): void {
    router.pushUrl({
      url: 'pages/DetailPage',
      params: { id: item.id, name: item.name, price: item.price, color: item.color }
    })
  }

  build() {
    Scroll() {
      Column() {
        SearchBar({ placeholder: '搜索美食、酒店、娱乐...' }).margin({ bottom: 14 })

        BannerSwiper({ banners: this.banners })

        CategoryGrid({
          categories: this.categories,
          onCategoryClick: (cat: CategoryItem) => {
            // 实际场景：跳转分类列表页，这里演示事件回调从子组件到父组件的传递
            router.pushUrl({ url: 'pages/DetailPage', params: { name: `${cat.name}分类`, price: 0, color: '#E0E0E0' } })
          }
        }).margin({ top: 14 })

        SectionHeader({ title: '热门推荐' })
        HotProductList({
          products: this.products,
          onItemClick: (item: ProductItem) => this.goDetail(item)
        })

        SectionHeader({ title: '精选活动', showMore: false })
        ActivitySection({ activities: this.activities })

        SectionHeader({ title: '人气榜单' })
        RankList({
          products: this.products,
          onItemClick: (item: ProductItem) => this.goDetail(item)
        })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12, bottom: 20 })
    }
    .scrollBar(BarState.Off)
    .width('100%').height('100%')
    .backgroundColor('#F5F6FA')
  }
}
