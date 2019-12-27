import 'dart:async';

import 'package:flutter/Material.dart';

import 'Bloc.dart';
import 'BlocProvider.dart';
import 'Customer.dart';
import 'CustomerWidget.dart';

class CustomerListWidget extends StatelessWidget {
  final Stream<String> messageStream;
  final String title;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  CustomerListWidget({Key key, this.title, this.messageStream}) : super(key: key) {
    this.messageStream.listen((message) {
      // TODO: Erreur non grave lors de l'appel de cette méthode
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message), duration: Duration(seconds: 1)));
    });
  }

  @override
  Widget build(BuildContext context) {
    final Bloc bloc = BlocProvider.of(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(title),
      ),
      body: StreamBuilder<List<Customer>>(
        stream: bloc.customerListStream,
        initialData: bloc.initCustomerList(),
        builder: (context, snapshot) {
          List<Widget> customerWidgets = snapshot.data.map((Customer customer) {
            return CustomerWidget(customer);
          }).toList();
          return ListView(
            padding: EdgeInsets.all(10.0),
            children: customerWidgets,
          );
        },
      ),
    );
  }
}
