/*
 * Copyright (c) 2019. Libre de droit
 */

class Order {
  static int nextId = 1;
  int id;
  DateTime _dt;
  String _description;
  double _total;

  Order(this._dt, this._description, this._total, {this.id}) {
    if (id == null) id = nextId++;
  }

  Order.empty() : this(DateTime.now(), '', 0, id: 0);
  DateTime get date => _dt;
  String get description => _description;
  double get total => _total;

  String frenchDate() => '${_dt.day}/${_dt.month}/${_dt.year}';

  static void init() {
    nextId = 1;
  }
}
