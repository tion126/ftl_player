import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ftl_player_control_layer.dart';
import 'ftl_player_marquee_layer.dart';
import 'ftl_player_menu_layer.dart';
import 'ftl_player_skin_controller.dart';
import 'ftl_player_skin_widget.dart';
import 'ftl_player_state_notifier.dart';


class FTLPlayerFullScreen extends StatefulWidget{
  final FTLPlayerSkinController skinController;
  FTLPlayerFullScreen(this.skinController);

  @override
  State<StatefulWidget> createState() {
    return FTLPlayerFullScreenState();
  }
}

class FTLPlayerFullScreenState extends State<FTLPlayerFullScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider<FTLPlayerSkinController>.value(
              value: widget.skinController),
          ChangeNotifierProvider<FTLPlayerStateNotifier>.value(
              value: widget.skinController.notifier),
        ],
        child: Stack(children: [
              SafeArea(top: false,bottom: false,child: FTLPlayerSkinWidget(widget.skinController.playerController)),
              FTLPlayerMarqueeLayer(widget.skinController.marqueeContent),
              FTLPlayerControlLayer(),
              FTLPlayerMenuLayer()
            ])));
  }
}
