import { router } from '@kit.ArkUI';
import { webview } from '@kit.ArkWeb';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

import { AppConfig } from '../common/AppConfig';

const DOMAIN: number = 0x0000;
const TAG: string = 'FoloIndex';

@Entry
@Component
struct Index {
  private controller: webview.WebviewController = new webview.WebviewController();
  @State url: string = '';
  @State progress: number = 0;
  @State showProgress: boolean = true;
  @State failed: boolean = false;

  aboutToAppear(): void {
    AppConfig.getUrl(getContext(this)).then((value: string) => {
      this.url = value;
    });
  }

  onPageShow(): void {
    AppConfig.getUrl(getContext(this)).then((value: string) => {
      if (value !== this.url) {
        this.url = value;
        this.failed = false;
      }
    });
  }

  /** Keeps the system back gesture inside the web history before leaving the app. */
  onBackPress(): boolean {
    try {
      if (this.controller.accessBackward()) {
        this.controller.backward();
        return true;
      }
    } catch (error) {
      const err = error as BusinessError;
      hilog.error(DOMAIN, TAG, `backward failed: ${err.code} ${err.message}`);
    }
    return false;
  }

  private goBack(): void {
    try {
      if (this.controller.accessBackward()) {
        this.controller.backward();
      }
    } catch (error) {
      const err = error as BusinessError;
      hilog.error(DOMAIN, TAG, `backward failed: ${err.code} ${err.message}`);
    }
  }

  private refresh(): void {
    try {
      this.controller.refresh();
    } catch (error) {
      const err = error as BusinessError;
      hilog.error(DOMAIN, TAG, `refresh failed: ${err.code} ${err.message}`);
    }
  }

  private goHome(): void {
    try {
      this.controller.loadUrl(this.url);
    } catch (error) {
      const err = error as BusinessError;
      hilog.error(DOMAIN, TAG, `loadUrl failed: ${err.code} ${err.message}`);
    }
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
          this.goBack();
        })

        Button({ type: ButtonType.Circle }) {
          Text('⟳')
            .fontSize(16)
            .fontColor($r('sys.color.font_primary'))
        }
        .width(36)
        .height(36)
        .backgroundColor(Color.Transparent)
        .onClick(() => {
          this.refresh();
        })

        Button({ type: ButtonType.Circle }) {
          Text('⌂')
            .fontSize(16)
            .fontColor($r('sys.color.font_primary'))
        }
        .width(36)
        .height(36)
        .backgroundColor(Color.Transparent)
        .onClick(() => {
          this.goHome();
        })

        Blank()

        Button({ type: ButtonType.Circle }) {
          Text('⚙')
            .fontSize(16)
            .fontColor($r('sys.color.font_primary'))
        }
        .width(36)
        .height(36)
        .backgroundColor(Color.Transparent)
        .onClick(() => {
          router.pushUrl({ url: 'pages/Settings' });
        })
      }
      .width('100%')
      .height(48)
      .padding({ left: 12, right: 12 })

      if (this.showProgress) {
        Progress({ value: this.progress, total: 100, type: ProgressType.Linear })
          .width('100%')
          .height(2)
          .color('#FF5C00')
      }

      if (this.url.length > 0) {
        Web({ src: this.url, controller: this.controller })
          .width('100%')
          .layoutWeight(1)
          .javaScriptAccess(true)
          .domStorageAccess(true)
          .databaseAccess(true)
          .fileAccess(false)
          .imageAccess(true)
          .onlineImageAccess(true)
          .mixedMode(MixedMode.Compatible)
          .cacheMode(CacheMode.Default)
          .darkMode(WebDarkMode.Auto)
          .onProgressChange((event) => {
            this.progress = event.newProgress;
            this.showProgress = event.newProgress < 100;
          })
          .onPageBegin(() => {
            this.failed = false;
          })
          .onPageEnd(() => {
            this.showProgress = false;
          })
          .onErrorReceive(() => {
            this.failed = true;
            this.showProgress = false;
          })
      } else {
        Column() {
          LoadingProgress()
            .width(48)
            .height(48)
            .color('#FF5C00')
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('sys.color.background_primary'))
  }
}
