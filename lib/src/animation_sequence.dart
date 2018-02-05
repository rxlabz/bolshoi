import 'dart:async';
import 'dart:collection';

import 'package:bolshoi/bolshoi.dart';
import 'package:flutter/animation.dart';

/// sequence animations of properties
class AnimationSequence extends ListQueue<PropertyAnimationBase>
    implements PropertyAnimationBase, IAnimation {
  bool isComplete = false;
  bool isDismissed = true;

  AnimationStatus currentStatus = AnimationStatus.dismissed;

  List<PropertyAnimationBase> _completedQueue;

  Queue<PropertyAnimationBase> currentAnimationList;

  PropertyAnimationBase get currentAnim =>
      currentStatus == AnimationStatus.reverse ||
              currentStatus == AnimationStatus.completed
          ? _completedQueue.last
          : _iteratorRef.current;

  //List<PropertyAnimation> _animList;

  int currentIndex = 0;

  Iterator _iteratorRef;

  Stream<AnimationStatus> _statu$;

  StreamController<AnimationStatus> statu$Control =
      new StreamController<AnimationStatus>.broadcast();

  Stream<AnimationStatus> get statu$ => _statu$;

  AnimationSequence() {
    _statu$ = statu$Control.stream;
    _completedQueue = new List<PropertyAnimationBase>();
  }

  factory AnimationSequence.from(Iterable<PropertyAnimationBase> elements) {

    return new AnimationSequence()..addAll(elements);
  }

  void _initIterator() {
    if (_iteratorRef == null) {
      _clearIterator();
    }
  }

  void _clearIterator() {
    _iteratorRef = iterator;
    _iteratorRef.moveNext();
    _completedQueue = map((a) => a).toList();
  }

  /// start the animation chain
  void forward() {
    if (isNotEmpty) {
      // init iteratorRef
      _initIterator();
      _iteratorRef.current.statu$
          .where(
              (AnimationStatus status) => status == AnimationStatus.completed)
          .listen((AnimationStatus status) {
        if (_iteratorRef.moveNext())
          forward();
        else {
          currentStatus = AnimationStatus.completed;
          statu$Control.add(status);
        }
      });
      _iteratorRef.current.forward();
      currentStatus = AnimationStatus.forward;
    } else
      print('AnimationSequence.forward  => empty');
  }

  /// reverse all animations
  void reverse() {
    if (_completedQueue.length > 0) {
      final current = _completedQueue.last
        ..statu$.listen((status) {
          if (status == AnimationStatus.dismissed) {
            _completedQueue.removeLast();
            if (_completedQueue.isNotEmpty)
              reverse();
            else {
              _clearIterator();
              currentStatus = AnimationStatus.dismissed;
              statu$Control.add(status);
            }
          } else {
            currentStatus = AnimationStatus.reverse;
          }
        });
      current.reverse();
    }
  }

  void stop() {
    print('AnimationSequence.stop... ');
    forEach((PropertyAnimationBase anim) => anim.stop());
    _completedQueue.forEach((PropertyAnimationBase anim) => anim.stop());
    //currentAnim.stop();
  }

  void dispose() {
    print('AnimationSequence.dispose... ');
    forEach((PropertyAnimationBase anim) => anim.dispose());
    _completedQueue.forEach((PropertyAnimationBase anim) => anim.dispose());
  }

  /*void pause() {
    print('AnimationSequence.pause... ');
    currentAnim.stop();
    //_anims.forEach((_anim) => _anim.stop());
  }*/
}
