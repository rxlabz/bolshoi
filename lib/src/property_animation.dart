import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

typedef void Animator(dynamic value);
//typedef void Animator(double value);

/// interface for animation and group of animations
abstract class PropertyAnimationBase {
  StreamController<AnimationStatus> _statu$Control =
      new StreamController<AnimationStatus>.broadcast();

  Stream<AnimationStatus> _statu$;

  Stream<AnimationStatus> get statu$ => _statu$;

  PropertyAnimationBase() {
    _statu$ = _statu$Control.stream;
  }

  void forward();
  void reverse();
  void stop();
}

///single property animation
///
class PropertyAnimation extends PropertyAnimationBase {
  AnimationController _anim;
  CurvedAnimation _curve;
  Tween _tween;
  int milliseconds;

  PropertyAnimation(
    this.milliseconds, {
    @required Animator animator,
    @required Curve curve,
    @required Tween tween,
    TickerProvider vsync,
  })
      : _tween = tween {
    _statu$ = _statu$Control.stream;

    if (vsync != null) {
      initAnim(vsync, animator: animator, curve: curve);
    }
  }

  void initAnim(TickerProvider vsync, {Animator animator, Curve curve}) {
    _anim = new AnimationController(
        duration: new Duration(milliseconds: milliseconds), vsync: vsync);

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

  void onStatus(status) {
    _statu$Control.add(status);
  }
}

/// parallel animations of properties
class PropertiesAnimation extends PropertyAnimationBase {
  List<PropertyAnimation> _anims;

  PropertiesAnimation(this._anims);

  void forward() {
    _anims.forEach((_anim) => _anim.forward());
    _anims.first.statu$.listen((status) {
      if (status == AnimationStatus.completed) _statu$Control.add(status);
    });
  }

  void reverse() {
    _anims.forEach((_anim) => _anim.reverse());
    _anims.first.statu$.listen((status) {
      if (status == AnimationStatus.dismissed) _statu$Control.add(status);
    });
  }

  void stop() {
    _anims.forEach((_anim) => _anim.stop());
  }
}
