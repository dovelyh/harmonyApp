import { DiscoverItem } from '../models/DataModels'

export const DISCOVER_CATEGORIES: string[] = ['全部', '美食', '出行', '电影', '购物', '休闲', '酒店']

export const DISCOVER_LIST: DiscoverItem[] = [
  { id: 1, title: '探店｜藏在胡同里的宝藏日料店', content: '今天发现一家超级隐蔽的日料店，三文鱼刺身新鲜到爆，性价比极高，人均不到80元就能吃到撑...', author: '美食侦探', avatar: '🧑‍🍳', likes: 234, comments: 45, time: '2小时前', category: '美食' },
  { id: 2, title: '周末徒步｜城市周边最美步道', content: '整理了5条适合周末的徒步路线，从入门到进阶都有，带上家人朋友一起出发吧...', author: '户外达人', avatar: '🏃', likes: 567, comments: 89, time: '5小时前', category: '出行' },
  { id: 3, title: '宅家也能做的高级甜品', content: '不用烤箱也能做的提拉米苏，只需要5种材料，30分钟搞定，味道不输甜品店...', author: '烘焙小厨', avatar: '👩‍🍳', likes: 891, comments: 126, time: '8小时前', category: '美食' },
  { id: 4, title: '高分电影推荐｜治愈系必看清单', content: '最近看了几部特别治愈的电影，适合下雨天窝在沙发上看，每一部都让人感觉心里暖暖的...', author: '影迷日记', avatar: '🎬', likes: 345, comments: 67, time: '昨天', category: '电影' },
  { id: 5, title: '旅行穿搭指南｜一个行李箱搞定', content: '出门旅行总是纠结带什么衣服？教你用8件单品搭出一周不重样的穿搭方案...', author: '时尚旅人', avatar: '👗', likes: 1203, comments: 234, time: '昨天', category: '购物' },
  { id: 6, title: '新开的沉浸式剧场太好玩了', content: '周末去体验了新开的沉浸式推理剧场，3小时完全沉浸在剧情中，强烈推荐给喜欢推理的朋友...', author: '玩乐体验官', avatar: '🎭', likes: 456, comments: 78, time: '2天前', category: '休闲' },
  { id: 7, title: '酒店控必看｜五星自助餐评测', content: '测评了本市5家五星级酒店的自助餐，从海鲜到甜品逐一打分，最后一家性价比最高...', author: '酒店品鉴师', avatar: '🏨', likes: 678, comments: 145, time: '2天前', category: '酒店' },
  { id: 8, title: '带娃周末好去处｜室内乐园合集', content: '盘点了城市里6个室内亲子乐园，有适合1-3岁的，也有适合学龄儿童的，下雨天再也不愁没地方去...', author: '宝妈日记', avatar: '👶', likes: 902, comments: 198, time: '3天前', category: '休闲' },
]
