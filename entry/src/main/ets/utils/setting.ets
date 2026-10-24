import { CURRENT_USER, STORY, TIKTOK_CONNECT, UserRecord_KEY } from '../constants'
import { CurrentUser, defaultUserInfo, UserInfo, UserInfoModel } from '../models/user'
import { MessageInfoModel } from '../models/message'
import { preferences } from '@kit.ArkData'
import { C, P } from '../common'
import { Constants } from '../common/Constants'

type U = UserInfoModel
type M = MessageInfoModel

/**
 * 首选项仓库
 * */
export class Tiktok {

  private context?: C

  constructor(ctx?: C) {
    this.context = ctx
  }

  getStore():P {
    //模块加载期拿不到UI实例context 统一在调用时惰性获取
    const ctx = this.context || AppStorage.get<C>(Constants.GET_CONTEXT) as C
    return preferences.getPreferencesSync(ctx, {
      name: STORY,
    })
  }

  getData<T>(key: string, value: preferences.ValueType):T{
    const Store = this.getStore()
    return JSON.parse(Store.getSync(key, JSON.stringify(value)) as string) as T
  }

  /**
   * 读取以JSON数组存放的键
   * 数组缺省值不能再走一次JSON.stringify 否则解析出来的是字符串'[]'*/
  getList<T>(key: string): T[] {
    const list = JSON.parse(this.getStore().getSync(key, '[]') as string) as T[]
    return Array.isArray(list) ? list : []
  }
  /**
   * 获取用户信息*/
  getUserInfo(){
    const Store = this.getStore()
    return Store.getSync(CURRENT_USER, CurrentUser)
  }

  /**
   * 获取抖音联系人
   * 联系人从未落库 首选项没有这个键时用默认列表兜底*/
  getTikTokConnect(): U[] {
    const list = this.getList<UserInfo>(TIKTOK_CONNECT)
    return (list.length ? list : defaultUserInfo).map(item => new UserInfoModel(item))
  }

  async setCurrentUser(token: string) {
    const Store = this.getStore()
    Store.putSync(CURRENT_USER, token) //将数据写入缓存的首选项实例中
    await Store.flush() //写入内存
  }

  /**
   * 把当前用户同步进AppStorage
   * 读取方都是 @StorageProp currentUser: UserInfoModel 所以这里绝不能写字符串
   * 退出登录传空模型 首选项仍由 setCurrentUser('') 清空以保留登录门禁判断*/
  syncCurrentUser(user: U) {
    AppStorage.setOrCreate(CURRENT_USER, user)
  }

  /**
   * 获取当前用户*/
  getCurrentUser(): U {
    //如果首选项的用户数据是空字符串返回相关数据
    return this.getUserInfo()?
      new UserInfoModel(this.getData<UserInfo>(CURRENT_USER,CurrentUser)) :
      //首次进入程序首选项没有任何数据返回一个空对象 防止出现无法进入程序等报错
      new UserInfoModel({} as UserInfo)
  }


  /**
   * 获取'我'和某个用户的整个的聊天记录 userid对话者的id
   * */
  getChatMessage(userId: string): M[] { //UserRecord_userid=>所有的聊天记录
    return this.getList<M>(`${UserRecord_KEY}_${userId}`)
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
}

//构造期不捕获context getStore会在调用时惰性获取
export const tiktok = new Tiktok()