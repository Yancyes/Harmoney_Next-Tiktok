/**
 * 弹窗组件*/
@ComponentV2
export struct customDialog {
  @Consumer('dialogBgColor')
  dialogBgColor: ResourceColor = Color.Transparent
  @BuilderParam
  imgAvatar: () => void //头像

  build() {
    Column() {
      if (this.imgAvatar) {
        this.imgAvatar()
      }
    }
    .width('100%').height('100%').backgroundColor(this.dialogBgColor)
  }
}
