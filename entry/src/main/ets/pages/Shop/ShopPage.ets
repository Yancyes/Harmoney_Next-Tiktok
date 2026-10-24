import { tipDialog } from '../../common/Function/commonFn'
import { DataSource, shopData, shopType } from '../../models'
import { waterFlowList } from '../../components'

/**
 * 商品页*/
@Entry
@Component
struct ShopPage {
  /**
   * 懒加载商品数据*/
  private shopDataInfo: DataSource<shopType> = new DataSource(shopData)
  /**
   * 下拉刷新状态*/
  @State isRefreshing: boolean = false
  /**
   * 商品搜索名*/
  @State
  @Watch('filterShop')
  private searchName: string = ''
  /**
   * 商品信息*/
  @State private shopInfo: shopType[] = []
  /**
   * 懒加载筛选后的商品信息*/
  @State private filterInfo: DataSource<shopType> | null = null

  //加载更多数据
  loadMore() {
    return new Promise<boolean>((resolve) => {
      setTimeout(() => {
        this.shopDataInfo.pushArrayData(shopData, false, 0, 6)
        resolve(true)
      }, 500)
    })
  }

  @Builder
  getFooter() {
    Row({ space: 4 }) {
      Text('数据加载')
      LoadingProgress()
        .width(24).height(24)
    }.width('100%')
    .height(60).justifyContent(FlexAlign.Center).margin({ bottom: 40 })
  }

  filterShop() {
    if (this.searchName) {
      this.shopInfo = shopData.filter(item => item.name.includes(this.searchName))
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
    Refresh({ refreshing: $$this.isRefreshing, builder: this.DownBuilder() }) {
      Column() {
        Search({ placeholder: '寻找你感兴趣的商品吧', value: $$this.searchName })
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

export default ShopPage
