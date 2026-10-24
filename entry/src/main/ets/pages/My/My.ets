import { BarClass, mediaType, MyPageOwnInfo } from '../../models'
import { common, Constants, globalState, GlobalState, tipDialog } from '../../common'
import { iconBtn, ImgComp, scrollbar, TitleTipBtn, VideoGrid } from '../../components'
import { TiktokCollection, TiktokLike } from '../../utils'

/**
 * 我的页 只作为底部导航的一个子页使用 不是路由入口*/
@ComponentV2
export struct MyPage {
  /**
   * 我的界面顶部信息title*/
  private infoTitle: BarClass[] = [
    { title: '1504', rightContent: '获赞' },
    { title: '46', rightContent: '朋友' },
    { title: '125', rightContent: '关注' },
    { title: '564', rightContent: '粉丝' }
  ]
  /**
   * 我的界面功能区*/
  private MyOwnInfo: BarClass[] = [
    {
      icon: $r('app.media.icon_shopCar'), title: '抖音商城', click: () => {
      common.nav(Constants.ROUTE_SHOP)
    }
    },
    {
      icon: $r('app.media.icon_time'), title: '观看历史', click: () => {
      tipDialog()
    }
    },
    {
      icon: $r('app.media.icon_wallet'), title: '我的钱包', click: () => {
      tipDialog()
    }
    },
    {
      icon: $r('app.media.icon_my_user'), title: '常访问的人', click: () => {
      tipDialog()
    }
    },
    {
      icon: $r('app.media.icon_music'), title: '我的音乐', click: () => {
      tipDialog()
    }
    },
    {
      icon: $r('app.media.icon_applet'), title: '我的小程序', click: () => {
      tipDialog()
    }
    },
    {
      icon: $r('app.media.icon_moreFn'), title: '查看更多', click: () => {
      this.getUIContext().animateTo({ duration: 200 }, () => {
        this.openRightSideBar()
      })
    }
    }
  ]
  /**
   * 我的界面个人作品区*/
  private personVd: BarClass[] = MyPageOwnInfo
  /**
   * 滚动条控制器*/
  scroll: Scroller = new Scroller()
  @Local gs: GlobalState = globalState()
  @Consumer('dialogBgColor')
  dialogBgColor: ResourceColor = ''
  @Consumer('IndexX')
  indexX: number | string = ''
  /**
   * 背景视频地址*/
  @Local
  videoBgUrl: string = ''
  @Local
  video_collection: mediaType[] = []
  @Local
  video_like: mediaType[] = []
  @Local
  currentIndex: number = 0

  aboutToAppear(): void {
    //作品标签等分屏宽 宽度由屏宽均分得出
    this.gs.btnTitleWidth = this.gs.screenWidth / this.personVd.length
  }

  /**
   * 打开右侧边栏*/
  openRightSideBar() {
    this.gs.showDialog = true
    this.dialogBgColor = Constants.COLOR_OpacityBlack
    this.indexX = '-65%'
  }

  @Builder
  newPerson() {
    ImgComp({
      imgWidth: 16,
      imgSrc: $r("app.media.icon_connect")
    })
  }

  @Builder
  search() {
    ImgComp({
      imgWidth: 28,
      imgSrc: $r("app.media.icon_search")
    })
  }

  @Builder
  iconTab() {
    ImgComp({
      imgWidth: 16,
      imgSrc: $r("app.media.icon_Tab")
    })
  }

  @Builder
  tab(index: number) {
    if (index === 3) {
      VideoGrid({ data: this.video_collection })
    } else if (index === 4) {
      VideoGrid({ data: this.video_like })
    } else {
      VideoGrid()
    }
  }

