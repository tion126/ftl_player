import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'ftl_player_constant.dart';


class FTLPlayerController {
  int                    textureId;
  MethodChannel          channel;

  FTLPlayerController(this.textureId) {
    this.channel = MethodChannel('plugins/ftl_player${this.textureId}');
  }

  //开始
  Future<void> start(String url,TX_Enum_PlayType type) {
    return this.channel.invokeMethod("start", {"url": url,"type":type.index});
  }

  //开始
  Future<void> startAutoType(String url) {
    TX_Enum_PlayType type = this.livePlayerType(url);
    if (type != null) {
      return this.channel.invokeMethod("start", {"url": url,"type":type.index});
    }else{
      return Future.value(false);
    }
  }

  //暂停
  Future<void> pause() {
    return this.channel.invokeMethod("pause");
  }

  //停止
  Future<void> stop() {
    return this.channel.invokeMethod("stop");
  }

  //恢复
  Future<void> resume() {
    return this.channel.invokeMethod("resume");
  }

  //开启硬解
  Future<void> setEnableHWAcceleration(bool enable) {
    return this.channel.invokeMethod("setEnableHWAcceleration",enable);
  }

  //硬解开启状态
  Future<bool> enableHWAcceleration() {
    return this.channel.invokeMethod("enableHWAcceleration");
  }
  
  //静音
  Future<void> setMute(bool mute) {
    return this.channel.invokeMethod("setMute",mute);
  }

  //释放
  Future<void> dispose() {
    return this.channel.invokeMethod("dispose");
  }

  //判断直播类型
  TX_Enum_PlayType livePlayerType(String url){
    TX_Enum_PlayType type;
    Uri uri = Uri.parse(url);
    if (Platform.isAndroid) {
      type = TX_Enum_PlayType.PLAY_TYPE_VOD_HLS;
    }else if (uri.scheme.toLowerCase() == "rtmp") {
      type = TX_Enum_PlayType.PLAY_TYPE_LIVE_RTMP;
    }else if(uri.scheme.startsWith("http") && uri.path.toLowerCase().endsWith("flv")){
      type = TX_Enum_PlayType.PLAY_TYPE_LIVE_FLV;
    }else if(uri.scheme.startsWith("http") && uri.path.toLowerCase().endsWith("m3u8")){
      type = TX_Enum_PlayType.PLAY_TYPE_VOD_HLS;
    }
    return type;
  }

}
