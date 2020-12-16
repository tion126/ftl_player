import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_forbidshot/flutter_forbidshot.dart';
import 'package:ftl_player/ftl_orientation.dart';
import 'package:ftl_player/ftl_player.dart';
import 'package:ftl_player/ftl_player_controller.dart';
import 'package:screen/screen.dart';
import 'ftl_player_fullscreen.dart';
import 'ftl_player_state_notifier.dart';

abstract class FTLPlayerEventHandler{
  void playerStateChange(FTLPlayerState state);
  void screenOrientationChange(DeviceOrientation orientation);
  void didTapBack();
  void needRefresh();
}

class FTLPlayerWraperController extends ChangeNotifier {
  FTLPlayerController playerController;
  FTLPlayerStateNotifier notifier;

  static Future<FTLPlayerWraperController> init() async {
    FTLPlayerWraperController wraperController = FTLPlayerWraperController();
    wraperController.playerController = await FTLPlayer.init(configs: TXLivePlayConfig(enableHWAcceleration: true));
    wraperController.hideTimerStart();
    wraperController.notifier = FTLPlayerStateNotifier(FTLPlayerStateValue());
    wraperController.playerController.channel
        .setMethodCallHandler(wraperController.notifier.callHandler);
    wraperController.notifier.addListener(wraperController.stateListener);
    ftlOrientation.addListener(wraperController.onDeviceOrientationEvent);

    return wraperController;
  }

  @override
  void dispose() {
    super.dispose();
    this.playerController.channel
        .setMethodCallHandler(null);
    this.notifier.removeListener(this.stateListener);
    ftlOrientation.removeListener(this.onDeviceOrientationEvent);
    this.timer?.cancel();
    Screen.keepOn(false);
  }

  /*封装事件回调 */
  FTLPlayerEventHandler handler;

  /*ctx */
  BuildContext ctx;

  /*锁定屏幕 */
  bool lock = false;

  /*当前方向 */
  DeviceOrientation playerOrientation = DeviceOrientation.portraitUp;

  /*是否全屏 */
  bool get fullScreen{
    return playerOrientation == DeviceOrientation.landscapeLeft || playerOrientation == DeviceOrientation.landscapeRight;
  }

  /* 当前的状态 */
  FTLPlayerState state;

  /*控制层是否显示 */
  bool showControl = false;

  /*调节音量中 */
  bool showVolume = false;

  /*调节亮度中 */
  bool showBrightness = false;

  /*显示控制菜单 */
  bool showMenu   = false;

  /*音量描述 */
  String volumeText = "";

  /*音量icon */
  IconData volumeIcon;

  /*亮度描述 */
  String brightnessText = "";

  /*亮度icon */
  IconData brightnessIcon;

  /*音量数值 */
  double volume = 0.0;

  /*亮度数值 */
  double brightness = 0.0;

  /*是否开启硬解 */
  bool   enableHWAcceleration = false;

  /*隐藏控制层 */
  Timer timer;

  /*marquee */
  String marqueeContent = "test121dcewc";

  /*比例 */
  double ratio;
  
  /*全屏是否自动适配比例 */
  bool aotuRatio = false;

  void stateListener() {

    if (this.notifier.value.state != this.state) {
      this.state = this.notifier.value.state;
      //常亮
      Screen.keepOn(this.notifier.value.state == FTLPlayerState.Buffering || this.notifier.value.state == FTLPlayerState.Playing);
      
      this.handler?.playerStateChange(state);

      switch (this.notifier.value.state) {
        case FTLPlayerState.Failed:
          break;
        case FTLPlayerState.Buffering:
          break;
        case FTLPlayerState.Playing:
          break;
        case FTLPlayerState.Stopped:
          break;
        case FTLPlayerState.Pause:
          break;
        default:
      }
    }
    print(this.notifier.value.eventParam);
    this.state = this.notifier.value.state;

    if (this.notifier.value.width > 0 && this.notifier.value.height > 0) {

      var newRatio = this.notifier.value.width / this.notifier.value.height;
      if (newRatio != this.ratio) {
        this.ratio = newRatio;
        this.notifyListeners();
      }else{
        this.ratio = newRatio;
      }
    }
  }

  void onTap() {
    this.showControl = !this.showControl;
    if (this.showControl) {
      this.hideTimerStart();
    }
    this.notifyListeners();
  }

  void onRefresh(){
    this.handler?.needRefresh();
  }

  void onLock() {
    this.lock = !this.lock;
    if (!this.lock) {
      this.showControl = true;
    }
    this.notifyListeners();
  }

