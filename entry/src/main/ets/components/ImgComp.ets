import { image } from '@kit.ImageKit'


/**
 * 二次封装的图片组件*/
@ComponentV2
export struct ImgComp {
  @Require
  @Param
  imgSrc: image.PixelMap | ResourceStr | DrawableDescriptor = '' //图片地址
  @Require
  @Param
  imgWidth: Length = 0 //宽度
  @Param
  imgHeight: Length = 0 //高度
  @Param
  isFillColor: boolean = false //是否填充颜色
  @Param
  isDraggable: boolean = false //图片是否可拖拽
  @Param
  ImageFitType: ImageFit = ImageFit.Contain //图片压缩类型
  @Param
  color_1: ResourceColor = ''
  @Param
  color_2: ResourceColor = ''
  @Param
  bordWidth: number = 0
  @Param
  bordRadius: number = 0
  @Param
  bordColor: ResourceColor = ''
  @Param
  shadowValue: number | Resource = 0
  @Param
  shadowColor: string | Color | Resource | undefined = ''
  /**
   * 图片地址加载失败时的兜底地址 空表示不兜底 只有头像这类网络图才需要传*/
  @Param
  fallbackSrc: string = ''
  /**
   * 实际渲染的地址 @Param不能自改 所以镜像一份用于失败替换*/
  @Local
  src: image.PixelMap | ResourceStr | DrawableDescriptor = ''

  aboutToAppear(): void {
    this.src = this.imgSrc
  }

  /**
   * 父组件换人换图时重新同步 否则会一直显示上一张*/
  @Monitor('imgSrc')
  syncSrc(): void {
    this.src = this.imgSrc
  }

  build() {
    Image(this.src)
      .draggable(this.isDraggable)
      .width(this.imgWidth)
      .height(this.imgHeight || null)
      .objectFit(this.ImageFitType)
      .fillColor(this.isFillColor ? this.color_1 : this.color_2)
      .border({
        width: this.bordWidth,
        color: this.bordColor,
        radius: this.bordRadius
      })
      .shadow({
        radius: this.shadowValue,
        color: this.shadowColor
      })
      .onError(() => {
        //直链过期(带签名参数的图床)时Image只会画出一张空图 这里换成网络头像兜底
        if (this.fallbackSrc && this.src !== this.fallbackSrc) {
          this.src = this.fallbackSrc
        }
      })
  }
}
