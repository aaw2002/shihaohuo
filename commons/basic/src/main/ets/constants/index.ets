// commons/basic/src/main/ets/constants/index.ets
import { emitter } from '@kit.BasicServicesKit';

export class BreakpointConstants {
  // 手表等超小屏
  static readonly XS: string = 'xs';
  // 手机竖屏
  static readonly SM: string = 'sm';
  // 手机横屏，折叠屏
  static readonly MD: string = 'md';
  // 平板，2in1 设备
  static readonly LG: string = 'lg';
  // AppStorage 中的 key
  static readonly BREAK_POINT_KEY: string = 'currentBreakpoint'
  //顶部安全距离
  static readonly TOP_SAFE_AREA: string = 'topHeight'
  //底部安全距离
  static readonly BOTTOM_SAFE_AREA: string = 'bottomHeight';


}

export class EmitterKey {
  // 切换到指定的 tab
  static CHANGE_TAB: emitter.InnerEvent = { eventId: 10001 }
}