  void onPlay() {
    if (this.notifier.playing) {
      this.playerController.pause().then((value) {
        this.notifier.state = FTLPlayerState.Pause;
      });
    } else {
      this.playerController.resume().then((value) {
        this.notifier.state = FTLPlayerState.Playing;
      });
    }
  }

  //**纵向手势 */
  void onDragGesture(Size size, detail) async {

    if (detail is DragStartDetails) {
      await syncDeviceData();
      return;
    }

    if (detail is DragEndDetails) {
      this.showVolume = false;
      this.showBrightness = false;
      notifyListeners();
      return;
    }

    if (detail.localPosition.dx > size.width / 2) {
      this.showVolume = true;
      this.showBrightness = false;
      double v = (this.volume - detail.delta.dy * 0.01)
          .clamp(0.0, 1.0);
      this.setVolume(v);
      var icons = [Icons.volume_down_sharp, Icons.volume_up_sharp];
      this.volumeIcon = icons[(v * 2.0).floor()];
      this.volumeText = "${(v * 100).toStringAsFixed(0)}%";
      this.notifyListeners();
    } else {
      this.showVolume = false;
      this.showBrightness = true;
      double b =
          (this.brightness - detail.delta.dy * 0.01).clamp(0.0, 1.0);
      this.setBrightness(b);
      var icons = [
        Icons.brightness_low_sharp,
        Icons.brightness_medium_sharp,
        Icons.brightness_high_sharp
      ];
      this.brightnessIcon = icons[(b * 3.0).floor()];
      this.brightnessText = "${(b * 100).toStringAsFixed(0)}%";
      print(this.brightnessText);
      this.notifyListeners();
    }
  }

  syncDeviceData() async{
    this.brightness = await Screen.brightness;
    this.volume = await FlutterForbidshot.volume;
    this.enableHWAcceleration = await this.playerController.enableHWAcceleration();
  }

  void setVolume(double v) {
    this.volume = v;
    FlutterForbidshot.setVolume(v);
    notifyListeners();
  }

  void setBrightness(double b){
    this.brightness = b;
    Screen.setBrightness(b);
    notifyListeners();
  }

  void setEnableHWAcceleration(bool e){
    this.enableHWAcceleration = e;
    this.playerController.setEnableHWAcceleration(e);
    this.notifier.state = FTLPlayerState.Buffering;
    notifyListeners();
  }

  void setAutoRatio(bool e){
    this.aotuRatio = e;
    notifyListeners();
  }

  void hideTimerStart() {
    if (this.timer != null) {
      this.timer.cancel();
      this.timer = null;
    }

    this.timer = Timer(Duration(seconds: 5), () {
      this.showControl = false;
      this.notifyListeners();
      this.timer = null;
    });
  }

  void onDeviceOrientationEvent(){
      this.switchScreenOrientation(ctx,ftlOrientation.value);
  }

  void switchScreenOrientation(
      BuildContext ctx, DeviceOrientation orientation) { 
    
    if (this.playerOrientation == orientation || this.lock || orientation == DeviceOrientation.portraitDown) {
      return;
    }

    if ((this.playerOrientation == DeviceOrientation.portraitUp || this.playerOrientation == DeviceOrientation.portraitDown) && (orientation == DeviceOrientation.landscapeLeft || orientation == DeviceOrientation.landscapeRight)) {
      
      Navigator.of(ctx).push(CupertinoPageRoute(builder: (_)=>FTLPlayerFullScreen(this)));
      SystemChrome.setEnabledSystemUIOverlays([]);
    }

    if ((this.playerOrientation == DeviceOrientation.landscapeLeft || this.playerOrientation == DeviceOrientation.landscapeRight) && (orientation == DeviceOrientation.portraitUp || orientation == DeviceOrientation.portraitDown)) {
      
      Navigator.of(ctx).pop();
      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top,SystemUiOverlay.bottom]);
    }

    this.playerOrientation = orientation;
    SystemChrome.setPreferredOrientations([orientation]);
    this.handler?.screenOrientationChange(orientation);
    this.notifyListeners();
  }

  void back(){
    if (this.fullScreen) {
      this.switchScreenOrientation(ctx,DeviceOrientation.portraitUp);
      return;
    }
    this.handler?.didTapBack();
  }

  void onMenu() async{
    this.showMenu = !this.showMenu;
    if (this.showMenu) {
      await this.syncDeviceData();
    }
    this.notifyListeners();
  }

}