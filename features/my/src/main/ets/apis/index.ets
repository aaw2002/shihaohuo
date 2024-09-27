import { MkUser, RequestAxios } from 'basic'

export interface LoginData {
  account: string
  password: string
}

export async function  LoginApi(loginData: LoginData){
let res=await RequestAxios.post<MkUser>('/login',loginData)
  return res.data.result

}