
import axios, { AxiosResponse } from '@ohos/axios'
// 创建 axios 实例，配置 baseURL 请求基地址 和 timeout 超时时间
export const axiosInstance = axios.create({
  baseURL: 'https://meikou-api.itheima.net/',
  timeout: 20000
})

// 后端返回的数据格式
export interface HttpResponse<T> {
  code: string
  msg: string
  result: T // 变化部分用泛型 T 表示
}

// 类型别名，相当于一个变量，可以存储任意类型
// AxiosResponse 是 axios 响应类型
// HttpResponse  是 后端响应的数据格式
// T 是 变化部分，泛型，也就是接口的返回的核心数据
export type ResponseType<T> = AxiosResponse<HttpResponse<T>>

export class RequestAxios {
  static get<T> (url:string,params?:object){
    return axiosInstance.get<null,ResponseType<T> >(url, { params:params })
  }
  static post<T> (url:string,data?:object){
    return axiosInstance.post<null,ResponseType<T> >(url,data)
  }
  static put<T> (url:string,data?:object){
    return axiosInstance.put<null,ResponseType<T> >(url,data)
  }
  static delete<T> (url:string,data?:object){
    return axiosInstance.delete<null,ResponseType<T> >(url,{params:data})
  }
}