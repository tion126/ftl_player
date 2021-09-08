import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ftl_player/ftl_player.dart';
import 'package:ftl_player_example/skin/ftl_player_skin.dart';
import 'package:ftl_player_example/skin/ftl_player_skin_controller.dart';
import 'package:ftl_player_example/skin/ftl_player_state_notifier.dart';

void main() => runApp(app());

Widget app() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark,
  ));

  return MaterialApp(initialRoute: "/", routes: {
    "/": (context) => HomePage(),
    "/page1": (context) => PlayerExample(),
  });
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CupertinoButton(
          child: Text("Player"),
          onPressed: () {
            Navigator.of(context).pushNamed("/page1");
          },
        ),
      ),
    );
  }
}

class PlayerExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PlayerExampleState();
  }
}

class PlayerExampleState extends State<PlayerExample> implements FTLPlayerEventHandler{
   FTLPlayerController? livePlayerController;
   FTLPlayerSkinController? liveSkinController;

   FTLPlayerController? vodPlayerController;
   FTLPlayerSkinController? vodSkinController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Column(children: [
          Padding(padding: EdgeInsets.only(top: 50)),
          Container(height: 200, child: FTLPlayerWidget(this.livePlayerController)),
          Padding(padding: EdgeInsets.only(top: 50)),
          Container(
              height: 200,
              child: FTLPlayerSkin((c) {
                this.liveSkinController = c;
                this.livePlayerController = c.playerController;
                this.liveSkinController!.handler = this;
                this.liveSkinController!.playerController.start("http://1011.hlsplay.aodianyun.com/demo/game.flv");
                this.setState(() {});
              })),
          Padding(padding: EdgeInsets.only(top: 30)),
          ///vod
          _optBtn()
        ])),
      );
  }

  Widget _optBtn() {
    return Padding(
      padding: const EdgeInsets.only(left: 45.0, right: 45.0, top: 0.0, bottom: 50.0),
      child: Wrap(
        children: <Widget>[
          CupertinoButton(
            onPressed: () {
              this.liveSkinController!.playerController.start("http://1011.hlsplay.aodianyun.com/demo/game.flv");
            },
            child: new Text("Start"),
          ),
          CupertinoButton(
            onPressed: () {
              liveSkinController!.playerController.pause();
            },
            child: Text("pause"),
          ),
          CupertinoButton(
            onPressed: () {
              this.liveSkinController!.playerController.resume();
            },
            child: new Text("resume"),
          ),
          CupertinoButton(
            onPressed: () {
              this.liveSkinController!.playerController.dispose();
            },
            child: new Text("dispose"),
          ),
          CupertinoButton(
            onPressed: () {
              liveSkinController!.playerController.pause();
              Navigator.of(context).pushNamed("/page1").then((value){
                liveSkinController!.playerController.resume();
              });
            },
            child: new Text("new page"),
          )
        ],
      ),
    );
  }

  @override
  void didTapBack() {
    Navigator.of(context).pop();
  }

  @override
  void needRefresh() {
    
    this.liveSkinController!.playerController.start(Random().nextBool() ? "http://liteavapp.qcloud.com/live/liteavdemoplayerstreamid.flv" : "http://1011.hlsplay.aodianyun.com/demo/game.flv");
  }

  @override
  void playerStateChange(FTLPlayerState state) {
    print(state);
  }
  
  @override
  void screenOrientationChange(DeviceOrientation orientation) {
    print(orientation);
  }
}
