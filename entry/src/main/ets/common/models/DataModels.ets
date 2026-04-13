export interface BannerItem {
  id: number
  title: string
  subtitle: string
  color: string
}

export interface CategoryItem {
  id: number
  icon: string
  name: string
}

export interface ProductItem {
  id: number
  name: string
  price: number
  originalPrice: number
  sales: number
  rating: number
  category: string
  color: string
  tags: string[]
}

export interface ActivityItem {
  id: number
  title: string
  description: string
  tag: string
  color: string
}

export interface DiscoverItem {
  id: number
  title: string
  content: string
  author: string
  avatar: string
  likes: number
  comments: number
  time: string
  category: string
}

export interface MessageItem {
  id: number
  name: string
  avatar: string
  lastMessage: string
  time: string
  unread: number
}

export interface NotificationItem {
  id: number
  title: string
  content: string
  time: string
  read: boolean
  type: string
}

export interface UserProfile {
  nickname: string
  avatar: string
  level: string
  points: number
  orderCount: number
  favoriteCount: number
  historyCount: number
  couponCount: number
}

export interface SettingItem {
  icon: string
  title: string
  value: string
  hasArrow: boolean
}

export interface SettingGroup {
  title: string
  items: SettingItem[]
}

export interface QuickEntry {
  icon: string
  label: string
  count: number
}

export interface ProductDetail {
  content: string
  rules: string
  tips: string
}
