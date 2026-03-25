import { Constants } from '../common/Constants'
import { C, P, tipDialog } from '../common/Function/commonFn'
import { mediaType } from '../models'
import { preferences } from '@kit.ArkData'

export class TiktokCollection {
  private static storeName = 'TiktokCollection-Store'

  private static getStore(): P {
    return preferences.getPreferencesSync(getContext(), {
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
}