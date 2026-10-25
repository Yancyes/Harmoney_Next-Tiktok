import { common, globalState, GlobalState, tipDialog } from '../../common'
import { ImgComp } from '../../components'
import Message from '../../components/Message'
import { ChatData, UserInfo, UserInfoModel } from '../../models'
import { MessageInfo, MessageInfoModel } from '../../models/message'
import { request } from '../../utils/request'
import { tiktok } from '../../utils/setting'

/**
 * 相邻消息间隔超过5分钟才再次显示时间 与私信习惯一致*/
const TIME_GAP = 5 * 60 * 1000

/**
 * 聊天详情页 动态路由表入口 见resources/base/profile/router_map.json*/
@Builder
export function ChatDetailBuilder() {
  ChatDetail()
}

@ComponentV2
export struct ChatDetail {
  @Local
  talkUser: UserInfoModel = new UserInfoModel({} as UserInfo) //聊天对象的消息
  @Local
  messList: MessageInfoModel[] = [] //消息列表
  /**
   * 控制顶部消息提示文本的显示隐藏*/
  @Local
  textInputIng: boolean = false
  @Local
  content: string = ''
  scroller: Scroller = new Scroller()
  @Local gs: GlobalState = globalState()

  /**
   * 是否需要显示时间分隔 首条和与上一条间隔超过5分钟的显示*/
  isTimeBreak(index: number): boolean {
    if (index === 0) {
      return true
    }
    return this.messList[index].sendTime - this.messList[index - 1].sendTime > TIME_GAP
  }

  /**
   * 动态路由的参数只能在NavDestination挂载后从pathInfo里取*/
  open(contact: UserInfo) {
    this.talkUser = new UserInfoModel(contact)
    this.getAllRecord()
  }

  /**
   * 获取所有聊天记录*/
  getAllRecord() {
    this.messList = tiktok.getChatMessage(this.talkUser.user_id)
    this.scroller.scrollEdge(Edge.Bottom)
  }

  /**
   * 删除一条聊天记录 气泡里的删除按钮触发*/
  delMessage(item: MessageInfoModel) {
    const index = this.messList.findIndex((message: MessageInfoModel) => message.id === item.id)
    if (index === -1) {
      return
    }
    this.messList.splice(index, 1)
    tiktok.delChatMessage(this.talkUser.user_id, item.id)
  }

  /**
   * 发送输入框里的内容 空内容与纯空格不发送*/
  sendCurrent() {
    const text = this.content.trim()
    if (!text) {
      return
    }
    //先清空再发 发送是异步的 等回调会卡住输入框
    this.content = ''
    this.sendTextMessage(text)
  }

  async sendTextMessage(content: string) {
    /**
     * 这里的mess是我发的信息，里面的发送用户是当前登录的用户*/
    let mess = new MessageInfoModel({
      messageContent: content, //消息内容
      sendUser: this.gs.currentUser, //我发的消息
      connectUser: this.talkUser, //联系人发的消息
    } as MessageInfo)
    this.messList.push(mess)
    //落库必须等写完再发下一条 否则两次读到的旧列表会互相覆盖
    await tiktok.addOwnChatMessage(this.talkUser.user_id, mess)
    this.getResponseMessage(content)
    this.scroller.scrollEdge(Edge.Bottom)
  }

  async getResponseMessage(content: string) {
    this.textInputIng = true
    try {
      const result = await request<ChatData>({
        url: `bot?userid=${Date.now()}&spoken=${encodeURIComponent(content)}`,
        //接口实测要2~3秒 实例默认的5秒在手机上很容易超时 这里单独放宽
        timeout: 20000
      })
      const text = result.info.text
      if (!text) return
      /**
       * 这里的mess是机器人回复的信息，里面的发送用户是聊天的对象回复的*/
      const mess = new MessageInfoModel({
        messageContent: text, //接口返回结果的消息内容
        sendUser: this.talkUser, //回复的消息
        connectUser: this.talkUser, //联系人发的消息
      } as MessageInfo)
      this.messList.push(mess)
      await tiktok.addOwnChatMessage(this.talkUser.user_id, mess)
    } catch (e) {
      tipDialog('消息发送失败，请检查网络', 2000, Alignment.Top)
    } finally {
      //请求失败时也必须归位 否则顶部一直显示正在输入
      this.textInputIng = false
      this.scroller.scrollEdge(Edge.Bottom)
    }
  }

