import { Constants } from '../common'

/**
 * 滑动条组件*/
@ComponentV2
export struct scrollbar {
  @Require
  @Param
  scroller: Scroller

  build() {
    ScrollBar({ scroller: this.scroller, direction: ScrollBarDirection.Horizontal, state: BarState.On }) {
      Text().height(4).borderRadius(10).width(15)
        .backgroundColor(Constants.COLOR_GrayNAV)
    }
    .width(30)
    .height(4)
    .borderRadius(10)
    .margin({ top: -10 })
    .backgroundColor('#ffd4d4d4')
  }
}
