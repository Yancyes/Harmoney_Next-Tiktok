import { Constants } from "../common"

/**
 * @param count 点赞数
 * @param isChangeColor 是否变化文本色
 * @param isWhite 是否默认白色 */
@ComponentV2
export struct LikeTextCount {
  @Require
  @Param
  count: number = 0
  @Param
  isChangeColor: boolean = false
  @Require
  @Param
  isWhite: boolean = false

  /**
   * count可能来自缺字段的JSON/首选项数据 直接toString会崩*/
  text(): string {
    const num = this.count ?? 0
    return num > 9999 ? (num / 10000).toFixed(1) + '万' : `${num}`
  }

  build() {
    Row() {
      Text(this.text())
        .fontSize(16)
        .fontColor(this.isWhite ? Color.White : this.isChangeColor ? Color.Red : Constants.COLOR_GREY)
    }
  }
}
