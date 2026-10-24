import { commentDataModel } from '../../models'
import { Comment, Input } from '../../components'
import { common, Constants, GlobalState, globalState } from '../../common'
import { util } from '@kit.ArkTS'
import { display } from '@kit.ArkUI'
import { tiktokChatStory } from '../../utils'

/**
 * 评论弹层 动态路由表入口 见resources/base/profile/router_map.json
 * 抖音式半屏: 没有蒙罩 DIALOG模式下层视频页保持可见可交互 视频由VideoComp按弹层高度顶起压缩*/
@Builder
export function CommentDialogBuilder() {
  CommentDialog()
}

@ComponentV2
struct CommentDialog {
  @Local gs: GlobalState = globalState()
  /**
   * 弹层高度vp 由Index提供 视频页消费后据此顶起画面并收起顶栏与侧栏*/
  @Consumer('commentDialogHeight')
  commentDialogHeight: number = 0
  /**
   * 弹层是否正被拖动 拖动时视频页不做补间 画面才能跟手*/
  @Consumer('commentDialogDragging')
  commentDialogDragging: boolean = false
  /**
   * 弹层完全展开时的高度vp 拖动时以它为基准递减*/
  panelHeight: number = 0
  /**
   * 评论所属视频的uri 评论仓库都以它为键*/
  @Local videoUri: string = ''
  @Local commentList: commentDataModel[] = []
  @Local content: string = ''
  /**
   * 弹层占屏高比例*/
  panelPercent: number = 65
  /**
   * 下拉关闭的位移 只累计向下的距离*/
  @Local dragOffset: number = 0
  /**
   * 松手时的关闭阈值vp*/
  closeDrag: number = 80
  /**
   * 已开始收起 防止连点重复出栈把下层页面也弹掉*/
  private closing: boolean = false
  scroller: Scroller = new Scroller()

  aboutToAppear(): void {
    //先算好目标高度 视频顶起和弹层滑入同一帧起步 动画才对得上
    const screenHeight = this.getUIContext().px2vp(display.getDefaultDisplaySync().height)
    this.panelHeight = screenHeight * this.panelPercent / 100
    this.commentDialogHeight = this.panelHeight
  }

  open(uri: string): void {
    this.videoUri = uri
    this.commentList = tiktokChatStory.getOneTiktokVideoAllComment(uri)
  }

  close(): void {
    if (this.closing) {
      return
    }
    this.closing = true
    //高度先归零 视频和弹层同一帧开始收回 不能等页面销毁后才复原
    this.commentDialogDragging = false
    this.commentDialogHeight = 0
    common.back()
  }

  addComment(content: string) {
    const now = new Date()
    const msg = new commentDataModel({
      id: util.generateRandomUUID(),
      avatar: common.avatar('', 'smallMiSu7'),
      author: 'smallMiSu7',
      content,
      time: `${common.toStr(now.getMonth() + 1)}-${common.toStr(now.getDate())}`,
      area: common.getRandomCity(),
      likeNum: common.getRandom(99999 + 1),
      likeFlag: false
    })
    this.commentList.unshift(msg)
    tiktokChatStory.addOneTiktokVideoComment(this.videoUri, msg)
  }

  /**
   * 删除一条评论 气泡里的删除按钮触发*/
  delComment(item: commentDataModel) {
    const index = this.commentList.findIndex((comment: commentDataModel) => comment.id === item.id)
    if (index === -1) {
      return
    }
    this.commentList.splice(index, 1)
    tiktokChatStory.delOneTiktokVideoComment(this.videoUri, item.id)
  }

  /**
   * 发送输入框里的内容 空内容与纯空格不发送*/
  sendCurrent() {
    const text = this.content.trim()
    if (!text) {
      return
    }
    this.content = ''
    this.addComment(text)
  }

  /**
   * 拖动弹层 列表没滚到顶部时先让列表自己滚
   * 弹层下移多少 视频就跟着放开多少 跟手不做补间*/
  dragSheet(e: GestureEvent) {
    if (this.scroller.currentOffset().yOffset > 0) {
      return
    }
    this.dragOffset = Math.min(Math.max(e.offsetY, 0), this.panelHeight)
    this.commentDialogHeight = this.panelHeight - this.dragOffset
  }

