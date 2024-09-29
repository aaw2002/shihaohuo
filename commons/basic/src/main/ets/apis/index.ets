import { RequestAxios } from '../utils/Request'
import { GoodsItems } from '../viewmodel/index'

export  async function getGuessLikeApi(){
      let res= await RequestAxios.get<GoodsItems>('/home/goods/guessLike');
      return res.data.result
  }


interface AddParams {
  skuId: string
  count: number
}


export class Cart {
  // 添加
  async add(data: AddParams) {
    return await RequestAxios.post<null>('/member/cart', data)
  }
}

export const cart = new Cart()