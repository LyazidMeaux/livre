/*
 * Copyright (c) 2019. Libre de droit
 */

import 'package:flutter/Material.dart';

import 'Bloc.dart';
import 'BlocProvider.dart';
import 'CustomerListWidget.dart';

class Chap32 extends StatelessWidget {
  final Bloc _bloc = Bloc();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLoC',
      theme: new ThemeData(
          //primarySwatch: Colors.blue,
          accentColor: Colors.redAccent,
          brightness: Brightness.dark),
      home: BlocProvider(
        bloc: _bloc,
        child: CustomerListWidget(
          title: 'BLoC',
          messageStream: _bloc.messageStream,
        ),
      ),
    );
  }
}
