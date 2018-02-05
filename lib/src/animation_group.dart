import 'package:bolshoi/bolshoi.dart';
import 'package:flutter/widgets.dart';


/// parallel animations of properties
class AnimationGroup extends PropertyAnimationBase {
  List<Animate> _anims;

  AnimationGroup(this._anims);

  void forward() {
    _anims.forEach((_anim) => _anim.forward());
    _anims.first.statu$.listen((AnimationStatus status) {
      if (status == AnimationStatus.completed) statu$Control.add(status);
    });
  }

  void reverse() {
    _anims.forEach((_anim) => _anim.reverse());
    _anims.first.statu$.listen((AnimationStatus status) {
      if (status == AnimationStatus.dismissed) statu$Control.add(status);
    });
  }

  void stop() {
    _anims.forEach((_anim) => _anim.stop());
  }

  @override
  void dispose() {
    _anims.forEach((_anim) => _anim.dispose());
  }
}
