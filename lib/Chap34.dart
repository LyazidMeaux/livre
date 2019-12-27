/*
 * Copyright (c) 2019. Libre de droit
 */
import 'dart:math';

import 'package:flutter/material.dart';

class Chap34 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mixins',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CircleWidget(),
      routes: <String, WidgetBuilder>{
        '/circle': (context) => CircleWidget(),
        '/square': (context) => SquareWidget(),
      },
    );
  }
}

class Colorizer {
  final _random = Random();

  int next(int min, int max) => min + (_random.nextInt(max) - min);
  List<Color> _colors = [];

  _initColors() {
    for (int i = 0; i < 100; i++) {
      _colors.add(Colors.green
          .withRed(next(0, 255))
          .withGreen(next(0, 255))
          .withBlue(next(0, 255)));
    }
  }
}

class CirclePainter extends CustomPainter with Colorizer {
  CirclePainter() {
    _initColors();
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < 100; i++) {
      var radius = (i * 10).toDouble();
      canvas.drawCircle(
          Offset(1000.0, 1000.0),
          radius,
          Paint()
            ..color = _colors[i]
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.stroke
            ..strokeWidth = 15.0);
    }
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) => false;
}

class SquarePainter extends CustomPainter with Colorizer {
  SquarePainter() {
    _initColors();
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < 100; i++) {
      double inset = i * 10.0;
      canvas.drawRect(
          Rect.fromLTRB(inset, inset, 2000 - inset, 2000 - inset),
          Paint()
            ..color = _colors[i]
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.stroke
            ..strokeWidth = 15.0);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class CircleWidget extends StatelessWidget {
  CirclePainter _painter = CirclePainter();

  CircleWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Circle'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.crop_square),
              onPressed: () => Navigator.pushNamed(context, '/square'))
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: AlwaysScrollableScrollPhysics(),
        child: CustomPaint(
          size: Size(2000.0, 2000.0),
          foregroundPainter: _painter,
        ),
      ),
    );
  }
}

class SquareWidget extends StatelessWidget {
  SquarePainter _painter = SquarePainter();
  SquareWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Square')),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: AlwaysScrollableScrollPhysics(),
        child: CustomPaint(
          size: Size(2000.0, 2000.0),
          foregroundPainter: _painter,
        ),
      ),
    );
  }
}
