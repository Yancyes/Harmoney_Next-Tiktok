/**
 * 这是发消息的接口
 * 接口结构必须和发请求的接口一致
 * */
export interface ChatResponse{
  status: number
  message: string
  data:ChatData
}
export interface ChatData{
  type: string
  info:ChatInfo
}
export interface ChatInfo{
  text: string
}