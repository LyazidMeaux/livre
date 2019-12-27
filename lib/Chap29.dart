/*
 * Copyright (c) 2019. Libre de droit
 */
import 'package:flutter/material.dart';
import 'package:main/ui/WidgetCar.dart';

import 'model/Car.dart';

class Chap29 extends StatefulWidget {
  final String title;
  Chap29(this.title);
  Chap29State createState() => Chap29State(title);
}

class Chap29State extends State<Chap29> {
  final String title;
  String subTitle;
  List<Car> _cars;
  Car _selectedCar;

  Chap29State(this.title) {
    subTitle = 'SSWA';
    _cars = [
      Car.picture('Peugeot', '204', 'http://lyazid.fr/image/word.png'),
      Car.picture('Peugeot', '304', 'http://lyazid.fr/image/zoom.png'),
      Car.picture('Peugeot', '404', 'http://lyazid.fr/image/pointer.png'),
      Car.picture('Peugeot', '504', 'http://lyazid.fr/image/pointer.png'),
      Car.picture('Peugeot', '604', 'http://lyazid.fr/image/pointer.png'),
      Car.picture('Peugeot', '104', 'http://lyazid.fr/image/pointer.png'),
    ];
  }

  void _selectionHandler(Car selectedCar) {
    setState(() {
      subTitle = 'Selected ${selectedCar.make} ${selectedCar.model}';
      _selectedCar = selectedCar;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<WidgetCar> carWidgets = _cars.map((Car car) {
      return WidgetCar(
        car,
        isSelected: car == _selectedCar,
        parentSelectionHandler: _selectionHandler,
      );
    }).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('$title\n$subTitle'),
      ),
      body: ListView(
        padding: EdgeInsets.all(20.0),
        children: carWidgets,
      ),
    );
  }
}
