import { Constants } from '../common/Constants'
import { DataSource, mediaType } from '../models'

/**
 * 视频栅格化组件*/
@Component
export struct VideoGrid {
  @Prop data: object[] = []
  @State lazyData: DataSource<mediaType> | null = null
  aboutToAppear(): void {
    this.lazyData = new DataSource<mediaType>(this.data as mediaType[])
  }

  build() {
    Column() {
      if (this.lazyData) {
        WaterFlow() {
          LazyForEach(this.lazyData, (item: mediaType) => {
            FlowItem() {
              Video({src:item.video.play_addr.url_list[0]}).vdSty()
                .height(180).border({width:.5,color:Color.White})
                .onClick(()=>{
                  this.getUIContext().getRouter().pushUrl({
                    url: Constants.VIDEO_DETAIL,
                    params:item
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