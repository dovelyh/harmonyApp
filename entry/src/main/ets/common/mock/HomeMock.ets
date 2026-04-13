import { BannerItem, CategoryItem, ProductItem, ActivityItem, ProductDetail } from '../models/DataModels'

export const HOME_BANNERS: BannerItem[] = [
  { id: 1, title: '新人专享福利', subtitle: '首单立减20元，更多优惠等你来', color: '#FF6B35' },
  { id: 2, title: '周末特惠专场', subtitle: '精选套餐低至5折，限时抢购', color: '#667EEA' },
  { id: 3, title: '美食节狂欢', subtitle: '百家餐厅联合特惠，吃遍全城', color: '#11998E' },
  { id: 4, title: '会员日双倍积分', subtitle: '每月15日，积分翻倍享不停', color: '#E74C3C' },
]

export const HOME_CATEGORIES: CategoryItem[] = [
  { id: 1, icon: '🍜', name: '美食' },
  { id: 2, icon: '🏨', name: '酒店' },
  { id: 3, icon: '🎬', name: '电影' },
  { id: 4, icon: '🛵', name: '外卖' },
  { id: 5, icon: '🛍️', name: '购物' },
  { id: 6, icon: '🚗', name: '出行' },
  { id: 7, icon: '🎮', name: '休闲' },
  { id: 8, icon: '📋', name: '更多' },
]

export const HOME_PRODUCTS: ProductItem[] = [
  { id: 1, name: '精品日料双人套餐', price: 128, originalPrice: 198, sales: 2341, rating: 4.8, category: '美食', color: '#FFE4D6', tags: ['人气', '必吃'] },
  { id: 2, name: '城市精选观光酒店', price: 299, originalPrice: 459, sales: 1892, rating: 4.6, category: '酒店', color: '#D6E4FF', tags: ['特价', '含早'] },
  { id: 3, name: '双人观影套餐', price: 59.9, originalPrice: 88, sales: 5621, rating: 4.9, category: '电影', color: '#E8D6FF', tags: ['热映'] },
  { id: 4, name: '养生SPA全身护理', price: 188, originalPrice: 328, sales: 876, rating: 4.7, category: '休闲', color: '#D6FFE4', tags: ['好评'] },
  { id: 5, name: '周末近郊短途游', price: 399, originalPrice: 599, sales: 1234, rating: 4.5, category: '出行', color: '#FFD6D6', tags: ['周末'] },
  { id: 6, name: '亲子乐园全天票', price: 68, originalPrice: 98, sales: 3456, rating: 4.8, category: '休闲', color: '#FFFBD6', tags: ['亲子', '热门'] },
  { id: 7, name: '健身月卡体验', price: 49, originalPrice: 199, sales: 7890, rating: 4.4, category: '休闲', color: '#D6F5FF', tags: ['限时'] },
  { id: 8, name: '美甲美睫精选套餐', price: 89, originalPrice: 158, sales: 2345, rating: 4.6, category: '购物', color: '#FFD6F5', tags: ['新品'] },
]

export const HOME_ACTIVITIES: ActivityItem[] = [
  { id: 1, title: '限时秒杀', description: '每日10点、14点、20点准时开抢', tag: '即将开始', color: '#FF6B35' },
  { id: 2, title: '拼团特惠', description: '2人成团，低至3折起', tag: '火热进行中', color: '#667EEA' },
  { id: 3, title: '周末免单', description: '消费满100元抽免单资格', tag: '本周限定', color: '#52C41A' },
]

export const HOME_PRODUCT_DETAIL: ProductDetail = {
  content: '【套餐内容】精选新鲜食材，由专业大厨精心制作。包含前菜、主菜、甜品和饮品各一份，适合2人享用。',
  rules: '· 有效期：购买后30天内\n· 使用时间：每日11:00-21:00\n· 需提前1天预约\n· 每桌限用1张',
  tips: '如遇节假日高峰期，建议提前2天预约。门店地址请在订单详情中查看。',
}