  build() {
    Scroll() {
      //把上下两个模块包在一起
      Column() {
        //顶部背景区
        Stack() {
          //右侧按钮
          Stack() {
            Row({ space: 20 }) {
              TitleTipBtn({
                w: 90,
                op: 1,
                img: () => {
                  this.newPerson()
                },
                title: '新访客1'
              }).onClick(() => {
                tipDialog()
              })
              //搜索和功能按钮区
              Row({ space: 10 }) {
                TitleTipBtn({
                  op: 1,
                  img: () => {
                    this.search()
                  }
                }).onClick(() => {
                  tipDialog()
                })
                TitleTipBtn({
                  op: 1,
                  img: () => {
                    this.iconTab()
                  }
                }).onClick(() => {
                  this.getUIContext().animateTo({ duration: 200 }, () => {
                    this.openRightSideBar()
                  })
                })
              }
            }
            .width('100%').height(50).justifyContent(FlexAlign.End).margin({ top: 10, right: 15 })
          }.width('100%').height('50%').zIndex(3).position({ y: 0 })

          Stack({ alignContent: Alignment.BottomStart }) {
            Row() {
              //背景视频
              Video({
                src: this.videoBgUrl
              })
                .layoutWeight(1)
                .height('150%')
                .muted(true)
                .loop(true)
                .autoPlay(true)
                .controls(false)
            }

            Row() {
              Row({ space: 20 }) {
                Row() {
                  //头像
                  ImgComp({
                    imgWidth: 100,
                    imgHeight: 100,
                    imgSrc: this.gs.currentUser.avatar,
                    bordWidth: 3,
                    bordColor: Color.White,
                    bordRadius: 50,
                    ImageFitType: ImageFit.Cover
                  })
                    .onClick(() => {
                      //打开自定义弹窗
                      this.gs.showDialog = true
                      this.dialogBgColor = Color.Black
                    })
                }

                Column({ space: 5 }) {
                  Text(this.gs.currentUser.username).fontColor(Color.White)
                  Text(`抖音号:${this.gs.currentUser.tiktokNub}`)
                    .fontColor(Color.Gray)
                    .fontSize(16)
                }.width('100%').alignItems(HorizontalAlign.Start)

              }.margin({ left: 20 })
            }
            .width('100%').height('50%').linearGradient({
              direction: GradientDirection.Top, //渐变方向
              colors: [['rgba(7, 7, 7, 0.7)', 0.4], ['rgba(78, 77, 77, 0)', 1]]
            })
          }
        }.layoutWeight(3.5).width('100%').margin({ bottom: -10 })

        //白色个人内容区
        Column() {
          //顶部个人信息
          Row({ space: 20 }) {
            ForEach(this.infoTitle, (item: BarClass) => {
              Row({ space: 5 }) {
                Text(item.title).fontWeight(600).fontSize(20)
                Text(`${item.rightContent}`).fontSize(16).fontColor(Color.Gray)
              }.onClick(() => {
                tipDialog()
              })
            })
          }.width('100%')
          .padding(15)

          //个人介绍
          Row() {
            Text('university of CFEC').fontSize(14)
              .fontColor(Color.Black).textAlign(TextAlign.Start)
          }.width('100%').padding(10)

          //功能区
          List({ space: 30, scroller: this.scroll }) {
            ForEach(this.MyOwnInfo, (item: BarClass) => {
              ListItem() {
                iconBtn({ icon: item.icon, title: item.title })
                  .onClick(() => {
                    item.click && item.click()
                  })
              }
            })
          }
          .edgeEffect(EdgeEffect.None)
          .listDirection(Axis.Horizontal)
          .padding(20)
          .scrollBar(BarState.Off)
          .height(100)

          //滑动条
          scrollbar({ scroller: this.scroll })

          Stack() {
            Tabs({ barPosition: BarPosition.Start, index: this.currentIndex!! }) {
              ForEach(this.personVd, (item: BarClass, index: number) => {
                TabContent() {
                  this.tab(index)
                }
                .tabBar(SubTabBarStyle.of(item.title)
                  .indicator({
                    borderRadius: 10,
                    color: Color.Black,
                    width: this.gs.btnTitleWidth,
                    height: 4,
                    marginTop: 13
                  })
                  .labelStyle({
                    unselectedColor: Color.Grey,
                    selectedColor: Color.Black
                  })
                )
              })
            }
            .edgeEffect(EdgeEffect.None)
          }
        }
        .layoutWeight(6.5)
        .width('100%')
        .border({
          color: Color.White
        })
        .borderRadius({
          topLeft: 15, topRight: 15
        })
        .backgroundColor(Color.White)
      }
    }
    .scrollBar(BarState.Off)
    .height('120%')
    .onVisibleAreaChange([0, 1], (isVisible: boolean, currentRatio: number) => {
      //完全离开页面时不需要重新解析收藏/喜欢数据
      if (isVisible && currentRatio > 0) {
        this.videoBgUrl = this.gs.videoBgUrl
        //添加收藏数据
        this.video_collection = TiktokCollection.getCollectionData()
        //添加喜欢数据
        this.video_like = TiktokLike.getLikeData()
      }
    })
    //修改整个页面的坐标
    .onClick(() => {
      this.getUIContext().animateTo({ duration: 200 }, () => {
        if (this.indexX === '-65%') {
          this.indexX = '0%'
        }
      })
    })
  }
}
