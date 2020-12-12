# ftl_player

基于TXLiteAVSDK_Player 腾讯播放器封装flutter sdk 目前支持直播，sdk只提供核心功能，具体功能需要自定义，example里有一套附带的ui。

左iOS    右安卓

pub地址 https://pub.dev/packages/ftl_player

![Image text](https://raw.githubusercontent.com/tion126/ftl_player/main/screenshot1.png)

![Image text](https://raw.githubusercontent.com/tion126/ftl_player/main/screenshot2.png)


简单使用
``` dart
Container(
    height: 200,
    child: FTLPlayerWraper((c) {
    this.wraperController = c;
    this.wraperController.handler = this;
    this.wraperController.playerController.startAutoType("11111");
}))
```
可以自定义修改UI，例如增加弹幕之类的功能，也可以播放其他平台的直播不一定要腾讯的。

目前已知问题 

1.安卓需要设置hls格式才可正常播放