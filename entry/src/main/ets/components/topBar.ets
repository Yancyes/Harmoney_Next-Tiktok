import { BarClass, DataSource, ListIndexPosition, TabList } from '../models'
import Shop from '../pages/Shop/ShopPage'
import { Colm, HeadBar } from '.'
import { Constants } from '../common'
import RecommendPage from '../pages/VideoPage/RecommendPage'
import { TikTokEmitter } from '../utils/TIkTokEmitter'
import { BtnName } from '../GlobalEnum'

/**
 * 顶部栏*/
@Component
export struct TopBar {
  @StorageProp(Constants.AREA_HEIGHT)
  topHeight: number = 0
  /**
   * 顶部栏信息*/
  @State
  topTabList: BarClass[] = TabList
  tabController: TabsController = new TabsController()
  @Consume
  IndexX: number | string
  @StorageLink(Constants.SHOW_DIALOG) showDialog: boolean = false
  @Consume
  dialogBgColor: string

  @Builder
  titleCommon(item: BarClass, index: number) {
    Stack({ alignContent: Alignment.Bottom }) {
      Text(item.title)
        .textAlign(TextAlign.Center)
        .fontColor(Color.White)
        .fontWeight(600)
        .fontSize(20)
        //强度驱动明暗与虚化 拖动中当前页与目标页此消彼长
        .opacity(0.9 + 0.1 * this.labelStrength(index))
        .textShadow({ radius: (1 - this.labelStrength(index)) * 5, offsetY: 5, color: '#ff6b6b6b' })
        .onClick(() => {
          this.selectTab(index)
        })
      //下划线是tab项自身的内容 跟着文字一起滚动 出界时和文字一起被列表自然遮挡
      if (index === this.fadeFrom) {
        Row()
          .width(this.indicatorW)
          .height(this.indicatorH)
          .borderRadius(2)
          .backgroundColor(this.indicatorColor())
          .translate({ x: this.underlineSlideX(), y: this.indicatorH + this.indicatorGap })
      }
    }
  }

  /**
   * 打开左侧边栏*/
  openLeftSideBar() {
    this.getUIContext().animateTo({ duration: 200 }, () => {
      this.showDialog = !this.showDialog
      this.dialogBgColor = '#80000000'
      //更改坐标轴
      this.IndexX = '70%'
    })
  }

  /**
   * 进入搜索页*/
  clickSearch() {
    this.getUIContext().getRouter().pushUrl({
      url: Constants.LOADING_SEARCH,
      params: {
        name: "搜你想看的"
      }
    })
  }

  /**
   * 顶部列表项数据*/
  private tabListData = new DataSource(this.topTabList)
  /**
   * 顶部栏主要内容总宽度*/
  private barContentWidth: number = AppStorage.get(Constants.SCREEN_WIDTH) as number - 100
  /**
   * 顶部列表滚动控制器*/
  private classifyScroller: Scroller = new Scroller()
  /**
   * 顶部栏列表可视区域的起始索引和终点索引*/
  tagIndexPosition: ListIndexPosition = { start: 0, end: 0 } // 一级列表可视区域的起始索引和终点索引
  /**
   * 顶部导航栏焦点索引值 当前索引
   * */
  @Link
  @Watch('onIndexChange')
  topNavCurrentIndex: number
  @Provide
  isShowRightSideBar: boolean = true
  //交叉渐变三元组:起始tab索引、目标tab索引、0~1进度由逐帧回调写入 起始tab同时是下划线当前挂靠的那一项文字明暗/虚化、下划线颜色与滑动偏移都按进度插值
  @State fadeFrom: number = 0
  @State fadeTarget: number = 0
  @State fadeProgress: number = 0
  /**
   * 下划线宽度、高度与文字间距*/
  private indicatorW: number = 30
  private indicatorH: number = 3
  private indicatorGap: number = 4
  /**
   * 顶部列表项间距*/
  private listSpace: number = 15
  /**
   * 内容区宽度 用于把手指拖动距离换算成翻页进度*/
  @StorageProp(Constants.SCREEN_WIDTH)
  private contentWidth: number = 0
  /**
   * 是否正在播点击切换的下划线滑动动画 期间内容停稳的回调不再归位渐变*/
  private tapSliding: boolean = false

  aboutToAppear(): void {
    //首帧就把下划线挂到当前tab 位置由该tab自身布局给出 无需等rect
    this.setFade(this.topNavCurrentIndex, this.topNavCurrentIndex, 0)
  }

