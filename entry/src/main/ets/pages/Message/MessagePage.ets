import { UserInfo } from '../../models/user'
import { tiktok } from '../../utils/setting'
import { common, Constants, globalState, GlobalState } from '../../common'
import { ContactRow } from '../../components/ContactRow'
import { HeadBar } from '../../components'
import { SearchParams } from '../Search/SearchPage'

/**
 * 消息页面 只作为底部导航的一个子页使用 不是路由入口*/
@ComponentV2
export struct MessagePage {
  @Local
  userList: UserInfo[] = [] //渲染默认用户列表
  @Consumer('dialogBgColor')
  dialogBgColor: ResourceColor = ''
  @Consumer('IndexX')
  indexX: number | string = ''
  @Local gs: GlobalState = globalState()

  aboutToAppear(): void {
    this.getUserList()
  }

  getUserList() {
    this.userList = tiktok.getTikTokConnect()
  }

  searchConcat() {
    common.nav(Constants.ROUTE_SEARCH, {
      name: '搜索'
    } as SearchParams)
  }

  openLeftSideBar() {
    this.getUIContext().animateTo({ duration: 200 }, () => {
      this.gs.showDialog = !this.gs.showDialog
      this.dialogBgColor = Constants.COLOR_OpacityBlack
      this.indexX = '70%'
    })
  }

  build() {
    Column() {
      HeadBar({
        LeftIcon: $r('app.media.icon_Leftbar_black'),
        RightIcon: $r("app.media.icon_search_black"),
        LeftIconClick: () => {
          this.openLeftSideBar()
        },
        RightIconClick: () => {
          this.searchConcat()
        }
      })

      List({ space: 15 }) {
        ForEach(this.userList, (item: UserInfo) => {
          ListItem() {
            ContactRow({ item: item })
          }
          .onClick(() => {
            common.nav(Constants.ROUTE_CHAT_DETAIL, item)
          })
        }, (item: UserInfo) => `${item.user_id}`)
      }.layoutWeight(1)
      .scrollBar(BarState.Off)
      .margin({
        top: 10,
        left: 15,
        right: 15,
        bottom: 59
      })

    }.width('100%').height('100%')
    .margin({ top: this.gs.areaHeight })
  }
}
