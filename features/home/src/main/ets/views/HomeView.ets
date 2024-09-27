import {
  axiosInstance,
  BreakpointConstants,
  BreakPointType,
  HttpResponse,
  Logger,
  MkLoading,
  RequestAxios,
  ResponseType,
  MkGoods
} from 'basic'
import {
  getBannerApi,
  getCategoryApi,
  getHotGoodsApi,
  getNewGoodsApi,
  getOneStopApi,
  getRecommendApi,
  getSaleGoodsApi
} from '../apis'
import { DiscountGoodsComp, DiscountType } from '../components/DiscountGoodsComp'

import { Banner, CategoryItem, GoodsItemsDataSource, MkGoodsItem, Params } from '../viewmodel'


@Component
export struct HomeView {
  // 当前断点
  @StorageProp(BreakpointConstants.BREAK_POINT_KEY) breakpoint: string = ''
  // 轮播图
  @State banners: Banner[] = []
  // 分类
  @State categories: CategoryItem[] = []
  // 特惠推荐
  @State saleGoods: MkGoodsItem[] = []
  // 爆款推荐
  @State hotGoods: MkGoodsItem[] = []
  // 一站买全
  @State oneGoods: MkGoodsItem[] = []
  // 新鲜好物
  @State newGoods: MkGoodsItem[] = []
  // 推荐商品
  @State recommendGoodsLazy: GoodsItemsDataSource = new GoodsItemsDataSource()
  // @State recommendGoods: MkGoodsItem[] = []
  @State isendLoading: boolean = false
  @StorageProp(BreakpointConstants.TOP_SAFE_AREA) topHeight: number = 0
  //首页加载组件显示
  @State isLoading: boolean = true
  // 是否下拉刷新
  @State isRefresh: boolean = false
  @State high: number = 0
  page: number = 1
  scroller: Scroller = new Scroller()
  @Consume pageStack: NavPathStack

  async getEndData() {
    this.page++;
    let res = await getRecommendApi(this.page * 8)
    this.recommendGoodsLazy.reloadData(res.result as object[])
  }

  /*
  * 请求数据
   */
  async getData() {

    let arr =
      await Promise.allSettled([getBannerApi(), getCategoryApi(), getSaleGoodsApi(), getHotGoodsApi(), getOneStopApi(),
        getNewGoodsApi(), getRecommendApi()])
    if (arr[0].status == 'fulfilled') {
      this.banners = arr[0].value.result
    }
    if (arr[1].status == 'fulfilled') {
      this.categories = arr[1].value.result
    }
    if (arr[2].status == 'fulfilled') {
      arr[2].value.result.subTypes.forEach((item) => {
        this.saleGoods.push(...item.goodsItems.items)
      })
    }
    if (arr[3].status == 'fulfilled') {
      arr[3].value.forEach((item) => {
        this.hotGoods.push(...item.goodsItems.items)
      })
    }
    if (arr[4].status == 'fulfilled') {
      arr[4].value.result.subTypes.forEach((item) => {
        this.oneGoods.push(...item.goodsItems.items)
      })
    }
    if (arr[5].status == 'fulfilled') {
      this.newGoods = arr[5].value.result
    }
    if (arr[6].status == 'fulfilled') {
      this.recommendGoodsLazy.reloadData(arr[6].value.result as object[])
    }
    this.isLoading = false
    /* // 获取轮播图数据
     // let res = await getBannerApi()
     // this.banners = res.result
     //获取分类列表
     // let resCategory = await getCategoryApi()
     // 获取特惠推荐     // this.categories = resCategory.result
     // let resSale = await getSaleGoodsApi()
     // let resSaleList = resSale.result.subTypes
     // resSaleList.forEach((item) => {
     //   this.saleGoods.push(...item.goodsItems.items)
     // })
     // 获取爆款推荐
     // let resHot = await getHotGoodsApi()
     // resHot.forEach((item) => {
     //   this.hotGoods.push(...item.goodsItems.items)
     // })
     //一站买全
     // let resOne = await getOneStopApi()
     // resOne.result.subTypes.forEach((item) => {
     //   this.oneGoods.push(...item.goodsItems.items)
     // })
     // // 获取新鲜好物
     // let resNew = await getNewGoodsApi()
     // this.newGoods = resNew.result
     // //推荐列表
     // let resRecommend = await getRecommendApi();
     // this.recommendGoods = resRecommend.result*/
  }

