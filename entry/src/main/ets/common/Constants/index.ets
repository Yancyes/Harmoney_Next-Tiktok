/**
 * 常量库 KEY
 * */
export class Constants {
  static readonly COLOR_OpacityBlack = '#80000000'
  static readonly COLOR_GREY = '#ff868585'
  static readonly COLOR_GrayNAV = '#ff393939'
  /**
   * 侧边栏钱包背景色*/
  static readonly COLOR_SiDerPay = 'rgba(227, 227, 227, 0.50)'
  static readonly COLOR_DIALOG_BG = 'rgba(0, 0, 0, 0.50)'
  /**
   * Navigation宿主页 唯一注册在main_pages.json的页面*/
  static readonly LOADING_INDEX = "pages/Index/Index"
  //以下路由名对应router_map.json里的name
  static readonly ROUTE_LOGIN = "Login"
  static readonly ROUTE_CHAT_DETAIL = "ChatDetail"
  static readonly ROUTE_SEARCH = "Search"
  static readonly ROUTE_SETTING = "Setting"
  static readonly ROUTE_SHOP = "Shop"
  static readonly ROUTE_SHOP_DETAIL = "ShopDetail"
  static readonly ROUTE_VIDEO_DETAIL = "VdDetail"
  static readonly ROUTE_COMMENT_DIALOG = "CommentDialog"
  /**
   * 评论弹层出入场动画时长(ms) 视频顶起压缩与弹层滑动必须同速*/
  static readonly COMMENT_DIALOG_ANIM_DURATION = 100
  /**
   * 全局视频暂停*/
  static readonly GLOBAL_VIDEO_CONTROLLER_PAUSE = "globalVideoControllerPause"
  /**
   * 全局视频播放*/
  static readonly GLOBAL_VIDEO_CONTROLLER_PLAYER = "globalVideoControllerPayer"
  /**
   * 视频收藏
   */
  static readonly GLOBAL_VIDEO_COLLECTION = "Global_video_collection"
  /**
   * 视频点赞
   */
  static readonly GLOBAL_VIDEO_LIKE = "Global_video_like"
}
