import { BannerItem, CategoryItem, ProductItem, ActivityItem, ProductDetail } from '../models/DataModels'
import { HOME_BANNERS, HOME_CATEGORIES, HOME_PRODUCTS, HOME_ACTIVITIES, HOME_PRODUCT_DETAIL } from '../mock/HomeMock'
import { HttpUtil } from './HttpUtil'

export class HomeApi {
  static async getBanners(): Promise<BannerItem[]> {
    return HttpUtil.request<BannerItem[]>('/api/home/banners', HOME_BANNERS)
  }

  static async getCategories(): Promise<CategoryItem[]> {
    return HttpUtil.request<CategoryItem[]>('/api/home/categories', HOME_CATEGORIES)
  }

  static async getProducts(): Promise<ProductItem[]> {
    return HttpUtil.request<ProductItem[]>('/api/home/products', HOME_PRODUCTS)
  }

  static async getActivities(): Promise<ActivityItem[]> {
    return HttpUtil.request<ActivityItem[]>('/api/home/activities', HOME_ACTIVITIES)
  }

  static async getProductDetail(_id: number): Promise<ProductDetail> {
    return HttpUtil.request<ProductDetail>(`/api/product/${_id}`, HOME_PRODUCT_DETAIL)
  }
}
