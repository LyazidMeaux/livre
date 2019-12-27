import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'Customer.dart';

class Bloc {
  List<Customer> _customerList = [];
  Bloc() {
    _upActionStreamController.stream.listen(_handleUp);
    _downActionStreamController.stream.listen(_handleDown);
  }
  List<Customer> initCustomerList() {
    _customerList = [
      Customer('Larbi', 'Ghemrani'),
      Customer('Djilali', 'Ghemrani'),
      Customer('Lihla', 'Ghemrani'),
      Customer('Lyazid', 'Ghemrani'),
      Customer('Yasmina', 'Ghemrani'),
    ];
    updateUpDownButton();
    return _customerList;
  }

  void dispose() {
    _upActionStreamController.close();
    _downActionStreamController.close();
  }

  void _handleUp(Customer customer) {
    swap(customer, true);
    updateUpDownButton();

    _customerListSubject.add(_customerList);
    _messageSubject.add(customer.name + ' mmoved up');
  }

  void _handleDown(Customer customer) {
    swap(customer, false);
    updateUpDownButton();

    _customerListSubject.add(_customerList);
    _messageSubject.add(customer.name + ' move down');
  }

  void swap(Customer customer, bool up) {
    int idx = _customerList.indexOf(customer);
    _customerList.remove(customer);
    _customerList.insert(up ? idx - 1 : idx + 1, customer);
  }

  void updateUpDownButton() {
    for (int idx = 0, lastIdx = _customerList.length - 1; idx <= lastIdx; idx++) {
      Customer customer = _customerList[idx];
      customer.upButton = (idx > 0);
      customer.downButton = (idx < lastIdx);
    }
  }

  /// SINK
  final _upActionStreamController = StreamController<Customer>();
  Sink<Customer> get upAction => _upActionStreamController.sink;

  final _downActionStreamController = StreamController<Customer>();
  Sink<Customer> get downAction => _downActionStreamController.sink;

  /// STREAM
  final _customerListSubject = BehaviorSubject<List<Customer>>();
  Stream<List<Customer>> get customerListStream => _customerListSubject.stream;

  final _messageSubject = BehaviorSubject<String>();
  Stream<String> get messageStream => _messageSubject.stream;
}
