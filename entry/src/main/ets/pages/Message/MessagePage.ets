import { UserInfo } from '../../models/user'
import { tiktok } from '../../utils/setting'
import { common } from '../../common'
import { ContactRow } from '../../components/ContactRow'
import { HeadBar } from '../../components'
import { Constants } from '../../common/Constants'

/**
 * 消息页面 只作为底部导航的一个子页使用 不是路由入口*/
@Component
export struct MessagePage {
  @State
  userList: UserInfo[] = [] //渲染默认用户列表
  @Consume
  dialogBgColor: string
  @StorageLink(Constants.SHOW_DIALOG) showDialog: boolean = false
  @Consume
  IndexX: number | string
  @StorageProp(Constants.AREA_HEIGHT)
  topArea: number = 0

  aboutToAppear(): void {
    this.getUserList()
  }

  getUserList() {
    this.userList = tiktok.getTikTokConnect()
  }

  /**
   * 搜索联系人*/
  searchConcat() {
    common.nav(Constants.LOADING_SEARCH, {
      name: '搜索'
    } as Record<string, string>)
  }

  /**
   * 打开左侧边栏*/
  openLeftSideBar() {
    animateTo({ duration: 200 }, () => {
      this.showDialog = !this.showDialog
      this.dialogBgColor = Constants.COLOR_OpacityBlack
      //更改坐标轴
      this.IndexX = '70%'
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
            common.nav(Constants.LOADING_ChatDetail, item)
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
    .margin({ top: this.topArea })
  }
}