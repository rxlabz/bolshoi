import 'dart:math';

import 'package:bolshoi/bolshoi.dart';
import 'package:bolshoi_demo2/animation_player.dart';
import 'package:flutter/material.dart';

abstract class AnimSceneState<T extends StatefulWidget>
    extends State<StatefulWidget> with TickerProviderStateMixin {
  String title;
  AnimationFacade anim;
  double posLeft;
}

/// flutter basic animation
///
class AnimScene0 extends StatefulWidget {
  AnimScene0();

  @override
  State<StatefulWidget> createState() => new AnimScene0State();
}

class AnimScene0State extends AnimSceneState<AnimScene0> {
  double posLeft2;

  @override
  void initState() {
    anim = new AnimationFacade(
        duration: new Duration(milliseconds: 500),
        vsync: this,
        lowerBound: 50.0,
        upperBound: 500.0)
      ..addListener(() => setState(() => posLeft = anim.value));
    posLeft = anim.value;

    new Animate<double>(500,
        onTick: (double v) => setState(() => posLeft2 = v),
        ticker: this,
        begin: 50.0,
        end: 500.0)
      ..forward();

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
                  decoration: new BoxDecoration(color: Colors.orange[500])))),
      new Positioned(
          left: posLeft2,
          top: 250.0,
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

/// 1 animation controller => 2 tweens
/// each tick -> tween evaluate animController
/// `tween.evaluate(anim)` && `colorTween.evaluate(anim)`
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
  void dispose() {
    super.dispose();
    anim.dispose();
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

class AnimatedWidgetExampleScene extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new AnimatedWidgetExampleSceneState();
}

class AnimatedWidgetExampleSceneState extends State<AnimatedWidgetExampleScene>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    new AnimationController(
        duration: const Duration(seconds: 1), value: 0.0, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return new AnimatedWidgetExample(_controller..forward());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class AnimatedWidgetExample extends AnimatedWidget {
  AnimatedWidgetExample(Animation anim) : super(listenable: anim);

  @override
  Widget build(BuildContext context) {
    final Animation<double> anim = listenable;
    return new Column(mainAxisSize: MainAxisSize.min, children: [
      new Center(
          child: new Text(
        anim.value.toStringAsPrecision(3),
        style: const TextStyle(fontSize: 32.0),
      )),
      new Transform.rotate(
          angle: anim.value * PI * 2,
          child: new Opacity(
            opacity: anim.value,
            child: new Container(
              width: 100.0 * anim.value,
              height: 100.0 * anim.value,
              color: Colors.blueGrey,
            ),
          ))
    ]);
  }
}

class AnimatedBuilderExampleScene extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new AnimatedBuilderExampleSceneState();
}

class AnimatedBuilderExampleSceneState
    extends State<AnimatedBuilderExampleScene> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = new AnimationController(
        duration: const Duration(seconds: 1), value: 0.0, vsync: this)
      ..repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new AnimatedBuilder(
      animation: _controller,
      child: new Center(
          child:
              new Container(width: 100.0, height: 100.0, color: Colors.teal)),
      builder: (BuildContext context, Widget child) {
        return new Transform.rotate(
          angle: _controller.value * 2.0 * PI,
          child: child,
        );
      },
    );
  }
}

class SlideTransitionExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new SlideTransitionExampleState();
}

class SlideTransitionExampleState extends State<SlideTransitionExample>
    with TickerProviderStateMixin {
  Tween tween;

  AnimationController anim;
  Animation<Offset> slide;

  SlideTransitionExampleState() {}

  @override
  Widget build(BuildContext context) {
    return new Stack(children: [
      new Container(color:Colors.yellow),
      new SlideTransition(
        position: slide,
        child: new Container(
          width: 100.0,
          height: 100.0,
          color: Colors.grey,
        ),
      ),
    ]);
  }

  @override
  void initState() {
    super.initState();
    anim = new AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    tween = new FractionalOffsetTween(
        begin: FractionalOffset.topLeft, end: FractionalOffset.bottomRight);
    slide = tween.animate(anim);
  }
}

class ExampleAnimationGroup extends StatefulWidget {
  ExampleAnimationGroup();

  factory ExampleAnimationGroup.instance() {
    return new ExampleAnimationGroup();
  }

  @override
  State<StatefulWidget> createState() => new ExampleAnimationGroupState();
}

class ExampleAnimationGroupState extends AnimSceneState<ExampleAnimationGroup> {
  /*Tween tween;
  ColorTween colorTween;*/
  AnimationGroup animations;
  Color color;

  final Color c1 = Colors.blue[300];
  final Color c2 = Colors.green[300];

  void initState() {
    color = c1;
    animations = new AnimationGroup([
      new Animate<double>(kDuration_ms * 5,
          ticker: this,
          curve: Curves.fastOutSlowIn,
          begin: 100.0,
          end: 500.0,
          onTick: (double v) => setState(() => posLeft = v)),
      new Animate<Color>(kDuration_ms,
          ticker: this,
          curve: Curves.fastOutSlowIn,
          tween: new ColorTween(begin: c1, end: c2),
          onTick: (Color c) => setState(() => color = c))
    ]);

    super.initState();
  }

  @override
  void dispose() {
    animations.dispose();
    super.dispose();
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

class ExampleSequence extends StatefulWidget {
  ExampleSequence();

  factory ExampleSequence.instance() {
    return new ExampleSequence();
  }

  @override
  State<StatefulWidget> createState() => new ExampleSequenceState();
}

class ExampleSequenceState extends AnimSceneState<ExampleSequence> {
  AnimationSequence animations;
  Color color;

  final Color c1 = Colors.blue[300];
  final Color c2 = Colors.green[300];

  void initState() {
    color = c1;
    animations = new AnimationSequence.from([
      new Animate<double>(kDuration_ms * 10,
          ticker: this,
          curve: Curves.fastOutSlowIn,
          begin: 100.0,
          end: 500.0,
          onTick: (double v) => setState(() => posLeft = v)),
      new Animate<Color>(kDuration_ms,
          ticker: this,
          curve: Curves.fastOutSlowIn,
          tween: new ColorTween(begin: c1, end: c2),
          onTick: (Color c) => setState(() => color = c))
    ]);
    super.initState();
  }

  @override
  void dispose() {
    animations.dispose();
    super.dispose();
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

class ExampleLoop extends StatefulWidget {
  ExampleLoop();

  factory ExampleLoop.instance() {
    return new ExampleLoop();
  }

  @override
  State<StatefulWidget> createState() => new ExampleLoopState();
}

class ExampleLoopState extends AnimSceneState<ExampleLoop> {
  AnimationSequence animations;
  Color color;

  final Color c1 = Colors.blue[300];
  final Color c2 = Colors.green[300];

  @override
  void dispose() {
    animations.dispose();
    super.dispose();
  }

  void initState() {
    color = c1;
    animations = new AnimationSequence.from([
      new Animate<double>(kDuration_ms,
          ticker: this,
          curve: Curves.fastOutSlowIn,
          begin: 100.0,
          end: 500.0,
          onTick: (double v) => setState(() => posLeft = v),
          loop: true),
      new Animate<Color>(kDuration_ms,
          ticker: this,
          curve: Curves.fastOutSlowIn,
          tween: new ColorTween(begin: c1, end: c2),
          onTick: (Color c) => setState(() => color = c))
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
