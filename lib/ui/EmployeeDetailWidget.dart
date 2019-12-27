/*
 * Copyright (c) 2019. Libre de droit
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:main/api/ApiWidgetEmployee.dart';
import 'package:main/model/Employee.dart';

import 'PleaseWaitWidget.dart';

class EmployeeDetailWidget extends StatefulWidget {
  String _employeeId;

  EmployeeDetailWidget(this._employeeId);

  @override
  EmployeeDetailWidgetState createState() => EmployeeDetailWidgetState(_employeeId);
}

class EmployeeDetailWidgetState extends State<EmployeeDetailWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final PleaseWaitWidget _pleaseWaitWidget =
      PleaseWaitWidget(key: ObjectKey('pleaseWaitWidget'));
  String _employeeId;
  bool _loaded = false;
  bool _pleaseWait = false;
  Employee _employee;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _salaryController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _photoController = TextEditingController();

  EmployeeDetailWidgetState(this._employeeId);

  _showSnackBar(String content, {bool error = false}) {
    debugPrint('_showSnackBar [ERROR] : $content');
    // TODO : Pourquoi ne fonctionne t'il pas avec les key et state
    var states = _scaffoldKey.currentState;
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('${error ? "An expected error occured: " : ""}$content'),
    ));
  }

  _showPleaseWait(bool b) {
    setState(() {
      _pleaseWait = b;
    });
  }

  TextFormField _createNameWidget() {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) return 'Please enter the Name';
      },
      decoration: InputDecoration(
        icon: Icon(Icons.person),
        hintText: 'Name',
        labelText: 'Enter the name',
      ),
      onSaved: (String value) {
        this._employee.name = value;
      },
      controller: _nameController,
      autofocus: false,
    );
  }

  TextFormField _createSalaryWidget() {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter the Salary';
        }
        int salary = int.parse(value);
        if (salary == null) {
          return 'Please enter salary like number';
        }
        if (salary < 100 || salary > 100000) {
          return 'Please enter a salry between 100 and 100000';
        }
      },
      maxLength: 6,
      maxLengthEnforced: true,
      keyboardType: TextInputType.number,
      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        icon: Icon(Icons.person),
        hintText: 'Salary',
        labelText: 'Enter the salary',
      ),
      onSaved: (String value) {
        this._employee.salary = value;
      },
      controller: _salaryController,
    );
  }

  TextFormField _createAgeWidget() {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter the age';
        }
        int age = int.parse(value);
        if (age == null) {
          return 'Please enter age like number';
        }
        if (age < 16 || age > 100) {
          return 'Please enter an age between 16 and 100';
        }
      },
      maxLength: 3,
      maxLengthEnforced: true,
      keyboardType: TextInputType.phone,
      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        icon: Icon(Icons.person),
        hintText: 'Age',
        labelText: 'Enter the age',
      ),
      onSaved: (String value) {
        this._employee.age = value;
      },
      controller: _ageController,
    );
  }

  TextFormField _createPhotoWidget() {
    return TextFormField(
      decoration: InputDecoration(
        icon: Icon(Icons.person),
        hintText: 'Photo',
        labelText: 'Enter the photoname',
      ),
      onSaved: (String value) {
        this._employee.photo = value;
      },
      controller: _photoController,
    );
  }

  _loadEmployee(BuildContext context) {
    _showPleaseWait(true);
    try {
      // TODO: Renommer avec employee et creer un package API
      ApiWidgetEmployee.of(context).loadEmployee(_employeeId).then((employee) {
        setState(() {
          _employee = employee;
          _nameController.text = _employee.name;
          _salaryController.text = _employee.salary;
          _ageController.text = _employee.age;
          _photoController.text = _employee.photo;
        });
        _showPleaseWait(false);
      }).catchError((error) {
        _showPleaseWait(false);
        _showSnackBar(error.toString(), error: true);
      });
    } catch (error) {
      _showPleaseWait(false);
      _showSnackBar(error.toString(), error: true);
    }
  }

  _saveEmployee(BuildContext context) {
    _showPleaseWait(true);
    try {
      ApiWidgetEmployee.of(context).saveEmployee(_employee).then((employee) {
        _showPleaseWait(false);
        Navigator.pop(context, true);
      }).catchError((error) {
        _showPleaseWait(false);
        _showSnackBar(error.toString(), error: true);
      });
    } catch (error) {
      _showPleaseWait(false);
      _showSnackBar(error.toString(), error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      _loaded = true;
      if (_employeeId == null) {
        _employee = Employee.empty();
      } else {
        _loadEmployee(context);
      }
    }

    List<Widget> formWidgetList = [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        child: _createNameWidget(),
      ),
      _createSalaryWidget(),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        child: _createAgeWidget(),
      ),
      _createPhotoWidget(),
      Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: RaisedButton(
            padding: EdgeInsets.symmetric(vertical: 0.0),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                _saveEmployee(context);
              }
            },
            child: Text('Save'),
          )),
    ];

    Form form = Form(key: _formKey, child: ListView(children: formWidgetList));
    Widget bodyWidget = _pleaseWait
        ? Stack(key: ObjectKey('stack'), children: [_pleaseWaitWidget, form])
        : Stack(key: ObjectKey('stack'), children: [form]);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Text('Back'),
            Spacer(),
            Text(_employeeId == null ? 'Create Employee' : 'EditEmployee')
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: bodyWidget,
      ),
    );
  }
}
