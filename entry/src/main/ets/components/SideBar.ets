import { mediaType, sideData, sideDataModel } from '../models'
import { common, Constants, tipDialog } from '../common'
import { ImgComp, LikeTextCount } from '.'
import { TiktokCollection, TiktokLike } from '../utils'

enum sideList {
  like,
  comment,
  collect,
  share
}

/**
 * 视频功能侧边栏*/
@ComponentV2
struct Sidebar {
  @Require
  @Param
  item: mediaType //视频数据
  @Local
  sideDataList: sideDataModel[] = [
    new sideDataModel({
      name: '点赞',
      imgUrl: $r('app.media.love'),
      Num: this.item.statistics.digg_count + (TiktokLike.isLiked(this.item.aweme_id) ? 1 : 0),
      isLike: TiktokLike.isLiked(this.item.aweme_id),
      click: () => {
        this.changeState(sideList.like)
        //changeState已翻转isLike 按新状态写入仓库
        TiktokLike.changeLike(this.item, this.sideDataList[sideList.like].isLike!)
      }
    }),
    new sideDataModel({
      name: '评论',
      imgUrl: $r('app.media.chat'),
      Num: this.item.statistics.comment_count,
      click: () => {
        //抖音式半屏评论 不暂停视频 由VideoComp按弹层高度把画面顶起
        common.nav(Constants.ROUTE_COMMENT_DIALOG, this.item.video.play_addr.uri)
      }
    }),
    new sideDataModel({
      name: '收藏',
      imgUrl: $r('app.media.collect'),
      Num: this.item.statistics.collect_count + (TiktokCollection.isCollected(this.item.aweme_id) ? 1 : 0),
      isLike: TiktokCollection.isCollected(this.item.aweme_id),
      click: () => {
        //先按当前状态决定增删 changeState在后 顺序不能颠倒
        this.sideDataList[sideList.collect].isLike === true ? TiktokCollection.delCollection(this.item) :
          TiktokCollection.addCollection(this.item)
        this.changeState(sideList.collect)
      }
    }),
    new sideDataModel({
      name: '分享',
      imgUrl: $r('app.media.transmit'),
      Num: this.item.statistics.share_count,
      click: () => {
        tipDialog()
      }
    })
  ]

  changeState(value: sideList) {
    //取消点赞/收藏时数量应减 原逻辑方向写反
    this.sideDataList[value].isLike ? this.sideDataList[value].Num!-- : this.sideDataList[value].Num!++
    this.sideDataList[value].isLike = !this.sideDataList[value].isLike
  }

  build() {
    Column() {
      ForEach(this.sideDataList, (item: sideData) => {
        sideIcon({ item: item })
      })
    }.height('100%')
    .zIndex(2)
    .position({ x: '82.5%', y: '50%' })
  }
}

export { Sidebar }

@ComponentV2
struct sideIcon {
  @Require
  @Param
  item: sideData
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
      this.item.click && this.item.click()
    }, 200)
  }

  build() {
    Column() {
      ImgComp({
        imgWidth: 45,
        imgSrc: this.item.imgUrl,
        isFillColor: this.item.isLike,
        color_1: Color.Red,
        color_2: Color.White
      }).aspectRatio(1)
        .scale({ x: this.scaleX, y: this.scaleY })
        .onClick(() => {
          this.change()
        })
        .animation({ duration: 200 })
      LikeTextCount({ count: this.item.Num!, isWhite: true })
    }
  }
}
