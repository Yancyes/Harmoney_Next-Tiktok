import { common, Constants } from '../common'

@Component
export struct ReplyBox {
  @BuilderParam
  content: () => void

  build() {
    Row({ space: 5 }) {
      if (this.content) {
        this.content()
      }
    }.width('100%').border({ width: { top: .5 }, color: Color.Gray })
  }
}
/**
 * 通用输入框组件
 */
@Component
export struct Input {
  @Link
  content: string
  publishComment: (content: string) => void = () => {
  }
  iptContent: string = ''

  build() {
    Row() {
      TextInput({ placeholder: this.iptContent, text: $$this.content })
        .textAlign(TextAlign.Center)
        .width('90%')
        .height(45)
        .borderRadius(40)
        .onSubmit(() => {
          if (this.content) {
            this.publishComment(this.content)
            this.content = ''
          }
        })
        .onClick(() => {
          if (this.iptContent === '善语结善缘,恶言伤人心') {
            common.redirect()
          }
        })
    }
    .width('100%')
    .padding({ top: 20 })
    .margin({ bottom: 30 })
    .height(50)
    .animation({ duration: 200, iterations: 1 })
    .justifyContent(FlexAlign.Center)

  }
}

/**
 * 发布评论组件*/
@Component
export struct ReplyInput {
  @Link content: string
  @StorageLink(Constants.SHOW_DIALOG) showDialog: boolean = false
  @StorageLink(Constants.SCALE_SIZE) scaleSize: number = 1
  iptContent: string = ''
  publishComment: (content: string) => void = () => {
  }

  build() {
    Input({
      content: this.content,
      publishComment: this.publishComment,
      iptContent: this.iptContent
    })
      .onFocus(() => {
        //显示遮罩层
        this.showDialog = true
        this.scaleSize = 1.1
      })
  }
}

