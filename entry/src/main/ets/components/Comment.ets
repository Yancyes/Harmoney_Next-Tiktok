import { ImgComp, LikeTextCount } from '.'
import { common, Constants } from '../common'
import { commentDataModel } from '../models'
import { tiktokChatStory } from '../utils'

/**
 * 评论区内容组件*/
@ComponentV2
export struct Comment {
  @Require
  @Param
  item: commentDataModel
  /**
   * 评论所属视频的uri 点赞按uri回写仓库*/
  @Require
  @Param
  videoUri: string = ''
  /**
   * 删除本条评论 列表与首选项都由父组件维护*/
  @Event
  deleteComment: (item: commentDataModel) => void = () => {
  }
  /**
   * 长按弹出的删除气泡显隐*/
  @Local
  showDeleteTip: boolean = false
  /**
   * 气泡内容 由返回值给对象字面量提供上下文类型*/
  deleteTip(): PopupOptions {
    return {
      message: '删除该评论',
      placement: Placement.Top,
      targetSpace: 12,
      enableArrow: true,
      mask: false,
      primaryButton: {
        value: '删除',
        action: () => {
          this.deleteComment(this.item)
        }
      },
      secondaryButton: {
        value: '取消',
        action: () => {
        }
      }
    }
  }
  //点赞方法
  changeLike() {
    //如果点过赞
    this.item.likeFlag ? this.item.likeNum-- : this.item.likeNum++
    this.item.likeFlag = !this.item.likeFlag
    //修改首选项
    tiktokChatStory.changeOneTiktokVideoCommentLike(this.videoUri, this.item.id as number,
      this.item.likeNum, this.item.likeFlag)
  }

  @Local
  scaleX: number = 1
  @Local
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
                //登录状态才能点赞
                common.withLogin(() => {
                  this.change()
                })
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
    //长按整条评论弹出删除气泡
    .gesture(LongPressGesture().onAction(() => {
      this.showDeleteTip = true
    }))
    .bindPopup(this.showDeleteTip!!, this.deleteTip())
  }
}
