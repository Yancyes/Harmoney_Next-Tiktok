import { CURRENT_USER } from '../../constants'
import { router } from '@kit.ArkUI'
import { Tiktok } from '../../utils/setting'
import { Constants } from '../../common/Constants'

/**
 * 设置页*/
@Entry
@Component
struct SettingPage {
  @BuilderParam
  CardItem: () => void

  /** 退出登录 */
  async logout(): Promise<void> {
    AppStorage.set(CURRENT_USER, "") //清空全局状态
    await new Tiktok().setCurrentUser("") //清空首选项 context由仓库内部惰性获取
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

      if (this.CardItem) {
        this.CardItem
      }
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