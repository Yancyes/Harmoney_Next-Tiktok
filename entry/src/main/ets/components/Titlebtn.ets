/**
 * 我的界面头像弹窗复用ui内容*/
@ComponentV2
export struct TitleBtn {
  @Param
  title: string = ''
  @Param
  borBom: boolean = false
  @Event
  click: () => void = () => {
  }

  build() {
    Row() {
      Text(this.title).fontSize(20)
        .width('100%')
        .fontColor(Color.White)
    }
    .height(50)
    .justifyContent(FlexAlign.Start)
    .padding({ left: 10, right: 10 })
    .border({
      width: {
        bottom: this.borBom === true ? .5 : 0
      },
      radius: 10,
      color: '#ff868686'
    })
    .margin(5)
    .animation({ duration: 200 })
    .stateStyles({
      normal: {
        .backgroundColor('#ff3e3e3e')
      },
      pressed: {
        .backgroundColor('#ff53ee38')
      }
    })
    .onClick(() => {
      this.click()
    })
  }
}
