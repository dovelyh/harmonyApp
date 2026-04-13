/**
 * 环境配置 —— 切换 dev / staging / prod 时只改这一个文件。
 * 后端对接时，把 USE_MOCK 改为 false，BASE_URL 改为真实地址即可。
 */
export class ApiConfig {
  static readonly USE_MOCK: boolean = true
  static readonly MOCK_DELAY: number = 300

  static readonly ENV: string = 'dev' // 'dev' | 'staging' | 'prod'

  static get BASE_URL(): string {
    if (ApiConfig.ENV === 'prod') {
      return 'https://api.yourapp.com'
    } else if (ApiConfig.ENV === 'staging') {
      return 'https://staging-api.yourapp.com'
    }
    return 'http://192.168.1.100:3000'
  }
}
