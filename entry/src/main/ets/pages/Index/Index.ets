import { BarClass } from '../../models'
import { bottomNav, Card, CardItem, iconContent, SideBarCom } from '../../components'
import { AppEnv, GlobalState, globalState, tipDialog } from '../../common'
import {
  commonFnItemData,
  commonlyUsedAppletsItemData,
  leftCardData,
  lifeDynamicsItemData,
  rightItemData
} from './indexMenuData'

@Entry
@ComponentV2
struct Index {
  /**
   * 记录返回时间*/
  backTime: number = 0
  @Local gs: GlobalState = globalState()
  /**
   * Navigation的路由栈 全应用唯一 与AppEnv是同一个实例
   * 页面内外都通过common.nav/back跳转*/
  pathStack: NavPathStack = AppEnv.pathStack

  onBackPress(): boolean | void {
    let now = Date.now() //获取时间戳
    //1秒内重复触发就退出程序
    if (now - this.backTime < 1000) {
      AppEnv.context?.terminateSelf() //终止程序
    } else {
      this.backTime = now
      tipDialog('再按一次退出', 2000, Alignment.Top)
    }
    return true //路由栈为空时用自定义功能而非Navigation
  }

  @Provider('IndexX')
  indexX: number | string = '' //整个index页面的x坐标
  /**
   * 评论弹层高度vp 由CommentDialog写入 视频页据此顶起画面、收起顶栏与侧栏*/
  @Provider('commentDialogHeight')
  commentDialogHeight: number = 0
  /**
   * 评论弹层是否正被拖动 拖动期间视频跟随手指即时变化 不做补间*/
  @Provider('commentDialogDragging')
  commentDialogDragging: boolean = false
  /**
   * 默认提示内容功能*/
  @BuilderParam
  FnTip: (TipContent: string) => void = this.FnTipContent

  /**
   * 提示内容功能*/
  @Builder
  FnTipContent(content: string) {
    Row() {
      Text(content)
        .width('100%')
        .fontColor(Color.Red)
        .maxLines(1)
        .fontSize(20)
        .textOverflow({ overflow: TextOverflow.MARQUEE }) //跑马灯效果
    }.padding({ left: 20, right: 20 })
    .justifyContent(FlexAlign.Center)
    .width('100%')
  }

  @Builder
  rightTipContent() {
    Text('>').fontColor(Color.Gray)
      .fontSize(20)
  }

  @Builder
  topContent() {
    Row() {
      Text('设置')
      Text('反馈')
    }
    .width('95%')
    .height(50)
    .justifyContent(FlexAlign.SpaceBetween)
    .margin({ left: 15, right: 15 })
  }

  /**
   * 卡片盒子*/
  @Builder
  CardBox(item: BarClass) {
    Card({
      leftTitle: item.title,
      rightTip: () => {
        if (item.id as number < leftCardData.length - 1) {
          this.rightTipContent()
        }
      },
      bgColor: Color.White,
      CardItem: () => {
        //通知消息
        if (item.id === 1) {
          if (this.FnTip) {
            this.FnTip('没有消息')
          }
        }
        //常用小程序
        if (item.id === 2) {
          //没有数据就渲染提示
          if (commonlyUsedAppletsItemData.length) {
            this.commonlyUsedApplets()
          } else {
            this.FnTip('啥也没有,快去尝鲜吧')
          }

        }
        //常用功能
        if (item.id === 3) {
          this.CommonFn()
        }
        //生活动态
        if (item.id === 4) {
          this.lifeDynamics()
        }
      }
    })
      .margin({ left: 15 })
  }

  /**
   * 常用小程序*/
  @Builder
  commonlyUsedApplets() {
    iconContent({
      itemData: commonlyUsedAppletsItemData
    })
  }

  /**
   * 常用功能*/
  @Builder
  CommonFn() {
    iconContent({
      itemData: commonFnItemData
    })
  }

  /**
   * 生活动态*/
  @Builder
  lifeDynamics() {
    iconContent({
      itemData: lifeDynamicsItemData
    })
  }

  //右侧边栏的结构
  @Builder
  rightSidebar(item: BarClass) {
    CardItem({
      icon: item.icon,
      leftTitle: item.title,
      rightContent: item.rightContent ?? ''
    })
      .onClick(() => {
        item.click && item.click()
      })
      .border({
        width: {
          bottom: item.bottomBorder === true ? 0 : 0.5
        }
      })
  }

  //右侧边栏的更多功能按钮结构
  @Builder
  moreFn() {
    Row() {
      Button() {
        Row({ space: 10 }) {
          Image($r("app.media.icon_moreFn")).width(24).height(24)
          Text('更多功能')
        }.width('100%').justifyContent(FlexAlign.Center)
      }
      .type(ButtonType.Normal)
      .backgroundColor(Color.White)
      .width('100%')
      .height(50)
      .border({
        radius: 4,
        width: .7,
        color: '#ff1d1d1d'
      })
      .margin({
        top: 5,
        left: 15,
        right: 20,
        bottom: 20
      })
      .onClick(() => {
        tipDialog()
      })
    }
  }

  aboutToAppear(): void {
    AppEnv.uiContext = this.getUIContext()
  }

  build() {
    Navigation(this.pathStack) {
      Column() {
        //底部导航栏
        bottomNav()
        //左侧边栏
        SideBarCom({
          sidePositionX: '-70%',
          topContentArea: () => {
            this.topContent()
          },
          itemData: leftCardData,
          contentItem: (item: object) => {
            this.Content(item as BarClass)
          },
          sideBgColor: '#ffefefef',
          sideBottom: 0,
          sideLeft: 0,
          sideRight: 0
        })
        //右侧边栏
        SideBarCom({
          sidePositionX: "100%",
          itemData: rightItemData,
          contentItem: (item: object) => {
            this.rightSidebar(item as BarClass)
          },
          contentMore: () => {
            this.moreFn()
          }
        })
      }
      //整个页面的坐标
      .translate({ x: this.indexX })
    }
    .mode(NavigationMode.Stack)
    .hideTitleBar(true)
    .hideNavBar(false)
  }

  @Builder
  Content(item: BarClass) {
    this.CardBox(item)
  }
}
