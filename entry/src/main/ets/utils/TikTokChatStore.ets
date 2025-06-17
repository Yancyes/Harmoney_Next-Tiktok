import { preferences } from '@kit.ArkData'
import { commentDataModel } from '../models'

class TiktokChatStory {
  context?: Context
  /**
   * 抖音的视频评论聊天仓库前缀名*/
  private TikTokCommentChatInfo = "TikTok_Chat_infoStore"

  constructor(ctx?: Context) {
    this.context = ctx
  }

  //单个视频单个仓库 存储信息 获取仓库 每个视频的仓库名不同
  /**
   * 获取抖音视频仓库 单个仓库
   * @param {String} videoId 视频的id */
  getVideoStore(videoId: string) {
    return preferences.getPreferencesSync(this.context || getContext(), {
      name: `${this.TikTokCommentChatInfo}_${videoId}`  //仓库名
    })
  }

  /**
   * 给单个视频写入评论
   * @param {String} videoId 视频的id
   * @param {MessageInfo} message 评论的信息
   * */
  async addOneTiktokVideoComment(videoId: string, message: commentDataModel) {
    const store = this.getVideoStore(videoId)
    const list = this.getOneTiktokVideoAllComment(videoId)
    list.unshift(message)
    store.putSync(videoId, JSON.stringify(list))
    await store.flush()
  }

  /**
   * 删除一条视频的一条评论
   * @param videoId 视频id
   * @param messageId 评论的id
   * */
  async delOneTiktokVideoComment(videoId: string, messageId: number) {
    const store = this.getVideoStore(videoId)
    const list = this.getOneTiktokVideoAllComment(videoId)
    const index = list.findIndex(item => item.id === messageId)
    list.splice(index, 1)
    store.putSync(videoId, JSON.stringify(list))
    await store.flush()
  }

  /**
   * 获取一条视频的所有评论数据
   * @param {String} videoId 视频的id */
  getOneTiktokVideoAllComment(videoId: string) {
    const store = this.getVideoStore(videoId)
    return JSON.parse(store.getSync(videoId, '[]') as string) as commentDataModel[]
  }

  /**
   * 单条评论状态修改*/
  async changeOneTiktokVideoCommentLike(videoId: string, messageId: number, likeCount: number,likeFlag: boolean) {
    const store = this.getVideoStore(videoId)
    const list = this.getOneTiktokVideoAllComment(videoId)
    const index = list.findIndex(item => item.id === messageId)
    list[index].likeNum = likeCount
    list[index].likeFlag = likeFlag
    await store.put(videoId, JSON.stringify(list))
    await store.flush()
  }
}

export const tiktokChatStory = new TiktokChatStory()