
import 'package:flutter/material.dart';
import 'ftl_player_controller.dart';

class FTLPlayerWidget extends StatefulWidget {
  final FTLPlayerController? controller;
  FTLPlayerWidget(this.controller);

  @override
  State<StatefulWidget> createState() {
      return FTLPlayerWidgetState();
  }
}

class FTLPlayerWidgetState extends State<FTLPlayerWidget>{
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return this.widget.controller == null ? Container(color: Colors.black) : Container(child:Texture(textureId: this.widget.controller!.textureId),color: Colors.black);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
