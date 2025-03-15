import { router } from '@kit.ArkUI'
import { Constants, tipDialog } from '../../common'
import { TitleTipBtn } from '../../components'
import { BuyTitle, BuyTitleInfo, shopType } from '../../models'

const BtnSty = ButtonType.Normal

@Entry
@Component
struct ShopDetailPage {
  @State
  images: Resource[] = []
  @State
  price: number = 0
  @State
  sold: number = 0
  @State
  name: string = ''
  @StorageProp(Constants.AREA_HEIGHT)
  areaHeight: number = 0

  async getData() {
    const params = router.getParams() as shopType
    return await new Promise<boolean>(rs => {
      this.images = params.images
      this.price = params.price
      this.sold = params.sold
      this.name = params.name
      rs(true)
    })
  }

  aboutToAppear() {
    this.getData()
  }

  /**
   * 图片索引*/
  @State currentImgIndex: number = 0

  @Styles
  buyBtn(){
    .height(60)
  }

  build() {
    Column() {
      //上半区
      Stack({ alignContent: Alignment.Top }) {
        //商品轮播图
        Swiper() {
          ForEach(this.images, (item: Resource) => {
            Image(item)
              .objectFit(ImageFit.Cover)
          })
        }
        .width('100%')
        .index($$this.currentImgIndex)
        .zIndex(1)
        .loop(true)
        .indicator(false)

        //当前浏览索引
        Row() {
          TitleTipBtn({
            title: `${this.currentImgIndex + 1}/${this.images.length}`
          })
        }
        .zIndex(2)
        .position({ x: '82.5%', y: '75%' })

        //顶部模糊背景
        Row().width('100%')
          .height(this.areaHeight)
          .blur(70).zIndex(3)
        //返回按钮
        Row() {
          Button() {
            Text('<').fontColor(Color.White)
              .fontSize(34)
          }
          .margin({ top: 10 })
          .backgroundColor(Color.Black)
          .opacity(.5)
          .width(40)
          .height(40)
          .zIndex(2)
          .onClick(() => {
            router.back()
          })
        }
        .width('100%')
        .height(60)
        .margin({ top: this.areaHeight })
        .alignItems(VerticalAlign.Top)
        .padding({ left: 20, right: 20 })
        .zIndex(2)
      }.layoutWeight(5)

      //下半区
      Column() {
        Column({ space: 10 }) {
          //顶部价格信息
          Row() {
            Text() {
              Span('优惠价￥').titleSize(18)
              Span(this.price.toString()).fontSize(40)
                .fontWeight(800)
              Span('起').titleSize(18)
            }.titleColor()

            Text('已售' + this.sold.toString())
              .fontSize(22)
              .fontWeight(300)
              .titleColor().margin({ bottom: 5 })
          }
          .width('100%')
          .height(50)
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(VerticalAlign.Bottom)

          //商品名
          Row() {
            Text(this.name)
              .fontColor(Color.Black)
              .fontWeight(600)
              .fontSize(20)
          }.width('100%').justifyContent(FlexAlign.Start)
        }.width('100%').height('100%').padding(15)

        //底部购买按钮
        Row({ space: 5 }) {
          ForEach(BuyTitleInfo, (item: BuyTitle) => {
            Text(item.name).buyTitle().onClick(() => {
              tipDialog()
            })
          })

          Row() {
            Button('加入购物车', { type: BtnSty })
              .borderRadius({
                topLeft: 40,
                bottomLeft: 40,
              })
              .fontColor(Color.Red)
              .backgroundColor('#ffe7b3b3')
              .buyBtn()
              .onClick(() => {
                tipDialog()
              })
            Button({ type: BtnSty }) {
              Column({ space: 5 }) {
                Text('优惠价￥' + this.price)
                  .buyWight().fontColor(Color.White).fontSize(15)
                Text('立即购买').buyWight().fontColor('#ff8c8c8c').fontSize(13)
              }
            }
            .padding(15)
            .backgroundColor(Color.Red)
            .buyBtn()
            .borderRadius({ topRight: 40, bottomRight: 40 })
            .onClick(() => {
              tipDialog()
            })
          }

        }
        .position({ y: '80%' })
        .width('100%')
        .height(100)
        .padding({ left: 13, right: 10 })
        .backgroundColor(Color.White)
        .border({
          color: '#ff969696', width: {
            top: .5
          }
        })
      }
      .layoutWeight(5)
      .margin({ top: -50 })
      .width('100%')
      .borderRadius(25)
      .backgroundColor(Color.White)
      .shadow({
        color: Color.Gray,
        radius: 50,
      })
    }.height('100%')
    .width('100%')
    .backgroundColor('#fff1e7e7')
  }
}

@Extend(Text)
function titleColor() {
  .fontColor(Color.Red)
}

@Extend(Span)
function titleSize(value: number) {
  .fontSize(value)
}

@Extend(Text)
function buyTitle() {
  .fontColor(Color.Black)
}

@Extend(Text)
function buyWight() {
  .fontWeight(800)
}