  /**
   * 松手 超过阈值就关 否则弹回原位*/
  endDrag() {
    this.commentDialogDragging = false
    if (this.dragOffset > this.closeDrag) {
      this.close()
      return
    }
    this.getUIContext().animateTo({ duration: Constants.COMMENT_DIALOG_ANIM_DURATION, curve: Curve.EaseOut }, () => {
      this.dragOffset = 0
      this.commentDialogHeight = this.panelHeight
    })
  }
  /**
   * 评论列表项 长按删除与点赞都按视频uri回写仓库*/
  @Builder
  RowItem(item: commentDataModel) {
    ListItem() {
      Comment({
        item: item,
        videoUri: this.videoUri,
        deleteComment: (comment: commentDataModel) => {
          this.delComment(comment)
        }
      })
    }
  }

  /**
   * 弹层主体 标题+关闭+评论列表+输入栏*/
  @Builder
  Sheet() {
    Column() {
      Row() {
        Text(`${this.commentList.length}条评论`)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .fontColor(Color.Black)
          .fontSize(16)
        Button('×')
          .type(ButtonType.Normal)
          .width(44)
          .height(44)
          .fontColor(Constants.COLOR_GREY)
          .fontSize(22)
          .backgroundColor(Color.Transparent)
          .onClick(() => {
            this.close()
          })
      }
      .width('100%')
      .height(50)
      .padding({ left: 44 })

      List({ space: 20, scroller: this.scroller }) {
        ForEach(this.commentList, (item: commentDataModel) => {
          this.RowItem(item)
        }, (item: commentDataModel) => `${item.id}`)
      }.layoutWeight(1)
      .scrollBar(BarState.Off)

      Row({ space: 5 }) {
        Input({
          content: this.content!!,
          iptContent: '善语结善缘,恶言伤人心',
          publishComment: (content: string) => {
            this.addComment(content)
          }
        }).layoutWeight(1)
        Button('发送')
          .type(ButtonType.Normal)
          .backgroundColor(Color.Transparent)
          .height(40)
          .fontColor(this.content ? '#fffd2217' : Color.Gray)
          .margin({ right: 10 })
          .animation({ duration: 200 })
          .enabled(this.content ? true : false)
          .onClick(() => {
            this.sendCurrent()
          })
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .border({ width: { top: .5 }, color: Color.Gray })
    }
    .width('100%')
    .height(`${this.panelPercent}%`)
    .backgroundColor(Color.White)
    .borderRadius({ topLeft: 20, topRight: 20 })
    .padding({ bottom: this.gs.bottomHeight })
    .translate({ y: this.dragOffset })
    .parallelGesture(PanGesture({ direction: PanDirection.Vertical })
      .onActionStart(() => {
        this.commentDialogDragging = true
      })
      .onActionUpdate((e: GestureEvent) => {
        this.dragSheet(e)
      })
      .onActionEnd(() => {
        this.endDrag()
      })
      .onActionCancel(() => {
        this.endDrag()
      }))
    .transition(TransitionEffect.asymmetric(
      TransitionEffect.move(TransitionEdge.BOTTOM).animation({ duration: Constants.COMMENT_DIALOG_ANIM_DURATION, curve: Curve.FastOutSlowIn }),
      TransitionEffect.move(TransitionEdge.BOTTOM).animation({ duration: Constants.COMMENT_DIALOG_ANIM_DURATION, curve: Curve.EaseIn })))
  }

  aboutToDisappear(): void {
    //弹层已收起 视频恢复全屏 顶栏与侧栏自动回来
    this.commentDialogHeight = 0
  }

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.Bottom }) {
        //点弹层上方任意位置收起 与抖音一致
        Column()
          .width('100%')
          .height('100%')
          .onClick(() => {
            this.close()
          })
        this.Sheet()
      }
      .width('100%')
      .height('100%')
    }
    .hideTitleBar(true)
    .mode(NavDestinationMode.DIALOG)
    /**
     * 动态路由的参数只能在NavDestination挂载后从pathInfo里取*/
    .onReady((context: NavDestinationContext) => {
      const uri = context.pathInfo.param as string | undefined
      if (uri) {
        this.open(uri)
      }
    })
  }
}
