/*
 * Copyright (c) 2019. Libre de droit
 */
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:main/ui/EmployeeDetailWidget.dart';
import 'package:main/ui/PleaseWaitWidget.dart';

import 'api/ApiWidgetEmployee.dart';
import 'model/Employee.dart';
import 'model/Person.dart';

class Chap27 extends StatefulWidget {
  final String title;
  Chap27(this.title, {Key key}) : super(key: key);
  //Chap27State_Serial createState() => Chap27State_Serial();
  Chap27State_Http createState() => Chap27State_Http();
}

class Chap27State_Http extends State<Chap27> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PleaseWaitWidget _pleaseWaitWidget = PleaseWaitWidget(
    key: ObjectKey('PleaseWaitWidget'),
  );

  bool _refresh = true;
  List<Employee> _employees;
  bool _pleaseWait = false;
  ApiWidgetEmployee api = ApiWidgetEmployee(child: null);

  _showSnackBar(String content, {bool error = false}) {
    // TODO : Remettre la ligne
    /*
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('${error ? "An unexpected error occurred:" : ""}$content'),
    ));*/
    debugPrint('${error ? "_showSnackBar: An unexpected error occurred:" : ""}$content');
  }

  _showPleaseWait(bool b) {
    setState(() {
      _pleaseWait = b;
    });
  }

  _navigateToEmployee(BuildContext context, String employeeId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EmployeeDetailWidget(employeeId)),
    ).then((result) {
      if ((result != null) && (result is bool) && (result == true)) {
        _showSnackBar('Employee  saved');
        _refreshEmployee();
      }
    });
  }

  _deleteEmployee(BuildContext context, Employee employee) async {
    _showDeleteConfirmDialog(employee).then((result) {
      if ((result != null) && (result is bool) && (result == true)) {
        _showPleaseWait(true);
        try {
          ApiWidgetEmployee.of(context).deleteEmployee(employee.id).then((employee) {
            _showPleaseWait(false);
            _showSnackBar('Employee deleted');
            _refreshEmployee();
          }).catchError((error) {
            _showPleaseWait(false);
            _showSnackBar(error.toString(), error: true);
          });
        } catch (e) {
          _showPleaseWait(false);
          _showSnackBar(e.toString(), error: true);
        }
      }
    });
  }

  Future<bool> _showDeleteConfirmDialog(Employee employee) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete Employee'),
            content: Text('Are you sure to delete ${employee.name} ?'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text('Yes'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text('No'),
              )
            ],
          );
        });
  }

  _refreshEmployee() {
    setState(() {
      _refresh = true;
    });
  }

  _loadEmployees(BuildContext context) {
    _showPleaseWait(true);
    try {
      debugPrint('Chargement de la base <employee>');
      //ApiWidgetEmployee api = ApiWidgetEmployee.of(context);
//      ApiWidgetEmployee.of(context).loadAndParseEmployees().then((employees) {
      debugPrint('Chargement de la base employee: $api}');

      api.loadAndParseEmployees().then((employees) {
        employees.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        setState(() {
          _employees = employees;
        });
        _showPleaseWait(false);
      }).catchError((error) {
        _showPleaseWait(true);
        _showSnackBar(error.toString(), error: error);
      });
    } catch (error) {
      _showPleaseWait(false);
      _showSnackBar(error.toString(), error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_refresh) {
      _refresh = false;
      _loadEmployees(context);
    }
    ListView builder = ListView.builder(
      itemCount: _employees != null ? _employees.length : 0,
      itemBuilder: (context, index) {
        Employee employee = _employees[index];
        return ListTile(
          title: Text('${employee.name}'),
          subtitle: Text('Age: ${employee.age}'),
          trailing: Icon(Icons.arrow_right),
          onTap: () => _navigateToEmployee(context, employee.id),
          onLongPress: () => _deleteEmployee(context, employee),
        );
      },
    );

    Widget bodyWidget = _pleaseWait
        ? Stack(
            key: ObjectKey('stack'),
            children: <Widget>[_pleaseWaitWidget, builder],
          )
        : Stack(
            key: ObjectKey('stack'),
            children: <Widget>[builder],
          );

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title + '\nHtml Rest'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            tooltip: 'Add',
            onPressed: () {
              _navigateToEmployee(context, null);
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () {
              _refreshEmployee();
            },
          )
        ],
      ),
      body: Center(
        child: bodyWidget,
      ),
    );
  }
}

class Chap27State_Serial extends State<Chap27> {
  final _jsonTextController = TextEditingController();

  Person _person;
  String _error;

  Chap27State_Serial() {
    final String person =
        '{"name": "Lyazid" , "addr": "Quai Voltaire", "city": "Meaux" , '
        '"state": "France" }';
    _jsonTextController.text = person;
  }

  TextFormField _createJsonTextFormField() {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter the json';
        }
      },
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Json',
          labelText: 'Enter the json for a person.'),
      controller: _jsonTextController,
      autofocus: true,
      maxLines: 8,
      keyboardType: TextInputType.multiline,
    );
  }

  _convertJsonToPerson() {
    _person = null;
    _error = null;
    setState(() {
      try {
        String jsonText = _jsonTextController.text;
        jsonText =
            ' {"name": "Lyazid" ,"addr" : "Quai Voltaire", "city": "Meaux" , "state": "'
            'France", "children": ['
            '{"name": "Lyazid_1" ,"addr" : "Quai Voltaire", "city": "Meaux" , "state"'
            ': "France"},'
            '{"name": "Lyazid_2" ,"addr" : "Quai Voltaire", "city": "Meaux" , "sta'
            'te"'
            ': "France"}'
            ']  }';

        debugPrint('JSON TEXT: $jsonText');
        var decoded = json.decode(jsonText);
        debugPrint('DECODED: type: ${decoded.runtimeType} value: $decoded');
        _person = Person.fromRecursifJson(decoded);
        debugPrint('RESULT :  ${_person.toString()}');
      } catch (e) {
        debugPrint('ERROR: $e');
        _error = e.toString();
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title + '\nSerialize'),
      ),
      body: Center(
        child: Padding(
          child: ListView(
            children: <Widget>[
              _createJsonTextFormField(),
              Padding(
                child: Text(
                  _error == null ? '' : 'An error occured:\n\n$_error',
                  style: TextStyle(color: Colors.red),
                ),
                padding: EdgeInsets.only(top: 0.0),
              ),
              Padding(
                child: Text(_person == null
                    ? 'Person is null'
                    : 'Converted to Person '
                        'Object:\n\n$_person'),
                padding: EdgeInsets.only(top: 10.0),
              ),
            ],
          ),
          padding: EdgeInsets.all(10.0),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _convertJsonToPerson,
        tooltip: 'Json -> Person',
        child: Icon(Icons.refresh),
      ),
    );
  }

  Widget build_bis(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title + '\nSerialize'),
        ),
        body: Center(
          child: Padding(
            child: ListView(
              children: <Widget>[
                Padding(
                  child: Text('GrandFather:\n$_person'),
                  padding: EdgeInsets.only(top: 0.0),
                ),
                Padding(
                  child: Text(
                    'Json Encoded:\n${json.encode(_person)}',
                    style: TextStyle(color: Colors.red),
                  ),
                  padding: EdgeInsets.only(top: 10.0),
                ),
                FlatButton(
                  child: Text("Copy'"),
                  onPressed: (() {
                    Clipboard.setData(ClipboardData(text: '${json.encode(_person)}'));
                  }),
                ),
              ],
            ),
            padding: EdgeInsets.all(10.0),
          ),
        ));
  }
}
