import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ftl_player/ftl_player.dart';
import 'package:ftl_player_example/default/ftl_player_state_notifier.dart';
import 'package:ftl_player_example/default/ftl_player_wraper.dart';
import 'package:ftl_player_example/default/ftl_player_wraper_controller.dart';

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
        child: OutlineButton(
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
  FTLPlayerController playerController;
  FTLPlayerWraperController wraperController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(children: [
          Padding(padding: EdgeInsets.only(top: 50)),
          Container(height: 200, child: FTLPlayerWidget(this.playerController)),
          Padding(padding: EdgeInsets.only(top: 50)),
          Container(
              height: 200,
              child: FTLPlayerWraper((c) {
                this.wraperController = c;
                this.playerController = c.playerController;
                this.wraperController.handler = this;
                this.wraperController.playerController.startAutoType("http://1011.hlsplay.aodianyun.com/demo/game.flv");
                this.setState(() {});
              })),
          Padding(padding: EdgeInsets.only(top: 30)),
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
              this.wraperController.playerController.startAutoType("http://1011.hlsplay.aodianyun.com/demo/game.flv");
            },
            child: new Text("Start"),
          ),
          CupertinoButton(
            onPressed: () {
              wraperController.playerController.pause();
            },
            child: Text("pause"),
          ),
          CupertinoButton(
            onPressed: () {
              this.wraperController.playerController.resume();
            },
            child: new Text("resume"),
          ),
          CupertinoButton(
            onPressed: () {
              this.wraperController.playerController.dispose();
            },
            child: new Text("dispose"),
          ),
          CupertinoButton(
            onPressed: () {
              wraperController.playerController.pause();
              Navigator.of(context).pushNamed("/page1").then((value){
                wraperController.playerController.resume();
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
    
    this.wraperController.playerController.startAutoType(Random().nextBool() ? "http://liteavapp.qcloud.com/live/liteavdemoplayerstreamid.flv" : "http://1011.hlsplay.aodianyun.com/demo/game.flv");
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
