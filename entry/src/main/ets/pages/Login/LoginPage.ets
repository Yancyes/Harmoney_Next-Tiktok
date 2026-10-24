import { UserInfo, UserInfoModel } from '../../models/index'
import { tiktok } from '../../utils/setting'
import { userData } from '../../api'
import { common, syncCurrentUser, tipDialog } from '../../common'

@Extend(Text)
function textStyle() {
  .width('100%')
  .textAlign(TextAlign.Center)
  .fontColor(Color.Red)
  .fontSize(20)

}

@Extend(TextInput)
function ipt() {
  .width(300)
  .height(60)
  .border({
    radius: 8,
    width: 3,
    color: '#fff3f3f2'
  })
}

/**
 * 登录页 动态路由表入口 见resources/base/profile/router_map.json*/
@Builder
export function LoginPageBuilder() {
  LoginPage()
}

@ComponentV2
export struct LoginPage {
  @Local
  loading: boolean = false
  @Local
  showText: boolean = false
  @Local
  loginErrorTip: string = ''
  @Local
  userInfo: UserInfoModel = new UserInfoModel({
    username: '',
    password: '',
    tiktokNub: 0,
    avatar: '',
    user_id: ''
  } as UserInfo)

  /**
   * 初始化时自动获取一些基本数据*/
  aboutToAppear(): void {
    this.userInfo.tiktokNub = common.creteRandom() //获取随机生成的抖音号
    this.userInfo.user_id = common.creteUserID(11, 100).toString() //获取随机生产的id
    //原先写死的dtstatic头像直链已404 不处理就是空头像 统一从网络头像池里取
    this.userInfo.avatar = common.avatar('', this.userInfo.user_id)
  }

  /**
   * 任一项不足6位时常驻红字提示*/
  @Monitor('userInfo.username', 'userInfo.password')
  watchIpt(): void {
    this.showText = this.userInfo.username.length < 6 || this.userInfo.password.length < 6
  }

  /*
   * 登录功能*/
  login() {
    //因为没有真实数据，模拟登录
    if (this.userInfo.username.length < 6 || this.userInfo.password.length < 6) {
      this.loginErrorTip = '用户名或密码长度小于6位'
      this.showText = true
    } else {
      this.loading = true

      setTimeout(async () => {
        //token就是用户信息数据
        const token = userData(this.userInfo)
        //用户信息校验
        if (this.userInfo.username && this.userInfo.password) {
          syncCurrentUser(new UserInfoModel({
            username: this.userInfo.username,
            password: this.userInfo.password,
            tiktokNub: this.userInfo.tiktokNub,
            avatar: this.userInfo.avatar,
            user_id: this.userInfo.user_id,
            content: this.userInfo.content
          })) //写入全局状态
          await tiktok.setCurrentUser(token) //写入首选项
          this.loading = false
          //登录页是栈内唯一一项 清空后直接露出宿主首页
          common.navWithClear()
        } else {
          tipDialog("账号或密码错误!", 200)
          this.loading = false
        }
      }, 200)
    }
  }

  build() {
    NavDestination() {
      Column({ space: 30 }) {
        Text("账号登录").fontSize(34)
          .fontColor(Color.Black)

        Column() {
          TextInput({ placeholder: "请输入用户名", text: this.userInfo.username })
            .onChange((value: string) => { //因为数据只能监视到第一层的变化,只能用onchange绑定
              this.userInfo.username = value
            })
            .maxLength(10)
            .type(InputType.USER_NAME).ipt()
        }

        Column({ space: 20 }) {
          TextInput({ placeholder: "请输入密码", text: this.userInfo.password })
            .onChange((value: string) => {
              this.userInfo.password = value
            })
            .ipt()
            .maxLength(15)
            .type(InputType.Password)
        }

        Row() {
          if (this.showText) {
            Text(this.loginErrorTip).textStyle()
          }
        }.width('100%').height(30)

        Button({ type: ButtonType.Normal }) {
          Row() {
            if (this.loading) {
              LoadingProgress().width(20).height(20).color(Color.White)
            }
            Text('一键登录，无账号将自动注册').fontSize(16)
          }
        }
        .width(250)
        .height(50)
        .borderRadius(8)
        .backgroundColor('#fff80606')
        .onClick(() => {
          this.login()
        })
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#ff29e980')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
    }
    .hideTitleBar(true)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}
