import { mediaType } from '../models'
import { Sidebar, VideoDescribe } from '.'
import { Constants } from '../common'
import { emitter } from '@kit.BasicServicesKit'

@Reusable
@Component
export struct VideoComp {
  /**
   * 接收传入的视频索引*/
  @Require
  @Prop
  index: number = -1
  /**
   * 视频项*/
  @Require
  @Prop
  item: mediaType
  /**
   * 播放的索引*/
  @Consume
  @Watch('updateActiveIndex')
  activeIndex: number
  /**
   * 视频播放状态*/
  @State
  playIng: boolean = true
  /** 是否显示倍速 */
  @Consume
  isShowSpeed: boolean
  @State
  videoSpeed: number = 1 //视频倍速
  /** 是否显示评论弹窗 */
  @Provide
  showCommentDialog: boolean = false
  //视频播控器
  videoController = new VideoController()
  /** 倍速颜色 */
  @Consume speedColor: string
  /** 倍速字体大小 */
  @Consume speedSize: number
  /**是否显示右侧导航*/
  @Consume isShowRightSideBar: boolean
  @StorageLink(Constants.SHOW_DIALOG) showDialog: boolean = false
  /**
   * 模态弹层高度*/
  @Provide dialogHeight: number = 0
  /**
   * 视频缩放值*/
  @State scaleSize: number = 1
  /**
   * 视频播放进度*/
  @State videoPlayProgress: number = 0
  /**
   * 视频总时长*/
  @State videoTotalDuration: number = 0
  /**
   * 是否显示视频进度条条*/
  @State isShowVideoProgressSlider: boolean = false
  /**
   * 是否显示视频描述*/
  @State isShowDescribe: boolean = true

  /**
   * 更新切换索引的状态*/
  updateActiveIndex() {
    this.activeIndex === this.index ? this.startVideo() : this.stopVideo()
  }

  startVideo() {
    this.videoController.start()
  }

  pauseVideo() {
    this.videoController.pause()
  }

  stopVideo() {
    this.videoController.stop()
  }

  startSpeed() {
    this.isShowSpeed = true
    this.videoSpeed = 2
  }

  closeSpeed() {
    this.isShowSpeed = false
    this.videoSpeed = 1
  }

  startSpeedAnimation() {
    animateTo({ duration: 500, iterations: -1 }, () => {
      this.speedColor = '#ff98fd25'
      this.speedSize = 40
    })
  }

  stopSpeedAnimation() {
    animateTo({ duration: 500, iterations: -1 }, () => {
      this.speedColor = '#ff4e4e4e'
      this.speedSize = 30
    })
  }

  aboutToAppear() {
    AppStorage.setOrCreate(Constants.SCALE_SIZE, this.scaleSize)
    this.getMyPageVideoUrl()
    this.onVideoPlayer()
    this.onVideoPause()
  }

  aboutToDisappear(): void {
    //销毁事件 减少资源浪费
    emitter.off(Constants.GLOBAL_VIDEO_CONTROLLER_PLAYER)
    emitter.off(Constants.GLOBAL_VIDEO_CONTROLLER_PAUSE)
  }

  getMyPageVideoUrl() {
    AppStorage.setOrCreate(Constants.GET_VIDEO_IMG_URL, this.item.video.play_addr.url_list[0])
  }

  /**
   * 在视频播放时触发*/
  onVideoPlayer() {
    emitter.on(Constants.GLOBAL_VIDEO_CONTROLLER_PLAYER, () => {
      //调用观察索引变化的方法 确保播放的视频索引和当前索引一致
      this.updateActiveIndex()
    })
  }

  /**
   * 在视频暂停时触发*/
  onVideoPause() {
    emitter.on(Constants.GLOBAL_VIDEO_CONTROLLER_PAUSE, () => {
      this.pauseVideo()
    })
  }

  build() {
    Stack({ alignContent: Alignment.BottomStart }) {
      Video({
        src: this.item.video.play_addr.url_list[0],
        controller: this.videoController,
        currentProgressRate: this.videoSpeed
      })
        .onPrepared(e => {
          this.videoTotalDuration = e.duration
        })
        .onUpdate(e => {
          this.videoPlayProgress = e.time
        })
        .scale({ x: this.scaleSize, y: this.scaleSize })
        .margin({
          bottom: this.showCommentDialog ? this.dialogHeight - 100 : null
        })
        .animation({ duration: 200 })
        .autoPlay(this.activeIndex === this.index)
        .loop(true)
        .objectFit(this.showCommentDialog ? ImageFit.Cover : ImageFit.Contain)
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
      //播放暂停按钮
      if (!this.playIng) {
        Column() {
          Image($r("app.media.Content_play")).width(68).height(68).opacity(.7)
        }
        .height('100%').width('100%')
        .justifyContent(FlexAlign.Center)
      }
      //视频描述
      Row() {
        if (this.isShowDescribe) {
          VideoDescribe({
            title: this.item.music.author,
            describe: this.item.desc
          })
        }
      }.gesture(GestureGroup(GestureMode.Parallel,
        LongPressGesture()
          .onAction(() => {
            this.isShowVideoProgressSlider = true
            this.isShowDescribe = false
            this.isShowRightSideBar = false
          })
      ))

      //视频进度条
      if (this.isShowVideoProgressSlider) {
        Slider({
          value: $$this.videoPlayProgress,
          min: 0,
          max: this.videoTotalDuration,
          style: SliderStyle.InSet
        })
          .width('90%')
          .height(20)
          .backgroundColor('#ff5f5f5f')
          .borderRadius(10)
          .selectedColor('#ffeeeeee')
          .margin({ left: 20, right: 20, bottom: 5 })
      }

      //侧边功能区组件
      Sidebar({
        item: this.item
      }).visibility(this.isShowRightSideBar ? Visibility.Visible : Visibility.Hidden)
    }.onClick(() => {
      //点击控制播放和暂停 默认在播放
      this.playIng ? this.pauseVideo() : this.startVideo()
      this.isShowVideoProgressSlider = false
      this.isShowRightSideBar = true
      this.isShowDescribe = true
    })
  }
}