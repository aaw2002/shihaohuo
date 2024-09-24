import { CategoryItem, RequestAxios } from 'basic'
import { Banner, iResult, MkGoodsItem, SubType } from '../viewmodel'
import { IServiceData } from '../views/SearchResultView'

// 获取轮播图数据
export const getBannerApi = async () => {
  let res = await RequestAxios.get<Banner[]>('/home/banner')
  return res.data
}

// 获取分类数据
export const getCategoryApi = async () => {
  let res = await RequestAxios.get<CategoryItem[]>('/home/category/head')
  return res.data
}

//获取特惠推荐
export const getSaleGoodsApi = async () => {
  let res = await RequestAxios.get<iResult>('/hot/preference')
  return res.data
}

// 获取爆款推荐
export const getHotGoodsApi = async () => {
  let res = await RequestAxios.get<iResult>('/hot/inVogue')
  return res.data.result.subTypes
}

// 首页-一站买全

export const getOneStopApi = async () => {
  let res = await RequestAxios.get<iResult>('/hot/oneStop')
  return res.data
}


///新鲜好物
export const getNewGoodsApi = async () => {
  let res = await RequestAxios.get<MkGoodsItem[]>('/home/new', new Object({ limit: 8 }))
  return res.data
}

//推荐列表
export const getRecommendApi = async (limit: number = 10) => {
  let res = await RequestAxios.get<MkGoodsItem[]>('/home/recommend', new Object({ limit }))
  return res.data
}

//搜索商品
// 开发中
// POST
// /search/all
export const searchGoodsApi = async (params: object) => {
  let res = await RequestAxios.post<IServiceData>('/search/all', params)
  return res.data.result
}