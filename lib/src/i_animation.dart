import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AnimationFacade extends AnimationController implements IAnimation {
  AnimationFacade({
    double value,
    Duration duration,
    String debugLabel,
    double lowerBound: 0.0,
    double upperBound: 1.0,
    @required TickerProvider vsync,
  })
      : super(
            value: value,
            duration: duration,
            debugLabel: debugLabel,
            lowerBound: lowerBound,
            upperBound: upperBound,
            vsync: vsync);
}

abstract class IAnimation {
  void forward();
  void stop();
  void reverse();
}
