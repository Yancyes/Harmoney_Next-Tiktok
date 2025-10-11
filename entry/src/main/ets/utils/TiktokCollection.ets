import { preferences } from '@kit.ArkData'
import { Constants } from '../common/Constants'
import { tipDialog } from '../common/Function/commonFn'
import { mediaType } from '../models'

export class TiktokCollection {
  private static storeName = 'TiktokCollection-Store'
  static Context: Context

  private static getStore() {
    return preferences.getPreferencesSync(TiktokCollection.Context, {
      name: TiktokCollection.storeName
    })
  }

  static getCollectionData() {
    const store = TiktokCollection.getStore()
    return JSON.parse(store.getSync(Constants.GLOBAL_VIDEO_COLLECTION, '[]') as string) as mediaType[]
  }

  /**
   * 添加收藏
   * @param item 视频
   */
  static async addCollection(item: mediaType) {
    const store = TiktokCollection.getStore()
    const list = TiktokCollection.getCollectionData()
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
    list.splice(list.findIndex(obj => obj === item), 1)
    store.putSync(Constants.GLOBAL_VIDEO_COLLECTION, JSON.stringify(list))
    await store.flush()
    tipDialog('已取消收藏', 1500, Alignment.Center)
  }

  /**
   * 检测是否收藏
   * @param item 视频
   * @return boolean
   */
  static hasCollection(item: mediaType) {
    const list = TiktokCollection.getCollectionData()
    return list.includes(item) ? true : false
  }
}