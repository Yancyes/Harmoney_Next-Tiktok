import { preferences } from '@kit.ArkData'
import { commentData, commentDataModel } from '../models'
import { AppEnv } from '../common/AppEnv'

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
    const ctx = this.context || AppEnv.context!
    return preferences.getPreferencesSync(ctx, {
      name: `${this.TikTokCommentChatInfo}_${videoId}`  //仓库名
    })
  }

  private serialize(list: commentDataModel[]): string {
    return JSON.stringify(list.map((item: commentDataModel) => item.toPlain()))
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
    store.putSync(videoId, this.serialize(list))
    await store.flush()
  }

  /**
   * 删除一条视频的一条评论
   * @param videoId 视频id
   * @param messageId 评论的id
   * */
  async delOneTiktokVideoComment(videoId: string, messageId: string | number) {
    const store = this.getVideoStore(videoId)
    const list = this.getOneTiktokVideoAllComment(videoId)
    const index = list.findIndex(item => item.id === messageId)
    //id为UUID字符串 找不到时不能splice(-1) 否则会误删末项
    if (index === -1) {
      return
    }
    list.splice(index, 1)
    store.putSync(videoId, this.serialize(list))
    await store.flush()
  }

  /**
   * 获取一条视频的所有评论数据
   * @param {String} videoId 视频的id */
  getOneTiktokVideoAllComment(videoId: string): commentDataModel[] {
    const store = this.getVideoStore(videoId)
    const raw = JSON.parse(store.getSync(videoId, '[]') as string) as commentData[]
    const list = Array.isArray(raw) ? raw : []
    return list.filter(item => item && item.content).map(item => new commentDataModel(item))
  }

  /**
   * 单条评论状态修改*/
  async changeOneTiktokVideoCommentLike(videoId: string, messageId: string | number, likeCount: number,likeFlag: boolean) {
    const store = this.getVideoStore(videoId)
    const list = this.getOneTiktokVideoAllComment(videoId)
    const index = list.findIndex(item => item.id === messageId)
    //找不到时直接返回 避免list[-1]抛异常
    if (index === -1) {
      return
    }
    list[index].likeNum = likeCount
    list[index].likeFlag = likeFlag
    await store.put(videoId, this.serialize(list))
    await store.flush()
  }
}

export const tiktokChatStory = new TiktokChatStory()