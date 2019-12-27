/*
 * Copyright (c) 2019. Libre de droit
 */
import 'package:flutter/material.dart';

import 'simple/BoutonWidget.dart';
import 'simple/TextBlock.dart';

// Chapitre 18
class Chap18 extends StatefulWidget {
  Chap18({Key key}) : super(key: key);

  Chap18State createState() => new Chap18State();
}

class Chap18State extends State<Chap18> {
  // TEXT
  int _index = 0;

  final List<TextBlock> blocs = [
    new TextBlock('Voiture', Colors.red),
    TextBlock(
        '\nMoto  Il est interdit de conduire sans caue ni gants sinon vou '
        'risquezz de vous faire tres tres mal',
        Colors.blue),
    TextBlock('\nVelo', Colors.green)
  ];

  Widget buildText(BuildContext context) {
    final List<TextSpan> textSpans = List<TextSpan>();
    for (var i = 0; i < _index; i++) {
      TextBlock bloc = blocs[i];
      textSpans.add(
          TextSpan(text: bloc.text, style: TextStyle(color: bloc.color, fontSize: 32.0)));
    }

    return new Scaffold(
      body: Center(
        child: Padding(
            padding: EdgeInsets.all(100.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[Text.rich(TextSpan(children: textSpans))],
            )),
      ),
      floatingActionButton: new FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: new Icon(Icons.note_add)),
    );
  }

  Widget build_Image(BuildContext context) {
    return new Scaffold(
      body: Center(
        child: FadeInImage.assetNetwork(
            placeholder: 'assets/loading.gif',
            image:
                'https://www.mediaforma.com/uneminuteparjour/windows10/images/windows-10-paint-3d-2.jpg'),
      ),
    );
  }

  Widget buildIcon(BuildContext context) {
    IconData icon = Icons.add;

    Row row1 = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[const Icon(Icons.add), const Text('Default 24 in black')],
    );
    Row row2 = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Icon(
          Icons.add,
          size: 48,
        ),
        Text("Default 48 in ${icon.codePoint}"
            ' black')
      ],
    );
    Row row3 = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Icon(
          Icons.add,
          size: 96,
          color: Colors.red,
        ),
        const Text('Default 96 in Red')
      ],
    );

    return new Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Text(
          'Code Icon: ${icon.codePoint}',
          textScaleFactor: 3.0,
        ),
        row1,
        row2,
        row3
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Bouton', theme: ThemeData.light(), home: BoutonWidget());
  }

  void _incrementCounter() {
    setState(() {
      if (_index < blocs.length) _index++;
    });
  }
}
