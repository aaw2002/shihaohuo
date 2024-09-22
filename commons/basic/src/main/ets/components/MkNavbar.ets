import { router } from '@kit.ArkUI'

@Component
export struct MkNavbar {
  // 顶部安全区域
  @StorageProp('topHeight') topHeight: number = 0
  @Prop title: string = ''
  // leftIcon	ResourceStr	 左侧图标	ic_public_left
  @Prop leftIcon: ResourceStr = $r('app.media.ic_public_left')
  // rightIcon	ResourceStr	 右侧图标	ic_public_more
  @Prop rightIcon: ResourceStr = $r('app.media.ic_public_more')
  // showLeftIcon	boolean	是否显示左侧图标	 true
  @Prop showLeftIcon: boolean = true
  // showRightIcon	boolean	是否显示右侧图标	 false
  @Prop showRightIcon: boolean = false
  //   color	ResourceColor	 文字+图标颜色	app.color.black
  @Prop color: ResourceColor = $r('app.color.black')
  //   bg	ResourceColor	背景颜色	 app.color.white
  @Prop bg: ResourceColor = $r('app.color.white')
  //   leftClickHandler	()=>void	点击左侧图标逻辑	()=>{}
  leftClickHandler: () => void = () => {
  }
  // rightClickHandler	()=>void	点击右侧图标逻辑	()=>{}
  rightClickHandler: () => void = () => {
  }

  // customTitle	BuilderParam	自定义中间标题区域	文本标题
@BuilderParam customTitle:()=>void =this.titleBuilder

  build() {
    Row() {
      Row() {
        if (this.showLeftIcon) {
          Image(this.leftIcon)
            .width(24)
            .aspectRatio(1)
            .fillColor(this.color)
            .onClick(() => {
              this.leftClickHandler()
            })
        }
      }
      .width(50)
      .aspectRatio(1)
      .justifyContent(FlexAlign.Center)

      this.customTitle()

      Row() {
        if (this.showRightIcon) {
          Image(this.rightIcon)
            .width(24)
            .aspectRatio(1)
            .fillColor(this.color)
            .onClick(()=>{
              this.rightClickHandler()
            })
        }
      }
      .width(50)
      .aspectRatio(1)
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height(50 + this.topHeight)
    .backgroundColor(this.bg)
    .padding({ top: this.topHeight })
  }

  @Builder
  titleBuilder() {
    Text(this.title)
      .fontSize(16)
      .fontWeight(500)
      .layoutWeight(1)
      .textAlign(TextAlign.Center)
      .fontColor(this.color)
  }
}