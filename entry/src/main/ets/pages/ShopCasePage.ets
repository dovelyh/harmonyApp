import { router } from '@kit.ArkUI';

import { PRODUCT_ITEMS, ProductItem } from '../common/LearningData';

@Styles
function shopCard() {
  .width('100%')
  .padding(16)
  .backgroundColor(Color.White)
  .borderRadius(18)
  .margin({ bottom: 12 })
  .shadow({ radius: 10, color: 'rgba(15, 23, 42, 0.08)', offsetX: 0, offsetY: 4 })
}

@Entry
@Component
struct ShopCasePage {
  @State category: string = '全部'
  @State cartCount: number = 0
  @State budget: number = 80

  private categories: string[] = ['全部', '学习资料', '项目模板', '练习题', '设计资源', '组件方案']

  private getVisibleProducts(): ProductItem[] {
    return PRODUCT_ITEMS.filter((item: ProductItem) => {
      const matchesCategory: boolean = this.category === '全部' || item.category === this.category;
      const withinBudget: boolean = item.price <= this.budget;

      return matchesCategory && withinBudget;
    });
  }

  @Builder
  PageHeader() {
    Column({ space: 12 }) {
      Row() {
        Button('返回案例市场')
          .fontSize(13)
          .fontColor('#5b6ee1')
          .backgroundColor('#eef1ff')
          .onClick(() => {
            router.back();
          })

        Blank()

        Text(`购物车 ${this.cartCount}`)
          .fontSize(12)
          .fontColor('#0f172a')
          .backgroundColor('#f8fafc')
          .padding({ left: 10, right: 10, top: 6, bottom: 6 })
          .borderRadius(999)
      }
      .width('100%')

      Text('商城列表案例')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor('#0f172a')

      Text('这个页面重点练习筛选、卡片布局、价格信息和购物车数量联动。')
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
          Text('预算过滤')
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .fontColor('#0f172a')

          Row({ space: 8 }) {
            Text('预算')
              .fontSize(13)
              .fontColor('#475569')
            Slider({ value: this.budget, min: 20, max: 100 })
              .layoutWeight(1)
              .selectedColor('#2563eb')
              .onChange((value: number) => {
                this.budget = Math.round(value);
              })
            Text(`${this.budget} 元`)
              .fontSize(13)
              .fontColor('#2563eb')
          }
          .width('100%')

          Progress({ value: this.budget, total: 100, type: ProgressType.Linear })
            .width('100%')
            .color('#2563eb')
            .backgroundColor('#dbeafe')
        }
        .shopCard()

        Column({ space: 12 }) {
          Text('分类筛选')
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .fontColor('#0f172a')

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
        }
        .shopCard()

        Column({ space: 10 }) {
          Text('商品列表')
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .fontColor('#0f172a')

          ForEach(this.getVisibleProducts(), (item: ProductItem) => {
            Column({ space: 10 }) {
              Row() {
                Text(item.category)
                  .fontSize(11)
                  .fontColor('#2563eb')
                  .backgroundColor('#eff6ff')
                  .padding({ left: 8, right: 8, top: 4, bottom: 4 })
                  .borderRadius(999)

                if (item.featured) {
                  Text('精选')
                    .fontSize(11)
                    .fontColor('#f97316')
                    .backgroundColor('#fff7ed')
                    .padding({ left: 8, right: 8, top: 4, bottom: 4 })
                    .borderRadius(999)
                    .margin({ left: 8 })
                }
              }

              Text(item.name)
                .fontSize(15)
                .fontWeight(FontWeight.Bold)
                .fontColor('#0f172a')
              Text(item.desc)
                .fontSize(13)
                .fontColor('#64748b')
                .lineHeight(20)
              Text(`¥ ${item.price.toFixed(1)} · 评分 ${item.rating} · 库存 ${item.stock}`)
                .fontSize(12)
                .fontColor('#94a3b8')

              Button('加入购物车')
                .width('100%')
                .backgroundColor('#16a34a')
                .fontColor(Color.White)
                .onClick(() => {
                  this.cartCount += 1;
                })
            }
            .shopCard()
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
