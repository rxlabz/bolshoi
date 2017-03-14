import 'package:bolshoi/bolshoi.dart';
import 'package:flutter/material.dart';

abstract class AnimSceneState<T extends StatefulWidget>
    extends State<StatefulWidget> with TickerProviderStateMixin {
  String title;
  AnimationController anim;
  double posLeft;
}

class AnimScene0 extends StatefulWidget {
  AnimScene0();

  factory AnimScene0.instance() {
    return new AnimScene0();
  }

  @override
  State<StatefulWidget> createState() => new AnimScene0State();
}

class AnimScene0State extends AnimSceneState<AnimScene0> {
  @override
  void initState() {
    anim = new AnimationController(
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
      new ButtonBar(anim),
      new Positioned(
          left: posLeft,
          top: 50.0,
          child: new SizedBox(
              width: 100.0,
              height: 100.0,
              child: new DecoratedBox(
                  decoration:
                      new BoxDecoration(backgroundColor: Colors.orange[500]))))
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
    anim = new AnimationController(
        duration: new Duration(milliseconds: 500),
        vsync: this)..addListener(() => setState(() => posLeft = anim.value));
    posLeft = anim.value;
    tween = new Tween(begin: 50.0, end: 400.0);
    colorTween =
        new ColorTween(begin: Colors.blue[300], end: Colors.green[300]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        child: new Stack(children: [
      new ButtonBar(anim),
      new Positioned(
          left: tween.evaluate(anim),
          top: 50.0,
          child: new SizedBox(
              width: 100.0,
              height: 100.0,
              child: new DecoratedBox(
                  decoration: new BoxDecoration(
                      backgroundColor: colorTween.evaluate(anim)))))
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
  PropertiesAnimation animations;
  Color color;

  final c1 = Colors.blue[300];
  final c2 = Colors.green[300];

  void initState() {
    color = c1;
    animations = new PropertiesAnimation([
      new PropertyAnimation(kDuration_ms,
          vsync: this,
          curve: Curves.fastOutSlowIn,
          tween: new Tween(begin: 100.0, end: 500.0),
          animator: (v) => setState(() => posLeft = v)),
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
      new BolshoiButtonBar(animations),
      new Positioned(
          left: posLeft,
          top: 50.0,
          child: new SizedBox(
              width: 100.0,
              height: 100.0,
              child: new DecoratedBox(
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle, backgroundColor: color))))
    ]));
  }
}


class ButtonBar extends Container {
  AnimationController anim;

  ButtonBar(this.anim);

  Widget getButton(String label, VoidCallback onPressed) => new SizedBox(
    width: 120.0,
    height: 48.0,
    child: new RaisedButton(child: new Text(label), onPressed: onPressed));

  @override
  Widget build(BuildContext context) {
    final posLeft = (MediaQuery.of(context).size.width - 260.0) / 2 - 200;

    return new Positioned(
      bottom: 60.0,
      left: posLeft,
      child: new Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        getButton('Play', () => anim.forward()),
        getButton('Pause', () => anim.stop()),
        getButton('Reverse', () => anim.reverse())
      ]));
  }
}

class BolshoiButtonBar extends Container {
  PropertyAnimationBase anim;

  BolshoiButtonBar(this.anim);

  Widget getButton(String label, VoidCallback onPressed) => new SizedBox(
    width: 120.0,
    height: 48.0,
    child: new RaisedButton(child: new Text(label), onPressed: onPressed));

  @override
  Widget build(BuildContext context) {
    final posLeft = (MediaQuery.of(context).size.width - 260.0) / 2 - 200;

    return new Positioned(
      bottom: 60.0,
      left: posLeft,
      child: new Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        getButton('Play', () => anim.forward()),
        getButton('Pause', () => anim.stop()),
        getButton('Reverse', () => anim.reverse())
      ]));
  }
}