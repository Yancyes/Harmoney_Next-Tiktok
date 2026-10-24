/**
 * 用户信息接口*/
export interface UserInfo {
  username: string //用户名
  password: string //用户密码
  tiktokNub: number //抖音号
  avatar: string //头像
  user_id: string //用户id
  content: string //聊天内容
}

@ObservedV2
export class UserInfoModel implements UserInfo {
  @Trace username: string = ''
  @Trace password: string = ''
  @Trace tiktokNub: number = 0
  @Trace avatar: string = ''
  @Trace user_id: string = ''
  @Trace content: string = ''

  constructor(model: UserInfo) {
    this.username = model.username
    this.password = model.password
    this.tiktokNub = model.tiktokNub
    this.avatar = model.avatar
    this.user_id = model.user_id
    this.content = model.content
  }

}

export function userToPlain(user: UserInfoModel): UserInfo {
  return {
    username: user.username,
    password: user.password,
    tiktokNub: user.tiktokNub,
    avatar: user.avatar,
    user_id: user.user_id,
    content: user.content
  }
}

/**
 * 可用的网络头像池
 * 原先用的是百度图搜直链 带sec/t签名 过期后只返回52字节的占位gif 头像就成了空的
 * randomuser.me的直链不带签名 不会失效*/
export const netAvatars: string[] = [
  'https://randomuser.me/api/portraits/men/32.jpg',
  'https://randomuser.me/api/portraits/women/44.jpg',
  'https://randomuser.me/api/portraits/men/75.jpg',
  'https://randomuser.me/api/portraits/women/68.jpg',
  'https://randomuser.me/api/portraits/men/12.jpg',
  'https://randomuser.me/api/portraits/women/25.jpg',
  'https://randomuser.me/api/portraits/men/41.jpg',
  'https://randomuser.me/api/portraits/women/11.jpg',
  'https://randomuser.me/api/portraits/men/86.jpg',
  'https://randomuser.me/api/portraits/women/53.jpg',
  'https://randomuser.me/api/portraits/men/3.jpg',
  'https://randomuser.me/api/portraits/women/90.jpg'
]

/**
 * 联系人英文名池
 * 顺序与netAvatars一一对应 性别要和头像对上*/
export const nickNames: string[] = [
  'Liam', 'Olivia', 'Noah', 'Emma', 'Oliver', 'Ava',
  'Ethan', 'Sophia', 'Lucas', 'Mia', 'Mason', 'Isabella'
]

/**
 * 默认用户数据
 * 名字和头像按下标配对 冷启动后同一个人还是同一个名字同一张脸*/
export const defaultUserInfo: UserInfo[] = nickNames.slice(0, 10).map((name: string, i: number): UserInfo => {
  return {
    username: name,
    password: '',
    tiktokNub: 1000000001 + i,
    avatar: netAvatars[i],
    user_id: `${i + 1}`,
    content: ''
  }
})


/**
 * preferences默认值必须是ValueType且模块import期读不到AppStorage
 * 用户信息以JSON字符串存储 无数据时返回空字符串作为兜底*/
export const CurrentUser: string = ''
