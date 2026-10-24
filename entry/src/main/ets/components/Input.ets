import { common, Constants } from '../common'

/**
 * 评论输入框
 * content用@Param接收、$content回抛 父组件用!!双向绑定*/
@ComponentV2
export struct Input {
  @Param
  content: string = ''
  @Event
  $content: (content: string) => void = (content: string) => {
  }
  @Param
  iptContent: string = ''
  @Event
  publishComment: (content: string) => void = (content: string) => {
  }

  build() {
    Row() {
      TextInput({ placeholder: this.iptContent, text: this.content })
        .textAlign(TextAlign.Start)
        .layoutWeight(1)
        .height(40)
        .borderRadius(20)
        .backgroundColor('#f2f2f4')
        .placeholderColor(Constants.COLOR_GREY)
        .padding({ left: 15, right: 15 })
        .onChange((value: string) => {
          this.$content(value)
        })
        .onSubmit(() => {
          if (this.content) {
            this.publishComment(this.content)
            this.$content('')
          }
        })
        .onClick(() => {
          if (this.iptContent === '善语结善缘,恶言伤人心') {
            common.redirect()
          }
        })
    }
    .width('100%')
    //行高由内部输入框撑开 固定高度加padding会把输入框顶出对齐线
    .padding({ left: 15, right: 5, top: 10, bottom: 10 })
  }
}
