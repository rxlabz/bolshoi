import 'package:flutter/material.dart';

import 'onboarding.dart';
import 'scenes.dart';

void main() {
  runApp(new MaterialApp(home: new TourDAnim()));
}

typedef Widget NewScene();

class PageRow {
  String title;
  NewScene build;
  bool selected = false;

  PageRow(this.title, this.build);
}

final pages = [
  new PageRow("Basic anim 1", () => new AnimScene0()),
  new PageRow("Basic anim 2", () => new AnimScene1()),
  new PageRow("AnimatedWidget", () => new AnimatedWidgetExampleScene()),
  new PageRow("AnimatedBuilder", () => new AnimatedBuilderExampleScene()),
  new PageRow("SlideTransition", () => new SlideTransitionExample()),
  new PageRow("Parallel", () => new ExampleAnimationGroup()),
  new PageRow("Sequence", () => new ExampleSequence()),
  new PageRow("Loop", () => new ExampleLoop()),
  new PageRow("Example", () => new OnBoardingDemo()),
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
                              color: p.selected
                                  ? Colors.grey.shade200
                                  : Colors.white,
                              height: 60.0,
                              child: new Center(child: new Text(p.title))),
                          onTap: () => setState(() {
                                deselectAll();
                                p.selected = true;
                                currentWidget = p.build();
                              })))
                      .toList()))),
      new Expanded(child: currentWidget),
    ]));
  }

  void deselectAll() {
    pages.forEach((p) => p.selected = false);
  }
}
