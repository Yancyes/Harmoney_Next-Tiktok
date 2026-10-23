import { Constants } from '../common/Constants'
import { P } from '../common/Function/commonFn'
import { mediaType } from '../models'
import { preferences } from '@kit.ArkData'

/**
 * 点赞仓库 持久化已点赞的视频 供"喜欢"列表展示*/
export class TiktokLike {
  private static storeName = 'TiktokLike-Store'

  private static getStore(): P {
    return preferences.getPreferencesSync(AppStorage.get<Context>(Constants.GET_CONTEXT)!, {
      name: TiktokLike.storeName
    })
  }

  /**
   * 获取已点赞的视频列表*/
  static getLikeData(): mediaType[] {
    const raw = JSON.parse(TiktokLike.getStore().getSync(Constants.GLOBAL_VIDEO_LIKE, '[]') as string) as mediaType[]
    //过滤早期版本只存id字符串的遗留数据 避免非法项渲染时取不到字段崩溃
    return raw.filter(item => item && item.aweme_id !== undefined)
  }

  /**
   * 视频是否已点赞
   * @param awemeId 视频id
   */
  static isLiked(awemeId: string): boolean {
    return TiktokLike.getLikeData().some(item => item.aweme_id === awemeId)
  }

  /**
   * 修改视频的点赞状态
   * @param item 视频
   * @param liked 是否点赞
   */
  static async changeLike(item: mediaType, liked: boolean): Promise<void> {
    const store = TiktokLike.getStore()
    const list = TiktokLike.getLikeData()
    if (liked) {
      if (!list.some(obj => obj.aweme_id === item.aweme_id)) {
        list.unshift(item)
      }
    } else {
      const index = list.findIndex(obj => obj.aweme_id === item.aweme_id)
      if (index >= 0) {
        list.splice(index, 1)
      }
    }
    store.putSync(Constants.GLOBAL_VIDEO_LIKE, JSON.stringify(list))
    await store.flush()
  }
}
