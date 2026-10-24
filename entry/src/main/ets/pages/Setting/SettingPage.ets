import { router } from '@kit.ArkUI'
import { UserInfo, UserInfoModel } from '../../models'
import { tiktok } from '../../utils/setting'
import { Constants } from '../../common/Constants'

/**
 * 设置页*/
@Entry
@Component
struct SettingPage {
  /** 退出登录 */
  async logout(): Promise<void> {
    //全局状态清成空模型 读取方都是 UserInfoModel 不能塞字符串
    tiktok.syncCurrentUser(new UserInfoModel({} as UserInfo))
    await tiktok.setCurrentUser("") //清空首选项 登录门禁按空串判断
    //清空页面栈 否则触发返回事件会回到上个页面
    router.clear()
    //此时跳转登录再返回就直接到桌面
    router.replaceUrl({
      url: Constants.LOADING_LOGIN
    })
  }

  build() {
    Column() {
      Row() {
        Row() {
          Text('<')
            .width(50)
            .height(50)
            .fontColor('#ff2f2e2e')
            .fontSize(50)
            .onClick(() => {
              router.back()
            })
        }.margin({ left: 20 })

      }.width('100%').height(50).position({
        y: '5%'
      })

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
}