import 'dart:async';

import 'package:bolshoi/bolshoi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

final titleStyle = new TextStyle(color: Colors.white, fontSize: 64.0);
final btStyle = new TextStyle(color: Colors.cyan[500], fontSize: 24.0);
final btStyle2 = new TextStyle(color: Colors.white, fontSize: 32.0);

class OnBoardingDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new OnBoardingDemoState();
}

class OnBoardingDemoState extends State<OnBoardingDemo>
    with TickerProviderStateMixin {
  final tWidth = 360.0;

  double tLeft = 0.0;
  double tTop = 0.0;
  double tAlpha = 0.0;
  double btBottom = -100.0;
  double btAlpha = 0.0;
  double bt2Bottom = -100.0;
  double bt2Alpha = 0.0;

  AnimationSequence animsQ;

  /*Queue<PropertyAnimationBase> anims = new Queue();

  Queue<PropertyAnimationBase> completedAnims = new Queue();*/

  PropertyAnimationBase currentAnim;
  StreamSubscription<AnimationStatus> currentAnimSub;

  bool queueComplete = false;

  void setTitleTop(double v) => setState(() => tTop = v);
  void setTitleAlpha(double a) => setState(() => tAlpha = a);
  void setBtBottom(double v) => setState(() => btBottom = v);
  void setBtAlpha(double a) => setState(() => btAlpha = a);
  void setBt2Bottom(double v) => setState(() => bt2Bottom = v);
  void setBt2Alpha(double a) => setState(() => bt2Alpha = a);

  @override
  void initState() {
    final List<PropertyAnimationBase> choregraphy = [
      new AnimationGroup([
        new Animate<double>(kDuration_ms,
            ticker: this,
            curve: Curves.fastOutSlowIn,
            begin: -100.0,
            end: 150.0,
            onTick: setTitleTop),
        new Fade(kDuration_ms,
            ticker: this,
            curve: Curves.fastOutSlowIn,
            onTick: setTitleAlpha)
      ]),
      new AnimationGroup([
        new Animate<double>(kDuration2_ms,
            ticker: this,
            curve: Curves.easeOut,
            begin: -100.0,
            end: 280.0,
            onTick: setBtBottom),
        new Animate<double>(kDuration_ms,
            ticker: this,
            curve: Curves.fastOutSlowIn,
            begin: 0.0,
            end: 1.0,
            onTick: setBtAlpha)
      ]),
      new AnimationGroup([
        new Animate<double>(kDuration2_ms,
            ticker: this,
            curve: Curves.easeOut,
            begin: -100.0,
            end: 120.0,
            onTick: setBt2Bottom),
        new Animate<double>(kDuration_ms,
            ticker: this,
            curve: Curves.fastOutSlowIn,
            begin: 0.0,
            end: 1.0,
            onTick: setBt2Alpha)
      ])
    ];
    animsQ = new AnimationSequence.from(choregraphy);
    animsQ.forward();
    super.initState();
  }

  @override
  void dispose() {
    animsQ.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final Size size = constraints.biggest;
      tLeft = (size.width - tWidth) * .5;
      final title = new Positioned(
          left: tLeft,
          top: tTop,
          child: new SizedBox(
              width: tWidth,
              child: new Opacity(
                opacity: tAlpha,
                child: new Text('Welcome',
                    textAlign: TextAlign.center, style: titleStyle),
              )));
      final btNew = new Positioned(
          left: tLeft,
          bottom: btBottom,
          child: new Align(
              alignment: FractionalOffset.bottomCenter,
              child: new SizedBox.fromSize(
                  size: new Size(tWidth, 80.0),
                  child: new Opacity(
                      opacity: btAlpha,
                      child: new RaisedButton(
                          child: new Text('Créer un compte', style: btStyle),
                          onPressed: () => animsQ.reverse(),
                          color: Colors.white)))));
      Widget mainStack = new Stack(children: [
        title,
        btNew,
        new Positioned(
            left: tLeft,
            bottom: bt2Bottom,
            child: new SizedBox.fromSize(
                size: new Size(tWidth, 80.0),
                child: new Opacity(
                  opacity: bt2Alpha,
                  child: new FlatButton(
                    child: new Text('Se connecter', style: btStyle2),
                    textColor: Colors.white,
                    color: new Color(0x20FFFFFF),
                    onPressed: () => animsQ.reverse(),
                  ),
                ))),
      ]);
      return new DecoratedBox(
          decoration: new BoxDecoration(color: Colors.cyan[800]),
          child: new SizedBox(
              width: size.width, height: size.height, child: mainStack));
    });
  }
}
