import { mediaType } from '../models'
import { Sidebar, VideoDescribe } from '.'
import { common, Constants, GlobalState, globalState } from '../common'
import { emitter } from '@kit.BasicServicesKit'
import { display } from '@kit.ArkUI'

@ReusableV2
@ComponentV2
export struct VideoComp {
  @Require
  @Param
  index: number = -1
  @Require
  @Param
  item: mediaType
  @Require
  @Param
  activeIndex: number = 0
  @Local
  playIng: boolean = true
  @Consumer('isShowSpeed')
  isShowSpeed: boolean = false
  @Local
  videoSpeed: number = 1 //视频倍速
  videoController: VideoController = new VideoController()
  @Consumer('speedColor')
  speedColor: string = '#ff4e4e4e'
  @Consumer('speedSize')
  speedSize: number = 16
  @Consumer('isShowRightSideBar')
  isShowRightSideBar: boolean = true
  @Consumer('commentDialogHeight')
  commentDialogHeight: number = 0
  @Consumer('commentDialogDragging')
  commentDialogDragging: boolean = false
  @Local gs: GlobalState = globalState()
  @Local
  videoPlayProgress: number = 0
  /**
   * 视频总时长*/
  @Local
  videoTotalDuration: number = 0
  /**
   * 是否显示视频进度条*/
  @Local
  isShowVideoProgressSlider: boolean = false
  /**
   * 是否显示视频描述*/
  @Local
  isShowDescribe: boolean = true
  @Local screenHeight: number = 0
  @Local screenWidth: number = 0
  /**
   * 容器底边相对屏幕底边的偏移vp 顶部栏的内容比屏幕高 顶起高度要补上这段误差
   * 由外层容器测量后传入 视频项自身随滑动移动 不能自己量*/
  @Param bottomOffset: number = 0

  /**
   * 更新切换索引的状态*/
  @Monitor('activeIndex')
  updateActiveIndex(): void {
    this.activeIndex === this.index ? this.startVideo() : this.stopVideo()
  }

  startVideo(): void {
    this.videoController.start()
  }

  pauseVideo(): void {
    this.videoController.pause()
  }

  stopVideo(): void {
    this.videoController.stop()
  }

  startSpeed(): void {
    this.isShowSpeed = true
    this.videoSpeed = 2
  }

  closeSpeed(): void {
    this.isShowSpeed = false
    this.videoSpeed = 1
  }

  startSpeedAnimation(): void {
    this.getUIContext().animateTo({ duration: 500, iterations: -1 }, () => {
      this.speedColor = '#ff98fd25'
      this.speedSize = 40
    })
  }

  stopSpeedAnimation(): void {
    this.getUIContext().animateTo({ duration: 500, iterations: -1 }, () => {
      this.speedColor = '#ff4e4e4e'
      this.speedSize = 30
    })
  }

  aboutToAppear(): void {
    const displayInfo = display.getDefaultDisplaySync()
    this.screenHeight = this.getUIContext().px2vp(displayInfo.height)
    this.screenWidth = this.getUIContext().px2vp(displayInfo.width)
    this.getMyPageVideoUrl()
    this.onVideoPlayer()
    this.onVideoPause()
  }

  aboutToDisappear(): void {
    //销毁事件 减少资源浪费 只移除自身的回调 避免影响其他页面的监听
    emitter.off(Constants.GLOBAL_VIDEO_CONTROLLER_PLAYER, this.playerCallback)
    emitter.off(Constants.GLOBAL_VIDEO_CONTROLLER_PAUSE, this.pauseCallback)
  }

  /**
   * 复用节点不会再走aboutToAppear 内部状态会残留上一项的播放状态 这里统一归位*/
  aboutToReuse(): void {
    this.playIng = this.activeIndex === this.index
    this.videoSpeed = 1
    this.videoPlayProgress = 0
    this.videoTotalDuration = 0
    this.isShowVideoProgressSlider = false
    this.isShowDescribe = true
    this.getMyPageVideoUrl()
  }

  getMyPageVideoUrl(): void {
    this.gs.videoBgUrl = this.item.video.play_addr.url_list[0]
  }

  /**
   * 播放事件回调*/
  private playerCallback = () => {
    //调用观察索引变化的方法 确保播放的视频索引和当前索引一致
    this.updateActiveIndex()
  }
  /**
   * 暂停事件回调*/
  private pauseCallback = () => {
    this.pauseVideo()
  }

  /**
   * 在视频播放时触发*/
  onVideoPlayer(): void {
    emitter.on(Constants.GLOBAL_VIDEO_CONTROLLER_PLAYER, this.playerCallback)
  }

  /**
   * 在视频暂停时触发*/
  onVideoPause(): void {
    emitter.on(Constants.GLOBAL_VIDEO_CONTROLLER_PAUSE, this.pauseCallback)
  }

  format(num: number): string {
    const totalSeconds = Math.floor(num)
    const minutes = Math.floor(totalSeconds / 60)
    const secs = totalSeconds % 60
    return common.toStr(minutes) + ':' + common.toStr(secs)
  }

  setVideoProgress(value: number): void {
    this.videoController.setCurrentTime(value)
  }

