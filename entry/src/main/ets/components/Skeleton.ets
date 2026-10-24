@Preview
@ComponentV2
struct Skeleton {
  timer: number = -1
  @Local
  currentColor: string = "#ffcce730"

  aboutToAppear(): void {
    this.timer = setInterval(() => {
      if (this.currentColor === "#ffcce730") {
        this.currentColor = "#ff3ef39e"
      } else {
        this.currentColor = "#ffcce730"
      }
    }, 300)
  }

  aboutToDisappear(): void {
    clearInterval(this.timer)
  }

  build() {
    Column() {
      Row({ space: 10 }) {
        Text('视频加载中')
          .fontColor(this.currentColor)
          .fontSize(40)
        LoadingProgress()
          .height(50)
      }
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .padding(20)
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
  }
}


export { Skeleton }
