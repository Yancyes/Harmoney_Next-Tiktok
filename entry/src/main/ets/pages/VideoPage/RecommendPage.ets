import { common, tipDialog } from '../../common'
import { Skeleton, VideoComp } from '../../components'
import { DataSource, mediaType } from '../../models'


/**
 * 推荐页
 * */
@Entry
@Component
struct RecommendPage {
  /**
   * 索引*/
  @State
  activeIndex: number = 0
  /**
   * 懒加载视频数据列表*/
  @State
  videoList: DataSource<mediaType> | null = null

  getVideoData() {
    const data = common.getJsonFileData('videos.json')
    return JSON.parse(data) as mediaType[]
  }

  aboutToAppear(): void {
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
            activeIndex:this.activeIndex
          })
        })
      }
      .index($$this.activeIndex)
      //关闭指示器
      .indicator(false)
      .duration(200)
      .loop(false)
      //允许滚动
      .vertical(true)
    }
  }
}

export default RecommendPage