  /**
   * 结束或取消拖动时恢复被临时隐藏的画面元素
   * 手势被Swiper接管时只会走取消不走结束 不处理侧边栏会一直不回来*/
  resetSeekState(): void {
    this.isShowVideoProgressSlider = false
    this.isShowDescribe = true
    this.isShowRightSideBar = true
  }

  build() {
    Stack({ alignContent: Alignment.BottomStart }) {
      Column() {
        //画面区由布局真实分高 底部留白撑大后画面随之压缩
        Stack({ alignContent: Alignment.BottomStart }) {
          Video({
            src: this.item.video.play_addr.url_list[0],
            controller: this.videoController,
            currentProgressRate: this.videoSpeed
          })
            .width('100%')
            .height('100%')
            .onPrepared(e => {
              this.videoTotalDuration = e.duration
            })
            .onUpdate(e => {
              this.videoPlayProgress = e.time
            })
            .autoPlay(this.activeIndex === this.index)
            .loop(true)
            .objectFit(ImageFit.Contain)
            .controls(false)
            .onStart(() => {
              this.playIng = true
            })
            .onPause(() => {
              this.playIng = false
            })
            .gesture(GestureGroup(GestureMode.Parallel,
              LongPressGesture()
                .onAction(() => {
                  this.startSpeed()
                  this.startSpeedAnimation()
                })
                .onActionEnd(() => {
                  this.closeSpeed()
                  this.stopSpeedAnimation()
                })
            ))
          //视频描述
          Row() {
            VideoDescribe({
              title: this.item.music.author,
              describe: this.item.desc
            }).visibility(this.isShowDescribe ? Visibility.Visible : Visibility.Hidden)
          }.layoutWeight(1).height(65).margin({ bottom: 15 })
          .gesture(GestureGroup(GestureMode.Parallel,
            //只接管水平拖动 垂直拖动交给Swiper切视频 否则会把侧边栏藏起来
            PanGesture({ direction: PanDirection.Horizontal })
              .onActionUpdate((e) => {
                //手指在视频区域   75是底部导航栏高度
                if (e.fingerList[0].globalY < this.screenHeight - 75) {
                  this.isShowVideoProgressSlider = true
                  this.isShowDescribe = false
                  this.isShowRightSideBar = false
                }
                if (this.videoPlayProgress < this.videoTotalDuration) {
                  //手指在屏幕左侧
                  if (e.fingerList[0].globalX < this.screenWidth / 2) {
                    if (this.videoPlayProgress > 0) {
                      this.setVideoProgress(this.videoPlayProgress - 1)
                    }
                  } else {
                    this.setVideoProgress(this.videoPlayProgress + 1)
                  }
                }
              })
              .onActionEnd(() => {
                this.resetSeekState()
              })
              .onActionCancel(() => {
                this.resetSeekState()
              })
          ))

          //视频进度条
          if (this.isShowVideoProgressSlider) {
            Column({ space: 50 }) {
              Row({ space: 20 }) {
                Text(this.format(this.videoPlayProgress)).TextProgress(Color.White)
                Text('|').TextProgress(Color.White)
                Text(this.format(this.videoTotalDuration)).TextProgress(Constants.COLOR_GREY)
              }

              Slider({
                value: this.videoPlayProgress!!,
                min: 0,
                max: this.videoTotalDuration
              })
                .margin({ bottom: -20, left: 10, right: 10 })
                .layoutWeight(1)
                .trackColor('#ff565656')
                .trackThickness(6)
                .selectedColor('#ffeeeeee')
            }.height(150)
          }
          //侧边功能区组件 评论弹层打开时与顶部栏一起收起
          Sidebar({
            item: this.item
          }).visibility(this.isShowRightSideBar && this.commentDialogHeight === 0 ? Visibility.Visible : Visibility.Hidden)
        }
        .width('100%')
        .layoutWeight(1)
        .onClick(() => {
          //点击控制播放和暂停 默认在播放
          this.playIng ? this.pauseVideo() : this.startVideo()
        })

        //评论弹层占多高 画面区下方就留多高 画面底边正好压在弹层上沿
        Row()
          .width('100%')
          .height(Math.max(this.commentDialogHeight + this.bottomOffset, 0))
          //拖动弹层时跟手不补间 开合时才走动画
          .animation({ duration: this.commentDialogDragging ? 0 : Constants.COMMENT_DIALOG_ANIM_DURATION, curve: Curve.EaseOut })
      }
      .width('100%')
      .height('100%')

      //播放暂停按钮 单独浮层绝对定位在屏幕中间 不随画面压缩移动 也不拦截点击
      Column() {
        Image($r("app.media.Content_play")).width(68).height(68).opacity(.7)
          .hitTestBehavior(HitTestMode.None)
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .hitTestBehavior(HitTestMode.None)
      .visibility(this.playIng ? Visibility.Hidden : Visibility.Visible)
    }
    .width('100%')
    .height('100%')
    //画面按比例缩进后露出的区域兜黑 与抖音一致
    .backgroundColor(Color.Black)
  }
}

@Extend(Text)
function TextProgress(color: ResourceColor) {
  .fontColor(color)
  .fontSize(35)
}
