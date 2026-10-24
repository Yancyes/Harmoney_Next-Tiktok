/**
 * 评论接口
 * 字段全部可选 首选项里可能是旧版本写入的数据 读出来会缺字段*/
export interface commentData {
  avatar?: ResourceStr //头像
  id?: string | number //评论的id
  content?: string //评论内容
  time?: string //发表时间
  author?: string //作者
  area?: string //地区
  likeNum?: number //点赞数
  likeFlag?: boolean //当前用户是否点过赞
}

@ObservedV2
export class commentDataModel implements commentData {
  @Trace avatar: ResourceStr = ''
  @Trace id: string | number = ''
  @Trace content: string = ''
  @Trace time: string = ''
  @Trace author: string = ''
  @Trace area: string = ''
  @Trace likeNum: number = 0
  @Trace likeFlag: boolean = false

  constructor(model: commentData) {
    //逐字段兜底 缺字段时@Trace上会是undefined 组件里读数值直接崩
    this.avatar = model.avatar ?? ''
    this.id = model.id ?? ''
    this.content = model.content ?? ''
    this.time = model.time ?? ''
    this.author = model.author ?? ''
    this.area = model.area ?? ''
    this.likeNum = model.likeNum ?? 0
    this.likeFlag = model.likeFlag ?? false
  }

  toPlain(): commentData {
    return {
      avatar: this.avatar,
      id: this.id,
      content: this.content,
      time: this.time,
      author: this.author,
      area: this.area,
      likeNum: this.likeNum,
      likeFlag: this.likeFlag
    }
  }
}