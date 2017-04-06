import 'package:bolshoi/bolshoi.dart';
import 'package:test/test.dart';

void main() {
  group('Animation queue basics', () {
    AnimationQueue queue;

    setUp(() {
      queue = new AnimationQueue();
    });
    test('new instance has a listenable status', () {
      queue.statu$.listen((s) => s);
      expect(queue.statu$ != null, equals(true));
    });
  });
}
