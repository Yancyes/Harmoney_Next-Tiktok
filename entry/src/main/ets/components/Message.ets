import { ImgComp } from '.'
import { common, GlobalState, globalState } from '../common'
import { MessageInfoModel } from '../models/message'

/**
 * 消息组件*/
@ComponentV2
export default struct Message {
  @Local gs: GlobalState = globalState() //当前登录用户
  @Require
  @Param
  currentMessage: MessageInfoModel
  /**
   * 是否显示时间分隔 由父级按消息间隔算出*/
  @Param
  showTime: boolean = false
  /**
   * 删除本条消息 列表与首选项都由父组件维护*/
  @Event
  deleteMessage: (item: MessageInfoModel) => void = () => {
  }
  /**
   * 长按弹出的删除气泡显隐*/
  @Local
  showDeleteTip: boolean = false
  /**
   * isOwnMessage是判断当前的登录用户id是否等于消息发送者的用户id设置元素的出现位置
   * 用@Computed 登录用户或发送者变化时才会重新取值并驱动刷新*/
  @Computed
  get isOwnMessage(): boolean {
    return this.gs.currentUser.user_id === this.currentMessage?.sendUser?.user_id
  }

  /**
   * 气泡内容 由返回值给对象字面量提供上下文类型*/
  deleteTip(): PopupOptions {
    return {
      message: '删除该消息',
      placement: Placement.Top,
      targetSpace: 12,
      enableArrow: true,
      mask: false,
      primaryButton: {
        value: '删除',
        action: () => {
          this.showDeleteTip = false
          this.deleteMessage(this.currentMessage)
        }
      },
      secondaryButton: {
        value: '取消',
        action: () => {
          this.showDeleteTip = false
        }
      }
    }
  }

  @Builder
  Avatar() {
    ImgComp({
      imgWidth: 38,
      imgHeight: 38,
      bordRadius: 19,
      //消息的发送者的头像 空头像用网络头像
      imgSrc: common.avatar(this.currentMessage.sendUser?.avatar, this.currentMessage.sendUser?.user_id),
      fallbackSrc: common.avatar('', this.currentMessage.sendUser?.user_id)
    })
  }

  @Builder
  Bubble() {
    Text(this.currentMessage.messageContent)//消息的内容
      .fontSize(16)
      .fontColor(this.isOwnMessage ? Color.White : '#ff171717')
      .backgroundColor(this.isOwnMessage ? '#fffe2c55' : Color.White)
      .padding({ left: 14, right: 14, top: 9, bottom: 9 })
      .borderRadius(14)
      .constraintSize({ maxWidth: '70%' })
      .textAlign(TextAlign.Start)
      .gesture(LongPressGesture().onAction(() => {
        this.showDeleteTip = true
      }))
      .bindPopup(this.showDeleteTip!!, this.deleteTip())
  }

  build() {
    Column() {
      if (this.showTime) {
        Text(common.formatMsgTime(this.currentMessage.sendTime))
          .fontSize(12)
          .fontColor('#ff9aa0a6')
          .width('100%')
          .textAlign(TextAlign.Center)
          .margin({ bottom: 4 })
      }
      //左右位置由显式的if决定 不用direction(Rtl)翻转整行 那样连头像圆角都会被镜像
      Row({ space: 10 }) {
        if (!this.isOwnMessage) {
          this.Avatar()
        }
        this.Bubble()
        if (this.isOwnMessage) {
          this.Avatar()
        }
      }
      .width('100%')
      .padding({ left: 16, right: 16 })
      .justifyContent(this.isOwnMessage ? FlexAlign.End : FlexAlign.Start)
      .alignItems(VerticalAlign.Top)
    }
  }
}
