/*
 * Copyright (c) 2019. Libre de droit
 */
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'model/Car.dart';

class Chap31 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chap 31 Model Widget',
      theme: new ThemeData(
        //primarySwatch: Colors.blue,
        accentColor: Colors.redAccent,
        brightness: Brightness.dark,
      ),
      home: ScopedModel<CarListModel>(
        model: CarListModel(),
        child: ScopedModel<CarSelectionModel>(
          model: CarSelectionModel(),
          child: CarAppLayoutWidget('Chap 31'),
        ),
      ),
      debugShowMaterialGrid: false,
      debugShowCheckedModeBanner: true,
      showPerformanceOverlay: false,
    );
  }
}

class CarAppLayoutWidget extends StatelessWidget {
  final String title;

  CarAppLayoutWidget(this.title, {Key key}) : super(key: key);

  _addCar(BuildContext context) {
    ScopedModel.of<CarListModel>(context, rebuildOnChange: true).add(
      'Renault',
      'Zoé',
      'http://lyazid.fr/image/zoom.png',
    );
  }

  String _calculateSelectedCarName(BuildContext context) {
    Car selectedCar =
        ScopedModel.of<CarSelectionModel>(context, rebuildOnChange: true)._selectedCar;
    if (selectedCar == null) {
      return 'No car selected';
    } else {
      return 'Selected: ${selectedCar.make} ${selectedCar.model}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(child: CarListWidget()),
      persistentFooterButtons: <Widget>[
        Text(_calculateSelectedCarName(context)),
        IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _addCar(context);
            }),
      ],
    );
  }
}

class CarListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final carList = ScopedModel.of<CarListModel>(context, rebuildOnChange: true).carList;
    List<CarWidget> carWidgets = carList.map((Car car) {
      return CarWidget(car);
    }).toList();
    return ListView(children: carWidgets);
  }
}

class CarWidget extends StatelessWidget {
  final Car car;

  CarWidget(this.car) : super();

  _buildCarWidget(context, child, CarSelectionModel selectionModel) {
    return GestureDetector(
      onTap: () => selectionModel.selectedCar = car,
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(),
            color: (selectionModel.isSelectedCar(car) ? Colors.blue : Colors.orange),
          ),
          padding: EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              children: <Widget>[
                Text(
                  '${car.make} ${car.model}',
                  style: TextStyle(fontSize: 24.0),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Image.network(
                    car.imageSrc,
                    scale: 4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<CarSelectionModel>(
      builder: (context, child, selectionModel) =>
          _buildCarWidget(context, child, selectionModel),
    );
  }
}

class CarListModel extends Model {
  final List<Car> _carList = [
    Car.picture('Peugeot', '204', 'http://lyazid.fr/image/word.png'),
    Car.picture('Peugeot', '304', 'http://lyazid.fr/image/zoom.png'),
    Car.picture('Peugeot', '404', 'http://lyazid.fr/image/pointer.png'),
    Car.picture('Peugeot', '504', 'http://lyazid.fr/image/pointer.png'),
    Car.picture('Peugeot', '604', 'http://lyazid.fr/image/pointer.png'),
    Car.picture('Peugeot', '104', 'http://lyazid.fr/image/pointer.png'),
  ];

  List<Car> get carList => _carList;

  void add(String make, String model, String imageSrc) {
    Car newCar = Car.picture(make, model, imageSrc);
    _carList.add(newCar);
    notifyListeners();
  }
}

class CarSelectionModel extends Model {
  Car _selectedCar;
  Car get selectedCar => _selectedCar;

  set selectedCar(Car theOne) {
    _selectedCar = theOne;
    notifyListeners();
  }

  bool isSelectedCar(Car car) {
    if (_selectedCar == null) {
      return false;
    } else {
      return _selectedCar == car;
    }
  }
}
