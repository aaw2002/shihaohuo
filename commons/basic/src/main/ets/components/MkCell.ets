@Component
export struct MkCell {

  build() {
    Row({ space: 8 }) {

      // 文本
      Text('label')
        .fontSize(14)
        .fontColor($r('app.color.black'))
      Blank()
      Text('value')
        .fontSize(14)
        .fontColor($r('app.color.gray'))
      // 图标
      Image($r('app.media.ic_public_right'))
        .width(20)
        .aspectRatio(1)
        .fillColor($r('app.color.gray'))
    }
    .width('100%')
    .constraintSize({ minHeight: 50 })
    .border({ width: { bottom: 1}, color: $r('app.color.under') })
  }
}


@Component
export struct MkCellGroup {
  build() {
    Column() {
      // 子组件放置的位置
    }
    .border({
      width: { top: 0.6, bottom: 0.6 },
      color: $r('app.color.under')
    })
    .padding({ left: 16, right: 16 })
    .backgroundColor($r('app.color.white'))
  }
}