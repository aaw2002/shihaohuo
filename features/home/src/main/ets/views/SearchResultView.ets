import { BreakpointConstants, BreakPointType, MkGoodsItem, MKPullToRefresh, RequestAxios } from 'basic'
import { searchGoodsApi } from '../apis'
import { MkGoods } from '../components/MkGoods'
import { GoodsItems, GoodsItemsDataSource } from '../viewmodel'
import { promptAction } from '@kit.ArkUI'
import { AudioSearchComp } from '../components/AudioSearchComp'

// 联合类型
export type SortField = 'publishTime' | 'orderNum' | 'price'

export type SortMethod = 'desc' | 'asc'

// 提交给服务器的参数
export interface SearchParams {
  keyword: string
  sortField: SortField
  sortMethod: SortMethod
  page: number
  pageSize: number
}

// 筛选条件
export interface SortCompAttr {
  field: SortField
  label: string
}


// 路由参数
interface RouterParam {
  keyword: string
}

export interface IServiceData {
  conditions: Conditions;
  pageData: GoodsItems;

}

export interface Conditions {
  brands: Brand[];
  categories: null;
}

export interface Brand {
  desc: null;
  id: string;
  logo: string;
  name: string;
  nameEn: string;
  picture: string;
  place: null;
  type: null;
}

@Builder
function SearchViewBuilder() {
  NavDestination() {
    SearchResultView()
  }
  .hideTitleBar(true)
}

@Component
export struct SearchResultView {
  //底部安全距离
  @StorageProp('bottomHeight') bottomHeight: number = 0
  //判断是否触底
  @State isEnd: boolean = true
  @StorageProp('topHeight') topHeight: number = 0
  @Consume pageStack: NavPathStack
  @StorageProp(BreakpointConstants.BREAK_POINT_KEY) breakpoint: string = ''
  // 顶部安全区域
  @StorageProp('safeTop') safeTop: number = 0
  // mock 数据
  // @State data: MkGoodsItem[] = []
  @State dataLazy: GoodsItemsDataSource = new GoodsItemsDataSource()
  // 查询参数
  @State
  @Watch('paramsChange')
  params: SearchParams =
    {
      keyword: '',
      sortField: 'publishTime',
      sortMethod: 'desc',
      page: 1,
      pageSize: 10
    }
  // 筛选条件
  sortList: SortCompAttr[] = [
    { label: '时间', field: 'publishTime' },
    { label: '销量', field: 'orderNum' },
    { label: '价格', field: 'price' }
  ]
  // 控制器
  scroller = new Scroller()
  //总页数
  @State totalPage: number = 0
  //当前页码
  @State page: number = 0

  async aboutToAppear(): Promise<void> {
    // TODO 接收路由参数
    this.params.keyword = this.pageStack.getParamByName('SearchResultView')[0] as string
    await this.getData()

  }

  private async getData() {
    this.params.page = 1
    let res = await searchGoodsApi(this.params)
    // this.data = res.pageData.items
    this.dataLazy.reloadData(res.pageData.items)
    this.totalPage = res.pageData.pages
  }

  paramsChange() {
  }

  //触底加载更多
  async lodeMore() {
    if (this.params.page < this.totalPage) {
      this.params.page++
      let res = await searchGoodsApi(this.params)
      // this.data.push(...res.pageData.items as MkGoodsItem[])
      res.pageData.items.forEach((item: MkGoodsItem) => {
        this.dataLazy.pushData(item)
      })
    }
  }

