import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { display, KeyboardAvoidMode, window } from '@kit.ArkUI';
import { Tiktok } from '../utils/setting';
import { CURRENT_USER } from '../constants';
import { Constants } from '../common/Constants';
import dayjs from 'dayjs';
import { Log } from '@abner/log';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.initLog()
    Log.info('ability onCreate');
  }

  onDestroy(): void {
    Log.info('ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    Log.info('ability onWindowStageCreate');
    const win = windowStage.getMainWindowSync()
    this.storeCurrentUser()
    this.storeScreenMetrics(win)
    //设置窗口全屏
    win.setWindowLayoutFullScreen(true)
    //加载内容
    windowStage.loadContent(Constants.LOADING_INDEX, () => {
      //UIContext在内容加载完成后才可用 键盘避让只能在回调内设置
      win.getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.RESIZE)
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
    // Ability has changed to background
    Log.info('ability onBackground');
  }

  /**
   * 初始化日志库并设置语言为中文*/
  private initLog(): void {
    dayjs.locale('zh-cn')
    Log.init({
      tag: 'ECX',
      domain: 0xEC00,
      close: false,
      isHilog: true,
      showLogLocation: true,
      logSize: 200
    })
  }

  /**
   * 将当前用户信息写入全局存储*/
  private storeCurrentUser(): void {
    AppStorage.setOrCreate(CURRENT_USER, new Tiktok(this.context).getCurrentUser())
  }

  /**
   * 将屏幕宽度、安全区高度等布局尺寸写入全局存储
   * 通过屏幕像素密度换算vp 不依赖UIContext 保证页面创建前即可读取*/
  private storeScreenMetrics(win: window.Window): void {
    const displayInfo = display.getDefaultDisplaySync()
    const px2vp = (px: number): number => px / displayInfo.densityPixels
    const safeArea = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM)
    AppStorage.setOrCreate(Constants.SCREEN_WIDTH, px2vp(displayInfo.width))
    AppStorage.setOrCreate(Constants.BTN_TITLE_WIDTH, 0)
    AppStorage.setOrCreate(Constants.AREA_HEIGHT, px2vp(safeArea.topRect.height))
    AppStorage.setOrCreate(Constants.BOTTOM_HEIGHT, px2vp(safeArea.bottomRect.height))
  }
}
