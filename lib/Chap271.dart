/*
 * Copyright (c) 2019. Libre de droit
 */
/*
 * Copyright (c) 2019. Libre de droit
 */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:main/ui/EmployeeDetailWidget.dart';
import 'package:main/ui/PleaseWaitWidget.dart';

import 'api/ApiWidgetEmployee.dart';
import 'model/Employee.dart';

class Chap271 extends StatefulWidget {
  final String title;
  Chap271(this.title, {Key key}) : super(key: key);
  Chap271State_Http createState() => Chap271State_Http();
}

class Chap271State_Http extends State<Chap271> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PleaseWaitWidget _pleaseWaitWidget = PleaseWaitWidget(
    key: ObjectKey('PleaseWaitWidget'),
  );

  bool _refresh = true;
  List<Employee> _employees;
  bool _pleaseWait = false;
  ApiWidgetEmployee api = ApiWidgetEmployee(child: null);

  _showSnackBar(String content, {dynamic error = false}) {
    // TODO : Remettre la ligne

    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('${error ? "An unexpected error occurred:" : ""}$content'),
    ));
    debugPrint('$content');
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
      //ApiWidgetEmployee api = ApiWidgetEmployee.of(context);
//      ApiWidgetEmployee.of(context).loadAndParseEmployees().then((employees) {
      debugPrint('Chargement de la base employee: $api');

      api.loadAndParseEmployees().then((employees) {
        employees.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        setState(() {
          _employees = employees;
        });
        _showPleaseWait(false);
      }).catchError((error) {
        _showPleaseWait(false);
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
