import { common } from '../common'
import { UserInfo } from '../models'
import { ImgComp } from './ImgComp'

/**
 * 联系人/搜索结果行 消息页与搜索页共用*/
@ComponentV2
export struct ContactRow {
  @Require
  @Param
  item: UserInfo

  build() {
    Row({ space: 10 }) {
      ImgComp({
        imgWidth: 70,
        imgSrc: common.avatar(this.item.avatar, this.item.user_id),
        fallbackSrc: common.avatar('', this.item.user_id),
        bordRadius: 35
      })
      Column() {
        Text(common.nickName(this.item.username, this.item.user_id))
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
