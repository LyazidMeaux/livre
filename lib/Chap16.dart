/*
 * Copyright (c) 2019. Libre de droit
 */
import 'package:flutter/material.dart';

import 'CarWidget.dart';

class Chap16 extends StatelessWidget {
  Chap16({Key key, this.title}) : super(key: key);
  final String title;

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text(this.title),
      ),
      body: ListView(children: <Widget>[
        // Ou Column pour ne pas avoir de rolling
        CarWidget('BMW', '305', webImage),
        CarWidget('BMW', '301', webImage),
        CarWidget('BMW', '303', webImage),
      ]),
    );
  }
}
