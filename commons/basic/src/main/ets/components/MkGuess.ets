import { BreakpointConstants, BreakPointType } from '../../../../Index'
import { getGuessLikeApi } from '../apis'
import { MkGoodsItem } from '../viewmodel'
import { MkGoods } from './MkGoods'


@Component
export struct MkGuess {
  @State likeGoods: MkGoodsItem[] = []
  @State loading: boolean = false
  limit: number = 8
  @StorageProp(BreakpointConstants.BREAK_POINT_KEY) breakpoint: string = '';

  async aboutToAppear(): Promise<void> {

    await this.getData()

  }

  private async getData() {
    this.loading = true
    let res = await getGuessLikeApi()
    this.likeGoods = res.items
    this.loading = false
  }

  build() {
    Column() {
      Text('猜你喜欢')
        .fontSize(14)
        .fontWeight(500)
        .fontColor($r('app.color.black'))
        .width('100%')
        .height(50)
        .textAlign(TextAlign.Center)
        .backgroundColor($r('app.color.white'))
        .border({ width: { bottom: 0.5 }, color: $r('app.color.under') })
      if (this.loading) {
        Column() {
          Text('加载中...')
            .fontSize(14)
            .fontColor($r('app.color.gray'))
        }
        .height(400)
        .width('100%')
        .backgroundColor($r('app.color.white'))
        .padding({ top: 100 })
      } else {
        WaterFlow() {
          ForEach(this.likeGoods, (item: MkGoodsItem) => {
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
      }
    }
    .width('100%')

    .backgroundColor($r('app.color.under'))
  }
}