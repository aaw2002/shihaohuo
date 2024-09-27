import { auth, MkNavbar } from 'basic'
import { promptAction } from '@kit.ArkUI'
import { LoginApi } from '../apis'

@Builder
function LoginViewBuilder() {
  NavDestination() {
    LoginView()
  }.hideTitleBar(true)
}

@Component
export struct LoginView {
  @State @Watch('onInput') account: string = 'zhousg'
  @State @Watch('onInput') password: string = '12345'
  @State valid: boolean = false
  @State agree: boolean = false
  @Consume pageStack: NavPathStack

  onInput() {
    this.valid = this.account && this.password ? true : false
  }

  async onSubmit() {
    if (!this.agree) {
      return promptAction.showToast({ message: '请先勾选协议' })
    }
    try { //调用登录接口
      let res = await LoginApi({ account: this.account, password: this.password })
      //持久化登录信息
      auth.saveUser(res);
      promptAction.showToast({ message: '登录成功' })
      //返回上一页
      this.pageStack.pop()
    } catch (e) {
      this.getUIContext().getFocusController().clearFocus()
      promptAction.showToast({ message: '登录失败请重新登录' })
    }
  }

  @Styles
  form() {
    .width('100%')
    .height(42)
    .padding({
      left: 16,
      right: 16,
      top: 0,
      bottom: 0
    })
  }

  build() {
    NavDestination() {
      Column() {
        MkNavbar({
          leftClickHandler: () => {
            this.pageStack.pop()
          }
        })

        Column({ space: 16 }) {
          Text('账号密码登录')
            .fontSize(18)
            .fontColor($r('[basic].color.black'))
            .width('100%')
            .fontWeight(500)
            .margin({ bottom: 10 })
          TextInput({ placeholder: '请输入账号', text: $$this.account })
            .placeholderColor($r('[basic].color.gray'))
            .placeholderFont({ size: 14 })
            .form()
          TextInput({ placeholder: '请输入密码', text: $$this.password })
            .type(InputType.Password)
            .showPasswordIcon(false)
            .placeholderColor($r('[basic].color.gray'))
            .placeholderFont({ size: 14 })
            .form()

          Row({ space: 4 }) {
            Checkbox()
              .select($$this.agree)
              .width(12)
              .aspectRatio(1)
              .selectedColor($r('[basic].color.black'))
              .mark({ size: 10, strokeWidth: 1 })
            Text() {
              Span('查看并同意')
              Span('《隐私条款》')
                .fontColor('#007DFB')
              Span('和')
              Span('《用户协议》')
                .fontColor('#007DFB')
            }
            .width('100%')
            .fontSize(12)
            .fontColor($r('[basic].color.gray'))
          }

          Button('登录')
            .backgroundColor(this.valid ? $r('[basic].color.black') : '#D4D2D9')
            .fontColor($r('[basic].color.white'))
            .form()
            .onClick(() => {
              this.onSubmit()
            })

          Row() {
            Blank()
            Text('忘记密码')
              .fontColor('#007DFB')
              .fontSize(12)
          }
          .width('100%')

          Column({ space: 16 }) {
            Stack() {
              Text()
                .width(200)
                .height(1)
                .backgroundColor($r('[basic].color.under'))
              Text('其他登录方式')
                .width(100)
                .fontSize(12)
                .backgroundColor($r('[basic].color.white'))
                .fontColor($r('[basic].color.text'))
                .textAlign(TextAlign.Center)
            }

            Row() {
              // 后续放置华为登录
            }
          }
          .margin({ top: 200 })
        }
        .padding(30)
      }
      .width('100%')
      .height('100%')
    }
    .hideTitleBar(true)
  }
}