import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FTLPlayerMarqueeLayer extends StatefulWidget {

  final String content;
  FTLPlayerMarqueeLayer(this.content);

  @override
  State<StatefulWidget> createState() {
    return FTLPlayerMarqueeLayerState();
  }
}

class FTLPlayerMarqueeLayerState extends State<FTLPlayerMarqueeLayer>
    with SingleTickerProviderStateMixin {
  
  late AnimationController animationController;
  late Animation<Offset> animation;

  Color color = Colors.white.withOpacity(0.6);
  double fontSize = 12;
  int duration    = 15 * 2;
  int interval    = 120;
  int paddingFlex = 8;
  Timer? timer;
  
  @override
  void initState() {
    this.animationController = AnimationController(
        duration: Duration(seconds: this.duration), vsync: this);
    var begin = Offset(1, 0);
    var end = Offset(-1, 0);
    this.animation = Tween(begin: begin, end: end)
        .animate(this.animationController);
    this.repeat();
    super.initState();
  }


  void repeat(){
    this.timer?.cancel();
    this.paddingFlex = Random().nextInt(10);
    this.setState(() {});
    this.animationController.reset();
    this.animationController.forward();
    int random = Random().nextInt(this.interval - this.duration) + this.duration;
    this.timer = Timer(Duration(seconds: random), this.repeat);
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.max, children: [
            Expanded(child: Container(),flex: paddingFlex),
            Expanded(flex:10 - paddingFlex,child: SlideTransition(
                position: this.animation,
                child: Container(width: double.infinity,child: Text(widget.content,
                    style: TextStyle(
                        color: this.color,
                        fontSize: this.fontSize)))))
          ]);
  }

  @override
  void dispose() {
    this.timer?.cancel();
    this.animationController.dispose();
    super.dispose();
  }
}
