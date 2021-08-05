import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'ftl_player_control_layer.dart';
import 'ftl_player_marquee_layer.dart';
import 'ftl_player_menu_layer.dart';
import 'ftl_player_observer.dart';
import 'ftl_player_skin_controller.dart';
import 'ftl_player_skin_widget.dart';
import 'ftl_player_state_notifier.dart';

typedef OnFTLPlayeSkinCreate = void Function(FTLPlayerSkinController skinController);

class FTLPlayerSkin extends StatefulWidget{
  final OnFTLPlayeSkinCreate onCreate;
  FTLPlayerSkin(this.onCreate);

  @override
  State<StatefulWidget> createState() {
    return FTLPlayerSkinState();
  }
}

class FTLPlayerSkinState extends State<FTLPlayerSkin> {

  FTLPlayerSkinController? skinController;
  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    
    FTLPlayerSkinController.init().then((value){
      this.skinController = value;
      this.skinController!.ctx = context;
      widget.onCreate(this.skinController!);
      this.setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return this.skinController == null ? Container() : MultiProvider(
        providers: [
          ChangeNotifierProvider<FTLPlayerSkinController>.value(
              value: this.skinController!),
          ChangeNotifierProvider<FTLPlayerStateNotifier>.value(
              value: this.skinController!.notifier),
        ],
        
        child: Stack(children: [
              FTLPlayerObserver(),
              FTLPlayerSkinWidget(skinController!.playerController),
              FTLPlayerMarqueeLayer(this.skinController!.marqueeContent),
              FTLPlayerControlLayer(),
              FTLPlayerMenuLayer()
            ]));
  }

  @override
  void dispose() {
    super.dispose();
    this.skinController?.playerController.dispose();
    this.skinController?.dispose();
  }
}
