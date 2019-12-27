/*
 * Copyright (c) 2019. Libre de droit
 */
import 'package:flutter/material.dart';
import 'package:main/model/Car.dart';

class WidgetCar extends StatelessWidget {
  final Car _car;
  bool isSelected = false;
  ValueChanged<Car> parentSelectionHandler;

  WidgetCar(this._car, {this.isSelected = false, this.parentSelectionHandler}) : super();

  void _handleTap() {
    if (parentSelectionHandler != null) parentSelectionHandler(_car);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(20.0),
        child: GestureDetector(
            onTap: _handleTap,
            child: Container(
                decoration: BoxDecoration(
                    border: Border.all(),
                    color: isSelected ? Colors.lightBlue : Colors.blueGrey),
                padding: EdgeInsets.all(20.0),
                child: Center(
                    child: Column(children: <Widget>[
                  Text(
                    '${_car.make} ${_car.model}',
                    style: TextStyle(fontSize: 24),
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0),
                      child: Image.network(
                        _car.imageSrc,
                        scale: 4,
                      ))
                ])))));
  }
}
