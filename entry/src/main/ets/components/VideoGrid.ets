import { Constants } from '../common/Constants'
import { DataSource, mediaType } from '../models'

/**
 * 跳转视频详情页的路由参数*/
export interface VdDetailParams {
  list: mediaType[]
  index: number
}

/**
 * 视频栅格化组件*/
@Component
export struct VideoGrid {
  @Prop @Watch('onDataChange') data: object[] = []
  @State lazyData: DataSource<mediaType> | null = null
  aboutToAppear(): void {
    this.lazyData = new DataSource<mediaType>(this.data as mediaType[])
  }

  /**
   * 父组件更新data后 懒加载数据源不会自动重建 需reload刷新*/
  onDataChange(): void {
    this.lazyData?.reload(this.data as mediaType[])
  }

  build() {
    Column() {
      if (this.lazyData) {
        WaterFlow() {
          LazyForEach(this.lazyData, (item: mediaType, index: number) => {
            FlowItem() {
              Video({src:item.video.play_addr.url_list[0]}).vdSty()
                .height(180).border({width:.5,color:Color.White})
                .onClick(()=>{
                  const params: VdDetailParams = {
                    list: this.data as mediaType[],
                    index
                  }
                  this.getUIContext().getRouter().pushUrl({
                    url: Constants.VIDEO_DETAIL,
                    params
                  })
                })
            }
          })
        }.columnsTemplate('1fr 1fr 1fr')
        .scrollBar(BarState.Off).height('100%')
      } else {
        Column() {
          Text("空空如也~").fontSize(30).fontColor(Color.Gray)
        }.width('100%').height('100%')
      }
    }.height('100%')
  }
}

@Extend(Video)
function vdSty() {
  .muted(true)
  .loop(true)
  .autoPlay(true)
  .controls(false)
}