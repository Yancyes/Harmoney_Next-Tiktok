/**
 * 图标按钮组件*/
import { ImgComp } from '.'

@ComponentV2
export struct iconBtn {
  @Require
  @Param
  icon: ResourceStr = ''
  @Require
  @Param
  title: string = ''

  build() {
    Column({ space: 10 }) {
      ImgComp({
        imgSrc: this.icon,
        imgWidth: 26,
        isDraggable: false,
        ImageFitType: ImageFit.Contain
      })
      Text(this.title)
        .fontWeight(500)
        .fontSize(14)
    }
  }
}
