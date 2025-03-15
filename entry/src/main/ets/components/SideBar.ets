import { commentDataModel, sideDataModel, mediaType, sideData } from '../models'
import { common, Constants, tipDialog } from '../common'
import { Comment, ImgComp, LikeTextCount, ReplyInput } from '.'
import { util } from '@kit.ArkTS'
import { tiktokChatStory } from '../utils'

/**
 * 视频功能侧边栏*/
@Component
struct Sidebar {
  @Consume
  showCommentDialog: boolean
  @Prop
  item: mediaType //视频数据
  @StorageLink(Constants.SHOW_DIALOG) showDialog: boolean = false

  changeLike() {
    if (this.sideDataList[0].isLike) {
      this.sideDataList[0].Num!++
    } else {
      this.sideDataList[0].Num!--
    }
    this.sideDataList[0].isLike = !this.sideDataList[0].isLike
  }

  @StorageLink(Constants.SCALE_SIZE) scaleSize: number = 1
  @Consume
  isShowRightSideBar: boolean
  @Consume
  dialogBgColor: ResourceColor
  /**
   * 模态弹层高度*/
  @Consume dialogHeight: number
  //评论的数据
  @State commentList: commentDataModel[] = []
  //侧边栏图标和数据
  @State
  sideDataList: sideDataModel[] = [
    new sideDataModel({
      name: '点赞',
      imgUrl: $r('app.media.love'),
      Num: this.item.statistics.digg_count,
      isLike: false,
      click: () => {
        this.changeLike()
      }
    }),
    new sideDataModel({
      name: '评论',
      imgUrl: $r('app.media.chat'),
      Num: this.item.statistics.comment_count,
      click: () => {
        this.showCommentDialog = true //打开评论弹窗
        this.isShowRightSideBar = false //隐藏顶部栏
        this.dialogBgColor = Constants.COLOR_DIALOG_BG //修改弹层背景色
      }
    }),
    new sideDataModel({
      name: '收藏',
      imgUrl: $r('app.media.collect'),
      Num: this.item.statistics.comment_count,
      click: () => {
        tipDialog()
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

  //添加评论方法
  addComment(content: string) {
    const msg = new commentDataModel({
      id: util.generateRandomUUID(),
      avatar: 'https://picx.zhimg.com/027729d02bdf060e24973c3726fea9da_l.jpg?source=06d4cd63',
      author: 'smallMiSu7',
      content,
      time: `${(new Date().getMonth() + 1).toString().padStart(2, '')}-${(new Date().getDate()
        .toString()
        .padStart(2, '0'))}`,
      area: common.getRandomCity(),
      likeNum: Math.floor(Math.random() * 9999999 + 1),
      likeFlag: false
    })
    //写到ui
    this.commentList.unshift(msg)
    //写入首选项
    tiktokChatStory.addOneTiktokVideoComment(this.item.video.play_addr.uri, msg)
  }

  @Builder
  endMegItem(item: commentDataModel, index: number) {
    Row() {
      Text('删除')
        .width('100%').textAlign(TextAlign.Center)
    }.backgroundColor(Color.Red)
    .width('100')
    .height('100%')
    .onClick(() => {
      this.commentList.splice(index, 1)
      tiktokChatStory.delOneTiktokVideoComment(this.item.video.play_addr.uri, item.id as number)
    })
  }

  /**
   * 评论弹窗*/
  @Builder
  Dialog() {
    Column() {
      Row() {
        Text(`${this.commentList.length}条评论`)
          .fontColor(Color.Black)
          .fontSize(16)
      }.margin({
        top: 50
      })

      List({ space: 20 }) {
        ForEach(this.commentList, (item: commentDataModel, index: number) => {
          ListItem() {
            Comment({ item: item, videoItem: this.item })
          }
          .swipeAction({
            end: this.endMegItem(item, index)
          })
        })
      }.layoutWeight(1)
      .scrollBar(BarState.Off)

      //评论组件
      ReplyInput({
        publishComment: (content: string) => {
          this.addComment(content)
        },
        iptContent: '善语结善缘,恶言伤人心',
      }).border({
        width: {
          top: .5
        },
        color: Color.Gray
      })
    }.onAreaChange((_oldValue, newValue) => {
      this.dialogHeight = newValue.height as number
    })
  }

  aboutToAppear(): void {
    //获取评论数据
    this.commentList = tiktokChatStory.getOneTiktokVideoAllComment(this.item.video.play_addr.uri)
  }

  build() {
    //主内容
    Column() {
      ForEach(this.sideDataList, (item: sideData) => {
        sideIcon({ item: item })
      })
    }.height('100%')
    .zIndex(2)
    .bindSheet($$this.showCommentDialog, this.Dialog, {
      height: '65%',
      backgroundColor: '#ffefecec',
      keyboardAvoidMode: SheetKeyboardAvoidMode.RESIZE_ONLY,
      shouldDismiss: () => {
        this.showCommentDialog = false
        this.isShowRightSideBar = true
        this.showDialog = false
        this.scaleSize = 1
      }
    })
    .position({ x: '82.5%', y: '50%' })
  }
}

export { Sidebar }

@Component
struct sideIcon {
  @ObjectLink
  item: sideDataModel
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
      LikeTextCount({ count: this.item.Num, isWhite: true })
    }
  }
}
