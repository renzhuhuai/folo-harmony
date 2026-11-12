import { router } from '@kit.ArkUI';

import { AppConfig, DEFAULT_URL } from '../common/AppConfig';

@Entry
@Component
struct Settings {
  @State url: string = '';
  @State loaded: boolean = false;

  aboutToAppear(): void {
    AppConfig.getUrl(getContext(this)).then((value: string) => {
      this.url = value;
      this.loaded = true;
    });
  }

  build() {
    Column() {
      Row() {
        Button({ type: ButtonType.Circle }) {
          Text('‹')
            .fontSize(22)
            .fontColor($r('sys.color.font_primary'))
        }
        .width(36)
        .height(36)
        .backgroundColor(Color.Transparent)
        .onClick(() => {
          router.back();
        })

        Text('设置')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.font_primary'))
      }
      .width('100%')
      .height(48)
      .padding({ left: 12, right: 12 })

      Column({ space: 12 }) {
        Text('网页版地址')
          .fontSize(14)
          .fontColor($r('sys.color.font_secondary'))
          .width('100%')

        TextInput({ text: this.url, placeholder: DEFAULT_URL })
          .width('100%')
          .height(44)
          .fontSize(14)
          .backgroundColor($r('sys.color.comp_background_tertiary'))
          .onChange((value: string) => {
            this.url = value;
          })

        Row({ space: 12 }) {
          Button('保存')
            .layoutWeight(1)
            .height(40)
            .backgroundColor('#FF5C00')
            .onClick(() => {
              const next: string = this.url.trim().length > 0 ? this.url.trim() : DEFAULT_URL;
              AppConfig.setUrl(getContext(this), next).then(() => {
                router.back();
              });
            })

          Button('恢复默认')
            .layoutWeight(1)
            .height(40)
            .backgroundColor($r('sys.color.comp_background_tertiary'))
            .fontColor($r('sys.color.font_primary'))
            .onClick(() => {
              this.url = DEFAULT_URL;
              AppConfig.setUrl(getContext(this), DEFAULT_URL).then(() => {
                router.back();
              });
            })
        }
        .width('100%')

        Text('AI 的自定义 Key 在网页版里配置：设置 → AI → Bring Your Own Key，填 Base URL、模型和 API Key。')
          .fontSize(12)
          .fontColor($r('sys.color.font_secondary'))
          .width('100%')
          .margin({ top: 8 })

        Text('如果 app.folo.is 打不开，可以换成你自己部署的 Folo 网页地址。')
          .fontSize(12)
          .fontColor($r('sys.color.font_secondary'))
          .width('100%')
      }
      .padding(16)
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('sys.color.background_primary'))
  }
}
