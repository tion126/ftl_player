
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ftl_player_wraper_controller.dart';

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
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    FTLPlayerWraperController wraperController =
        Provider.of<FTLPlayerWraperController>(context, listen: false);

    switch (state) {
      case AppLifecycleState.resumed:
        if (!wraperController.notifier.playing) {
          wraperController.onPlay();
        }
        break;
      case AppLifecycleState.paused:
        if (wraperController.notifier.playing) {
          wraperController.onPlay();
        }
        break;
      case AppLifecycleState.inactive:

        break;
      case AppLifecycleState.detached:

        break;
    }
  }
}