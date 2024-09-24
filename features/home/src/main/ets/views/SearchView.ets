@Builder
function SearchViewBuilder() {
  NavDestination() {
    SearchView()
  }.hideTitleBar(true)
}

@Component
struct SearchView {
  // 封装成组件后，可通过 @Consume 获取页面栈对象
  @Consume pageStack: NavPathStack

  build() {
    Column() {
      Text('邦政哈哈哈')
      Button('邦政回去').onClick(() => {
        // 返回上一页
        this.pageStack.pop()
      })
    }.width('100%')
    .height("100%")
    .justifyContent(FlexAlign.Center)
  }
}