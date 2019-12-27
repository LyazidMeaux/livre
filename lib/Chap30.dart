/*
 * Copyright (c) 2019. Libre de droit
 */
import 'package:flutter/material.dart';

import 'model/Car.dart';
import 'ui/WidgetCar.dart';

class Chap30 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        //primarySwatch: Colors.blue,
        accentColor: Colors.redAccent,
        brightness: Brightness.dark,
      ),
      home: CarInheritedWidget(Chap300('Chap30')),
      debugShowMaterialGrid: false,
      debugShowCheckedModeBanner: true,
      showPerformanceOverlay: false,
    );
  }
}

class Chap300 extends StatelessWidget {
  final String title;

  Chap300(this.title, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<WidgetCar> widgetCar = [];
    List<Car> cars = CarInheritedWidget.of(context)._cars;
    for (Car car in cars) {
      WidgetCar wc = WidgetCar(car);
      widgetCar.add(wc);
    }
    /*
    List<WidgetCar> carWidgets = CarInheritedWidget.of(context).cars.map((Car car) {
      return WidgetCar(car);
    });
    */

    return Scaffold(
        appBar: AppBar(
          title: Text(title + '\nSIWA'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  CarInheritedWidget.of(context).addNissan();
                })
          ],
        ),
        body: ListView(children: widgetCar));
  }
}

class CarInheritedWidget extends InheritedWidget {
  final List<Car> _cars = [
    Car.picture('Peugeot', '204', 'http://lyazid.fr/image/word.png'),
    Car.picture('Peugeot', '304', 'http://lyazid.fr/image/zoom.png'),
    Car.picture('Peugeot', '404', 'http://lyazid.fr/image/pointer.png'),
    Car.picture('Peugeot', '504', 'http://lyazid.fr/image/pointer.png'),
    Car.picture('Peugeot', '604', 'http://lyazid.fr/image/pointer.png'),
    Car.picture('Peugeot', '104', 'http://lyazid.fr/image/pointer.png'),
  ];

  CarInheritedWidget(child) : super(child: child);

  List<Car> get cars => _cars;

  void addNissan() {
    debugPrint('Add Nissan');
    Car nissan = Car.picture('Nissan', 'KashKai', 'http://lyazid.fr/image/word.png');
    _cars.add(nissan);
  }

  @override
  bool updateShouldNotify(CarInheritedWidget oldWidget) => true;

  static CarInheritedWidget of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(CarInheritedWidget);
  }
}
