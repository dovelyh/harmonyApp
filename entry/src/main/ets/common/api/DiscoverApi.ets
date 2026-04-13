import { DiscoverItem } from '../models/DataModels'
import { DISCOVER_LIST } from '../mock/DiscoverMock'
import { HttpUtil } from './HttpUtil'

export class DiscoverApi {
  static async getList(category?: string): Promise<DiscoverItem[]> {
    const all = await HttpUtil.request<DiscoverItem[]>('/api/discover/list', DISCOVER_LIST)
    if (category && category !== '全部') {
      return all.filter((d: DiscoverItem) => d.category === category)
    }
    return all
  }

  static async getDetail(id: number): Promise<DiscoverItem | undefined> {
    const all = await HttpUtil.request<DiscoverItem[]>(`/api/discover/${id}`, DISCOVER_LIST)
    return all.find((d: DiscoverItem) => d.id === id)
  }
}
