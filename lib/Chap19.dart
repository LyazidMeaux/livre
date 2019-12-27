/*
 * Copyright (c) 2019. Libre de droit
 */
import 'package:flutter/Material.dart';

class Chap19 extends StatelessWidget {
  Chap19({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ListView'),
      ),
      body: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          CW.getOne(Colors.red),
          CW.getOne(Colors.blue),
          CW.getOne(Colors.yellow),
          CW.getOne(Colors.orange)
        ],
      ),
    );
  }

  Widget build_ListView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ListView'),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 20.0),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            CW.getOne(Colors.red),
            CW.getOne(Colors.blue),
            CW.getOne(Colors.yellow),
            CW.getOne(Colors.orange)
          ],
        ),
      ),
    );
  }

  Widget build_Row(BuildContext context) {
    Texte t = Texte();
    Widget centre = Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        RowAlign.getOne('Center', MainAxisAlignment.center),
        RowAlign.getOne('End', MainAxisAlignment.end),
        RowAlign.getOne('SpaceAround', MainAxisAlignment.spaceAround),
        RowAlign.getOne('SpaceEvenly', MainAxisAlignment.spaceEvenly),
        RowAlign.getOne('SpaceBetween', MainAxisAlignment.spaceBetween),
        RowAlign.getOne('Start', MainAxisAlignment.start),
        Row(
          children: <Widget>[t.get('Non'), t.get('Expanded'), t.get('Dutout')],
        ),
        Row(
          children: <Widget>[t.exp('Expanded'), t.get(' A '), t.get('Gauche')],
        ),
        Row(
          children: <Widget>[t.get('Expanded'), t.exp(' Au '), t.get('Milieu')],
        ),
        Row(
          children: <Widget>[t.get('Expanded'), t.get(' A '), t.exp('Droite')],
        ),
      ],
    );

    return centre;
  }

  Widget build_Column(BuildContext context) {
    ColorButton colorButton = new ColorButton();
    Widget centre = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          colorButton.getOne(Colors.red, true),
          colorButton.getOne(Colors.orange, true),
          colorButton.getOne(Colors.green, true),
          colorButton.getOne(Colors.blue, true),
          colorButton.getOne(Colors.red, true),
          colorButton.getOne(Colors.orange, true),
          colorButton.getOne(Colors.green, true),
          colorButton.getOne(Colors.blue, true),
        ],
      ),
    );
    Center expanded = new Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(child: colorButton.getOne(Colors.green, false)),
          Expanded(child: colorButton.getOne(Colors.orange, false)),
          Expanded(child: colorButton.getOne(Colors.red, false)),
        ],
      ),
    );
    return centre;
  }
}

class ColorButton {
  bool _contrainte;
  Color _color;

  RawMaterialButton getOne(_color, _contrainte) {
    RawMaterialButton button;
    if (_contrainte) // Contrainte de taille tout en utilisant l'espace
      button = RawMaterialButton(
        constraints: BoxConstraints(minWidth: 99.0, minHeight: 99.0),

        onPressed: () {},
        //shape: CircleBorder(),
        elevation: 2.0,
        fillColor: _color,
        padding: EdgeInsets.all(5.0),
      );
    else // S'adapte a l'espace disponible
      button = RawMaterialButton(
        onPressed: () {},
        elevation: 2.0,
        fillColor: _color,
        //padding: EdgeInsets.all(15.0),
      );

    return button;
  }
}

class RowAlign {
  static Row getOne(String _text, var axe) {
    Row row = Row(
      mainAxisAlignment: axe,
      children: <Widget>[
        const Text(
          'Alignment',
          style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              decorationStyle: TextDecorationStyle.solid,
              decorationThickness: 0.0),
        ),
        const Text(
          '__Is__',
          style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              decorationStyle: TextDecorationStyle.solid,
              decorationThickness: 0.0),
        ),
        Text(
          _text,
          style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              decorationStyle: TextDecorationStyle.solid,
              decorationThickness: 0.0),
        ),
      ],
    );
    return row;
  }
}

class Texte {
  Widget get(String value) {
    return Text(
      value,
      style: TextStyle(
          color: Colors.white,
          fontSize: 18.0,
          decorationStyle: TextDecorationStyle.solid,
          decorationThickness: 0.0),
    );
  }

  Widget exp(String value) {
    return Expanded(
        child: Text(
      value,
      style: TextStyle(
          color: Colors.white,
          fontSize: 18.0,
          decorationStyle: TextDecorationStyle.solid,
          decorationThickness: 0.0),
    ));
  }
}

class CW {
  static Widget getOne(Color _color) {
    return Container(
      //   margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
      width: 160.0,
      color: _color,
    );
  }
}
