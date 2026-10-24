import { shopType } from '../models'
import { DataSource } from '../models/DataSource'
import { shopComp } from './shopComp'

/**
 * 底部footer
 * @param title 标签 */
@ComponentV2
struct Footer {
  @Require
  @Param
  title: string = ''
  @Require
  @Param
  flag: boolean

  build() {
    Row({ space: 4 }) {
      Text(this.title)
      if (!this.flag) {
        LoadingProgress()
          .width(24).height(24)
      }
    }.width('100%')
    .height(60).justifyContent(FlexAlign.Center).margin({ bottom: 40 })
  }
}

/**
 * 瀑布流列表
 * @param flag 是否为筛选后的数据标记 true 是 false 否
 * @param item 懒加载后的数据源
 * @function onReach 触底事件
 */
@ComponentV2
export struct waterFlowList {
  @Event
  onReach: () => void = () => {
  }
  @Require
  @Param
  flag: boolean
  @Require
  @Param
  item: DataSource<object> | null = null
  @BuilderParam
  waterFlowItem: (item: object, index: number) => void = this.flowItem

  @Builder
  flowItem(item: object, index: number) {
    shopComp({ item: item as shopType, index: index })
  }

  @Builder
  getFooter(flag: boolean) {
    if (flag) {
      Footer({ title: '加载完了', flag })
    } else {
      Footer({ title: '数据加载中', flag })
    }

  }

  build() {
    WaterFlow({ footer: this.getFooter(this.flag) }) {
      LazyForEach(this.item,
        (item: object, index: number) => {
          FlowItem() {
            if (this.waterFlowItem) {
              this.waterFlowItem(item, index)
            }
          }
          .backgroundColor(Color.White)
          .border({
            radius: 15
          })
        })
    }
    .backgroundColor('#ffe2e2e2')
    .columnsTemplate('1fr 1fr')
    .rowsGap(10)
    .columnsGap(10)
    .padding(10)
    .height('100%')
    .nestedScroll({
      scrollForward: NestedScrollMode.PARENT_FIRST,
      scrollBackward: NestedScrollMode.SELF_FIRST
    })
    .onReachEnd(() => {
      this.onReach()
    })
  }
}
