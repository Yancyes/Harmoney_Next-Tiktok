import { common, Constants, globalState, GlobalState } from '../../common'
import { ContactRow } from '../../components/ContactRow'
import { UserInfo } from '../../models/user'
import { tiktok } from '../../utils/setting'

/**
 * 搜索页路由参数*/
export interface SearchParams {
  name: string
}

/**
 * 搜索页 动态路由表入口 见resources/base/profile/router_map.json*/
@Builder
export function SearchPageBuilder() {
  SearchPage()
}

@ComponentV2
export struct SearchPage {
  @Local gs: GlobalState = globalState()
  @Local
  userList: UserInfo[] = []
  @Local
  filterList: UserInfo[] = []
  @Local
  searchName: string = ''
  @Local
  searchValue: string = '搜索'

  aboutToAppear(): void {
    this.userList = tiktok.getTikTokConnect()
    this.updateFilterList()
  }

  /**
   * 更新列表 有关键字就筛选 没关键字回到完整联系人列表
   * 原先靠入口传参('搜索')决定渲染与否 从顶栏进入时列表恒空*/
  @Monitor('searchName')
  updateFilterList(): void {
    this.filterList = this.searchName ? this.userList.filter((item: UserInfo) => item.username.includes(this.searchName)) :
      this.userList
  }

  build() {
    NavDestination() {
      Column() {
        //搜索框
        Row({ space: 10 }) {
          Search({ placeholder: this.searchValue, value: this.searchName!! })
            .caretStyle({ color: Color.Red })
            .border({
              radius: 8
            })
            .width('85%')
            .backgroundColor('#ffececec')
          Row() {
            Text('取消')
              .onClick(() => {
                common.back()
              })
              .fontColor(Color.Black)
              .fontSize(20)
              .textAlign(TextAlign.Start)
              .layoutWeight(1)
          }.padding({ left: 10 })

        }.margin({
          top: this.gs.areaHeight + 10
        })
        .width('100%').height(50)

        //内容区域 联系人列表/筛选结果
        List({ space: 15 }) {
          ForEach(this.filterList, (item: UserInfo) => {
            ListItem() {
              ContactRow({ item: item })
            }
            .onClick(() => {
              common.nav(Constants.ROUTE_CHAT_DETAIL, item)
            })
          }, (item: UserInfo) => `${item.user_id}`)
        }
        .scrollBar(BarState.Off)
        .margin({ top: 20, left: 10, right: 15 })

      }.padding({ left: 20, right: 20 }).width('100%').height('100%').backgroundColor(Color.White)
    }
    .hideTitleBar(true)
    //动态路由的参数只能在NavDestination挂载后从pathInfo里取
    .onReady((context: NavDestinationContext) => {
      this.searchValue = (context.pathInfo.param as SearchParams | undefined)?.name ?? '搜索'
    })
  }
}
