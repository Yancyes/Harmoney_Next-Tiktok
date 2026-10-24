@ComponentV2
export struct TitleTipBtn {
  @Param
  title: string = ''
  @Param
  w: Length = 40
  @Param
  h: Length = 40
  @Param
  br: Length = 30
  @Param
  op: number = .5
  @BuilderParam
  img: () => void

  build() {
    Row({ space: 5 }) {
      if (this.img) {
        this.img()
      }
      Text(this.title).fontSize(16).fontColor(Color.White)
    }
    .backgroundColor(Color.Black)
    .opacity(this.op)
    .justifyContent(FlexAlign.Center)
    .height(this.h)
    .width(this.w)
    .borderRadius(this.br)
  }
}
