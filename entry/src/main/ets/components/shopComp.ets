import { ImgComp } from '.'
import { shopType } from '../models'
import { common, Constants } from '../common'

@ReusableV2
@ComponentV2
export struct shopComp {
  @Require
  @Param
  item: shopType
  //复用时奇偶错落的高度会残留上一项 索引必须由父级重新传入
  @Require
  @Param
  index: number = 0

  build() {
    Column({ space: 10 }) {
      ImgComp({
        imgWidth: '100%',
        imgSrc: this.item.cover
      })
        .height(this.index % 2 ? 180 : 200)
        .borderRadius({
          topLeft: 15, topRight: 15
        })
      Column() {
        Text(this.item.name)
        Row({ space: 5 }) {
          Text(`￥${this.item.price.toString()}`)
            .fontColor(Color.Red).fontSize(16)
            .fontWeight(600)
          Text(`已售${this.item.sold.toString()}`)
            .fontColor('#ff696868').fontSize(14)
        }
        .width('100%')
        .padding({
          left: 0,
          top: 10
        })
      }.margin(10)
    }.onClick(() => {
      common.nav(Constants.ROUTE_SHOP_DETAIL, this.item)
    })
  }
}
