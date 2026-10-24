import { iconBtn } from "."
import { BarClass } from "../models"

/**
 * icon类图标统一结构
 * @param itemData 数据源 */
@ComponentV2
export struct iconContent {
  @Require
  @Param
  itemData: BarClass[] = []

  build() {
    Grid() {
      ForEach(this.itemData, (item: BarClass) => {
        GridItem() {
          iconBtn({
            icon: item.icon,
            title: item.title
          })
            .onClick(() => {
              item.click && item.click()
            })
        }.margin({ top: 15, bottom: 10 })
      })
    }.columnsTemplate('1fr 1fr 1fr')
  }
}
