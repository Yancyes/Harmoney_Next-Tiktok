import { ImgComp, LikeTextCount } from '.'
import { common, Constants } from '../common'
import { commentDataModel, mediaType } from '../models'
import { tiktok, tiktokChatStory } from '../utils'

/**
 * 评论区内容组件*/
@Component
export struct Comment {
  @ObjectLink
  item: commentDataModel
  @Link
  videoItem: mediaType

  //点赞方法
  changeLike() {
    if (this.item.likeFlag) { //如果点过赞
      this.item.likeNum--
    } else {
      this.item.likeNum++
    }
    this.item.likeFlag = !this.item.likeFlag
    //修改首选项
    tiktokChatStory.changeOneTiktokVideoCommentLike(this.videoItem.video.play_addr.uri, this.item.id as number,
      this.item.likeNum,this.item.likeFlag)
  }

  @State
  scaleX: number = 1
  @State
  scaleY: number = 1

  /**
   * 动画*/
  change() {
    this.scaleX = 0
    this.scaleY = 0
    setTimeout(() => {
      this.scaleX = 1
      this.scaleY = 1
      this.changeLike()
    }, 200)
  }

  build() {

    Row({ space: 10 }) {
      ImgComp({
        imgSrc: this.item.avatar, //头像
        isFillColor: this.item.likeFlag,
        imgWidth: 40,
        color_1: Color.Red,
        color_2: Constants.COLOR_GREY,
        bordRadius: 50
      })
      Column() {
        Text(this.item.author)//作者
          .fontColor(Constants.COLOR_GREY)
          .fontSize(18)
        Text(this.item.content)//内容
          .fontColor('#ff1c1c1c')
          .fontSize(22)
        Row({ space: 10 }) {
          Row() {
            Text(`${this.item.time} • ${this.item.area}`)//事件地区
              .fontColor(Constants.COLOR_GREY)
              .fontSize(18)
          }

          Row() {
            ImgComp({
              imgWidth: 20,
              imgSrc: $r('app.media.ic_public_love'),
              isFillColor: this.item.likeFlag,
              color_1: Color.Red,
              color_2: Constants.COLOR_GREY
            })
              .scale({ x: this.scaleX, y: this.scaleY })
              .onClick(() => {
                common.redirect()
                //如果有账号信息
                if (tiktok.getUserInfo()){
                  this.change()
                }
              })
              .animation({ duration: 200 })
            LikeTextCount({ count: this.item.likeNum, isChangeColor: this.item.likeFlag, isWhite: false })
          }
        }
        .width('100%')

        .justifyContent(FlexAlign.SpaceBetween)
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
    }
    .alignItems(VerticalAlign.Top)
    .width('100%')
    .padding({
      left: 20, right: 20
    })
  }
}


