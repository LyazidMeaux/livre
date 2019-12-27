/*
 * Copyright (c) 2019. Libre de droit
 */
import 'package:flutter/material.dart';

class BoutonWidget extends StatelessWidget {
  const BoutonWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Row flatButtonRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        FlatButton(
          onPressed: () => debugPrint('FlatButton Pressed'),
          child: Text('FlatButton'),
        ),
        const Text('Flat-Button')
      ],
    );

    Row raisedButttonRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        RaisedButton(
          onPressed: () => debugPrint('RaisedButton Pressed'),
          child: Text('RaisedButton'),
        ),
        const Text('Raised-Button')
      ],
    );

    Row iconButtonRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          onPressed: () => debugPrint('IconButton Pressed'),
          icon: Icon(Icons.add),
        ),
        const Text('Flat-Button')
      ],
    );

    Row outlineButtonRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        OutlineButton(
          onPressed: () => debugPrint('OutlineFlatButton Pressed'),
          child: Text('OutlineButton'),
        ),
        const Text('Outline-Button')
      ],
    );

    Row dropdownButtonRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        DropdownButton<String>(
            items: <String>['Auto', 'Moto', 'Velo', 'Trotinette', 'A Pied']
                .map((String value) {
              return new DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
            onChanged: (value) => debugPrint('FlatButton Changed Value $value')),
        const Text('Dropdown-Button')
      ],
    );

    Row backButtonRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[BackButton(), const Text('Back-Button')],
    );

    Row closeButtonRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[CloseButton(), const Text('Close-Button')],
    );

    return new Scaffold(
      appBar: AppBar(
        title: Text('Button'),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            flatButtonRow,
            raisedButttonRow,
            iconButtonRow,
            outlineButtonRow,
            dropdownButtonRow,
            backButtonRow,
            closeButtonRow
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => debugPrint('FloatingActionButton Pressed'),
        child: Text('F.A.B'),
      ),
    );
  }
}
