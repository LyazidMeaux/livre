/*
 * Copyright (c) 2019. Libre de droit
 */

import 'Order.dart';

class Customer {
  static int nextId = 1;
  int _id;
  String _name;
  String _location;
  List<Order> _orders;

  Customer(this._name, this._location, this._orders) {
    _id = nextId++;
  }

  Customer.empty() : this('', '', []);

  int get id => _id;
  List<Order> get orders => _orders;
  String get location => _location;
  String get name => _name;

  static void init() {
    nextId = 1;
  }
}
