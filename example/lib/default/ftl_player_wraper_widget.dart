
import 'package:flutter/material.dart';
import 'package:ftl_player/ftl_player_controller.dart';
import 'package:provider/provider.dart';

import 'ftl_player_wraper_controller.dart';


class FTLPlayerWraperWidget extends StatefulWidget {
  final FTLPlayerController controller;
  FTLPlayerWraperWidget(this.controller);

  @override
  State<StatefulWidget> createState() {
      return FTLPlayerWraperWidgetState();
  }
}

class FTLPlayerWraperWidgetState extends State<FTLPlayerWraperWidget>{

  @override
  Widget build(BuildContext context) {
    FTLPlayerWraperController wraperController =
        Provider.of<FTLPlayerWraperController>(context);
    if (this.widget.controller == null) {
      return Container(color: Colors.black);
    }else if(wraperController.ratio == null || !wraperController.aotuRatio){
      return Container(color: Colors.black,child:Texture(textureId: this.widget.controller.textureId));
    }else{
      return  Container(color: Colors.black,child:Align(alignment: Alignment.center,child: AspectRatio(aspectRatio: wraperController.ratio,child:Texture(textureId: this.widget.controller.textureId))));
    }
  }
}
