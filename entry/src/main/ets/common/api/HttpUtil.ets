import { ApiConfig } from './ApiConfig'

/**
 * 网络请求封装。
 * USE_MOCK = true 时：直接返回调用方传入的 mockData，用 setTimeout 模拟网络延迟。
 * USE_MOCK = false 时：走真实 http 请求（预留骨架）。
 *
 * 后端对接只需：1. ApiConfig.USE_MOCK = false  2. 填好 BASE_URL
 */
export class HttpUtil {

  static async request<T>(url: string, mockData: T): Promise<T> {
    if (ApiConfig.USE_MOCK) {
      return HttpUtil.mockRequest<T>(mockData)
    }
    return HttpUtil.realRequest<T>(url)
  }

  private static mockRequest<T>(data: T): Promise<T> {
    return new Promise<T>((resolve) => {
      setTimeout(() => resolve(data), ApiConfig.MOCK_DELAY)
    })
  }

  private static async realRequest<T>(url: string): Promise<T> {
    // TODO: 后端对接时启用
    // import { http } from '@kit.NetworkKit'
    // const req = http.createHttp()
    // const resp = await req.request(ApiConfig.BASE_URL + url, {
    //   method: http.RequestMethod.GET,
    //   header: { 'Content-Type': 'application/json' },
    // })
    // req.destroy()
    // const body = JSON.parse(resp.result as string) as ApiResponse<T>
    // if (body.code !== 0) throw new Error(body.message)
    // return body.data
    throw new Error(`[HttpUtil] 真实请求未启用: ${ApiConfig.BASE_URL}${url}`)
  }
}