  // 下拉刷新
  @Builder
  RefreshBuilder() {
    Row() {
      MkLoading()
    }

  }

  async aboutToAppear(): Promise<void> {
    // mock数据

    await this.getData()
    AppStorage.setOrCreate('categoryData', this.categories)
    // Logger.warn(res.data.result)
  }

  getSpace(): number | undefined {
    return new BreakPointType({
      sm: 14,
      md: 36,
      lg: 72
    }).getValue(this.breakpoint)
  }

  @Builder
  DiscountBuilder(params: Params) {

    Column() {
      Row({ space: 10 }) {
        Text(params.title)
          .fontColor($r('[basic].color.black'))
          .fontSize(14)
        Text(params.subTitle)
          .fontColor($r('[basic].color.text'))
          .fontSize(11)
      }
      .width('100%')
      .margin({ bottom: 10 })

      List({ space: this.getSpace() }) {
        ForEach(params.list, (item: MkGoodsItem) => {
          ListItem() {
            DiscountGoodsComp({ type: DiscountType.DISCOUNT, goods: item })
          }
        })
      }
      .width('100%')
      .height(116)
      .scrollBar(BarState.Off)
      .listDirection(Axis.Horizontal)
    }
    .height(160)
    .layoutWeight(1)
    .padding(10)
    .backgroundColor(params.bg)
    .borderRadius(8)
  }
  build() {
    if (this.isLoading) {
      MkLoading()
    } else {
      Refresh({ refreshing: $$this.isRefresh, builder: this.RefreshBuilder() }) {
        Scroll(this.scroller) {
          Column() {
            // 轮播图 + 搜索
            Stack({ alignContent: Alignment.Top }) {
              Swiper() {
                ForEach(this.banners, (item: Banner) => {
                  Image(item.imgUrl)
                })
              }.displayCount(new BreakPointType({
                xs: 1,
                sm: 1,
                md: 2,
                lg: 3
              }).getValue(this.breakpoint))
              .itemSpace(new BreakPointType({
                sm: 0,
                md: 10,
                lg: 20
              }).getValue(this.breakpoint))
              .indicator(
                this.breakpoint === BreakpointConstants.SM
                  ?
                DotIndicator.dot()
                  .itemWidth(8)
                  .itemHeight(4)
                  .color('#33191919')
                  .selectedItemWidth(24)
                  .selectedItemHeight(4)
                  .selectedColor('#191919')
                  :
                  false
              )

              Row() {
                Row({ space: 4 }) {
                  Image($r('[basic].media.ic_public_search'))
                    .width(16)
                    .height(16)
                    .fillColor($r('[basic].color.white'))
                  Text('搜索...')
                    .fontSize(14)
                    .fontColor($r('[basic].color.white'))
                }
                .backgroundColor('#33191919')
                .width('100%')
                .height(40)
                .borderRadius(20)
                .padding({ left: 12 })
              }
              .padding({ left: 16, right: 16, top: this.topHeight })
              .onClick(()=>{
                this.pageStack.pushPath({name:'SearchView'})
              })
            }
            .width('100%')

            // 分类
            Column({ space: 10 }) {
              // 分类
              List({ space: this.getSpace() }) {
                ForEach(this.categories, (item: CategoryItem) => {
                  ListItem() {
                    Column() {
                      Image(item.picture)
                        .width(56)
                        .aspectRatio(1)
                      Text(item.name)
                        .fontSize(10)
                        .fontColor('#CC191919')
                    }
                    .width(60)
                    .height(80)
                    .borderRadius(30)

                    .clip(true)
                    .backgroundImage(item.picture)
                    .backgroundImageSize(ImageSize.Contain)
                    .backgroundImagePosition(Alignment.Center)
                    .backgroundBlurStyle(
                      BlurStyle.BACKGROUND_ULTRA_THICK,
                      { scale: 0.25 }
                    )
                  }
                })
              }
              .width('100%')
              .height(92)
              .scrollBar(BarState.Off)
              .listDirection(Axis.Horizontal)
              .alignListItem(ListItemAlign.Center)


              // 特惠推荐
              Column({ space: 10 }) {
                Image($r('app.media.home_cmd_title'))
                  .width(150)
                  .height(20)
                Row() {
                  Image($r('app.media.home_cmd_inner'))
                    .width(86)
                    .height(116)
                  List({ space: this.getSpace() }) {
                    ForEach(this.saleGoods, (item: MkGoodsItem) => {
                      ListItem() {
                        DiscountGoodsComp({ goods: item })
                      }
                    })
                  }
                  .layoutWeight(1)
                  .width('100%')
                  .height(116)
                  .backgroundColor($r('[basic].color.white'))
                  .borderRadius({
                    topRight: 8,
                    bottomRight: 8
                  })
                  .padding({ right: 10, left: 10 })
                  .scrollBar(BarState.Off)
                  .listDirection(Axis.Horizontal)
                }
              }
              .width('100%')
              .height(166)
              .backgroundImage($r('app.media.home_cmd_sm'))
              .backgroundImageSize(ImageSize.Cover)
              .borderRadius(8)
              .padding(10)
              .alignItems(HorizontalAlign.Start)

              // 爆款推荐+一站买全
              Row({ space: 10 }) {
                this.DiscountBuilder({
                  title: '爆款推荐',
                  subTitle: '最受欢迎',
                  bg: '#EDF1FB',
                  list: this.hotGoods
                })
                this.DiscountBuilder({
                  title: '一站买全',
                  subTitle: '精心优选',
                  bg: '#FCF6EA',
                  list: this.oneGoods
                })
              }

              // 新鲜好物
              Column({ space: 10 }) {
                Image($r('app.media.home_new'))
                  .width(146)
                  .height(19)
                List({ space: this.getSpace() }) {
                  ForEach(this.newGoods, (item: MkGoodsItem) => {
                    ListItem() {
                      DiscountGoodsComp({ type: DiscountType.NEW, goods: item })
                    }
                  })
                }
                .width('100%')
                .height(116)
                .scrollBar(BarState.Off)
                .listDirection(Axis.Horizontal)
              }
              .width('100%')
              .height(156)
              .padding(10)
              .backgroundColor('#F7EFF5')
              .borderRadius(8)
              .alignItems(HorizontalAlign.Start)

              // 推荐商品
              WaterFlow() {
                LazyForEach(this.recommendGoodsLazy, (item: MkGoodsItem) => {
                  FlowItem() {
                    MkGoods({ goods: item })
                  }
                })
              }
              .height('100%')
              .columnsTemplate(new BreakPointType({
                sm: '1fr 1fr',
                md: '1fr 1fr 1fr',
                lg: '1fr 1fr 1fr 1fr'
              }).getValue(this.breakpoint))
              .columnsGap(8)
              .rowsGap(10)
              .onReachEnd(async () => {
                if (this.isendLoading == false) {
                  this.isendLoading = true
                  await this.getEndData()
                  this.isendLoading = false
                }
              })
              .nestedScroll({
                //滚动嵌套向前优先
                scrollForward: NestedScrollMode.PARENT_FIRST,
                //滚动嵌套自己向后优先
                scrollBackward: NestedScrollMode.SELF_FIRST
              })

              if (this.isendLoading) {
                //todo
                MkLoading()
              }

            }
            .padding({
              left: 8,
              right: 8,
              bottom: 10,
              top: this.topHeight
            })

          }
        }
        .scrollBar(BarState.Off)
      }.onRefreshing(async () => {
        await this.refreshData()
        // await this.getData()
        // this.isRefresh= false
      })
      .transition(TransitionEffect.OPACITY.animation({ duration: 400 }))

    }


  }

  private async refreshData() {
    await this.getData()
    this.isRefresh = false
    this.page = 1
  }
}