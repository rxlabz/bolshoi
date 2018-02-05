import 'package:bolshoi/bolshoi.dart';
import 'package:flutter/animation.dart';
import 'package:test/test.dart';

void main() {
  group('Animation group basics', () {
    AnimationGroup anims;

    setUp(() {
      anims = new AnimationGroup([]);
    });
    test('new instance has a listenable status', () {
      anims.statu$.listen((s) => s);
      expect(anims.statu$ != null, equals(true));
      expect(anims.statu$ , equals(AnimationStatus.dismissed));
    });
  });
}
