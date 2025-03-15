import { BarClass } from '../../models'
import { bottomNav, Card, CardItem, iconContent, SideBarCom } from '../../components'
import { router } from '@kit.ArkUI'
import { tipDialog } from '../../common/Function/commonFn'
import { common } from '@kit.AbilityKit'
import { Constants } from '../../common/Constants'

@Entry
@Component
struct Index {
  /**
   * 记录返回时间*/
  backTime: number = 0

  onBackPress(): boolean | void {
    let now = Date.now() //获取时间戳
    //1秒内重复触发就退出程序
    if (now - this.backTime < 1000) {
      //获取声明公共UI能力上下文方法
      const ctx = getContext(this) as common.UIAbilityContext
      ctx.terminateSelf() //终止程序
    } else {
      this.backTime = now
      tipDialog('再按一次退出', 2000, Alignment.Top)
    }
    return true //使用自定义功能而非router
  }

  @Provide
  IndexX: number | string = '' //整个index页面的x坐标
  //右侧边栏的数据
  @State
  rightItemData: BarClass[] = [
    {
      icon: $r('app.media.icon_shopCar'),
      title: "我的订单",
      click: () => {
        tipDialog()
      },
      bottomBorder: true
    },
    {
      icon: $r('app.media.icon_wallet'),
      title: "我的钱包",
      rightContent: '8.88',
      click: () => {
        tipDialog()
      }

    },
    {
      icon: $r('app.media.icon_QRcode'),
      title: "我的二维码",
      click: () => {
        tipDialog()
      },
      bottomBorder: true

    },
    {
      icon: $r('app.media.icon_time'),
      title: "观看历史",
      click: () => {
        tipDialog()
      },
      bottomBorder: true

    },
    {
      icon: $r('app.media.icon_waitplay'),
      title: "稍后再看",
      click: () => {
        tipDialog()
      },
      bottomBorder: true

    },
    {
      icon: $r('app.media.icon_clouddownload'),
      title: "离线模式",
      click: () => {
        tipDialog()
      },
      bottomBorder: true
    },
    {
      icon: $r('app.media.icon_idea'),
      title: "抖音创作着中心",
      click: () => {
        tipDialog()
      }
    },
    {
      icon: $r('app.media.icon_applet'),
      title: "小程序",
      click: () => {
        tipDialog()
      },
      bottomBorder: true
    },
    {
      icon: $r('app.media.icon_love'),
      title: "抖音公益",
      click: () => {
        tipDialog()
      },
      bottomBorder: true
    },
    {
      icon: $r('app.media.icon_sapling'),
      title: "青少年模式",
      click: () => {
        tipDialog()
      },
      bottomBorder: true
    },
    {
      icon: $r('app.media.icon_service'),
      title: "我的客服",
      click: () => {
        tipDialog()
      },
      bottomBorder: true
    },
    {
      icon: $r('app.media.icon_setting'),
      title: "设置",
      click: () => {
        router.pushUrl({
          url: Constants.LOADING_SETTING
        })
      }
    },
    {
      icon: $r('app.media.icon_personedetail'),
      title: "个人信息收集清单",
      click: () => {
        tipDialog()
      },
      bottomBorder: true
    },
    {
      icon: $r('app.media.icon_share'),
      title: "第三方信息共享清单",
      click: () => {
        tipDialog()
      },
      bottomBorder: true
    }
  ]
  @State
  leftCardData: BarClass[] = [
    {
      title: '通知消息',
      id: 1,
    },
    {
      title: '常用小程序',
      id: 2
    },
    {
      title: '常用功能',
      id: 3
    },
    {
      title: '生活动态',
      id: 4
    }
  ]
  /**
   * 常用小程序数据源*/
  @State
  commonlyUsedAppletsItemData: BarClass[] = []
  /**
   * 常用功能数据源*/
  @State
  commonFnItemData: BarClass[] = [
    {
      icon: $r('app.media.icon_wallet'),
      title: '我的钱包',
      click: () => {
        tipDialog()
      }
    }, {
    icon: $r('app.media.icon_leftsider_coupons'),
    title: '优惠卷',
    click: () => {
      tipDialog()
    }
  }, {
    icon: $r('app.media.icon_applet'),
    title: '小程序',
    click: () => {
      tipDialog()
    }
  }, {
    icon: $r('app.media.icon_time'),
    title: '观看历史',
    click: () => {
      tipDialog()
    }
  }, {
    icon: $r('app.media.icon_leftSider_contentLove'),
    title: '内容偏好',
    click: () => {
      tipDialog()
    }
  }, {
    icon: $r('app.media.icon_clouddownload'),
    title: '离线模式',
    click: () => {
      tipDialog()
    }
  }, {
    icon: $r('app.media.icon_waitplay'),
    title: '稍后再看',
    click: () => {
      tipDialog()
    }
  },
  ]
  /**
   * 生活动态数据源*/
  @State
  lifeDynamicsItemData: BarClass[] = [
    {
      icon: $r('app.media.icon_siderLeft_live'),
      title: '直播广场',
      click: () => {
        tipDialog()
      }
    }, {
    icon: $r('app.media.icon_siderLeft_shopCarperson'),
    title: '附近团购',
    click: () => {
      tipDialog()
    }
  }, {
    icon: $r('app.media.icon_siderLeft_activityCenter'),
    title: '活动中心',
    click: () => {
      tipDialog()
    }
  }, {
    icon: $r('app.media.icon_siderLeft_playGame'),
    title: '玩游戏',
    click: () => {
      tipDialog()
    }
  }, {
    icon: $r('app.media.icon_siderLeft_music'),
    title: '听抖音',
    click: () => {
      tipDialog()
    }
  }, {
    icon: $r('app.media.icon_siderLeft_screeningRoom'),
    title: '放映厅',
    click: () => {
      tipDialog()
    }
  }, {
    icon: $r('app.media.icon_siderLeft_singing'),
    title: 'K歌',
    click: () => {
      tipDialog()
    }
  },
  ]
  /**
   * 默认提示内容功能*/
  @BuilderParam
  FnTip: (TipContent: string) => void = this.FnTipContent
  /**
   * 提示内容*/
  @State
  TipContent: string = ''

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
        if (item.id as number < this.leftCardData.length - 1) {
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
          if (!this.commonlyUsedAppletsItemData) {
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
      itemData: this.commonlyUsedAppletsItemData
    })
  }

  /**
   * 常用功能*/
  @Builder
  CommonFn() {
    iconContent({
      itemData: this.commonFnItemData
    })
  }

  /**
   * 生活动态*/
  @Builder
  lifeDynamics() {
    iconContent({
      itemData: this.lifeDynamicsItemData
    })
  }

  //右侧边栏的结构
  @Builder
  rightSidebar(item: BarClass) {
    CardItem({
      icon: item.icon,
      leftTitle: item.title,
      rightContent: item.rightContent
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

  build() {
    Column() {
      //底部导航栏
      bottomNav()
      //左侧边栏
      SideBarCom({
        sidePositionX: '-70%',
        topContentArea: () => {
          this.topContent()
        },
        itemData: this.leftCardData,
        contentItem: (item: object) => {
          this.CardBox(item as BarClass)
        },
        sideBgColor: '#ffefefef',
        sideBottom: 0,
        sideLeft: 0,
        sideRight: 0
      })
      //右侧边栏
      SideBarCom({
        sidePositionX: "100%",
        itemData: this.rightItemData,
        contentItem: (item: object) => {
          this.rightSidebar(item as BarClass)
        },
        contentMore: () => {
          this.moreFn()
        }
      })
    }
    //整个页面的坐标
    .translate({ x: this.IndexX })
  }
}


