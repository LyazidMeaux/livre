/*
 * Copyright (c) 2019. Libre de droit
 */

import 'Customer.dart';
import 'Order.dart';

class Provider {
  static List<Customer> getCustomers({String prefixe}) {
    Customer.init();
    Order.init();
    String _prefixe = (prefixe == null) ? '' : prefixe + '_';
    List<Customer> customerList = [
      Customer('${_prefixe}Velo', 'Paris', [
        Order(DateTime(20190501), 'CMD -10-', 10.0),
        Order(DateTime(20190501), 'CMD -11-', 15.0),
        Order(DateTime(20191005), 'CMD -12-', 10.0)
      ]),
      Customer('${_prefixe}Auto', 'Paris', [
        Order(DateTime(20190501), 'CMD -20-', 20.0),
        Order(DateTime(20190501), 'CMD -21-', 21.0),
        Order(DateTime(20191005), 'CMD -22-', 27.0)
      ]),
      Customer('${_prefixe}Bateau', 'Paris', [
        Order(DateTime(20190501), 'CMD -30-', 30.0),
        Order(DateTime(20190501), 'CMD -31-', 31.0),
        Order(DateTime(20191005), 'CMD -32-', 39.0)
      ]),
      Customer('${_prefixe}Moto', 'Paris', [
        Order(DateTime(20190501), 'CMD -40-', 40.0),
        Order(DateTime(20190501), 'CMD -41-', 41.0),
        Order(DateTime(20191005), 'CMD -42-', 44.0)
      ]),
      Customer('${_prefixe}Avion', 'Paris', [
        Order(DateTime(20190501), 'CMD -50-', 50.0),
        Order(DateTime(20190501), 'CMD -51-', 51.0),
        Order(DateTime(20191005), 'CMD -52-', 54.0)
      ]),
    ];

    return customerList;
  }
}
