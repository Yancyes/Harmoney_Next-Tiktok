import { Log } from '@abner/log'
import axios, { AxiosError, AxiosRequestConfig, AxiosResponse, InternalAxiosRequestConfig } from '@ohos/axios'


const BASE_URL = 'https://api.ownthink.com/'
//创建实例
const instance = axios.create({
  baseURL: BASE_URL,
  timeout: 5000
})

//异常信息需序列化"当前"的错误对象 模块加载期固化的字符串永远为空
const logError = (error: AxiosError) => Log.error('3.异常信息' + JSON.stringify(error))
//请求拦截器
instance.interceptors.request.use((config: InternalAxiosRequestConfig) => {
  return config
}, (error: AxiosError) => {
  //请求错误
  logError(error)
  return Promise.reject(error)
})
//响应拦截器
instance.interceptors.response.use((response: AxiosResponse) => {
  //打印信息
  Log.info('2.响应结果' + JSON.stringify(response))
  //返回数据]
  return response.data

}, (error: AxiosError) => {
  logError(error)
  return Promise.reject(error)
})

//r 是返回类型 d 是请求类型
export const request = <Response = null, DataParms = null>(config: AxiosRequestConfig) => {
  return instance.request<null, Response, DataParms>(config)
}

export { instance }