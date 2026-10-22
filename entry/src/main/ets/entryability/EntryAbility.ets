import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { display, KeyboardAvoidMode, window } from '@kit.ArkUI';
import { Tiktok } from '../utils/setting';
import { CURRENT_USER } from '../constants';
import { Constants } from '../common/Constants';
import dayjs from 'dayjs';
import { Log } from '@abner/log';

// 设置语言为中文
dayjs.locale('zh-cn');

Log.init({
  tag: "ECX",
  domain: 0xEC00,
  close: false,
  isHilog: true,
  showLogLocation: true,
  logSize: 200
})

const ctx = AppStorage.get<UIContext>(Constants.GET_UI_CONTEXT)

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    Log.info('ability onCreate');
  }

  onDestroy(): void {
    Log.info('ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability
    Log.info('ability onWindowStageCreate');
    // 获取窗口
    const win = windowStage.getMainWindowSync()
    win.setWindowLayoutFullScreen(true) //设置窗口全屏
    //获取用户信息
    const info = new Tiktok(this.context).getCurrentUser()
    //创建存储用户信息的空间
    AppStorage.setOrCreate(CURRENT_USER, info)
    //加载内容
    windowStage.loadContent(Constants.LOADING_INDEX, () => {
      const convert = (value: number) => ctx!.px2vp(value)
      //安全区高度
      const safeArea = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM)
      const areaHeight: number = convert(safeArea.topRect.height)
      const bottomHeight: number = convert(safeArea.bottomRect.height)
      //屏幕宽度
      const screenWidth: number = convert(display.getDefaultDisplaySync().width)
      //标签按钮宽度
      let btnTitleWidth: number = 0
      AppStorage.setOrCreate(Constants.SCREEN_WIDTH, screenWidth)
      AppStorage.setOrCreate(Constants.BTN_TITLE_WIDTH, btnTitleWidth)
      AppStorage.setOrCreate(Constants.AREA_HEIGHT, areaHeight)
      AppStorage.setOrCreate(Constants.BOTTOM_HEIGHT, bottomHeight)
      //设置键盘避让模式
      windowStage.getMainWindowSync().getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.RESIZE)
    })
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    Log.info('ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    Log.info('ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    Log.info('ability onBackground');
  }
}
