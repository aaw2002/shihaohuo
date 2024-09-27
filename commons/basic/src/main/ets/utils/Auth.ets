export interface MkUser {
  token: string
  nickname: string
  avatar: string
  account: string
  // password:string
}

class Auth {
  KEY: string = 'user'

  //初始化用户信息
  initUser() {
    PersistentStorage.persistProp(auth.KEY, {})
  }

  getUser() {
    return AppStorage.get<MkUser>(this.KEY) || {} as MkUser
  }

  saveUser(user: MkUser) {
    AppStorage.setOrCreate<MkUser>(this.KEY, user)
  }

  removeUser() {
    AppStorage.setOrCreate<MkUser>(this.KEY, {} as MkUser)
  }
}

// 导出实例化对象
export const auth = new Auth()