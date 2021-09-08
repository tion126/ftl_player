import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ftl_player/ftl_player.dart';

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

class PlayerExampleState extends State<PlayerExample>{
   FTLPlayerController? livePlayerController;

  @override
  void initState() {
    super.initState();
    FTLPlayer.init().then((value){
      this.livePlayerController = value;
      this.setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Column(children: [
          Padding(padding: EdgeInsets.only(top: 50)),
          Container(height: 200, child: FTLPlayerWidget(this.livePlayerController)),
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
              this.livePlayerController!.start("http://1011.hlsplay.aodianyun.com/demo/game.flv");
            },
            child: new Text("Start"),
          ),
          CupertinoButton(
            onPressed: () {
              this.livePlayerController!.pause();
            },
            child: Text("pause"),
          ),
          CupertinoButton(
            onPressed: () {
              this.livePlayerController!.resume();
            },
            child: new Text("resume"),
          ),
          CupertinoButton(
            onPressed: () {
              this.livePlayerController!.dispose();
            },
            child: new Text("dispose"),
          ),
          CupertinoButton(
            onPressed: () {
              this.livePlayerController!.pause();
              Navigator.of(context).pushNamed("/page1").then((value){
                this.livePlayerController!.resume();
              });
            },
            child: new Text("new page"),
          )
        ],
      ),
    );
  }


}
