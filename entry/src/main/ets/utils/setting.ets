import { CURRENT_USER, STORY, TIKTOK_CONNECT, UserRecord_KEY } from '../constants'
import { CurrentUser, defaultUserInfo, UserInfo, UserInfoModel } from '../models/user'
import { MessageInfoModel } from '../models/message'
import { preferences } from '@kit.ArkData'
import { C, P } from '../common'

type U = UserInfoModel
type M = MessageInfoModel

/**
 * 首选项仓库
 * */
export class Tiktok {

  private context: C

  constructor(ctx: C) {
    this.context = ctx
  }

  getStore():P {
    return preferences.getPreferencesSync(this.context||getContext(),{
      name: STORY,
    })
  }

  getData<T>(key: string, value: preferences.ValueType):T{
    const Store = this.getStore()
    return JSON.parse(Store.getSync(key, JSON.stringify(value)) as string) as T
  }
  /**
   * 获取用户信息*/
  getUserInfo(){
    const Store = this.getStore()
    return Store.getSync(CURRENT_USER, CurrentUser)
  }

  /**
   * 获取抖音联系人*/
  getTikTokConnect() {
    return this.getData<U[]>(TIKTOK_CONNECT, defaultUserInfo)
  }

  async setCurrentUser(token: string) {
    const Store = this.getStore()
    Store.putSync(CURRENT_USER, token) //将数据写入缓存的首选项实例中
    await Store.flush() //写入内存
  }

  /**
   * 获取当前用户*/
  getCurrentUser() {
    //如果首选项的用户数据是空字符串返回相关数据
    return this.getUserInfo()?
      this.getData<U>(CURRENT_USER,CurrentUser) :
      //首次进入程序首选项没有任何数据返回一个空对象 防止出现无法进入程序等报错
      new UserInfoModel({} as UserInfo)
  }


  /**
   * 获取'我'和某个用户的整个的聊天记录 userid对话者的id
   * */
  getChatMessage(userId: string) { //UserRecord_userid=>所有的聊天记录
    return this.getData<M[]>(`${UserRecord_KEY}_${userId}`, '[]')
  }

  /**
   * 删除'我和某个人的整个的聊天记录'*/
  async delChatMessage(userId: string) {
    const store = this.getStore()
    store.deleteSync(`${UserRecord_KEY}_${userId}`)
    await store.flush()
  }

  /**
   * 添加一条"我"和某个人的聊天记录*/
  async addOwnChatMessage(userId: string, message: M) {
    const store = this.getStore()
    const list = this.getChatMessage(userId) //拿到所有的所有的聊天记录
    // 写入list
    list.push(message)
    store.putSync(`${UserRecord_KEY}_${userId}`, JSON.stringify(list))
    await store.flush()
  }

  /**
   * 删除一条"我"和某个人的聊天记录*/
  async delOwnChatMessage(userId: string, messId: string) {
    const store = this.getStore()
    const list = this.getChatMessage(userId) //拿到所有的所有的聊天记录
    const index = list.findIndex(item => item.id === messId)
    list.splice(index, 1) //删除
    // 写入list
    store.putSync(`${UserRecord_KEY}_${userId}`, JSON.stringify(list))
    await store.flush()
  }

  /**
   * 获取所有人的最后的一条聊天记录的集合*/
  getAllLastRecord() {
    const store = this.getStore()
    const arr: M[] = []
    const result = store.getAllSync() as object
    Object.keys(result).forEach(key => {
      if (key.includes(UserRecord_KEY)) {
        //key对应的value
        if (result[key]) {
          const list = JSON.parse(result[key]) as M[] //所有的聊天记录
          if (list.length) {
            arr.push(list[list.length-1])

          }
        }
      }
    })
    //按照时间排序
    arr.sort((a: M, b: M) => {
      return b.sendTime - a.sendTime
    }) //会对原数组排序
    return arr
  }
}

export const tiktok = new Tiktok(getContext())