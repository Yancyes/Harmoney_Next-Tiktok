/**
 * 卡片项*/
import { ImgComp } from '.'
import { Constants } from '../common/Constants'

@Component
export struct CardItem {
  icon: ResourceStr = ""
  leftTitle: string = ""
  rightContent?: string = ""

  build() {
    Row() {
      Row({ space: 10 }) {
        ImgComp({
          imgWidth: 20,
          imgSrc: this.icon
        })
        Text(this.leftTitle)
          .fontSize(16)
      }

      if (this.rightContent) {
        Row() {
          Text('￥' + this.rightContent).textAlign(TextAlign.Center)
            .fontColor('#ff515151')

        }
        .width(60)
        .height(30)
        .borderRadius(40)
        .justifyContent(FlexAlign.Center)
        .backgroundColor(Constants.COLOR_SiDerPay)
      }
    }.width('100%').height(60).justifyContent(FlexAlign.SpaceBetween)
  }
}