import { common, tipDialog } from '../../common'
import { Skeleton, VideoComp } from '../../components'
import { DataSource, mediaType } from '../../models'
import { display } from '@kit.ArkUI'

const videoDataResource = 'videos.json'

/**
 * 推荐页 只作为顶部栏 Tabs 的一页使用 不是路由入口
 * */
@ComponentV2
export struct RecommendPage {
  @Local
  activeIndex: number = 0
  @Local
  videoList: DataSource<mediaType> | null = null
  /**
   * 容器底边相对屏幕底边的偏移vp 顶部栏的内容比屏幕高 顶起高度要补上这段误差*/
  @Local
  bottomOffset: number = 0
  private screenHeight: number = 0

  getVideoData() {
    const data = common.getJsonFileData(videoDataResource)
    return JSON.parse(data) as mediaType[]
  }

  /**
   * 用不随滑动移动的Swiper量 视频项自己在滚动中位置一直在变 不能作为基准*/
  syncBottomOffset(area: Area): void {
    const offset = (area.globalPosition.y as number) + (area.height as number) - this.screenHeight
    if (offset !== this.bottomOffset) {
      this.bottomOffset = offset
    }
  }

  aboutToAppear(): void {
    this.screenHeight = this.getUIContext().px2vp(display.getDefaultDisplaySync().height)
    setTimeout(() => {
      this.videoList = new DataSource<mediaType>(this.getVideoData())
      tipDialog('项目数据原因，网络条件优异才能看到视频', 3000, Alignment.Top)
    }, 1000)
  }

  build() {
    if (!this.videoList) {
      Skeleton()
    } else {
      Swiper() {
        LazyForEach(this.videoList, (item: mediaType, index: number) => {
          VideoComp({
            item,
            index,
            activeIndex: this.activeIndex,
            bottomOffset: this.bottomOffset
          })
        })
      }
      .index(this.activeIndex!!)
      .indicator(false)
      .duration(200)
      .loop(false)
      .vertical(true)
      .onAreaChange((_oldArea: Area, newArea: Area) => {
        this.syncBottomOffset(newArea)
      })
    }
  }
}
