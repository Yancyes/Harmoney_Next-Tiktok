
/**
 * 视频栅格化组件*/
@Component
export struct VideoGrid {
  data: object[] = []

  build() {
    Column() {
      if (this.data) {
        WaterFlow() {

        }.columnsTemplate('1fr 1fr 1fr')
        .scrollBar(BarState.Off)
      } else {
        Column() {
          Text("空空如也~").fontSize(30).fontColor(Color.Gray)
        }.width('100%').height('100%').justifyContent(FlexAlign.Start).padding({ top: 80 })
      }
    }.layoutWeight(1)
  }
}

@Extend(Video)
function vdSty() {
  .muted(true)
  .loop(true)
  .autoPlay(true)
  .controls(false)
}