  /**
   * 写入交叉渐变状态 起始/目标相同表示没有过渡在进行*/
  setFade(from: number, target: number, progress: number) {
    this.fadeFrom = from
    this.fadeTarget = target
    this.fadeProgress = target === from ? 0 : progress
  }

  /**
   * 某个tab的选中强度 0~1 拖动中在当前页与目标页之间线性此消彼长*/
  labelStrength(index: number): number {
    if (index === this.fadeFrom) {
      return 1 - this.fadeProgress
    }
    return index === this.fadeTarget ? this.fadeProgress : 0
  }

  /**
   * 商场tab的权重 用于让下划线颜色在黑白之间平滑过渡*/
  indicatorColor(): string {
    const shopOf = (index: number) => this.topTabList[index].name === BtnName.SHOP ? 1 : 0
    const blend = shopOf(this.fadeFrom) + (shopOf(this.fadeTarget) - shopOf(this.fadeFrom)) * this.fadeProgress
    const gray = Math.round(255 * (1 - blend)).toString(16).padStart(2, '0')
    return `#ff${gray}${gray}${gray}`
  }

  /**
   * 目标tab中心相对挂靠tab中心的距离
   * 目标tab未参与布局(不在可视范围)时按挂靠tab宽度+列表间距估算一个步长*/
  slideDistance(target: number): number {
    const from = this.classifyScroller.getItemRect(this.fadeFrom)
    if (!from || from.width === 0) {
      return 0
    }
    const to = this.classifyScroller.getItemRect(target)
    if (!to || to.width === 0) {
      const step = from.width + this.listSpace
      return target > this.fadeFrom ? step : -step
    }
    return (to.x + to.width / 2) - (from.x + from.width / 2)
  }

  /**
   * 下划线在挂靠tab内的横向偏移 停稳时为0 翻页时按进度滑向目标tab*/
  underlineSlideX(): number {
    if (this.fadeTarget === this.fadeFrom) {
      return 0
    }
    return this.slideDistance(this.fadeTarget) * this.fadeProgress
  }

  /**
   * 逐帧渲染的唯一入口 把选中页的位移比例写成渐变状态
   * 下划线位置由挂靠tab的布局+偏移得出 天然跟随列表滚动
   * @param from 选中页索引
   * @param ratio 该页相对起点的位移比例 负值表示去后一页 0表示已停稳*/
  driveIndicatorByRatio(from: number, ratio: number) {
    if (ratio === 0) {
      //停稳 把下划线交还给选中tab自己持有 偏移归零但像素位置不变
      //点击切换的滑动还没走完时不能归位 否则会把滑动动画打断
      if (!this.tapSliding) {
        this.setFade(from, from, 0)
      }
      return
    }
    //手指左滑去后一页 下划线向右滑
    const target = from + (ratio < 0 ? 1 : -1)
    //首/尾tab没有相邻页 目标即自身 setFade会把进度归零 文字与颜色都不再渐变
    const reachable = target >= 0 && target < this.topTabList.length
    //手指一旦接管 点击切换的滑动就地让位 保证跟手
    this.tapSliding = false
    //弹簧曲线过冲时最多滑到相邻tab 不穿透
    this.setFade(from, reachable ? target : from, Math.min(Math.abs(ratio), 1))
  }

  /**
   * 手指拖动翻页时逐帧回调 currentOffset单位vp 除以页宽即比例*/
  onSwipeFollow(index: number, extraInfo: TabsAnimationEvent) {
    this.driveIndicatorByRatio(index, extraInfo.currentOffset / this.contentWidth)
  }

  /**
   * 内容区滚动逐帧回调 覆盖松手后的惯性滑动与回弹 抬手处不会停顿*/
  onContentScroll(selectedIndex: number, index: number, position: number, mainAxisLength: number) {
    //同一帧还会回调相邻页 信息重复 只取选中页自身的位移
    if (index === selectedIndex && mainAxisLength > 0) {
      this.driveIndicatorByRatio(selectedIndex, position)
    }
  }

  /**
   * 索引变化时把选中项滚进可视区 下划线随该项的布局一起过去*/
  onIndexChange() {
    this.scrollTabIntoView()
  }

  /**
   * 选中项贴近顶部列表可视区边缘时把列表滚过去*/
  scrollTabIntoView() {
    const current = this.topNavCurrentIndex
    const c = current === (this.tagIndexPosition.start||this.tagIndexPosition.end)
    if (c || current === this.tagIndexPosition.end - 1) {
      this.classifyScroller.scrollToIndex(this.clampIndex(current + 2), true) //获焦item向左滚动
    }
    if (c || current === this.tagIndexPosition.start + 1) {
      this.classifyScroller.scrollToIndex(this.clampIndex(current - 2), true) //获焦item向右滚动
    }
  }

