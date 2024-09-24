import { BreakpointConstants, BreakPointType, CategoryItem, CategoryItemChild, MkNavbar } from 'basic'
import { promptAction } from '@kit.ArkUI'

@Component
export struct CategoryView {
  //  Mock分类数据
  // categories: CategoryItem[] = new Array(10).fill({
  //   id: "1181622001",
  //   name: "气质女装",
  //   picture: "https://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/meikou/c1/qznz.png"
  // })
  @State activeIndex: number = 0
  @StorageProp('topHeight') topHeight: number = 0
  @StorageProp('categoryData') categories: CategoryItem[] = []
  // 当前断点
  @StorageProp(BreakpointConstants.BREAK_POINT_KEY) breakpoint: string = ''
  scroller: Scroller = new Scroller()

  build() {
    Column() {
      MkNavbar({
        title: '商品分类',
        showLeftIcon: false,
        rightIcon: $r('[basic].media.ic_public_search'),
        showRightIcon: true,
        rightClickHandler: () => {
          promptAction.showToast({
            message: '别打扰邦政看片',
            alignment: Alignment.Center
          })
        },

        // customTitle: this.titleBuilder
      })
        .border({ width: { bottom: 0.5 }, color: $r('[basic].color.under') })

      Row() {
        Column() {
          ForEach(this.categories, (item: CategoryItem, i) => {
            Text(item.name)// 文本
              .backgroundColor(this.activeIndex === i ? $r('[basic].color.black') : $r('[basic].color.white'))
              .fontSize(14)
              .fontColor(this.activeIndex === i ? $r('[basic].color.white') : $r('[basic].color.black'))
              .textAlign(TextAlign.Center)
              .width('100%')
              .height(56)
              .onClick(() => {
                animateTo({ duration: 300 }, () => {
                  this.activeIndex = i
                })
                this.scroller.scrollEdge(Edge.Top)
              })

          })
        }
        .width(88)
        .border({ width: { right: 0.5 }, color: $r('[basic].color.under') })

        Scroll(this.scroller) {
          Column() {
            // 顶部图片
            Image(this.categories[this.activeIndex]?.picture)
              .width('100%')
              .height(new BreakPointType({
                sm: 134, md: 200, lg: 250
              }).getValue(this.breakpoint))
              .objectFit(ImageFit.Contain)
              .backgroundColor('#f6f6f6')
              .borderRadius(8)
              .margin({ bottom: 8 })
            GridRow({
              columns: { sm: 2, md: 3, lg: 4 }, gutter: 8
            }) {
              // 子分类
              ForEach(this.categories[this.activeIndex]?.children, (sub: CategoryItemChild) => {
                GridCol() {
                  Column() {
                    // 图片
                    Image(sub.picture)
                      .width(64)
                      .aspectRatio(1)
                    Text(sub.name)// 文本
                      .fontSize(14)
                      .fontColor($r('[basic].color.text'))
                      .margin({ top: 8 })
                  }
                  .height('100%')
                  .justifyContent(FlexAlign.Center)
                }
                .aspectRatio(1)
                .backgroundColor('#f6f6f6')
                .borderRadius(8)
              })
            }
          }
          .padding(8)
        }
        .layoutWeight(1)
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring)
      }
      .layoutWeight(1)
      .alignItems(VerticalAlign.Top)
    }
    .width('100%')
    .height('100%')
  }
}