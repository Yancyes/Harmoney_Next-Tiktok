import { router } from '@kit.ArkUI'
import { common, Constants } from '../../common'
import { ContactRow } from '../../components/ContactRow'
import { UserInfo } from '../../models/user'
import { tiktok } from '../../utils/setting'

interface routerParamsName {
  name: string
}

/**
 * 获取路由传的参数*/
const getParams = () => router.getParams() as routerParamsName

@Entry
@Component
struct SearchPage {
  @State
  userList: UserInfo[] = []
  @State
  @Watch('updateFilterList')
  searchName: string = ''
  @State
  filterList: UserInfo[] = []
  @State
  searchValue: string = getParams()?.name ?? '搜索'

  aboutToAppear(): void {
    this.getUserList()

  }

  /*
   * 获取用户列表*/
  getUserList() {
    this.userList = tiktok.getTikTokConnect()
    this.updateFilterList()
  }

  /*
   * 更新列表 有关键字就筛选 没关键字回到完整联系人列表
   * 原先靠入口传参('搜索')决定渲染与否 从顶栏进入时列表恒空*/
  updateFilterList() {
    this.filterList = this.searchName ? this.userList.filter(item => item.username.includes(this.searchName)) :
      this.userList
  }

  build() {
    Column() {
      //搜索框
      Row({ space: 10 }) {
        Search({ placeholder: this.searchValue, value: $$this.searchName })
          .caretStyle({ color: Color.Red })
          .border({
            radius: 8
          })
          .width('85%')
          .backgroundColor('#ffececec')
        Row() {
          Text('取消')
            .onClick(() => {
              router.back()
            })
            .fontColor(Color.Black)
            .fontSize(20)
            .textAlign(TextAlign.Start)
            .layoutWeight(1)
        }.padding({ left: 10 })

      }.margin({
        top: '15%'
      })
      .width('100%').height(50)

      //内容区域 联系人列表/筛选结果
      List({ space: 15 }) {
        ForEach(this.filterList, (item: UserInfo) => {
          ListItem() {
            ContactRow({ item: item })
          }
          .onClick(() => {
            common.nav(Constants.LOADING_ChatDetail, item)
          })
        }, (item: UserInfo) => `${item.user_id}`)
      }
      .scrollBar(BarState.Off)
      .margin({ top: 20, left: 10, right: 15 })

    }.padding({ left: 20, right: 20 }).width('100%').height('100%').backgroundColor(Color.White)
  }
}