
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ftl_player_skin_controller.dart';


class FTLPlayerObserver extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return FTLPlayerObserverState();
  }
}

class FTLPlayerObserverState extends State<FTLPlayerObserver> with WidgetsBindingObserver{
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance?.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    FTLPlayerSkinController skinController =
        Provider.of<FTLPlayerSkinController>(context, listen: false);

    switch (state) {
      case AppLifecycleState.resumed:
        if (!skinController.notifier.playing) {
          skinController.onPlay();
        }
        break;
      case AppLifecycleState.paused:
        if (skinController.notifier.playing) {
          skinController.onPlay();
        }
        break;
      case AppLifecycleState.inactive:

        break;
      case AppLifecycleState.detached:

        break;
    }
  }
}