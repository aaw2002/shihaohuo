import axios, { AxiosError, AxiosResponse, InternalAxiosRequestConfig } from '@ohos/axios'
import { auth, Logger, MKNavPathStack } from '../../../../Index'
import { promptAction } from '@kit.ArkUI'

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
  static get<T>(url: string, params?: object) {
    return axiosInstance.get<null, ResponseType<T>>(url, { params: params })
  }

  static post<T>(url: string, data?: object) {
    return axiosInstance.post<null, ResponseType<T>>(url, data)
  }

  static put<T>(url: string, data?: object) {
    return axiosInstance.put<null, ResponseType<T>>(url, data)
  }

  static delete<T>(url: string, data?: object) {
    return axiosInstance.delete<null, ResponseType<T>>(url, { params: data })
  }
}

// 添加请求拦截器
axiosInstance.interceptors.request.use((config: InternalAxiosRequestConfig) => {
  // 对请求数据做点什么
  const user = auth.getUser();
  if (user.token) {
    config.headers.Authorization = `Bearer ${user.token}`
    // Logger.info(config)
  }
  return config;
}, (error: AxiosError) => {
  // 对请求错误做些什么
  return Promise.reject(error);
});


// 添加响应拦截器
axiosInstance.interceptors.response.use((response: AxiosResponse) => {
  // 对响应数据做点什么
  // Logger.info(response)


  return response;

}, (error: AxiosError<APIErrorType>) => {
  // 对响应错误做点什么
  if (error.status == 400) {
    //参数错误
    promptAction.showToast({
      message: error.response?.data.message,
    })
  } else if (error.status == 401) {
    // token过期
    promptAction.showToast({
      message: '身份验证失败，请先登录',
    })
    auth.removeUser()
    MKNavPathStack.pushPath({ name: 'LoginView' })
  }
  return Promise.reject(error);
});

// 增加类型
export interface APIErrorType {
  message: string
  msg: string
  code: string
}
