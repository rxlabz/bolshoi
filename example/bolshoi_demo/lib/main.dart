import 'package:bolshoi_demo/onboarding.dart';
import 'package:bolshoi_demo/scenes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(new Material(child: new TourDAnim()));
}

typedef Widget NewScene();

class PageRow {
  String title;
  NewScene build;

  PageRow(this.title, this.build);
}

final pages = [
  new PageRow("Basic anim 1", () => new AnimScene0()),
  new PageRow("Basic anim 2", () => new AnimScene1()),
  new PageRow("Bolshoi anim 3", () => new AnimScene2()),
  new PageRow("Bolshoi queue", () => new OnBoardingDemo()),
];

class TourDAnim extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new TourDAnimState();
}

class TourDAnimState extends State<TourDAnim> {
  Widget currentWidget;

  @override
  Widget build(BuildContext context) {
    currentWidget = currentWidget ?? new AnimScene0();

    return new Scaffold(
        body: new Row(children: [
      new SizedBox(
          width: 200.0,
          height: MediaQuery.of(context).size.height,
          child: new Padding(
              padding: new EdgeInsets.only(top: 36.0, left: 20.0),
              child: new ListView(
                  children: pages
                      .map((p) => new InkWell(
                          child: new Container(
                              height: 60.0,
                              child: new Center(child: new Text(p.title))),
                          onTap: () =>
                              setState(() => currentWidget = p.build())))
                      .toList()))),
      new Expanded(child: currentWidget),
    ]));
  }
}
