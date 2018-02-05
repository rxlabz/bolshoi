import 'package:bolshoi/bolshoi.dart';
import 'package:flutter/material.dart';

class AnimationPlayer extends Container {
  final IAnimation anim;

  AnimationPlayer(this.anim);

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
