import { UserInfo } from '../models'
import { ImgComp } from './ImgComp'

/**
 * 联系人/搜索结果行 消息页与搜索页共用*/
@Component
export struct ContactRow {
  @Require
  @Prop
  item: UserInfo

  build() {
    Row({ space: 10 }) {
      ImgComp({
        imgWidth: 70,
        imgSrc: this.item.avatar,
        bordRadius: 35
      })
      Column() {
        Text(this.item.username)
          .fontWeight(600)
          .fontSize(24)
        Text(this.item.content)
          .fontColor('#ff646464')
          .fontSize(14)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
  }
}
