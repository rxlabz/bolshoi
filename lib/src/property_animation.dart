import 'dart:async';

import 'package:bolshoi/bolshoi.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

//part 'animation_group.dart';
typedef void OnTick<T>(T value);

/// interface for animation and group of animations
abstract class PropertyAnimationBase implements IAnimation {
  StreamController<AnimationStatus> statu$Control =
      new StreamController<AnimationStatus>.broadcast();

  Stream<AnimationStatus> _statu$;

  Stream<AnimationStatus> get statu$ => _statu$;

  PropertyAnimationBase() {
    _statu$ = statu$Control.stream;
  }

  void forward();

  void reverse();

  void stop();

  void dispose();
}

///single property animation
///
class Animate<T> extends PropertyAnimationBase {
  final AnimationController _anim;
  final Tween<T> _tween;
  final int msSeconds;
  CurvedAnimation _curve;
  bool loop;

  Animate(
    this.msSeconds, {
    @required OnTick<T> onTick,
    @required TickerProvider ticker,
    Curve curve = Curves.linear,
    T begin,
    T end,
    Tween tween,
    this.loop: false,
  })
      : _tween = tween ?? new Tween<T>(begin: begin, end: end),
        _anim = new AnimationController(
            duration: new Duration(milliseconds: msSeconds), vsync: ticker) {
    assert(ticker != null, "vsync must not be null !");

    _statu$ = statu$Control.stream;

    initAnim(ticker, animator: onTick, curve: curve);
  }

  void initAnim(TickerProvider vsync, {OnTick<T> animator, Curve curve}) {
    _curve = new CurvedAnimation(parent: _anim, curve: curve)
      ..addListener(() => animator(_tween.evaluate(_curve)))
      ..addStatusListener(onStatus);
  }

  void forward() {
    _anim.forward();
  }

  void reverse() {
    _anim.reverse();
  }

  void stop() {
    _anim.stop();
  }

  void onStatus(AnimationStatus status) {
    if (loop) {
      if (status == AnimationStatus.completed)
        reverse();
      else if (status == AnimationStatus.dismissed) forward();
    }
    statu$Control.add(status);
  }

  @override
  void dispose() {
    loop = false;
    if( _anim.isAnimating)
      _anim.dispose();
  }
}
