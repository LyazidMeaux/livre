/*
 * Copyright (c) 2019. Libre de droit
 */
import 'package:flutter/material.dart';
import 'package:main/view/DataContainerWidget.dart';

import 'model/Customer.dart';
import 'model/Order.dart';
import 'model/Provider.dart';

enum Mode { Simple, NameNoParam, NameWithParam }

class Chap24 extends StatelessWidget {
  final String title;
  final String etude;
  var chap24;

  Chap24(this.title, {Key key, this.etude}) : super(key: key) {
    chap24 = Chap24_MaterialPageRoute(title);
    chap24 = Chap24_RouteNamedNoParam(title);
    chap24 = Chap24_RouteNamedWithParam(title);
    //  chap24 = Chap24_PageView(title);
  }

  @override
  Widget build(BuildContext context) {
    return chap24;
  }
}

class Chap24_PageView extends StatelessWidget {
  final String title;
  List<Customer> _customerList;
  final PageController _pageController = PageController(initialPage: 0);
  final Duration _duration = Duration(seconds: 1);
  final Curve _curve = Curves.ease;

  Chap24_PageView(this.title, {Key key}) : super(key: key) {
    _customerList = Provider.getCustomers();
  }

  Widget pageViewItemBuilder(BuildContext context, int index) {
    print('ItemBuilder for index: $index');
    if (index == 0) {
      return createHomePage(context);
    } else {
      return createDetailPage(context, index);
    }
  }

  Widget createHomePage(BuildContext context) {
    List<Widget> widgetList = [];
    widgetList.add(
      Padding(
        padding: EdgeInsets.all(20.0),
        child: Text(
          'Customer List',
          style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );

    for (int i = 0, ii = _customerList.length; i < ii; i++) {
      Customer customer = _customerList[i];
      widgetList.add(createHomePageListItem(context, customer, i));
    }
    return ListView(children: widgetList);
  }

  Widget createHomePageListItem(BuildContext context, Customer customer, int index) {
    return ListTile(
      title: Text('- $index - ${customer.name}'),
      subtitle: Text(customer.location),
      trailing: Icon(Icons.arrow_right),
      onTap: () => _pageController.animateToPage(
            index + 1,
            duration: _duration,
            curve: _curve,
          ),
    );
  }

  Widget createDetailPage(BuildContext context, int index) {
    Customer customer = _customerList[index - 1];
    List<Widget> widgetList = [];
    List<Order> orders = customer.orders;

    for (int i = 0; i < orders.length; i++) {
      widgetList.add(createOrderListWidget(context, customer, orders[i]));
    }

    /*
    List<Widget> widgetList = List.from(customer.orders.map((Order order) {
      createOrderListWidget(context, customer, order);
    }));
    */

    widgetList.insert(
      0,
      Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Text(
              customer.name,
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
            Text(
              customer.location,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            Text(
              '${customer.orders.length} Orders',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            Padding(padding: EdgeInsets.all(20.0)),
          ],
        ),
      ),
    );

    return ListView(
      children: widgetList,
    );
  }

  ListTile createOrderListWidget(BuildContext context, Customer customer, Order order) {
    return ListTile(
      title: Text('${order.description}'),
      subtitle: Text('${order.frenchDate()}: \$${order.total}'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title + '\nPageView'),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () =>
                _pageController.animateToPage(0, duration: _duration, curve: _curve),
          ),
        ],
      ),
      body: Center(
          child: PageView.builder(
        controller: _pageController,
        itemBuilder: pageViewItemBuilder,
        itemCount: _customerList.length + 1,
      )),
    );
  }
}

class Chap24_RouteNamedWithParam extends StatelessWidget {
  final String title;

  Chap24_RouteNamedWithParam(this.title, {Key key}) : super(key: key) {}

  void navigateToCustomer(BuildContext context, Customer customer) {
    Navigator.pushNamed(context, '/Chap24Customer/:${customer.id}');
  }

