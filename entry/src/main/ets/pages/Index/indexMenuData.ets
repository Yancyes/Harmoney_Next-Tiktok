import { BarClass } from '../../models'
import { common, tipDialog } from '../../common/Function/commonFn'
import { Constants } from '../../common/Constants'

/**
 * Index左右侧边栏的静态菜单数据
 * 单独成模块是为了让页面只保留渲染逻辑 这些数组全程只读 不需要@State*/
const leftCardData: BarClass[] = [
  {
    title: '通知消息',
    id: 1,
  },
  {
    title: '常用小程序',
    id: 2
  },
  {
    title: '常用功能',
    id: 3
  },
  {
    title: '生活动态',
    id: 4
  }
]

/**
 * 常用小程序数据源 暂无落库数据 空数组时页面渲染提示*/
const commonlyUsedAppletsItemData: BarClass[] = []

/**
 * 常用功能数据源*/
const commonFnItemData: BarClass[] = [
  {
    icon: $r('app.media.icon_wallet'),
    title: '我的钱包',
    click: () => {
      tipDialog()
    }
  }, {
  icon: $r('app.media.icon_leftsider_coupons'),
    title: '优惠卷',
    click: () => {
      tipDialog()
    }
}, {
  icon: $r('app.media.icon_applet'),
    title: '小程序',
    click: () => {
      tipDialog()
    }
}, {
  icon: $r('app.media.icon_time'),
    title: '观看历史',
    click: () => {
      tipDialog()
    }
}, {
  icon: $r('app.media.icon_leftSider_contentLove'),
    title: '内容偏好',
    click: () => {
      tipDialog()
    }
}, {
  icon: $r('app.media.icon_clouddownload'),
    title: '离线模式',
    click: () => {
      tipDialog()
    }
}, {
  icon: $r('app.media.icon_waitplay'),
    title: '稍后再看',
    click: () => {
      tipDialog()
    }
},
]

/**
 * 生活动态数据源*/
const lifeDynamicsItemData: BarClass[] = [
  {
    icon: $r('app.media.icon_siderLeft_live'),
    title: '直播广场',
    click: () => {
      tipDialog()
    }
  }, {
  icon: $r('app.media.icon_siderLeft_shopCarperson'),
    title: '附近团购',
    click: () => {
      tipDialog()
    }
}, {
  icon: $r('app.media.icon_siderLeft_activityCenter'),
    title: '活动中心',
    click: () => {
      tipDialog()
    }
}, {
  icon: $r('app.media.icon_siderLeft_playGame'),
    title: '玩游戏',
    click: () => {
      tipDialog()
    }
}, {
  icon: $r('app.media.icon_siderLeft_music'),
    title: '听抖音',
    click: () => {
      tipDialog()
    }
}, {
  icon: $r('app.media.icon_siderLeft_screeningRoom'),
    title: '放映厅',
    click: () => {
      tipDialog()
    }
}, {
  icon: $r('app.media.icon_siderLeft_singing'),
    title: 'K歌',
    click: () => {
      tipDialog()
    }
},
]

/**
 * 右侧边栏(更多功能)的数据*/
const rightItemData: BarClass[] = [
  {
    icon: $r('app.media.icon_shopCar'),
    title: "我的订单",
    click: () => {
      tipDialog()
    },
    bottomBorder: true
  },
  {
    icon: $r('app.media.icon_wallet'),
    title: "我的钱包",
    rightContent: '8.88',
    click: () => {
      tipDialog()
    }

  },
  {
    icon: $r('app.media.icon_QRcode'),
    title: "我的二维码",
    click: () => {
      tipDialog()
    },
    bottomBorder: true

  },
  {
    icon: $r('app.media.icon_time'),
    title: "观看历史",
    click: () => {
      tipDialog()
    },
    bottomBorder: true

  },
  {
    icon: $r('app.media.icon_waitplay'),
    title: "稍后再看",
    click: () => {
      tipDialog()
    },
    bottomBorder: true

  },
  {
    icon: $r('app.media.icon_clouddownload'),
    title: "离线模式",
    click: () => {
      tipDialog()
    },
    bottomBorder: true
  },
  {
    icon: $r('app.media.icon_idea'),
    title: "抖音创作着中心",
    click: () => {
      tipDialog()
    }
  },
  {
    icon: $r('app.media.icon_applet'),
    title: "小程序",
    click: () => {
      tipDialog()
    },
    bottomBorder: true
  },
  {
    icon: $r('app.media.icon_love'),
    title: "抖音公益",
    click: () => {
      tipDialog()
    },
    bottomBorder: true
  },
  {
    icon: $r('app.media.icon_sapling'),
    title: "青少年模式",
    click: () => {
      tipDialog()
    },
    bottomBorder: true
  },
  {
    icon: $r('app.media.icon_service'),
    title: "我的客服",
    click: () => {
      tipDialog()
    },
    bottomBorder: true
  },
  {
    icon: $r('app.media.icon_setting'),
    title: "设置",
    click: () => {
      common.nav(Constants.ROUTE_SETTING)
    }
  },
  {
    icon: $r('app.media.icon_personedetail'),
    title: "个人信息收集清单",
    click: () => {
      tipDialog()
    },
    bottomBorder: true
  },
  {
    icon: $r('app.media.icon_share'),
    title: "第三方信息共享清单",
    click: () => {
      tipDialog()
    },
    bottomBorder: true
  }
]

export { leftCardData, rightItemData, commonFnItemData, lifeDynamicsItemData, commonlyUsedAppletsItemData }
