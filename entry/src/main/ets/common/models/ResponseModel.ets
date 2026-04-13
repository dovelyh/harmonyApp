/**
 * 统一接口响应结构 —— 后端返回的 JSON 统一遵循这个格式。
 * 页面只关心 data 字段；HttpUtil 负责拦截 code !== 0 的异常。
 */
export interface ApiResponse<T> {
  code: number
  message: string
  data: T
}
