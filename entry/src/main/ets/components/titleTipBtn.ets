@Component
export struct TitleTipBtn {
  @Prop
  title: string = ''
  @Prop
  w: Length = 40
  @Prop
  h: Length = 40
  @Prop
  br: Length = 30
  @Prop
  op:number=.5
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