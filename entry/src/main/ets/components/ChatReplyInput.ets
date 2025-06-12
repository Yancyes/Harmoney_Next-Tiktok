import { common } from '../common'

/**
 * 发布评论组件*/
@Component
export struct ChatReplyInput {
  @Link
  content: string //输入框内容
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

