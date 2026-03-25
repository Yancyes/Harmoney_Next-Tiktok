import { UserInfo, UserInfoModel } from '../../models/index'
import { router } from '@kit.ArkUI'
import { CURRENT_USER } from '../../constants'
import { tiktok } from '../../utils/setting'
import { userData } from '../../api'
import { Constants, common, tipDialog } from '../../common'

@Extend(Text)
function textStyle() {
  .width('100%')
  .textAlign(TextAlign.Center)
  .fontColor(Color.Red)
  .fontSize(20)

}

/**
 * 登录页*/
@Entry
@Component
struct LoginPage {
  @Styles
  ipt(){
    .width(300)
    .height(60)
    .border({
      radius: 8,
      width: 3,
      color: '#fff3f3f2'
    })
  }

  @State
  loading: boolean = false
  @State
  showText: boolean = false
  @State
  loginErrorTip: string = ''
  @State
  @Watch('watchIpt')
  userInfo: UserInfoModel = new UserInfoModel({
    username: '',
    password: '',
    tiktokNub: 0,
    avatar: '',
    user_id: ''
  } as UserInfo)

  watchIpt() {
    this.userInfo.username.length < 6 || this.userInfo.password.length < 6
      ? this.showText = true : this.showText = false
  }

  //初始化时自动获取一些基本数据
  aboutToAppear(): void {
    this.userInfo.tiktokNub = common.creteRandom() //获取随机生成的抖音号
    this.userInfo.avatar = 'https://c-ssl.dtstatic.com/uploads/blog/202206/16/20220616151457_21591.thumb.400_0.jpg'
    this.userInfo.user_id = common.creteUserID(11, 100).toString() //获取随机生产的id
  }

  /*
   * 登录功能*/
  login() {

    //因为没有真实数据，模拟登录
    if (this.userInfo.username.length < 6 && this.userInfo.password.length < 6 ||
      this.userInfo.username.length < 6 || this.userInfo.password.length < 6) {
      this.loginErrorTip = '用户名或密码长度小于6位'
      this.showText = true
    } else {
      this.loading = true

      setTimeout(async () => {
        //token就是用户信息数据
        const token = userData(this.userInfo)
        //用户信息校验
        if (this.userInfo.username && this.userInfo.password) {
          AppStorage.set(CURRENT_USER, new UserInfoModel({
            username: this.userInfo.username,
            password: this.userInfo.password,
            tiktokNub: this.userInfo.tiktokNub,
            avatar: this.userInfo.avatar,
            user_id: this.userInfo.user_id,
            content: this.userInfo.content
          })) //写入全局状态
          await tiktok.setCurrentUser(token) //写入首选项
          this.loading = false
          router.replaceUrl({ url: Constants.LOADING_INDEX })
        } else {
          tipDialog("账号或密码错误!", 200)
          this.loading = false
          return
        }
      }, 200)
    }
  }

  build() {
    Column({ space: 30 }) {
      Text("账号登录").fontSize(34)
        .fontColor(Color.Black)

      Column() {
        TextInput({ placeholder: "请输入用户名", text: this.userInfo.username })
          .onChange(value => { //因为数据只能监视到第一层的变化,只能用onchange绑定
            this.userInfo.username = value

          })
          .maxLength(10)
          .type(InputType.USER_NAME).ipt()
      }


      Column({ space: 20 }) {
        TextInput({ placeholder: "请输入密码", text: this.userInfo.password })
          .onChange(value => {
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
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .width('100%')
    .height('100%')
    .backgroundColor('#ff29e980')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}

export default LoginPage