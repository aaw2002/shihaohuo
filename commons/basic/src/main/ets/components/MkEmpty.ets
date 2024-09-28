@Component
export struct MkEmpty {
  @Prop tip:string='购物车空空~~';
  @Prop buttonText:string='去逛逛';
  @Prop icon:ResourceStr=	$r('app.media.ic_public_empty')
  onClickButton:()=>void=()=>{}
  build() {
    Column({ space: 20 }) {
      Image($r('app.media.ic_public_empty'))
        .width(120)
        .aspectRatio(1)
      Text(this.tip)
        .fontSize(12)
        .fontColor($r('app.color.gray'))
      Button(this.buttonText)
        .fontSize(12)
        .height(26)
        .padding({ left: 20, right: 20 })
        .linearGradient({
          angle: 90,
          colors: [['#FD3F8F', 0], ['#FF773C', 1]]
        })
        .margin({ bottom: 20 })
        .onClick(()=>{
          this.onClickButton()
        })
    }
    .padding(40)
    .width('100%')
  }
}