import { BarClass, MyPageOwnInfo, UserInfoModel } from '../../models'
import { router } from '@kit.ArkUI'
import { tiktok } from '../../utils/setting'
import { tipDialog } from '../../common'
import { iconBtn, ImgComp, scrollbar, TitleTipBtn, VideoGrid } from '../../components'
import { Constants } from '../../common/Constants'

@Component
export default struct MyPage {
  @Consume
  info: UserInfoModel

  aboutToAppear(): void {
    //因为首选项仓库中进行了判断返回不同数据 这里需要重新获取用户信息数据
    this.info = tiktok.getCurrentUser()
    //重新赋值宽度
    AppStorage.set(Constants.BTN_TITLE_WIDTH, AppStorage.get(Constants.SCREEN_WIDTH) as number / this.personVd.length)
  }

  //背景视频地址
  @StorageProp(Constants.GET_VIDEO_IMG_URL)
  videoBgUrl: string = ''

  @Styles
  imgBg(){
    .width(16).height(16)
  }

  @StorageLink(Constants.SHOW_DIALOG) showDialog: boolean = false
  @Consume
  dialogBgColor: ResourceColor
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
      router.pushUrl({
        url: Constants.LOADING_SHOP
      })
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
      animateTo({ duration: 200 }, () => {
        this.openRightSideBar()
      })
    }
    }
  ]
  /**
   * 我的界面个人作品区*/
  private personVd: BarClass[] = MyPageOwnInfo
  @Consume
  IndexX: number | string
  @State
  private personInfo: ResourceStr | undefined = undefined
  @State
  currentIndex: number = 0
  /**
   * 按钮标签宽度*/
  @StorageProp(Constants.BTN_TITLE_WIDTH)
  btnTitleWidth: number = 0
  tabController: TabsController = new TabsController()

  /**
   * 打开右侧边栏*/
  openRightSideBar() {
    this.showDialog = true
    this.dialogBgColor = Constants.COLOR_OpacityBlack
    this.IndexX = '-65%'
  }

  /**
   * 滚动条控制器
   * */
  scroll: Scroller = new Scroller()

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
                  img: () => {
                    this.search()
                  }
                }).onClick(() => {
                  tipDialog()
                })
                TitleTipBtn({
                  img: () => {
                    this.iconTab()
                  }
                }).onClick(() => {
                  animateTo({ duration: 200 }, () => {
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
                    imgSrc: this.info.avatar,
                    bordWidth: 3,
                    bordColor: Color.White,
                    bordRadius: 50,
                    ImageFitType: ImageFit.Cover
                  })
                    .onClick(() => {
                      //打开自定义弹窗
                      this.showDialog = true
                      this.dialogBgColor = Color.Black
                    })
                }

                Column({ space: 5 }) {
                  Text(this.info.username).fontColor(Color.White)
                  Text(`抖音号:${this.info.tiktokNub}`)
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
            Text(this.personInfo === undefined ? 'I‘m form UK❥(^_-)' : this.personInfo).fontSize(14)
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
            Tabs({ barPosition: BarPosition.Start, index: $$this.currentIndex }) {
              ForEach(this.personVd, (item: BarClass, index: number) => {
                TabContent() {
                  if (index === 0) {
                    VideoGrid()
                  } else if (index === 1) {
                    VideoGrid()
                  } else if (index === 2) {
                    VideoGrid()
                  } else if (index === 3) {
                    VideoGrid()
                  } else {
                    VideoGrid()
                  }
                }
                .tabBar(SubTabBarStyle.of(item.title)
                  .indicator({
                    borderRadius: 10,
                    color: Color.Black,
                    width: this.btnTitleWidth,
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
    //修改整个页面的坐标
    .onClick(() => {
      animateTo({ duration: 200 }, () => {
        if (this.IndexX === '-65%') {
          this.IndexX = '0%'
        }
      })
    })
  }
}
