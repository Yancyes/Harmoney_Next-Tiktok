import { UserInfo, UserInfoModel, userToPlain } from '.'
import { util } from '@kit.ArkTS'
/**
 * 消息类型枚举*/
export enum  MessageTypeEnum {
  TEXT, // 文本
  IMAGE, // 图片
  AUDIO, // 音频
  VIDEO, // 视频
  LOCATION, // 定位
  LINK // 链接
}
/**
 * 消息信息接口*/
export interface MessageInfo {
  id: string // 标识
  sendUser: UserInfo //这条消息的发送者
  connectUser: UserInfo // 这条消息的归属者
  /**
   * @params
   * 发送消息的内容 接受的值不能是同一个变量*/
  messageContent: string // 消息内容  文本消息  [图片] [语音‘7]
  sendTime: number // 发送时间
  // 消息类型
  messageType: MessageTypeEnum // 消息类型
  sourceFilePath: string // 音频地址 图片地址 视频地址
  sourceDuration: number // 音频或者视频的长度 单位s
}

@ObservedV2
export class MessageInfoModel implements MessageInfo {
  @Trace id: string = ''
  @Trace sendUser: UserInfo = new UserInfoModel({} as UserInfo)
  @Trace connectUser: UserInfo = new UserInfoModel({} as UserInfo)
  @Trace messageContent: string = ''
  @Trace sendTime: number = 0
  @Trace messageType: MessageTypeEnum = MessageTypeEnum.TEXT
  @Trace sourceFilePath: string = ''
  @Trace sourceDuration: number = 0

  constructor(model: MessageInfo) {
    this.id = model.id || util.generateRandomUUID() // 生成uuid
    this.sendUser = model.sendUser
    this.connectUser = model.connectUser
    this.messageContent = model.messageContent
    this.sendTime = model.sendTime || Date.now() // 发送时间
    this.messageType = model.messageType || MessageTypeEnum.TEXT
    this.sourceFilePath = model.sourceFilePath
    this.sourceDuration = model.sourceDuration
  }

  toPlain(): MessageInfo {
    return {
      id: this.id,
      sendUser: this.toPlainUser(this.sendUser),
      connectUser: this.toPlainUser(this.connectUser),
      messageContent: this.messageContent,
      sendTime: this.sendTime,
      messageType: this.messageType,
      sourceFilePath: this.sourceFilePath,
      sourceDuration: this.sourceDuration
    }
  }

  private toPlainUser(user: UserInfo): UserInfo {
    return user instanceof UserInfoModel ? userToPlain(user as UserInfoModel) : user
  }
}