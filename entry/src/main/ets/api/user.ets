import { UserInfoModel, userToPlain } from '../models'

/**
 * 用户数据*/
export const userData = (data: UserInfoModel) => {
  //使用静态数据不用和使用(封装登录请求)
  return JSON.stringify(userToPlain(data))
}
