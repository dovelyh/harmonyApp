import { UserProfile, QuickEntry, SettingGroup } from '../models/DataModels'
import { MOCK_USER, MOCK_QUICK_ENTRIES, MOCK_SETTINGS } from '../mock/MineMock'
import { HttpUtil } from './HttpUtil'

export class MineApi {
  static async getProfile(): Promise<UserProfile> {
    return HttpUtil.request<UserProfile>('/api/user/profile', MOCK_USER)
  }

  static async getQuickEntries(): Promise<QuickEntry[]> {
    return HttpUtil.request<QuickEntry[]>('/api/user/quick-entries', MOCK_QUICK_ENTRIES)
  }

  static async getSettings(): Promise<SettingGroup[]> {
    return HttpUtil.request<SettingGroup[]>('/api/user/settings', MOCK_SETTINGS)
  }
}
