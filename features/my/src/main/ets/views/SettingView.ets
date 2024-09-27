import { auth, MkCell, MkCellGroup, MkNavbar, MkUser } from 'basic'
import { audio } from '@kit.AudioKit'

// import { MkCell, MkCellGroup } from '@mk/basic'

@Builder
function SettingsViewBuilder() {
  SettingsView()
}

@Component
export struct SettingsView {
  @StorageProp(auth.KEY) user: MkUser = {} as MkUser
  @Consume
  pageStack: NavPathStack

  @Builder
  ProfileBuilder() {
    Row({ space: 8 }) {
      Image(this.user.avatar)
        .width(50)
        .aspectRatio(1)
        .borderRadius(25)
      Column({ space: 4 }) {
        Text(this.user.nickname || this.user.account)
          .fontColor($r('[basic].color.black'))
          .fontWeight(500)
        Text('账号名：' + this.user.account)
          .fontColor($r('[basic].color.gray'))
          .fontSize(12)
      }
      .alignItems(HorizontalAlign.Start)
    }
    .padding({ top: 16, bottom: 16 })
  }

  build() {
    NavDestination() {
      Column() {
        MkNavbar({
          title: '设置',
          leftClickHandler: () => {
            // 点击返回
            this.pageStack.pop()
          }
        })
        Column({ space: 8 }) {


          MkCellGroup() {
            MkCell({
              hasBorder: false, customLabel: () => {
                this.ProfileBuilder()
              }
            })
          }

          MkCellGroup() {
            MkCell({ label: '收货地址管理' })
            MkCell({ label: '账号安全' })
            MkCell({ label: '消息设置' })
            MkCell({ label: '隐私设置' })
            MkCell({ label: '通用设置', hasBorder: false })
          }

          if (this.user.token) {
            MkCellGroup() {
              MkCell({ label: '退出登录', hasBorder: false })
                .onClick(() => {

                  AlertDialog.show({
                    title: '退出登录',
                    message: '确定退出登录？',
                    autoCancel: true,

                    buttons: [
                      {
                        value: '取消',
                        fontColor: "#000",
                        action: () => {
                        }
                      },
                      {
                        value: '确定',
                        fontColor: "#fff",
                        backgroundColor: '#000',
                        action: () => {
                          auth.removeUser()
                          this.pageStack.pop()
                        }
                      }
                    ]
                  })
                })
            }

          } else {
            Button('登录')
              .fontSize(20)
              .fontColor($r('[basic].color.red'))
              .height(50)
              .backgroundColor('#fff')
              .width('90%')
              .onClick(() => {
                this.pageStack.pushPath({ name: 'LoginView' })
              })

          }
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor($r('[basic].color.under'))
    }
    .hideTitleBar(true)

  }
}