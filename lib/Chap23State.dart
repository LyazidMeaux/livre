/*
 * Copyright (c) 2019. Libre de droit
 */
import 'dart:async';

import 'package:flutter/material.dart';

class Chap23State extends StatefulWidget {
  final String title;
  final String etude;
  Chap23State(this.title, {Key key, this.etude}) : super(key: key);

  Chap23StateFutureBuilder createState() => Chap23StateFutureBuilder();
  //Chap23StateAsync createState() => Chap23StateAsync();

  String computeListOfTimestamp(int count) {
    StringBuffer sb = StringBuffer();
    for (int i = 0; i < count; i++) {
      sb.writeln('${i + 1}: ${DateTime.now()}');
    }
    return sb.toString();
  }

  Future<String> createFutureCalculation(int count) {
    return new Future(() {
      return computeListOfTimestamp(count);
    });
  }

  Future<String> _createFutureCalculation(int count) async {
    debugPrint('Start Running Calculation');
    String result = await computeListOfTimestamp(count);
    debugPrint('Calculation finished');
    return result;
  }
}

// TODO : Verifier le fait qu'il est vraiment Asynchrone
class Chap23StateAsync extends State<Chap23State> {
  bool _showCalculation = false;
  String data;

  void _futurePressed() {
    _showCalculation = !_showCalculation;
    data = null;
    if (_showCalculation) {
      data = 'Process in progress';
      executeStamp(200000);
    }
    setState(() {
      debugPrint('Callback running $data');
    });
  }

  void executeStamp(int count) async {
    String datas = await createTimestamp(count);
    setState(() {
      data = datas;
      debugPrint('executeStamp: Call Build');
    });
  }

  Future<String> createTimestamp(int count) {
    /*
    Timer(Duration(seconds: 10), () {
      print('Timer in effect');
    });
*/
    print('create Timestamp starting');
    StringBuffer sb = StringBuffer();

    for (int i = 0; i < count; i++) {
      sb.writeln('${i + 1}: ${DateTime.now()}');
      if (i % 1000 == 0) sb.clear();
    }
    String result = sb.toString();
    print('create Timestamp finished');

    return Future(() {
      return result;
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Build UI');
    Widget child = Expanded(
      child: SingleChildScrollView(
        child: Text('${data == null ? 'Cliquez sur le bouton -1- ' : data}'),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title + '\nAsynchronous'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[child],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _futurePressed,
        tooltip: 'Invoke Future',
        child: Icon(Icons.refresh),
      ),
    );
  }
}

class Chap23StateFutureBuilder extends State<Chap23State> {
  bool _showCalculation = false;

  void _onInvokeFuturePressed() {
    setState(() {
      _showCalculation = !_showCalculation;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget child = _showCalculation
        ? FutureBuilder(
            future: widget._createFutureCalculation(10000),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return Expanded(
                child: SingleChildScrollView(
                  child: Text('${snapshot.data == null ? '' : snapshot.data}'),
                ),
              );
            },
          )
        : Text('Hit the button to show calculation');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title + '\nFutureBuilder'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[child],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onInvokeFuturePressed,
        tooltip: 'Invoke Future',
        child: Icon(Icons.refresh),
      ),
    );
  }
}
