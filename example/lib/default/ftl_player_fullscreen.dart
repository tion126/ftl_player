import 'package:flutter/material.dart';
import 'package:ftl_player/ftl_player.dart';
import 'package:provider/provider.dart';
import 'ftl_player_control_layer.dart';
import 'ftl_player_marquee_layer.dart';
import 'ftl_player_menu_layer.dart';
import 'ftl_player_state_notifier.dart';
import 'ftl_player_wraper_controller.dart';

class FTLPlayerFullScreen extends StatefulWidget{
  final FTLPlayerWraperController wraperController;
  FTLPlayerFullScreen(this.wraperController);

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
          ChangeNotifierProvider<FTLPlayerWraperController>.value(
              value: widget.wraperController),
          ChangeNotifierProvider<FTLPlayerStateNotifier>.value(
              value: widget.wraperController?.notifier),
        ],
        child: Stack(children: [
              SafeArea(top: false,bottom: false,child: FTLPlayerWidget(widget.wraperController.playerController)),
              FTLPlayerMarqueeLayer(widget.wraperController.marqueeContent),
              FTLPlayerControlLayer(),
              FTLPlayerMenuLayer()
            ])));
  }
}
