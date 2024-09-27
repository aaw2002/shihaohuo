import { RequestAxios } from '../utils/Request'
import { GoodsItems } from '../viewmodel/index'

export  async function getGuessLikeApi(){
      let res= await RequestAxios.get<GoodsItems>('/home/goods/guessLike');
      return res.data.result
  }
