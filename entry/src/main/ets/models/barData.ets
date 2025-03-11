// tabs
import { BtnName } from "../GlobalEnum"

/**
 * tab栏的接口
 * 这个接口有多个渲染组件的地方会用到不能乱改*/
export interface BarClass {
  id?: number
  icon?: ResourceStr
  title?: string
  name?: string
  rightContent?: string
  click?: () => void
  bottomBorder?: boolean
}

export class BarClassModel implements BarClass {
  id?: number = 0
  icon?: ResourceStr = ""
  title?: string = ""
  name?: string = ""
  rightContent?: string = ""
  click?: () => void

  constructor(model: BarClass) {
    this.id = model.id
    this.icon = model.icon
    this.title = model.title
    this.name = model.name
    this.rightContent = model.rightContent
    this.click = model.click
  }
}

export const MyPageOwnInfo: BarClass[] = [
  { title: '作品' },
  { title: '私密' },
  { title: '推荐' },
  { title: '收藏' },
  { title: '喜欢' }
]

/**
 * 顶部栏列表*/
export const TabList: BarClass[] = [
  {
    title: "经验",
    name: BtnName.EXPERIMENT
  },
  {
    title: "热点",
    name: BtnName.HOTPOT
  },
  {
    title: "直播",
    name: BtnName.LIVE
  },
  {
    title: "精选",
    name: BtnName.SELECTED
  },
  {
    title: '团购',
    name: BtnName.LOT_OF_BUY
  },
  {
    title: "上海",
    name: BtnName.AREA
  },
  {
    title: "关注",
    name: BtnName.CONCERN
  },
  {
    title: "商场",
    name: BtnName.SHOP
  },
  {
    title: "推荐",
    name: BtnName.FOR_YOU
  }]
