import 'package:flutter/services.dart';
import 'package:ftl_player/ftl_player_controller.dart';
import 'ftl_player_config.dart';
export 'package:ftl_player/ftl_player_config.dart';
export 'package:ftl_player/ftl_player_constant.dart';
export 'package:ftl_player/ftl_player_widget.dart';
export 'package:ftl_player/ftl_player_controller.dart';

class FTLPlayer{
  static const MethodChannel _channel =
      const MethodChannel('plugins/ftl_player');
  
   static Future<FTLPlayerController> init({TXLivePlayConfig? configs}) async {
    var map       = {
      "cacheTime" : configs?.cacheTime,
      "bAutoAdjustCacheTime" : configs?.bAutoAdjustCacheTime,
      "maxAutoAdjustCacheTime" : configs?.maxAutoAdjustCacheTime,
      "minAutoAdjustCacheTime" : configs?.minAutoAdjustCacheTime,
      "videoBlockThreshold" : configs?.videoBlockThreshold,
      "connectRetryCount" : configs?.connectRetryCount,
      "connectRetryInterval" : configs?.connectRetryInterval,
      "enableHWAcceleration" : configs?.enableHWAcceleration,
    };
    map.removeWhere((key, value) => value  == null);
    var id        = await _channel.invokeMethod<int>('init',map);
    var ctl       = FTLPlayerController(id!);
    return ctl;
  }
}
