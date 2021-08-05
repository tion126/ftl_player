
import 'package:flutter/material.dart';
import 'package:ftl_player/ftl_player_controller.dart';
import 'package:provider/provider.dart';
import 'ftl_player_skin_controller.dart';


class FTLPlayerSkinWidget extends StatefulWidget {
  final FTLPlayerController? controller;
  FTLPlayerSkinWidget(this.controller);

  @override
  State<StatefulWidget> createState() {
      return FTLPlayerSkinWidgetState();
  }
}

class FTLPlayerSkinWidgetState extends State<FTLPlayerSkinWidget>{

  @override
  Widget build(BuildContext context) {
    FTLPlayerSkinController skinController =
        Provider.of<FTLPlayerSkinController>(context);
    if (this.widget.controller == null) {
      return Container(color: Colors.black);
    }else if(skinController.ratio == null || !skinController.aotuRatio){
      return Container(color: Colors.black,child:Texture(textureId: this.widget.controller?.textureId ?? 0));
    }else{
      return  Container(color: Colors.black,child:Center(child: AspectRatio(aspectRatio: skinController.ratio ?? 1,child:Texture(textureId: this.widget.controller?.textureId ?? 0))));
    }
  }
}
