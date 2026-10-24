import { UIContext } from '@kit.ArkUI'
import { common } from '@kit.AbilityKit'

/**
 * 非响应式的基础设施持有者
 * context供首选项仓库与rawfile读取使用 pathStack是路由跳转的唯一入口
 * 取代之前的AppStorage GET_CONTEXT/GET_UI_CONTEXT键*/
export class AppEnv {
  static context?: common.UIAbilityContext
  static uiContext?: UIContext
  static pathStack: NavPathStack = new NavPathStack()
}
