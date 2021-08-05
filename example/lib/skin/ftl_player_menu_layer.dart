import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ftl_player_skin_controller.dart';

class FTLPlayerMenuLayer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FTLPlayerMenuLayerState();
  }
}

class FTLPlayerMenuLayerState extends State<FTLPlayerMenuLayer> {
  @override
  Widget build(BuildContext context) {
    FTLPlayerSkinController skinController =
        Provider.of<FTLPlayerSkinController>(context);
    return GestureDetector(
        behavior: skinController.showMenu ? HitTestBehavior.opaque : HitTestBehavior.translucent,
        onTap: skinController.showMenu ? skinController.onMenu : null,
        child: Stack(children: [
      AnimatedPositioned(
          duration: Duration(milliseconds: 150),
          top: 0,
          bottom: 0,
          right: skinController.showMenu ? 0 : -400,
          child: SafeArea(top: false,left: false,bottom: false,child:Container(
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16))),
              child: SingleChildScrollView(child: Column(children: [
                Container(
                    padding: EdgeInsets.only(top: 10, left: 15, right: 15),
                    child: Row(children: [
                      Text("声音",
                          style: TextStyle(color: Colors.white, fontSize: 12)),
                      Container(width: 10),
                      Icon(Icons.volume_mute_sharp,
                          color: Colors.white, size: 20),
                      Expanded(
                          child:Slider(
                          value: skinController.volume,
                          onChanged: (v){
                              skinController.setVolume(v.clamp(0, 1));
                          },
                          min: 0,
                          max: 1.0,
                        )),
                      Icon(Icons.volume_up_sharp,
                          color: Colors.white, size: 20)
                    ])),
                Container(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Row(children: [
                      Text("亮度",
                          style: TextStyle(color: Colors.white, fontSize: 12)),
                      Container(width: 10),
                      Icon(Icons.brightness_low_sharp,
                          color: Colors.white, size: 20),
                      Expanded(
                          child: Slider(
                          value: skinController.brightness,
                          onChanged: (b){
                              skinController.setBrightness(b.clamp(0, 1));
                          },
                          min: 0,
                          max: 1.0,
                        )),
                      Icon(Icons.brightness_high_sharp,
                          color: Colors.white, size: 20)
                    ])),
                Container(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Row(children: [
                      Text("硬件加速",
                          style: TextStyle(color: Colors.white, fontSize: 12)),
                      Container(width: 10),
                      Switch(value: skinController.enableHWAcceleration, onChanged: (e){
                          skinController.setEnableHWAcceleration(e);
                      })
                    ])),
                Container(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Row(children: [
                      Text("自动比例",
                          style: TextStyle(color: Colors.white, fontSize: 12)),
                      Container(width: 10),
                      Switch(value: skinController.aotuRatio, onChanged: (e){
                          skinController.setAutoRatio(e);
                      })
                    ]))
              ])))))
    ]));
  }
}
