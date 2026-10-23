import { VdDetailParams, VideoComp } from '../../components'
import { DataSource, mediaType } from '../../models'

/**
 * 视频详情页 支持上下滑动切换视频*/
@Entry
@Component
struct VdDetail {
  @Provide isShowSpeed: boolean = false
  @Provide speedColor: string = '#ff4e4e4e'
  @Provide speedSize: number = 16
  @Provide isShowRightSideBar: boolean = true
  @Provide dialogBgColor: ResourceColor = ''
  /**
   * 当前播放索引 初始值为点击的视频索引*/
  @State
  activeIndex: number = 0
  /**
   * 视频列表数据源*/
  @State
  videoList: DataSource<mediaType> = new DataSource<mediaType>([])

  aboutToAppear(): void {
    const params = this.getUIContext().getRouter().getParams() as VdDetailParams
    this.activeIndex = params?.index ?? 0
    this.videoList = new DataSource<mediaType>(params?.list ?? [])
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Swiper() {
        LazyForEach(this.videoList, (item: mediaType, index: number) => {
          VideoComp({
            item,
            index,
            activeIndex: this.activeIndex
          })
        })
      }
      .index($$this.activeIndex)
      //关闭指示器
      .indicator(false)
      .duration(200)
      .loop(false)
      //允许上下滚动
      .vertical(true)
      .cachedCount(1)

      Text('<')
        .fontColor(Color.White)
        .fontSize(40)
        .margin({ top: 20, left: 15 })
        .onClick(() => {
          this.getUIContext().getRouter().back()
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Black)
  }
}
