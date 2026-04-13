import { UserProfile, QuickEntry, SettingGroup } from '../models/DataModels'

export const MOCK_USER: UserProfile = {
  nickname: '生活家小明',
  avatar: '😊',
  level: '黄金会员',
  points: 2580,
  orderCount: 12,
  favoriteCount: 36,
  historyCount: 128,
  couponCount: 5,
}

export const MOCK_QUICK_ENTRIES: QuickEntry[] = [
  { icon: '📦', label: '我的订单', count: 12 },
  { icon: '❤️', label: '我的收藏', count: 36 },
  { icon: '👁️', label: '浏览记录', count: 128 },
  { icon: '🎫', label: '优惠券', count: 5 },
]

export const MOCK_SETTINGS: SettingGroup[] = [
  {
    title: '订单管理',
    items: [
      { icon: '📦', title: '我的订单', value: '', hasArrow: true },
      { icon: '🎫', title: '优惠券', value: '5张可用', hasArrow: true },
      { icon: '💰', title: '余额', value: '¥128.00', hasArrow: true },
    ]
  },
  {
    title: '通用设置',
    items: [
      { icon: '🔔', title: '消息通知', value: '', hasArrow: true },
      { icon: '🌙', title: '深色模式', value: '', hasArrow: false },
      { icon: '🗑️', title: '清除缓存', value: '23.5MB', hasArrow: true },
      { icon: '🌐', title: '语言', value: '简体中文', hasArrow: true },
    ]
  },
  {
    title: '关于',
    items: [
      { icon: '📄', title: '用户协议', value: '', hasArrow: true },
      { icon: '🔒', title: '隐私政策', value: '', hasArrow: true },
      { icon: 'ℹ️', title: '关于我们', value: 'v1.0.0', hasArrow: true },
    ]
  },
]
