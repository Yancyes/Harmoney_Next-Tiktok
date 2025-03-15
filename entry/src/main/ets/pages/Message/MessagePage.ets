import { UserInfo } from '../../models/user'
import { Tiktok } from '../../utils/setting'
import { router } from '@kit.ArkUI'
import { HeadBar } from '../../components'
import { Constants } from '../../common/Constants'

/**
 * 消息页面*/
@Entry
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
    this.userList = new Tiktok(getContext()).getTikTokConnect()
  }

  @Styles
  img(){
    .width(28).height(28)
  }

  /**
   * 搜索联系人*/
  searchConcat() {
    router.pushUrl({
      url: Constants.LOADING_SEARCH,
      params: {
        name: '搜索'
      }
    })
  }

  /**
   * 打开左侧边栏*/
  openLeftSideBar() {
    animateTo({ duration: 200 }, () => {
      this.showDialog = !this.showDialog
      this.dialogBgColor = '#80000000'
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
            Row({ space: 10 }) {
              Image(item.avatar).width(70).height(70).border({ radius: 35 })
              Row() {
                Column() {
                  Text(item.username).fontWeight(600).fontSize(24)
                  Text(item.content)
                    .fontColor('#ff646464')
                    .fontSize(14)
                    .maxLines(1)
                    .textOverflow({
                      overflow: TextOverflow.Ellipsis
                    })
                }.width('100%').alignItems(HorizontalAlign.Start)
              }
            }.width('100%')
          }
          .onClick(() => {
            router.pushUrl({
              url: Constants.LOADING_ChatDetail,
              params: item
            })
          })
        })
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