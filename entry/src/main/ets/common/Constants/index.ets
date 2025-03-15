/**
 * 常量库 KEY
 * */
export class Constants {
  //统一色值
  /**
   * 弹窗背景色*/
  static readonly COLOR_OpacityBlack = '#80000000'
  /**
   * 灰色*/
  static readonly COLOR_GREY = '#ff868585'
  /**
   * 底部栏背景色*/
  static readonly COLOR_GrayNAV = '#ff393939'
  /**
   * 侧边栏钱包背景色*/
  static readonly COLOR_SiDerPay = 'rgba(227, 227, 227, 0.50)'
  static readonly COLOR_DIALOG_BG = 'rgba(0, 0, 0, 0.50)'
  //统一数值
  static readonly SCREEN_WIDTH = 'SCREEN_WIDTH'
  static readonly BTN_TITLE_WIDTH = 'BTN_TITLE_WIDTH'
  static readonly AREA_HEIGHT = 'AREA_HEIGHT'
  static readonly BOTTOM_HEIGHT = 'BOTTOM_HEIGHT'
  //统一路由管理
  /**
   * 加载登录页*/
  static readonly LOADING_LOGIN = "pages/Login/LoginPage"
  /**
   * 加载主页*/
  static readonly LOADING_INDEX = "pages/Index/Index"
  /**
   * 加载聊天详情页*/
  static readonly LOADING_ChatDetail = "pages/ChatDetail/ChatDetail"
  /**
   * 加载搜索页*/
  static readonly LOADING_SEARCH = "pages/Search/SearchPage"
  /**
   * 加载设置页*/
  static readonly LOADING_SETTING = "pages/Setting/SettingPage"
  /**
   * 加载商品页*/
  static readonly LOADING_SHOP = "pages/Shop/ShopPage"
  /**
   * 加载视频详情页*/
  static readonly LOADING_VdDETAIL = "pages/My/VdDetail"
  /**
   * 商品详情页*/
  static readonly SHOP_DETAIL = "pages/Shop/ShopDetailPage"
  /**
   * 我的页面 视频背景图片地址*/
  static readonly GET_VIDEO_IMG_URL = "get_Video_Img_Url"
  /**
   * 全局视频暂停*/
  static readonly GLOBAL_VIDEO_CONTROLLER_PAUSE = "globalVideoControllerPause"
  /**
   * 全局视频播放*/
  static readonly GLOBAL_VIDEO_CONTROLLER_PLAYER = "globalVideoControllerPayer"
  /**
   * 遮罩弹窗*/
  static readonly SHOW_DIALOG = "ShowDialog"
  /**
   * 视频缩放 */
  static readonly SCALE_SIZE = "scaleSize"
}