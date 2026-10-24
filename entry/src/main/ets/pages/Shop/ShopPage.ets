import { tipDialog } from '../../common/Function/commonFn'
import { DataSource, shopData, shopType } from '../../models'
import { waterFlowList } from '../../components'

/**
 * 商品页 动态路由表入口 见resources/base/profile/router_map.json
 * ShopPage本身还要作为顶栏的一页复用 所以NavDestination只包在路由入口里*/
@Builder
export function ShopPageBuilder() {
  NavDestination() {
    ShopPage()
  }.hideTitleBar(true)
}

@ComponentV2
export struct ShopPage {
  /**
   * 懒加载商品数据*/
  private shopDataInfo: DataSource<shopType> = new DataSource(shopData)
  /**
   * 下拉刷新状态*/
  @Local
  isRefreshing: boolean = false
  /**
   * 商品搜索名*/
  @Local
  private searchName: string = ''
  /**
   * 商品信息*/
  @Local private shopInfo: shopType[] = []
  /**
   * 懒加载筛选后的商品信息*/
  @Local private filterInfo: DataSource<shopType> | null = null

  //加载更多数据
  loadMore() {
    return new Promise<boolean>((resolve) => {
      setTimeout(() => {
        this.shopDataInfo.pushArrayData(shopData, false, 0, 6)
        resolve(true)
      }, 500)
    })
  }

  @Monitor('searchName')
  filterShop(): void {
    if (this.searchName) {
      this.shopInfo = shopData.filter((item: shopType) => item.name.includes(this.searchName))
      this.filterInfo = new DataSource(this.shopInfo)
    }
  }

  @Builder
  DownBuilder() {
    Row() {
      Text('下拉刷新')
        .fontSize(24)
      LoadingProgress()
        .height(30)
    }
  }

  build() {
    Refresh({ refreshing: this.isRefreshing!!, builder: this.DownBuilder() }) {
      Column() {
        Search({ placeholder: '寻找你感兴趣的商品吧', value: this.searchName!! })
          .width('90%')
          .height(40)
          .border({
            color: Color.Red,
            width: 2,
            radius: 10
          })
          .margin({ top: -10 })
        if (this.searchName) {
          //筛选后的商品列表数据
          waterFlowList({
            flag: true,
            item: this.filterInfo
          })
        } else {
          //渲染商品列表数据
          waterFlowList({
            flag: false,
            item: this.shopDataInfo,
            onReach: async () => {
              await this.loadMore()
            }
          })
        }
      }
      .margin({ top: 100 })
    }.width('100%')
    .height('100%').backgroundColor('#ffe2e2e2')
    .onRefreshing(() => {
      setTimeout(() => {
        this.isRefreshing = false
        tipDialog('刷新完成,该页面都是重复数据', 1500, Alignment.Top)
      }, 500)
    })
  }
}
