import { Colm, customDialog, ImgComp, TitleBtn, TopBar } from '.'
import { common, Constants, tipDialog } from '../common'
import { BarClass, TabList } from '../models'
import { UserInfo, UserInfoModel } from '../models/user'
import { MessagePage } from '../pages/Message/MessagePage'
import { tiktok, Tiktok } from '../utils/setting'
import MyPage from '../pages/My/My'
import { photoAccessHelper } from '@kit.MediaLibraryKit'
import { TikTokEmitter } from '../utils/TIkTokEmitter'
import { BtnType } from '../GlobalEnum'


@Component
export struct bottomNav {
  @StorageProp(Constants.BOTTOM_HEIGHT)
  BtmAreaHeight: number = 0
  /**
   * 顶部栏信息*/
  topTabList: BarClass[] = TabList
  /**
   * 顶部栏索引*/
  @State
  topNavCurrentIndex: number = this.topTabList.length - 1
  /**
   * 是否显示上传弹窗*/
  @State
  showUploadDialog: boolean = false
  //底部tab的数据
  btmTabList: BarClass[] = [
    {
      title: '首页',
      name: BtnType.Home,
    },
    {
      title: '朋友',
      name: BtnType.Friend,
      click: () => {
        common.redirect()
      }
    },
    {
      icon: $r('app.media.ic_uploading'),
      name: BtnType.Upload,
      click: () => {
        common.redirect()
        if (tiktok.getUserInfo()) {
          this.showUploadDialog = true
        }
      }
    },
    {
      title: '信息',
      name: BtnType.Message,
      click: () => {
        common.redirect()
      }
    },
    {
      title: '我',
      name: BtnType.My,
      click: () => {
        common.redirect()
      }
    }
  ]
  tabController: TabsController = new TabsController()
  @State
  currentIndex: number = 0
  @State
  userInfo: UserInfoModel = new UserInfoModel({} as UserInfo)
  //底部title字体的颜色
  @State
  titleColor: ResourceColor[] = [Color.White, Color.Gray]
  @StorageLink(Constants.SHOW_DIALOG) showDialog: boolean = false
  @Provide
  dialogBgColor: ResourceColor = '' //修改渐变背景色只能通过#00000000的方式
  @Provide
  info: UserInfoModel = new Tiktok(getContext()).getCurrentUser()
  @Consume
  IndexX: number | string //整个index页面的x坐标
  @Provide
  isShowSpeed: boolean = false //是否显示倍速提示
  /*
   * 图片选择数量*/
  maxImgNumber: number = 1 //最多可选1张图片

  aboutToAppear(): void {
    AppStorage.setOrCreate(Constants.SHOW_DIALOG, this.showDialog)
  }

  /**
   * 选择图片*/
  async selectPhoto() {
    const photo = new photoAccessHelper.PhotoViewPicker(); //图片选择对象
    const result = await photo.select({
      MIMEType: photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE, //指定选择类型
      maxSelectNumber: this.maxImgNumber  //最大数量
    })
    //如果有图片 这里的业务只需要单个图片
    if (result.photoUris.length) {
      this.info.avatar = result.photoUris.toString()
      const token = this.info
      await new Tiktok(getContext()).setCurrentUser(JSON.stringify(token)) //写入首选项
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
          this.showDialog = false
        })
        .margin({ top: "5%", left: '-85%' })
      Image(this.info.avatar)
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

  //底部tab的的结构
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
      //通过获取索引值实现点击切换tab
      item.click && item.click()
      //如果有用户信息才执行点击事件
      if (tiktok.getUserInfo()) {
        if (item.name !== BtnType.Upload) {
          const index = this.btmTabList.findIndex(obj => obj.name === item.name)
          this.tabController.changeIndex(index)
          if (item.name !== BtnType.Home) {
            TikTokEmitter.Emitter_VideoCrl(false)
          }
          //如果底部栏索引是首页且顶部栏索引是推荐页开启播放器
          if (item.name === BtnType.Home && this.topNavCurrentIndex === this.topTabList.length - 1) {
            TikTokEmitter.Emitter_VideoCrl(true)
          }
        }
        //如果是功能按钮停止播放
        if (item.name === BtnType.Upload) {
          TikTokEmitter.Emitter_VideoCrl(false)
        }
      }
    })
  }

  @Provide
  speedColor: string = '#ff4e4e4e'
  @Provide
  speedSize: number = 16

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Tabs({ index: $$this.currentIndex, controller: this.tabController, barPosition: BarPosition.End }) {
        ForEach(this.btmTabList, (item: BarClass) => {
          TabContent() {
            if (item.name === BtnType.Home) {
              TopBar({
                topNavCurrentIndex: this.topNavCurrentIndex
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
      .margin({ bottom: this.BtmAreaHeight })
      .backgroundColor(Constants.COLOR_GrayNAV)
      .justifyContent(FlexAlign.SpaceAround)
      //全屏模态弹窗
      .bindContentCover($$this.showUploadDialog, this.contentDialog, {
        modalTransition: ModalTransition.DEFAULT
      })

      //默认不显示遮罩层
      if (this.showDialog) {
        customDialog({
          imgAvatar: () => {
            if (this.dialogBgColor === Color.Black) {
              this.imgAvatar()
            }
          }
        })
          .onClick(() => {
            animateTo({ duration: 200 }, () => {
              //通过判断色值区别弹窗是哪个页面的再进行相应改变
              if (this.dialogBgColor !== Color.Black) {
                this.showDialog = !this.showDialog
                this.IndexX = '0%' //修改整个Index界面的x坐标
                TikTokEmitter.Emitter_VideoCrl(true)
              }
            })
          })
      }
    }
  }
}