  ListTile createCustomerWidget(BuildContext context, Customer customer) {
    return ListTile(
      title: Text(customer.name),
      subtitle: Text(customer.location),
      trailing: Icon(Icons.arrow_right),
      onTap: () {
        navigateToCustomer(context, customer);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    DataContainerWidget data = DataContainerWidget.of(context);
    // TODO : A remettre
    //List<Customer> customerList = data.customerList;
    List<Customer> customerList = DataContainerWidget.customerList;

    print('Number of customers: ${customerList.length}');
    // TODO: Comprendre pourquoi cette méthode ne fonctionne pas
    /*
    List<Widget> customerList = List.from(_customerList.map(((Customer customer) {
      createCustomerWidget(context, customer);
    })));
*/

    print('Number of customersWidget: ${customerList.length}');

    List<Widget> cl = [];
    for (int i = 0; i < customerList.length; i++) {
      cl.add(createCustomerWidget(context, customerList[i]));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title + '\nSimpleRoute'),
      ),
      body: Center(child: ListView(children: cl)),
    );
  }
}

class Chap24_RouteNamedNoParam extends StatelessWidget {
  final String title;
  List<Customer> _customerList;

  Chap24_RouteNamedNoParam(this.title, {Key key}) : super(key: key) {
    _customerList = Provider.getCustomers();
  }

  void navigateToCustomer(BuildContext context) {
    Navigator.pushNamed(context, '/Chap24Customer');
  }

  ListTile createCustomerWidget(BuildContext context, Customer customer) {
    return ListTile(
      title: Text(customer.name),
      subtitle: Text(customer.location),
      trailing: Icon(Icons.arrow_right),
      onTap: () {
        navigateToCustomer(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Number of customers: ${_customerList.length}');
    // TODO: Comprendre pourquoi cette méthode ne fonctionne pas
    List<Widget> customerList = List.from(_customerList.map(((Customer customer) {
      createCustomerWidget(context, customer);
    })));
    print('Number of customersWidget: ${customerList.length}');
    var w = _customerList.elementAt(0);

    List<Widget> cl = [];
    for (int i = 0; i < _customerList.length; i++) {
      cl.add(createCustomerWidget(context, _customerList[i]));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title + '\nNamedRoute NoParam'),
      ),
      body: Center(child: ListView(children: cl)),
    );
  }
}

class Chap24_MaterialPageRoute extends StatelessWidget {
  final String title;
  List<Customer> _customerList;

  Chap24_MaterialPageRoute(this.title, {Key key}) : super(key: key) {
    _customerList = Provider.getCustomers();
  }

  void navigateToCustomer(BuildContext context, Customer customer) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CustomerWidget(customer, Mode.Simple),
        ));
  }

  ListTile createCustomerWidget(BuildContext context, Customer customer) {
    return ListTile(
      title: Text(customer.name),
      subtitle: Text(customer.location),
      trailing: Icon(Icons.arrow_right),
      onTap: () {
        navigateToCustomer(context, customer);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Number of customers: ${_customerList.length}');
    // TODO: Comprendre pourquoi cette méthode ne fonctionne pas
    List<Widget> customerList = List.from(_customerList.map(((Customer customer) {
      createCustomerWidget(context, customer);
    })));
    print('Number of customersWidget: ${customerList.length}');
    var w = _customerList.elementAt(0);

    List<Widget> cl = [];
    for (int i = 0; i < _customerList.length; i++) {
      cl.add(createCustomerWidget(context, _customerList[i]));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title + '\nSimpleRoute'),
      ),
      body: Center(child: ListView(children: cl)),
    );
  }
}

class CustomerWidget extends StatelessWidget {
  Customer customer;
  var mode;
  CustomerWidget(this.customer, this.mode);

