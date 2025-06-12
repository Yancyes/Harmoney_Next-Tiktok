import { router } from '@kit.ArkUI'
import { Constants } from '../../common'
import { ChatReplyInput } from '../../components'
import Message from '../../components/Message'
import { CURRENT_USER } from '../../constants'
import { UserInfo, UserInfoModel } from '../../models'
import { MessageInfo, MessageInfoModel } from '../../models/message'
import { getRequestMessage } from '../../utils/request'
import { Tiktok } from '../../utils/setting'

/**
 * 聊天详情页*/
@Entry
@Component
struct ChatDetail {
  @Provide
  talkUser: UserInfoModel = new UserInfoModel({} as UserInfo) //聊天对象的消息
  @StorageProp(CURRENT_USER)
  currentUser: UserInfoModel = new UserInfoModel({} as UserInfo) //我发的消息
  scroller: Scroller = new Scroller()
  @StorageLink(Constants.SHOW_DIALOG) showDialog: boolean = false

  aboutToAppear(): void {
    this.getTalkUser()
  }

  /**
   * 获取所有聊天记录*/
  getAllRecord() {
    this.messList = new Tiktok(getContext()).getChatMessage(this.talkUser.user_id)
    this.scroller.scrollEdge(Edge.Bottom)
  }

  async getTalkUser() {
    this.talkUser = router.getParams() as UserInfoModel
    this.getAllRecord()
  }

  @State
  messList: MessageInfoModel[] = [] //消息列表
  /**
   * 控制顶部消息提示文本的显示隐藏*/
  @State
  textInputIng: boolean = false

  //发送文本信息
  sendTextMessage(content: string) {
    /**
     * 这里的mess是我发的信息，里面的发送用户是当前登录的用户*/
    let mess = new MessageInfoModel({
      messageContent: content, //消息内容
      sendUser: this.currentUser, //我发的消息
      connectUser: this.talkUser, //联系人发的消息
    } as MessageInfo)
    this.messList.push(mess) //追加消息
    new Tiktok(getContext()).addOwnChatMessage(this.talkUser.user_id, mess)
    //发送消息到服务器 得到响应内容
    this.getResponseMessage(content)
    this.scroller.scrollEdge(Edge.Bottom)
  }

  //获取响应的消息
  async getResponseMessage(content: string) {
    this.textInputIng = true
    const result = await getRequestMessage(content)
    //新建一个消息
    /**
     * 这里的mess是机器人回复的信息，里面的发送用户是聊天的对象回复的*/
    const mess = new MessageInfoModel({
      messageContent: result.data?.info?.text, //接口返回结果的消息内容
      sendUser: this.talkUser, //回复的消息
      connectUser: this.talkUser, //联系人发的消息
    } as MessageInfo)
    this.messList.push(mess)
    new Tiktok(getContext()).addOwnChatMessage(this.talkUser.user_id, mess)
    this.textInputIng = false
    this.scroller.scrollEdge(Edge.Bottom)
  }

  build() {
    Column() {
      //顶部聊天对象信息区
      Row() {
        Stack({ alignContent: Alignment.Start }) {
          Text('<')
            .width(30)
            .height(30)
            .fontSize(30)
            .margin({ left: 10 })
            .onClick(() => {
              this.showDialog = false
              router.back()
            })
            .zIndex(2)
          //顶部的头像和聊天对象用户名信息
          Row({ space: 10 }) {
            Image(this.talkUser.avatar === undefined ? '' : this.talkUser.avatar).width(40).height(40).borderRadius(20)
            Text(this.textInputIng ? '对方正在输入' : this.talkUser.username)
              .fontWeight(400)
              .fontSize(20)
              .fontColor('#000')
          }.margin({ left: 50 })
        }.width('100%')
        .height(50)
      }.padding({
        left: 10,
        right: 10
      })

      Divider()
        .strokeWidth(.5)
        .color('#ff929292')
      List({ space: 20, scroller: this.scroller }) {
        ForEach(this.messList, (item: MessageInfoModel) => {
          ListItem() {
            Message({ currentMessage: item })
          }
        })
      }.layoutWeight(8)
      .padding({ top: 20, bottom: 20 })

      ChatReplyInput({
        iptContent: '发送消息', publishComment: (content: string) => {
          this.sendTextMessage(content)
        }
      })
    }
    .height('100%').justifyContent(FlexAlign.SpaceBetween).margin({ top: '10%' }).padding({ bottom: '10%' })
  }
}