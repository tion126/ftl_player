import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'ftl_player_skin_controller.dart';

class FTLPlayerGestureLayer extends StatefulWidget {
  final Widget child;
  FTLPlayerGestureLayer(this.child);

  @override
  State<StatefulWidget> createState() {
    return FTLPlayerGestureLayerState();
  }
}

class FTLPlayerGestureLayerState extends State<FTLPlayerGestureLayer> {
  @override
  Widget build(BuildContext context) {
    FTLPlayerSkinController skinController =
        Provider.of<FTLPlayerSkinController>(context, listen: false);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Stack(children: [
        widget.child,
        if (skinController.showBrightness) brightnessWidget(),
        if (skinController.showVolume) volumeWidget()
      ]),
      onTap: skinController.onTap,
      onVerticalDragUpdate: this.onDrag,
      onVerticalDragEnd: this.onDrag,
      onVerticalDragStart: this.onDrag,
      onDoubleTap: this.onDoubleTap,
    );
  }

  void onDoubleTap() {
    FTLPlayerSkinController skinController =
        Provider.of<FTLPlayerSkinController>(context, listen: false);
    if (skinController.lock) {
      return;
    }
    skinController.switchScreenOrientation(context,skinController.fullScreen ? DeviceOrientation.portraitUp : DeviceOrientation.landscapeLeft);
  }

  void onDrag(e) {
    FTLPlayerSkinController skinController =
        Provider.of<FTLPlayerSkinController>(context, listen: false);
    if (RenderObject.debugActiveLayout != null) {
      return;
    }
    var size = context.findRenderObject()?.paintBounds.size;
    if (size != null) {
      skinController.onDragGesture(size, e);
    }
  }

  Widget volumeWidget() {
    FTLPlayerSkinController skinController =
        Provider.of<FTLPlayerSkinController>(context, listen: false);

    return Align(
        child: Container(
            decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.all(Radius.circular(16))),
            height: 90,
            width: 90,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(skinController.volumeIcon, color: Colors.white, size: 50),
              Text(skinController.volumeText,
                  style: TextStyle(color: Colors.white, fontSize: 12))
            ]),
            alignment: Alignment.center));
  }

  Widget brightnessWidget() {
    FTLPlayerSkinController skinController =
        Provider.of<FTLPlayerSkinController>(context, listen: false);

    return Align(
        child: Container(
            decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.all(Radius.circular(16))),
            height: 90,
            width: 90,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(skinController.brightnessIcon,
                  color: Colors.white, size: 50),
              Text(skinController.brightnessText,
                  style: TextStyle(color: Colors.white, fontSize: 12))
            ]),
            alignment: Alignment.center));
  }
}