  build() {
    Column() {
      // 搜索区域
      Row() {
        Image($r('[basic].media.ic_public_left'))
          .width(24)
          .aspectRatio(1)
          .fillColor($r('[basic].color.white'))
          .margin(13)
          .onClick(() => {
            this.pageStack.pop()
          })
        Search({ placeholder: '商品关键字...', value: $$this.params.keyword })
          .searchIcon({ src: $r('[basic].media.ic_public_search'), color: $r('[basic].color.gray') })
          .placeholderColor($r('[basic].color.gray'))
          .placeholderFont({ size: 14 })
          .backgroundColor($r('[basic].color.white'))
          .textFont({ size: 14 })
          .layoutWeight(1)
          .padding(0)
          .margin(0)
          .height(36)
          .caretStyle({ color: $r('[basic].color.red') })
          .onSubmit(async (value) => {
            this.params.keyword = value
            let res = await searchGoodsApi(this.params)
            // this.data = res.pageData.items
            this.dataLazy.reloadData(res.pageData.items)
          })
      }
      .padding({ top: this.topHeight, right: 16 })
      .linearGradient({
        angle: 135,
        colors: [[$r('[basic].color.linear_begin'), 0], [$r('[basic].color.linear_end'), 1]]
      })

      // list
      Row() {
        ForEach(this.sortList, (item: SortCompAttr) => {
          // 筛选组件
          SortItemComp({
            label: item.label,
            field: item.field,
            sortField: this.params.sortField,
            sortMethod: this.params.sortMethod,
            onClickItem: async (sortField: SortField, sortMethod: SortMethod) => {
              // AlertDialog.show({ message: sortField + sortMethod })
              this.params.sortField = sortField
              this.params.sortMethod = sortMethod
              let res = await searchGoodsApi(this.params)
              // this.data = res.pageData.items
              this.dataLazy.reloadData(res.pageData.items)
            }

          })
        })
        Text('筛选')
          .fontSize(14)
          .fontColor($r('[basic].color.gray'))
      }
      .padding({ left: 16, right: 16 })
      .height(50)
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .border({ width: { bottom: 0.5 }, color: $r('[basic].color.border') })

      MKPullToRefresh({
        // data: $data,
        scroller: this.scroller,
        customList: () => {
          this.FlowBuilder()
        },
        onRefresh: async () => {
          //页码至一
          this.params.page = 1
          // 请求数据
          let res = await searchGoodsApi(this.params)
          animateTo({ duration: 500 }, () => {
            // this.data = res.pageData.items
            this.dataLazy.reloadData(res.pageData.items)
          })

          return '邦政温馨提示：刷新成功'
        },
        onLoadMore: async () => {
          this.lodeMore()
          return '邦政温馨提示：加载成功'
        }

      }).layoutWeight(1)

    }

  }

  @Builder
  FlowBuilder() {
    WaterFlow({ scroller: this.scroller }) {
      LazyForEach(this.dataLazy, (item: MkGoodsItem) => {
        FlowItem() {
          MkGoods({ goods: item, smallImage: true })
        }
      })

    }

    .columnsTemplate(new BreakPointType({
      sm: '1fr 1fr',
      md: '1fr 1fr 1fr',
      lg: '1fr 1fr 1fr 1fr'
    }).getValue(this.breakpoint))
    .columnsGap(0.5)
    .rowsGap(0.5)
    .layoutWeight(1)

    // .padding({ bottom: this.bottomHeight })
  }
}

@Component
struct SortItemComp {
  @StorageProp('topHeight') topHeight: number = 0
  // 筛选字段
  field: SortField = 'publishTime'
  // 显示的文本
  label: string = ''
  // 状态变量，接收父组件的状态属性
  // 父组件的筛选字段
  @Prop sortField: SortField = 'publishTime'
  // 父组件的排序方法
  @Prop sortMethod: SortMethod = 'desc'
  // TODO 点击筛选条件，回传  sortField 和 sortMethod 给父组件（回调函数）
  onClickItem: (sortField: SortField, sortMethod: SortMethod) => void = () => {

  }

  build() {
    Row() {
      Text(this.label)
        .fontWeight(500)
        .fontSize(14)
        .fontColor(this.sortField === this.field ? $r('[basic].color.black') : $r('[basic].color.gray'))
      Column() {
        Image($r('[basic].media.ic_public_up'))
          .width(15)
          .height(6)
          .fillColor(this.sortField === this.field && this.sortMethod === 'asc' ? $r('[basic].color.black') :
          $r('[basic].color.gray'))
        Image($r('[basic].media.ic_public_down'))
          .width(15)
          .height(6)
          .fillColor(this.sortField === this.field && this.sortMethod === 'desc' ? $r('[basic].color.black') :
          $r('[basic].color.gray'))
      }
      .justifyContent(FlexAlign.Center)
    }
    .onClick(() => {
      if (this.field == this.sortField) {
        this.onClickItem(this.field, this.sortMethod == 'desc' ? 'asc' : 'desc')
      } else {
        this.onClickItem(this.field, 'desc')
      }
    })
  }
}