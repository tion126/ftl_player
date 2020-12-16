import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ftl_player/ftl_player.dart';

class FTLPlayerStateNotifier extends ValueNotifier<FTLPlayerStateValue> {
  FTLPlayerStateNotifier(value) : super(value);

  Future<void> callHandler(MethodCall call) {
    switch (call.method) {
      case "onPlayEvent":
        var evtId = call.arguments["playEvent"];
        if (evtId == PLAY_EVT_PLAY_BEGIN || evtId == PLAY_EVT_RCV_FIRST_I_FRAME) {
          this.value = this.value.copyWith(state:FTLPlayerState.Playing,eventParam: call.arguments);
        }else if (evtId == PLAY_EVT_PLAY_END) {
            this.value = this.value.copyWith(state:FTLPlayerState.Stopped,eventParam: call.arguments);
        } else if (evtId == PLAY_ERR_NET_DISCONNECT) {
            this.value = this.value.copyWith(state:FTLPlayerState.Failed,eventParam: call.arguments);
        } else if (evtId == PLAY_EVT_PLAY_LOADING){
            // 当缓冲是空的时候
            this.value = this.value.copyWith(state:FTLPlayerState.Buffering,eventParam: call.arguments);
        } else if (evtId == PLAY_EVT_STREAM_SWITCH_SUCC) {
            
        } else if (evtId == PLAY_ERR_STREAM_SWITCH_FAIL) {
            this.value = this.value.copyWith(state:FTLPlayerState.Failed,eventParam: call.arguments);
        } else if (evtId == PLAY_EVT_PLAY_PROGRESS) {
            if (this.value.state == FTLPlayerState.Stopped){
            }
        }

        break;
      case "onNetStatus":
        var netSpeed = double.parse("${call.arguments[NET_STATUS_NET_SPEED]}",(err)=>0.0)/8;
        var height = double.parse("${call.arguments[NET_STATUS_VIDEO_HEIGHT]}",(e)=>null);
        var width = double.parse("${call.arguments[NET_STATUS_VIDEO_WIDTH]}",(e)=>null);

        var netText;
        if (netSpeed > 1024) {
          netText = "${(netSpeed/1024).toStringAsFixed(1)} mb/s";
        }else if(netSpeed <= 1024 && netSpeed > 0){
          netText = "${netSpeed.toStringAsFixed(0)} kb/s";
        }else{
          netText = "";
        }
        this.value = this.value.copyWith(
          height : height,
          width: width,
          netSpeed:netText,
          netParam: call.arguments);
        break;
      default:
    }
    return Future.value();
  }

  bool get playing{
    return this.value.state == FTLPlayerState.Buffering || this.value.state == FTLPlayerState.Playing;
  }

  bool get buffering{
    return this.value.state == FTLPlayerState.Buffering;
  }

  bool get failed{
    return this.value.state == FTLPlayerState.Failed;
  }

  set state(FTLPlayerState state){
    this.value = this.value.copyWith(state:state);
  }

}

enum FTLPlayerState {
  Failed, // 播放失败
  Buffering, // 缓冲中
  Playing, // 播放中
  Stopped, // 停止播放
  Pause // 暂停播放
} 

class FTLPlayerStateValue {
  FTLPlayerState state;
  String         netSpeed;
  double         height;
  double         width;
  Map            eventParam;
  Map            netParam;
  FTLPlayerStateValue({this.state = FTLPlayerState.Buffering,this.netSpeed = "",this.netParam,this.eventParam,this.height = 0,this.width = 0});
  FTLPlayerStateValue copyWith({FTLPlayerState state ,String netSpeed,Map netParam,Map eventParam,double height,double width}){
      return FTLPlayerStateValue(
        state : state ?? this.state,
        netSpeed : netSpeed ?? this.netSpeed,
        eventParam : eventParam ?? this.eventParam,
        netParam : netParam ?? this.netParam,
        height : height ?? this.height,
        width : width ?? this.width
      );
  }
}