  /**
   * 顶部：返回 + 对方头像 + 昵称/输入状态*/
  @Builder
  Header() {
    Row({ space: 10 }) {
      SymbolGlyph($r('sys.symbol.chevron_left'))
        .fontSize(26)
        .fontColor(['#ff171717'])
        .onClick(() => {
          this.gs.showDialog = false
          common.back()
        })
      ImgComp({
        imgWidth: 40,
        imgHeight: 40,
        bordWidth: 1,
        bordColor: '#ffefefef',
        bordRadius: 20,
        imgSrc: common.avatar(this.talkUser.avatar, this.talkUser.user_id),
        fallbackSrc: common.avatar('', this.talkUser.user_id)
      })
      Column() {
        //昵称为空时按id从英文名池随机取 与头像同源
        Text(common.nickName(this.talkUser.username, this.talkUser.user_id))
          .fontSize(17)
          .fontWeight(600)
          .fontColor('#ff171717')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        //副标题固定占位 状态切换时顶栏不跳动
        Text(this.textInputIng ? '对方正在输入' : '')
          .fontSize(12)
          .fontColor('#ff9aa0a6')
          .height(16)
      }.alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
    }
    .width('100%')
    .height(56)
    .padding({ left: 12, right: 12 })
  }

  /**
   * 底部输入栏*/
  @Builder
  InputBar() {
    Row({ space: 10 }) {
      TextInput({ placeholder: '发送消息', text: this.content!! })
        .layoutWeight(1)
        .height(40)
        .borderRadius(20)
        .backgroundColor(Color.White)
        .placeholderColor('#ff9aa0a6')
        .enterKeyType(EnterKeyType.Send)
        .onSubmit(() => {
          this.sendCurrent()
        })
      Button('发送')
        .type(ButtonType.Normal)
        .height(40)
        .borderRadius(20)
        .fontSize(15)
        .fontColor(Color.White)
        .padding({ left: 16, right: 16 })
        //空内容时置灰且不可点 不再靠if让按钮忽隐忽现
        .backgroundColor(this.content ? '#fffe2c55' : '#ffbdbdbd')
        .enabled(this.content.trim().length > 0)
        .onClick(() => {
          this.sendCurrent()
        })
    }
    .width('100%')
    .padding({ left: 12, right: 12, top: 8, bottom: 8 })
    .border({ width: { top: .5 }, color: '#ffe3e3e3' })
  }

  build() {
    NavDestination() {
      Column() {
        this.Header()
        Divider()
          .strokeWidth(.5)
          .color('#ffededed')
        List({ space: 14, scroller: this.scroller }) {
          ForEach(this.messList, (item: MessageInfoModel, index: number) => {
            ListItem() {
              Message({
                currentMessage: item,
                showTime: this.isTimeBreak(index),
                deleteMessage: (message: MessageInfoModel) => {
                  this.delMessage(message)
                }
              })
            }
          }, (item: MessageInfoModel) => item.id)
        }
        .layoutWeight(1)
        .padding({ top: 12, bottom: 12 })
        .scrollBar(BarState.Off)
        .width('100%')

        this.InputBar()
      }
      .width('100%')
      .height('100%')
      //用真实安全区高度替代原先的10%边距hack 顶栏不被状态栏压住 输入栏不被导航条遮住
      .padding({ top: this.gs.areaHeight, bottom: this.gs.bottomHeight })
      .backgroundColor('#fff5f5f5')
    }
    .hideTitleBar(true)
    .onReady((context: NavDestinationContext) => {
      const contact = context.pathInfo.param as UserInfo | undefined
      if (contact) {
        this.open(contact)
      }
    })
  }
}
