import { AppStorageV2 } from '@kit.ArkUI'
import { UserInfo, UserInfoModel } from '../models/user'

/**
 * 全局响应式状态 替代AppStorage与@StorageProp/@StorageLink
 * 字段由@Trace驱动 组件里直接读globalState().xxx即可精确刷新*/
@ObservedV2
export class GlobalState {
  /**
   * 当前登录用户 空模型表示未登录*/
  @Trace currentUser: UserInfoModel = new UserInfoModel({} as UserInfo)
  /**
   * 屏幕宽度vp*/
  @Trace screenWidth: number = 0
  /**
   * 我的页作品标签宽度vp 由屏宽均分得出*/
  @Trace btnTitleWidth: number = 0
  /**
   * 顶部安全区高度vp*/
  @Trace areaHeight: number = 0
  /**
   * 底部导航条安全区高度vp*/
  @Trace bottomHeight: number = 0
  /**
   * 遮罩弹窗开关*/
  @Trace showDialog: boolean = false
  /**
   * 我的页背景视频地址 由当前播放的视频写入*/
  @Trace videoBgUrl: string = ''
}

let storage: GlobalState | undefined

/**
 * AppStorageV2在UI实例就绪前(onWindowStageCreate)也会被读写
 * 连接失败时退化为同构实例 模块级单例保证全局仍是同一份引用*/
export function globalState(): GlobalState {
  if (storage) {
    return storage
  }
  const connected = AppStorageV2.connect(GlobalState, () => new GlobalState())
  storage = connected ?? new GlobalState()
  return storage
}

/**
 * 同步当前用户到全局状态 首选项仍是持久来源*/
export function syncCurrentUser(user: UserInfoModel): void {
  globalState().currentUser = user
}
