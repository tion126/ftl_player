import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ftl_player/ftl_player.dart';
import 'package:provider/provider.dart';

import 'ftl_player_control_layer.dart';
import 'ftl_player_marquee_layer.dart';
import 'ftl_player_menu_layer.dart';
import 'ftl_player_observer.dart';
import 'ftl_player_state_notifier.dart';
import 'ftl_player_wraper_controller.dart';
import 'ftl_player_wraper_widget.dart';

typedef OnFTLPlayerWraperCreate = void Function(FTLPlayerWraperController wraperController);

class FTLPlayerWraper extends StatefulWidget{
  final OnFTLPlayerWraperCreate onCreate;
  FTLPlayerWraper(this.onCreate);

  @override
  State<StatefulWidget> createState() {
    return FTLPlayerWraperState();
  }
}

class FTLPlayerWraperState extends State<FTLPlayerWraper> {

  FTLPlayerWraperController wraperController;
  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    
    FTLPlayerWraperController.init().then((value){
      this.wraperController = value;
      this.wraperController.ctx = context;
      widget.onCreate(this.wraperController);
      this.setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return this.wraperController == null ? Container() : MultiProvider(
        providers: [
          ChangeNotifierProvider<FTLPlayerWraperController>.value(
              value: this.wraperController),
          ChangeNotifierProvider<FTLPlayerStateNotifier>.value(
              value: this.wraperController?.notifier),
        ],
        
        child: Stack(children: [
              FTLPlayerObserver(),
              FTLPlayerWraperWidget(wraperController.playerController),
              FTLPlayerMarqueeLayer(this.wraperController.marqueeContent),
              FTLPlayerControlLayer(),
              FTLPlayerMenuLayer()
            ]));
  }

  @override
  void dispose() {
    super.dispose();
    this.wraperController.playerController?.dispose();
    this.wraperController.dispose();
  }
}
