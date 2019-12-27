/*
 * Copyright (c) 2019. Libre de droit
 */
import 'dart:developer';

import 'package:flutter/material.dart';

class Chap36 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Chap36',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: Chap360(title: 'Debug'));
  }
}

class Chap360 extends StatefulWidget {
  final String title;

  Chap360({Key key, this.title}) : super(key: key);

  Chap360State createState() => Chap360State();
}

class Chap360State extends State<Chap360> {
  int counter = 0;
  void _incrementCounter() {
    debugger(when: counter > 5);
    assert(counter != 4);
    setState(() {
      counter++;
      debugPrint('Counter:$counter');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Push button:'),
            Text(
              '$counter',
              style: Theme.of(context).textTheme.display1,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        child: Icon(Icons.add),
        tooltip: 'Increment',
      ),
    );
  }
}
