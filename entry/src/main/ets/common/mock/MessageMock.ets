import { MessageItem, NotificationItem } from '../models/DataModels'

export const MESSAGE_LIST: MessageItem[] = [
  { id: 1, name: '味道餐厅', avatar: '🍜', lastMessage: '您预订的座位已确认，今晚18:00', time: '刚刚', unread: 2 },
  { id: 2, name: '城市酒店', avatar: '🏨', lastMessage: '尊敬的会员，您的订单已完成', time: '10分钟前', unread: 0 },
  { id: 3, name: '运动健身', avatar: '💪', lastMessage: '您的月卡将于3天后到期，续费享8折', time: '1小时前', unread: 1 },
  { id: 4, name: '好友小李', avatar: '😄', lastMessage: '周末一起去那家新开的火锅店吧', time: '3小时前', unread: 3 },
  { id: 5, name: '美丽说', avatar: '💄', lastMessage: '您收藏的商品正在打折，快来看看', time: '昨天', unread: 0 },
  { id: 6, name: '出行助手', avatar: '🚗', lastMessage: '您的行程提醒：明天上午9:00出发', time: '昨天', unread: 1 },
]

export const NOTIFICATION_LIST: NotificationItem[] = [
  { id: 1, title: '订单已完成', content: '您在味道餐厅的订单已完成，快去评价赢积分吧', time: '10分钟前', read: false, type: 'order' },
  { id: 2, title: '优惠券即将过期', content: '您有2张优惠券将在3天后过期，请尽快使用', time: '1小时前', read: false, type: 'activity' },
  { id: 3, title: '系统维护通知', content: '平台将于今晚23:00-次日01:00进行系统维护', time: '5小时前', read: true, type: 'system' },
  { id: 4, title: '会员等级升级', content: '恭喜您升级为黄金会员，享受更多专属特权', time: '昨天', read: true, type: 'system' },
  { id: 5, title: '新活动上线', content: '周末免单活动已开启，消费满100元即可参与抽奖', time: '2天前', read: true, type: 'activity' },
]
