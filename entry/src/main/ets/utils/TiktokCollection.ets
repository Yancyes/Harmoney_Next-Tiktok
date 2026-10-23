import { Constants } from '../common/Constants'
import { P, tipDialog } from '../common/Function/commonFn'
import { mediaType } from '../models'
import { preferences } from '@kit.ArkData'

export class TiktokCollection {
  private static storeName = 'TiktokCollection-Store'

  private static getStore(): P {
    return preferences.getPreferencesSync(AppStorage.get<Context>(Constants.GET_CONTEXT)!, {
      name: TiktokCollection.storeName
    })
  }

  static getCollectionData() {
    const store = TiktokCollection.getStore()
    return JSON.parse(store.getSync(Constants.GLOBAL_VIDEO_COLLECTION, '[]') as string) as mediaType[]
  }

  /**
   * 视频是否已收藏
   * @param awemeId 视频id
   */
  static isCollected(awemeId: string): boolean {
    return TiktokCollection.getCollectionData().some(item => item.aweme_id === awemeId)
  }

  /**
   * 添加收藏
   * @param item 视频
   */
  static async addCollection(item: mediaType) {
    const store = TiktokCollection.getStore()
    const list = TiktokCollection.getCollectionData()
    //JSON.parse出的对象引用不相等 需按aweme_id判重
    if (list.some(obj => obj.aweme_id === item.aweme_id)) {
      return
    }
    list.unshift(item)
    store.putSync(Constants.GLOBAL_VIDEO_COLLECTION, JSON.stringify(list))
    await store.flush()
    tipDialog("收藏成功", 1500, Alignment.Center)
  }

  /**
   * 删除收藏
   * @param item 视频
   */
  static async delCollection(item: mediaType) {
    const store = TiktokCollection.getStore()
    const list = TiktokCollection.getCollectionData()
    const index = list.findIndex(obj => obj.aweme_id === item.aweme_id)
    if (index === -1) {
      return
    }
    list.splice(index, 1)
    store.putSync(Constants.GLOBAL_VIDEO_COLLECTION, JSON.stringify(list))
    await store.flush()
    tipDialog('已取消收藏', 1500, Alignment.Center)
  }
}
