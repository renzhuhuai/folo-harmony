# Folo for HarmonyOS

鸿蒙原生外壳版 Folo：界面用 ArkTS/ArkUI，内容区用系统 `Web` 组件加载 Folo 网页版，
AI 的「自定义 Key（BYOK）」直接在网页版里配置，因此翻译和总结走你自己的接口。

## 结构

```
AppScope/                     应用级配置（包名 is.follow.harmony、图标、版本）
entry/src/main/ets/
  entryability/EntryAbility.ets   入口 Ability
  pages/Index.ets                 主页面：工具栏 + Web 容器 + 进度条
  pages/Settings.ets              设置：可修改网页版地址
  common/AppConfig.ets            地址持久化（@ohos.data.preferences）
```

主页面工具栏提供：后退、刷新、回首页、设置。系统返回手势会先回退网页历史，再退出应用。

## 环境要求

- DevEco Studio 5.0 或更高（HarmonyOS NEXT / HarmonyOS 6/7 SDK，API 12 起）
- 华为开发者账号（免费注册），用于自动签名
- 真机或模拟器

## 构建与安装

1. DevEco Studio 打开本目录，等待 `Sync Now` 完成
2. `File → Project Structure → Signing Configs` 勾选 `Automatically generate signature`，登录华为账号
3. 连接手机（开发者模式 + USB 调试），点 `Run 'entry'`
4. 首次启动会加载 `https://app.folo.is/`

## 用自己的 API Key

在应用内进入 Folo 网页版的 `设置 → AI → Bring Your Own Key`：

- 选择提供商（OpenAI 兼容）
- 填 Base URL、API Key、模型
- 打开开关后，网页版的翻译和总结就用你自己的 Key

## 已知限制

- 依赖网页版：断网时只能看浏览器缓存；没有离线数据库
- 没有系统级推送通知
- 网页版打不开时，可在应用内「设置」里换成自己部署的 Folo 网页地址

## 后续可以做

- 原生底部导航（阅读 / 订阅 / 设置），把网页版收在阅读页
- 系统分享入口：其他应用「分享到 Folo」直接翻译、总结
- 原生 BYOK 设置页，供不依赖网页版的场景
- 深色模式、字号跟随系统
