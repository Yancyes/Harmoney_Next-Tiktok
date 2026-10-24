@ComponentV2
export struct Colm {
  build() {
    Column() {
      Text('敬请期待')
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Gray)
    .justifyContent(FlexAlign.Center)
  }
}
