import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { auth, BreakpointConstants } from 'basic';
import { deviceInfo } from '@kit.BasicServicesKit';

export default class EntryAbility extends UIAbility  {
  private curBp: string = ''

  // 根据当前窗口尺寸更新断点
  private updateBreakpoint(windowWidth: number): void {
    // 将长度的单位由px换算为vp
    let windowWidthVp = px2vp(windowWidth)
    let newBp: string = ''
    if (windowWidthVp < 320) {
      newBp = BreakpointConstants.XS
    } else if (windowWidthVp < 600) {
      newBp = BreakpointConstants.SM
    } else if (windowWidthVp < 840) {
      newBp = BreakpointConstants.MD
    } else {
      newBp = BreakpointConstants.LG
    }
    if (this.curBp !== newBp) {
      this.curBp = newBp
      // 使用状态变量记录当前断点值
      AppStorage.setOrCreate(BreakpointConstants.BREAK_POINT_KEY, this.curBp)
    }
  }

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    windowStage.getMainWindow()
      .then((windowObj) => {
        // 获取应用启动时的窗口尺寸
        this.updateBreakpoint(windowObj.getWindowProperties()
          .windowRect
          .width)
        // 注册回调函数，监听窗口尺寸变化
        windowObj.on('windowSizeChange', (windowSize) => {
          this.updateBreakpoint(windowSize.width)
        })
      });
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index',  (err) => {
      if (deviceInfo.deviceType!='2in1'){
        // 开启全屏
        const win = windowStage.getMainWindowSync()
        win.setWindowLayoutFullScreen(true)

        // 获取安全区域
        const top = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM).topRect
        AppStorage.setOrCreate<number>(BreakpointConstants.TOP_SAFE_AREA, px2vp(top.height))
        const bottom = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR)
          .bottomRect
        AppStorage.setOrCreate<number>(BreakpointConstants.BOTTOM_SAFE_AREA, px2vp(bottom.height))
      }
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      //初始化用户信息类
      auth.initUser()

      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
