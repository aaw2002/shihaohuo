import { CustomContentDialog } from '@ohos.arkui.advanced.Dialog'

@Component
export struct MkCell {
  @Prop label: string = '' //左侧文字
  @Prop value: string = '' //右侧文字
  @Prop
  icon: ResourceStr = $r('app.media.ic_public_right')// 右侧图标
  @Prop
  hasBorder: boolean = true// 是否显示底部边框
  @BuilderParam
  customLabel: () => void = this.LabelBuilder// 左侧自定义
  @BuilderParam
  customIcon: () => void = this.IconBuilder// 右侧自定义

  @Builder
  LabelBuilder() {
    // 文本
    Text(this.label)
      .fontSize(14)
      .fontColor($r('app.color.black'))
  }

  @Builder
  IconBuilder() {
    Text(this.value)
      .fontSize(14)
      .fontColor($r('app.color.gray'))
  }

  build() {
    Row({ space: 8 }) {

      this.customLabel()
      Blank()
      this.customIcon
      // 图标
      Image($r('app.media.ic_public_right'))
        .width(20)
        .aspectRatio(1)
        .fillColor($r('app.color.gray'))
    }
    .width('100%')
    .constraintSize({ minHeight: 50 })
    .border({ width: { bottom: 1 }, color: $r('app.color.under') })
  }
}


@Component
export struct MkCellGroup {
  @BuilderParam customLabel: () => void = this.defaultBuilder

  @Builder
  defaultBuilder() {

  }

  build() {
    Column() {
      // 子组件放置的位置
      this.customLabel()
    }
    .border({
      width: { top: 0.6, bottom: 0.6 },
      color: $r('app.color.under')
    })
    .padding({ left: 16, right: 16 })
    .backgroundColor($r('app.color.white'))
  }
}