  void navigateToOrderSimple(BuildContext context, Customer customer, Order order) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => OrderWidget(
                customer: customer,
                order: order,
              )),
    );
  }

  void navigateToOrderNamedNoParam(BuildContext context) {
    Navigator.pushNamed(context, '/Chap24Order');
  }

  ListTile createOrderListWidget(BuildContext context, Customer customer, Order order) {
    return ListTile(
      title: Text(order.description),
      subtitle: Text(''),
      trailing: Icon(Icons.arrow_right),
      onTap: () => mode == Mode.Simple
          ? navigateToOrderSimple(context, customer, order)
          : navigateToOrderNamedNoParam(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList =
        List.from(customer.orders.map((Order order) => createOrderListWidget(
              context,
              customer,
              order,
            )));

    widgetList.insert(
      0,
      Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Text(
              customer.name,
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
            Text(
              customer.location,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            Text(
              '${customer.orders.length} Orders',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Info'),
      ),
      body: Center(
        child: ListView(
          children: widgetList,
        ),
      ),
    );
  }
}

class OrderWidget extends StatelessWidget {
  final Customer customer;
  final Order order;

  OrderWidget({this.customer, this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Info'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            Text(
              customer.name,
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              customer.location,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(''),
            Text(
              order.description,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              '${order.frenchDate()}: \$${order.total}',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomerWidgetNoParameter extends StatelessWidget {
  Customer customer;
  CustomerWidgetNoParameter({Key key}) : super(key: key) {
    Order order_1 = Order(DateTime(2019, 12, 21), 'Velo', 30.0);
    Order order_2 = Order(DateTime(2019, 09, 21), 'Moto', 125.52);

    customer = Customer('Moi', 'Meaux', [order_1, order_2]);
  }

  @override
  Widget build(BuildContext context) {
    return CustomerWidget(
      customer,
      Mode.NameNoParam,
    );
  }
}

class OrderWidgetNoParameter extends StatelessWidget {
  Order order;
  Customer customer;
  OrderWidgetNoParameter({Key key}) : super(key: key) {
    order = Order(DateTime(2019, 12, 21), 'Velo', 125.52);
    customer = Customer('Moi', 'Meaux', [order, order]);
  }

  @override
  Widget build(BuildContext context) {
    return OrderWidget(customer: customer, order: order);
  }
}

class CustomerWidgetWithParameter extends StatelessWidget {
  int _id;
  CustomerWidgetWithParameter(this._id);

  void navigateToOrderSimple(BuildContext context, Order order) {
    Navigator.pushNamed(context, '/Chap24Order/:${order.id}');
  }

  ListTile createOrderListWidget(BuildContext context, Customer customer, Order order) {
    return ListTile(
      title: Text(order.description),
      subtitle: Text(''),
      trailing: Icon(Icons.arrow_right),
      onTap: () => navigateToOrderSimple(context, order),
    );
  }

  @override
  Widget build(BuildContext context) {
    DataContainerWidget data = DataContainerWidget.of(context);
    Customer customer = data.getCustomer(_id);

    List<Widget> widgetList =
        List.from(customer.orders.map((Order order) => createOrderListWidget(
              context,
              customer,
              order,
            )));

    widgetList.insert(
      0,
      Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Text(
              customer.name,
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
            Text(
              customer.location,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            Text(
              '${customer.orders.length} Orders',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Info'),
      ),
      body: Center(
        child: ListView(
          children: widgetList,
        ),
      ),
    );
  }
}

class OrderWidgetWithParameter extends StatelessWidget {
  int _id;
  OrderWidgetWithParameter(this._id);

  @override
  Widget build(BuildContext context) {
    DataContainerWidget data = DataContainerWidget.of(context);
    Customer customer = data.getCustomerForOrderId(_id);
    Order order = data.getOrder(customer, _id);

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Info'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            Text(
              customer.name,
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              customer.location,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(''),
            Text(
              order.description,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              '${order.frenchDate()}: \$${order.total}',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