  /**
   * 把索引收敛到tab列表范围内*/
  clampIndex(index: number): number {
    return Math.min(Math.max(index, 0), this.topTabList.length - 1)
  }

  /**
   * 顶部栏主要内容*/
  @Builder
  barMainContent() {
    List({ space: this.listSpace, initialIndex: this.topNavCurrentIndex, scroller: this.classifyScroller }) {
      LazyForEach(this.tabListData, (item: BarClass, index: number) => {
        ListItem() {
          this.titleCommon(item, index)
        }
      })
    }
    .onScrollIndex((start: number, end: number) => {
      this.tagIndexPosition = { start, end }
    })
    .edgeEffect(EdgeEffect.None)
    .scrollBar(BarState.Off)
    .listDirection(Axis.Horizontal)
    .width(this.barContentWidth)
    .height(50)
    .padding({ top: 15, left: 5, right: 5 })
  }

  /**
   * 末页是推荐流 其余页面都暂停播放*/
  isFeedTab(index: number): boolean {
    return index === this.topTabList.length - 1
  }

  /**
   * 点击标签切到该页 下划线从当前tab滑过去再归位到选中tab
   * 推荐页恢复播放 其余暂停*/
  selectTab(index: number) {
    if (index !== this.topNavCurrentIndex) {
      const from = this.topNavCurrentIndex
      this.tapSliding = true
      this.getUIContext().animateTo({
        duration: 250,
        curve: Curve.EaseOut,
        onFinish: () => {
          //期间被手指拖动接管就不再归位 免得把正在跟手的状态打断
          if (this.tapSliding) {
            this.tapSliding = false
            this.setFade(this.topNavCurrentIndex, this.topNavCurrentIndex, 0)
          }
        }
      }, () => this.setFade(from, index, 1))
    }
    this.tabController.changeIndex(index)
    this.isFeedTab(index) ? this.startVideo() : this.pauseVideo()
  }

  /**
   * 播放视频*/
  startVideo() {
    TikTokEmitter.Emitter_VideoCrl(true)
  }

  /**
   * 暂停视频*/
  pauseVideo() {
    TikTokEmitter.Emitter_VideoCrl(false)
  }

  /**
   * 各tab页内容 商场类页面复用Shop 末页是推荐视频流 其余为占位列*/
  @Builder
  tabBody(item: BarClass) {
    if (item.name === BtnName.SHOP || item.name === BtnName.LOT_OF_BUY) {
      Shop()
    } else if (item.name === BtnName.FOR_YOU) {
      RecommendPage()
    } else {
      Colm()
    }
  }

  build() {
    Stack() {
      Tabs({ index: $$this.topNavCurrentIndex, controller: this.tabController, barPosition: BarPosition.Start }) {
        ForEach(this.topTabList, (item: BarClass) => {
          TabContent() {
            this.tabBody(item)
          }
        })
      }
      .animationDuration(0)
      //手势拖动期间逐帧回调 下划线跟手
      .onGestureSwipe((index: number, extraInfo: TabsAnimationEvent) => {
        this.onSwipeFollow(index, extraInfo)
      })
      //内容滚动逐帧回调 覆盖松手后的惯性滑动与回弹 抬手处不再停顿
      .onContentDidScroll((selectedIndex: number, index: number, position: number, mainAxisLength: number) => {
        this.onContentScroll(selectedIndex, index, position, mainAxisLength)
      })
      .onChange(() => {
        this.isFeedTab(this.topNavCurrentIndex) ? this.startVideo() : this.pauseVideo()
      })
      .height('106%')
      .position({ y: -this.topHeight })

      //自定义组件覆盖原来的tabs
      HeadBar({
        LeftIcon: $r('app.media.icon_LeftBar_white'),
        RightIcon: $r('app.media.icon_search'),
        LeftIconClick: () => {
          this.openLeftSideBar()
          this.pauseVideo()
        },
        RightIconClick: () => {
          this.pauseVideo()
          this.clickSearch()
        },
        BarMainContent: () => {
          this.barMainContent()
        },
        isShowLeftIcon: this.isShowRightSideBar,
        isShowMainContent: this.isShowRightSideBar
      })
        .position({ y: this.topHeight + 10 })
    }.position({ y: '-2.5%' })
  }
}
