/**
 * 评论接口*/
export interface commentData {
  avatar: ResourceStr //头像
  id: string | number //评论的id
  content: string //评论内容
  time: string //发表时间
  author: string //作者
  area: string //地区
  likeNum: number //点赞数
  likeFlag: boolean //当前用户是否点过赞
}

@Observed
export class commentDataModel implements commentData {
  @Track avatar: ResourceStr = ''
  @Track id: string | number = ''
  @Track content: string = ''
  @Track time: string = ''
  @Track author: string = ''
  @Track area: string = ''
  @Track likeNum: number = 0
  @Track likeFlag: boolean = false

  constructor(model: commentData) {
    this.avatar = model.avatar
    this.id = model.id
    this.content = model.content
    this.time = model.time
    this.author = model.author
    this.area = model.area
    this.likeNum = model.likeNum
    this.likeFlag = model.likeFlag
  }
}