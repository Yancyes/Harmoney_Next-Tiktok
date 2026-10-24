import { Colm, customDialog, ImgComp, TitleBtn, TopBar } from '.'
import { common, Constants, GlobalState, globalState, tipDialog } from '../common'
import { BarClass, TabList, userToPlain } from '../models'
import { MessagePage } from '../pages/Message/MessagePage'
import { tiktok } from '../utils/setting'
import { MyPage } from '../pages/My/My'
import { photoAccessHelper } from '@kit.MediaLibraryKit'
import { TikTokEmitter } from '../utils/TIkTokEmitter'
import { BtnType } from '../GlobalEnum'

@ComponentV2
export struct bottomNav {
  @Local gs: GlobalState = globalState()
  /**
   * 顶部栏信息*/
  topTabList: BarClass[] = TabList
  /**
   * 顶部栏索引*/
  @Local
  topNavCurrentIndex: number = this.topTabList.length - 1
  /**
   * 是否显示上传弹窗*/
  @Local
  showUploadDialog: boolean = false
  btmTabList: BarClass[] = [
    {
      title: '首页',
      name: BtnType.Home,
    },
    {
      title: '朋友',
      name: BtnType.Friend,
    },
    {
      icon: $r('app.media.ic_uploading'),
      name: BtnType.Upload,
      click: () => {
        this.showUploadDialog = true
      }
    },
    {
      title: '信息',
      name: BtnType.Message,
    },
    {
      title: '我',
      name: BtnType.My,
    }
  ]
  tabController: TabsController = new TabsController()
  @Local
  currentIndex: number = 0
  @Local
  titleColor: ResourceColor[] = [Color.White, Color.Gray]
  @Provider('dialogBgColor')
  dialogBgColor: ResourceColor = '' //修改渐变背景色只能通过#00000000的方式
  @Consumer('IndexX')
  indexX: number | string = '' //整个index页面的x坐标
  @Provider('isShowSpeed')
  isShowSpeed: boolean = false //是否显示倍速提示
  maxImgNumber: number = 1 //最多可选1张图片

  async selectPhoto() {
    const photo = new photoAccessHelper.PhotoViewPicker()
    const result = await photo.select({
      MIMEType: photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE,
      maxSelectNumber: this.maxImgNumber
    })
    if (result.photoUris.length) {
      const user = this.gs.currentUser
      user.avatar = result.photoUris.toString()
      await tiktok.setCurrentUser(JSON.stringify(userToPlain(user))) //写入首选项 全局状态是同一份引用 无需再同步
    }
  }

  // 上传视频等用的弹窗
  @Builder
  contentDialog() {
    Column() {
      Row() {
        Text('x')
          .fontSize(44)
          .fontColor(Color.White)
          .onClick(() => {
            this.showUploadDialog = false
          })
      }.width('100%')
      .margin({
        top: 30,
        left: 20
      })
      .justifyContent(FlexAlign.Start)
    }.width('100%')
    .height('100%')
    .backgroundColor(Color.Black)
    .zIndex(99999)
  }

  /**
   * 头像详情界面*/
  @Builder
  imgAvatar() {
    Column({ space: 40 }) {
      Text('x')
        .fontSize(54)
        .fontColor(Color.White)
        .fontWeight(100)
        .onClick(() => {
          this.gs.showDialog = false
        })
        .margin({ top: "5%", left: '-85%' })
      Image(this.gs.currentUser.avatar)
        .draggable(true)
        .height('50%')
        .width('100%')
      Column() {
        TitleBtn({
          title: "创建抖音仔仔", borBom: true, click: () => {
            tipDialog()
          }
        })
        TitleBtn({
          title: "更换头像", borBom: true, click: () => {
            this.selectPhoto()
          }
        })
        TitleBtn({
          title: "保存头像", borBom: true, click: () => {
            tipDialog()
          }
        })
        TitleBtn({
          title: "查看抖音码", borBom: false, click: () => {
            tipDialog()
          }
        })
      }.width('90%')
      .borderRadius(10)
      .margin({ top: -20 })
    }
  }

  @Builder
  bottomBar(item: BarClass, index: number) {
    Column() {
      if (item.name === BtnType.Upload) {
        ImgComp({
          imgWidth: 50,
          imgSrc: item.icon
        })
      } else {
        Text(item.title)
          .fontSize(24)
          .fontColor(this.currentIndex === index ? this.titleColor[0] : this.titleColor[1])
      }
    }
    .onClick(() => {
      //未登录只弹登录提示 登录后才执行切换
      common.withLogin(() => {
        item.click && item.click()
        //功能按钮只负责暂停播放
        if (item.name === BtnType.Upload) {
          TikTokEmitter.Emitter_VideoCrl(false)
          return
        }
        this.tabController.changeIndex(index)
        //不是主页 禁止播放
        if (item.name !== BtnType.Home) {
          TikTokEmitter.Emitter_VideoCrl(false)
        }
        //如果底部栏索引是首页且顶部栏索引是推荐页开启播放器
        if (item.name === BtnType.Home && this.topNavCurrentIndex === this.topTabList.length - 1) {
          TikTokEmitter.Emitter_VideoCrl(true)
        }
      })
    })
  }

  @Provider('speedColor')
  speedColor: string = '#ff4e4e4e'
  @Provider('speedSize')
  speedSize: number = 16

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Tabs({ index: this.currentIndex!!, controller: this.tabController, barPosition: BarPosition.End }) {
        ForEach(this.btmTabList, (item: BarClass) => {
          TabContent() {
            if (item.name === BtnType.Home) {
              TopBar({
                topNavCurrentIndex: this.topNavCurrentIndex!!
              })
            } else if (item.name === BtnType.Friend) {
              Colm()
            } else if (item.name === BtnType.Message) {
              MessagePage()
            } else if (item.name === BtnType.My) {
              MyPage()
            }
          }
        })
      }
      .animationDuration(0)
      .scrollable(false)


      Row({ space: 20 }) {
        if (!this.isShowSpeed) {
          ForEach(this.btmTabList, (item: BarClass, index: number) => {
            this.bottomBar(item, index)
          })
        } else {
          Row({ space: 5 }) {
            Text('2x 快进中')
              .fontColor(Color.White)
              .fontSize(24)
            Text('>')
              .fontColor(this.speedColor)
              .fontSize(this.speedSize)
          }
          .width('100%')
          .height(75)
          .justifyContent(FlexAlign.Center)
          .linearGradient({
            direction: GradientDirection.Top, //渐变方向
            colors: [['rgba(0, 0, 0, 0.3)', 0.3], ['rgba(0, 0, 0, 0)', 1]]
          })
        }

      }
      .width('100%')
      .height(75)
      .margin({ bottom: this.gs.bottomHeight })
      .backgroundColor(Constants.COLOR_GrayNAV)
      .justifyContent(FlexAlign.SpaceAround)
      .bindContentCover(this.showUploadDialog!!, this.contentDialog, {
        modalTransition: ModalTransition.DEFAULT
      })

      if (this.gs.showDialog) {
        customDialog({
          imgAvatar: () => {
            if (this.dialogBgColor === Color.Black) {
              this.imgAvatar()
            }
          }
        })
          .onClick(() => {
            this.getUIContext().animateTo({ duration: 200 }, () => {
              //通过判断色值区别弹窗是哪个页面的再进行相应改变
              if (this.dialogBgColor !== Color.Black) {
                this.gs.showDialog = !this.gs.showDialog
                this.indexX = '0%' //修改整个Index界面的x坐标
                TikTokEmitter.Emitter_VideoCrl(true)
              }
            })
          })
      }
    }
  }
}
