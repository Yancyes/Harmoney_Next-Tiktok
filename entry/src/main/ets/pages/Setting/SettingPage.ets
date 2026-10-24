import { UserInfo, UserInfoModel } from '../../models'
import { tiktok } from '../../utils/setting'
import { common, GlobalState, globalState, syncCurrentUser } from '../../common'
import { Constants } from '../../common/Constants'

/**
 * 设置页 动态路由表入口 见resources/base/profile/router_map.json*/
@Builder
export function SettingPageBuilder() {
  SettingPage()
}

@ComponentV2
export struct SettingPage {
  @Local gs: GlobalState = globalState()

  /** 退出登录 */
  async logout(): Promise<void> {
    //全局状态清成空模型 读取方都是 UserInfoModel 不能塞字符串
    syncCurrentUser(new UserInfoModel({} as UserInfo))
    await tiktok.setCurrentUser("") //清空首选项 登录门禁按空串判断
    //清空页面栈 否则触发返回事件会回到上个页面 此时再返回就直接到桌面
    common.navWithClear(Constants.ROUTE_LOGIN)
  }

  build() {
    NavDestination() {
      Column() {
        Row() {
          SymbolGlyph($r('sys.symbol.chevron_left'))
            .fontSize(28)
            .fontColor(['#ff2f2e2e'])
            .onClick(() => {
              common.back()
            })
        }
        .width('100%')
        .height(50)
        .padding({ left: 20 })
        .margin({ top: this.gs.areaHeight })
        .alignItems(VerticalAlign.Center)

        Button('退出登录')
          .onClick(() => {
            this.logout()
          })
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .backgroundColor(Color.White)
    }
    .hideTitleBar(true)
  }
}
