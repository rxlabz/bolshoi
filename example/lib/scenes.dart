import 'package:bolshoi/bolshoi.dart';
import 'package:bolshoi_demo2/animation_player.dart';
import 'package:flutter/material.dart';

abstract class AnimSceneState<T extends StatefulWidget>
    extends State<StatefulWidget> with TickerProviderStateMixin {
  String title;
  AnimationFacade anim;
  double posLeft;
}

class AnimScene0 extends StatefulWidget {
  AnimScene0();

  @override
  State<StatefulWidget> createState() => new AnimScene0State();
}

class AnimScene0State extends AnimSceneState<AnimScene0> {
  @override
  void initState() {
    anim = new AnimationFacade(
        duration: new Duration(milliseconds: 500),
        vsync: this,
        lowerBound: 50.0,
        upperBound: 500.0)
      ..addListener(() => setState(() => posLeft = anim.value));
    posLeft = anim.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        child: new Stack(children: [
      new AnimationPlayer(anim),
      new Positioned(
          left: posLeft,
          top: 50.0,
          child: new SizedBox(
              width: 100.0,
              height: 100.0,
              child: new DecoratedBox(
                  decoration: new BoxDecoration(color: Colors.orange[500]))))
    ]));
  }
}

class AnimScene1 extends StatefulWidget {
  AnimScene1();

  factory AnimScene1.instance() {
    return new AnimScene1();
  }

  @override
  State<StatefulWidget> createState() => new AnimScene1State();
}

class AnimScene1State extends AnimSceneState<AnimScene1> {
  Tween tween;
  ColorTween colorTween;

  void initState() {
    anim = new AnimationFacade(
        duration: new Duration(milliseconds: 500), vsync: this)
      ..addListener(() => setState(() => posLeft = anim.value));
    posLeft = anim.value;
    tween = new Tween<double>(begin: 50.0, end: 400.0);
    colorTween =
        new ColorTween(begin: Colors.blue[300], end: Colors.green[300]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        child: new Stack(children: [
      new AnimationPlayer(anim),
      new Positioned(
          left: tween.evaluate(anim),
          top: 50.0,
          child: new SizedBox(
              width: 100.0,
              height: 100.0,
              child: new DecoratedBox(
                  decoration:
                      new BoxDecoration(color: colorTween.evaluate(anim)))))
    ]));
  }
}

class AnimScene2 extends StatefulWidget {
  AnimScene2();

  factory AnimScene2.instance() {
    return new AnimScene2();
  }

  @override
  State<StatefulWidget> createState() => new AnimScene2State();
}

class AnimScene2State extends AnimSceneState<AnimScene2> {
  /*Tween tween;
  ColorTween colorTween;*/
  AnimationGroup animations;
  Color color;

  final Color c1 = Colors.blue[300];
  final Color c2 = Colors.green[300];

  void initState() {
    color = c1;
    animations = new AnimationGroup([
      new PropertyAnimation(kDuration_ms,
          vsync: this,
          curve: Curves.fastOutSlowIn,
          tween: new Tween<double>(begin: 100.0, end: 500.0),
          animator: (double v) => setState(() => posLeft = v)),
      new PropertyAnimation(kDuration_ms,
          vsync: this,
          curve: Curves.fastOutSlowIn,
          tween: new ColorTween(begin: c1, end: c2),
          animator: (Color c) => setState(() => color = c))
    ]);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        child: new Stack(children: [
      new BolshoiAnimationPlayer(animations),
      new Positioned(
          left: posLeft,
          top: 50.0,
          child: new SizedBox(
              width: 100.0,
              height: 100.0,
              child: new DecoratedBox(
                  decoration:
                      new BoxDecoration(shape: BoxShape.circle, color: color))))
    ]));
  }
}

class AnimScene3 extends StatefulWidget {
  AnimScene3();

  factory AnimScene3.instance() {
    return new AnimScene3();
  }

  @override
  State<StatefulWidget> createState() => new AnimScene3State();
}

class AnimScene3State extends AnimSceneState<AnimScene3> {
  AnimationSequence animations;
  Color color;

  final Color c1 = Colors.blue[300];
  final Color c2 = Colors.green[300];

  void initState() {
    color = c1;
    animations = new AnimationSequence.from([
      new PropertyAnimation(kDuration_ms,
          vsync: this,
          curve: Curves.fastOutSlowIn,
          tween: new Tween<double>(begin: 100.0, end: 500.0),
          animator: (double v) => setState(() => posLeft = v)),
      new PropertyAnimation(kDuration_ms,
          vsync: this,
          curve: Curves.fastOutSlowIn,
          tween: new ColorTween(begin: c1, end: c2),
          animator: (Color c) => setState(() => color = c))
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        child: new Stack(children: [
      new AnimationPlayer(animations),
      new Positioned(
          left: posLeft,
          top: 50.0,
          child: new SizedBox(
              width: 100.0,
              height: 100.0,
              child: new DecoratedBox(
                  decoration:
                      new BoxDecoration(shape: BoxShape.circle, color: color))))
    ]));
  }
}

