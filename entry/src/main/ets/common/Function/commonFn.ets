/*
 * 公共方法类库*/
import { cities, netAvatars, nickNames } from '../../models'
import { Constants } from '../Constants'
import { util } from '@kit.ArkTS'
import { tiktok } from '../../utils/setting'
import { preferences } from '@kit.ArkData'
import { AppEnv } from '../AppEnv'
export type P = preferences.Preferences
export type P_O = preferences.Options
export type C = Context
/**
 * 提示弹窗
 * @param {String} msg传入需要的提示信息
 * @default 默认值:功能未完善
 * @return {Function} 返回一个弹窗信息*/
const showToast =
  (message: string = "功能未完善", time: number = 1500, alignment?: Alignment,
    backgroundColor: ResourceColor = Constants.COLOR_DIALOG_BG, offset?: Offset
  ) => {
    AppEnv.uiContext?.getPromptAction()?.showToast({
      message,
      backgroundColor,
      textColor: Color.White,
      duration: time,
      backgroundBlurStyle: BlurStyle.NONE,
      alignment,
      offset: offset || { dx: null, dy: 200 }
    })
  }

class commonFn {
  /**未登录时的提示弹窗*/
  private showLoginTip() {
    AppEnv.uiContext?.showAlertDialog({
      title: '登录状态监测',
      message: '请先登录!',
      alignment: DialogAlignment.Center,
      confirm: {
        value: '确定',
        action: () => {
          this.nav(Constants.ROUTE_LOGIN)
        }
      }
    })
  }

  /**路由重定向*/
  redirect() {
    //如果不是空字符串跳转到登录页
    if (!tiktok.getUserInfo()) {
      this.showLoginTip()
    }
  }

  /**
   * 登录门禁
   * 之前每个入口都要手写一遍 redirect()+if(getUserInfo()) 判断*/
  withLogin(action: () => void) {
    if (tiktok.getUserInfo()) {
      action()
    } else {
      this.showLoginTip()
    }
  }

  /**
   * 统一路由跳转 走router_map.json注册的系统路由表
   * 全应用只有一个Navigation宿主 栈直接取AppEnv的路由栈
   * @param name 路由名 一律取Constants里的ROUTE_*常量
   * @param param 页面参数 目标页在NavDestination的onReady里读pathInfo.param*/
  nav(name: string, param?: Object) {
    AppEnv.pathStack.pushPathByName(name, param)
  }

  /**
   * 返回上一页*/
  back() {
    AppEnv.pathStack.pop()
  }

  /**
   * 清空路由栈 传name时再压入目标路由
   * 登录后栈中只剩登录页 清空即露出宿主首页
   * 退出登录不清空的话返回键会退回已登出的页面栈*/
  navWithClear(name?: string) {
    const stack = AppEnv.pathStack
    stack.clear()
    if (name) {
      stack.pushPathByName(name, undefined)
    }
  }

  /**
   * 私信时间分隔文案 当天只显示时分 昨天及以前补上日期*/
  formatMsgTime(sendTime: number): string {
    const date = new Date(sendTime)
    const now = new Date()
    const time = `${this.toStr(date.getHours())}:${this.toStr(date.getMinutes())}`
    if (date.getDate() === now.getDate() && date.getMonth() === now.getMonth() && date.getFullYear() === now.getFullYear()) {
      return time
    }
    const yesterday = new Date(now.getTime() - 24 * 60 * 60 * 1000)
    if (date.getDate() === yesterday.getDate() && date.getMonth() === yesterday.getMonth() &&
      date.getFullYear() === yesterday.getFullYear()) {
      return `昨天 ${time}`
    }
    return `${date.getMonth() + 1}月${date.getDate()}日 ${time}`
  }

  getJsonFileData(path: string) {
    return new util.TextDecoder().decodeToString(AppEnv.context!.resourceManager.getRawFileContentSync(path))
  }

  /**
   * 按种子在池里取样 同一个种子恒定命中同一个元素*/
  private pick<T>(pool: T[], seed: string): T {
    let sum = 0
    for (let i = 0; i < seed.length; i++) {
      sum += seed.charCodeAt(i)
    }
    return pool[sum % pool.length]
  }

  /**
   * 头像兜底
   * @param src 已有头像 为空时用网络头像替代
   * @param seed 取样的种子 一般传用户id 保证同一个人每次进来是同一张脸*/
  avatar(src: string | undefined, seed: string = ''): string {
    return src ? src : this.pick(netAvatars, seed)
  }

  /**
   * 昵称兜底
   * @param src 已有昵称 为空时按种子从英文名池随机取一个
   * @param seed 取样的种子 一般传用户id*/
  nickName(src: string | undefined, seed: string = ''): string {
    return src ? src : this.pick(nickNames, seed)
  }

  getRandom(value: number) {
    return Math.floor(Math.random() * value)
  }

  toStr(v: number) {
    return v.toString().padStart(2, '0')
  }
  /**
   * 获取随机地名*/
  getRandomCity() {
    const randomIndex = this.getRandom(cities.length)
    return cities[randomIndex]
  }

  /**
   * 随机点赞量*/
  getRandomLikes(): number {
    return this.getRandom(10000)
  }

  /**
   * 生成11位数的抖音号
   * @param n 最小值
   * @param m 最大值
   * */
  creteRandom(n: number = 9999999999, m: number = 10000000000): number {
    //区间应为[n, m] 原先误加m导致取值恒接近上限
    return Math.floor(Math.random() * (m - n + 1)) + n
  }

  /**
   * 生成固定范围类的随机数
   * @param n 最小值
   * @param m 最大值*/
  creteUserID(n: number, m: number): number {
    return Math.floor(Math.random() * (m - n + 1)) + n
  }
}

const common = new commonFn()

export { showToast as tipDialog, common }