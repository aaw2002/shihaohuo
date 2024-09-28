import { CartView } from 'cart';
import { HomeView } from 'home';
import { CategoryView } from 'category';
import { MyView } from 'my';
import { BreakpointConstants, Logger, MKNavPathStack } from 'basic'

interface TabItem {
  text: string
  normal: ResourceStr
  active: ResourceStr
}

@Entry
@Component
struct Index {
  @State activeIndex: number = 0
  @StorageProp('currentBreakpoint') breakpoint: string = '';
  @StorageProp('topHeight') topHeight: number = 0
  // @StorageProp('topHeight') topHeight: number = 0
  @StorageProp(BreakpointConstants.BOTTOM_SAFE_AREA) bottomHeight: number = 0
  list: TabItem[] = [
    { text: '首页', normal: $r('app.media.ic_public_home_normal'), active: $r('app.media.ic_public_home_active') },
    { text: '分类', normal: $r('app.media.ic_public_pro_normal'), active: $r('app.media.ic_public_pro_active') },
    { text: '购物袋', normal: $r('app.media.ic_public_cart_normal'), active: $r('app.media.ic_public_cart_active') },
    { text: '我的', normal: $r('app.media.ic_public_my_normal'), active: $r('app.media.ic_public_my_active') },
  ]
  // 创建一个路由栈对象，并配置到 Navigation 组件中
  @Provide pageStack: NavPathStack =MKNavPathStack

  aboutToAppear(): void {
    Logger.warn(this.list)
  }

  build() {
    Navigation(this.pageStack) {
      Tabs({ barPosition: BarPosition.End }) {
        ForEach(this.list, (item: TabItem, index: number) => {
          TabContent() {
            if (index === 0) {
              HomeView()
            } else if (index === 1) {
              CategoryView()
            } else if (index === 2) {
              CartView()
            } else {
              MyView()
            }
          }
          .tabBar(this.TabItemBuilder(item, index))
        })
      }
      .barPosition(this.breakpoint == BreakpointConstants.LG ? BarPosition.Start : BarPosition.End)
      .vertical(this.breakpoint == BreakpointConstants.LG ? true : false)
      .scrollable(false)
      .onTabBarClick(index => {
        this.activeIndex = index
      })
      .padding({ bottom: this.bottomHeight })
    }.mode(NavigationMode.Stack)
    .hideTitleBar(true)

  }

  @Builder
  TabItemBuilder(item: TabItem, index: number) {
    Column() {
      Image(this.activeIndex === index ? item.active : item.normal)
        .width(24)
        .aspectRatio(1)
      Text(item.text)// 跨 HSP 访问资源，需要在 oh-package.json5中导入
        .fontColor($r('[basic].color.black'))
        .fontSize(12)
    }
    .justifyContent(FlexAlign.SpaceEvenly)
    .height(50)
  }
}