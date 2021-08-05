import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

FTLOrientation ftlOrientation = FTLOrientation._(DeviceOrientation.portraitUp);

class FTLOrientation extends ValueNotifier<DeviceOrientation>{

  FTLOrientation._(value) : super(value){
    
    _channel.setMethodCallHandler((call) async{
        this.value = DeviceOrientation.values[call.arguments];
    });
  }

  static const MethodChannel _channel = MethodChannel("plugins/ftl_player/orientation");
  
  @override
  void addListener(void Function() listener) {
    if (!this.hasListeners) {
      _channel.invokeMethod("start");
    }
    super.addListener(listener);
  }

  @override
  void removeListener(void Function() listener) {
    super.removeListener(listener);
    if (!this.hasListeners) {
      _channel.invokeMethod("stop");
    }
  }
  
}
