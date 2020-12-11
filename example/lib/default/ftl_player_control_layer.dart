import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'ftl_player_gesture_layer.dart';
import 'ftl_player_state_notifier.dart';
import 'ftl_player_wraper_controller.dart';

class FTLPlayerControlLayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FTLPlayerWraperController wraperController =
        Provider.of<FTLPlayerWraperController>(context);
    Provider.of<FTLPlayerStateNotifier>(context);
    
    return FTLPlayerGestureLayer(Stack(children: [
      AnimatedPositioned(
          duration: Duration(milliseconds: 350),
          top: !wraperController.showControl || wraperController.lock ? -100 : 0,
          left: 0,
          right: 0,
          child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.5),
                Colors.black.withOpacity(0.8)
              ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
              child: safeArea(Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    genButton("ic-back", 22, () {
                      wraperController.back();
                    }),
                    genButton("ic-more", 22, () {
                      wraperController.onMenu();
                    }),
                  ]),wraperController.fullScreen))),
      AnimatedPositioned(
          duration: Duration(milliseconds: 350),
          bottom: !wraperController.showControl || wraperController.lock ? -100 : 0,
          left: 0,
          right: 0,
          child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.5),
                Colors.black.withOpacity(0.8)
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
              child: safeArea(Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                genButton(
                    wraperController.notifier?.playing ?? false
                        ? "ic-pause"
                        : "ic-play",
                    18,
                    wraperController.onPlay),
                genButton("ic-refresh", 18, wraperController.onRefresh),
                Expanded(child: Container()),
                Container(width: 16),
                genButton(wraperController.fullScreen ? "ic-exitfull" : "ic-full", 16, () {
                  wraperController.switchScreenOrientation(context,wraperController.fullScreen ? DeviceOrientation.portraitUp : DeviceOrientation.landscapeLeft);
                }),
              ]),wraperController.fullScreen))),
      Align(
          child: AnimatedOpacity(
              duration: Duration(milliseconds: 350),
              opacity: wraperController.showControl ? 1 : 0,
              child: Visibility(visible: wraperController.showControl,child: safeArea(genButton(wraperController.lock ? "ic-lock" : "ic-unlock",
                  22, wraperController.onLock),wraperController.fullScreen))),
          alignment: Alignment.centerLeft),
      Align(
          child: AnimatedOpacity(
              duration: Duration(milliseconds: 350),
              opacity: wraperController.notifier.buffering ? 1 : 0,
              child: Visibility(visible: wraperController.notifier.buffering,child: Container(
                  color: Colors.transparent,
                  height: 90,
                  width: 90,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(padding: EdgeInsets.only(top: 10)),
                        CircularProgressIndicator(
                            strokeWidth: 1,
                            valueColor: AlwaysStoppedAnimation(Colors.white)),
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Text(wraperController.notifier.value.netSpeed,
                            style: TextStyle(color: Colors.white, fontSize: 12))
                      ]),
                  alignment: Alignment.center))),
          alignment: Alignment.center),
        Align(
          child: AnimatedOpacity(
              duration: Duration(milliseconds: 350),
              opacity: wraperController.notifier.failed ? 1 : 0,
              child: Visibility(visible: wraperController.notifier.failed,child: InkWell(child: Container(
            decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.all(Radius.circular(16))),
                height: 35,
                width: 120,
                child:
                    Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text("播放失败,点击重试",
                            style: TextStyle(color: Colors.white, fontSize: 12))
                ]),
                alignment: Alignment.center),onTap: (){
                  wraperController.onRefresh();
                }))),
          alignment: Alignment.center)
    ]));
  }

  Widget genButton(String name, double size, VoidCallback onPressed) {
    return FlatButton(
      highlightColor: Colors.transparent,
      minWidth: 44,
      child: Image.asset("assets/images/$name.png", height: size, width: size),
      onPressed: onPressed,
    );
  }

  Widget safeArea(Widget widget,bool use){
    return SafeArea(left:use,right:use,top:use,bottom:use,child: widget);
  }
}