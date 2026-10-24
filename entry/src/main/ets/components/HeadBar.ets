/**
 * 顶部导航栏*/
import { ImgComp } from '.'

/**
 * @param isShowLeftIcon 是否显示左侧图标
 * @param isShowRightIcon 是否显示有右侧图标
 * @param isShowMainContent 是否显示主要内容*/
@Component
export struct HeadBar {
  /**
   * 左侧图标*/
  LeftIcon: ResourceStr = ''
  /**
   * 右侧图标*/
  RightIcon: ResourceStr = ''
  /**
   * 左侧图标事件*/
  LeftIconClick: () => void = () => {
  }
  /**
   * 右侧图标事件*/
  RightIconClick: () => void = () => {
  }
  /**
   * 顶部栏内容区*/
  @BuilderParam
  BarMainContent: () => void
  @Prop
  isShowLeftIcon: boolean = true
  @Prop
  isShowRightIcon: boolean = true
  @Prop
  isShowMainContent: boolean = true

  build() {
    Row() {
      if (this.isShowLeftIcon) { //是否显示左侧图标和主内容
        ImgComp({
          imgWidth: 30,
          imgSrc: this.LeftIcon
        }).onClick(() => {
          this.LeftIconClick()
        })
        if (this.BarMainContent && this.isShowMainContent) {
          this.BarMainContent()
        }
      } else {
        Blank() //占位防止搜索图标错位
      }
      if (this.isShowRightIcon) {
        ImgComp({
          imgWidth: 30,
          imgSrc: this.RightIcon,
        }).onClick(() => {
          this.RightIconClick()
        })
      }
    }.width('100%')
    .height(50)
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({ left: 15, right: 15 })
  }
}