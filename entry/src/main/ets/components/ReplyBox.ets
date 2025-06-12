@Component
export struct ReplyBox {
  @BuilderParam
  content:()=>void
  build() {
    Row({ space: 5 }) {
      if(this.content){
        this.content()
      }
    }.width('100%').border({ width: { top: .5 }, color: Color.Gray })
  }
}