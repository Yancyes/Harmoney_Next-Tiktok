import { common } from '../../common'
import { VdDetailParams, VideoComp } from '../../components'
import { DataSource, mediaType } from '../../models'

/**
 * 视频详情页 支持上下滑动切换视频 动态路由表入口 见resources/base/profile/router_map.json*/
@Builder
export function VdDetailBuilder() {
  VdDetail()
}

@ComponentV2
export struct VdDetail {
  @Provider('isShowSpeed')
  isShowSpeed: boolean = false
  @Provider('speedColor')
  speedColor: string = '#ff4e4e4e'
  @Provider('speedSize')
  speedSize: number = 16
  @Provider('isShowRightSideBar')
  isShowRightSideBar: boolean = true
  @Provider('dialogBgColor')
  dialogBgColor: ResourceColor = ''
  /**
   * 当前播放索引 初始值为点击的视频索引*/
  @Local
  activeIndex: number = 0
  /**
   * 视频列表数据源*/
  @Local
  videoList: DataSource<mediaType> = new DataSource<mediaType>([])

  build() {
    NavDestination() {
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
        .index(this.activeIndex!!)
        //关闭指示器
        .indicator(false)
        .duration(200)
        .loop(false)
        //允许上下滚动
        .vertical(true)
        .cachedCount(1)

        SymbolGlyph($r('sys.symbol.chevron_left'))
          .fontSize(30)
          .fontColor([Color.White])
          .margin({ top: 20, left: 15 })
          .onClick(() => {
            common.back()
          })
      }
      .width('100%')
      .height('100%')
      .backgroundColor(Color.Black)
    }
    .hideTitleBar(true)
    //动态路由的参数只能在NavDestination挂载后从pathInfo里取
    .onReady((context: NavDestinationContext) => {
      const params = context.pathInfo.param as VdDetailParams | undefined
      this.activeIndex = params?.index ?? 0
      this.videoList = new DataSource<mediaType>(params?.list ?? [])
    })
  }
}
