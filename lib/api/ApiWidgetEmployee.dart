/*
 * Copyright (c) 2019. Libre de droit
 */

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as HTTP;
import 'package:http/http.dart';

import '../model/Employee.dart';

class ApiWidgetEmployee extends InheritedWidget {
  static final String _BASE_URL = 'http://dummy.restapiexample.com/api/v1';
  static const _TIMEOUT = Duration(seconds: 10);

  ApiWidgetEmployee({Key key, @required Widget child});

  /*
  ApiWidgetEmployee({Key key, @required Widget child})
      : assert(child != null),
        super(key: key, child: child);
*/

  static ApiWidgetEmployee of(BuildContext context) {
    return ApiWidgetEmployee();
    //   return context.inheritFromWidgetOfExactType(ApiWidgetEmployee) as ApiWidgetEmployee;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget OldWidget) {
    return false;
  }

  Future<List<Employee>> loadAndParseEmployees() async {
    var uri = '$_BASE_URL/employees';

    debugPrint('Requete Server: loadAndParseEmployees Server -> $uri');
    final response = await HTTP.get(uri).timeout(_TIMEOUT);
    if (response.statusCode == 200) {
      List<Employee> employees = [];

      List<dynamic> jsonData = json.decode(response.body);

      for (Map<String, dynamic> line in jsonData) {
        employees.add(Employee.fromJson(line));
      }

      return employees;
    } else
      badStatusCode(response);
  }

  Future<Employee> loadEmployee(String id) async {
    //id = '1';
    var uri = '$_BASE_URL/employee/$id';
    print('loadEmployee: $uri');
    final response = await HTTP.get(uri).timeout(_TIMEOUT);
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);
      return Employee.fromJson(parsed);
    } else
      badStatusCode(response);
  }

  Future<dynamic> saveEmployee(Employee employee) async {
    bool isUpdate = employee.id.isNotEmpty;
    var uri = '$_BASE_URL' + (isUpdate ? '/update/${employee.id}' : '/create');
    debugPrint('Requete appelée: $uri');
    debugPrint('SAVE: ${json.encode(employee)}');

    final response = isUpdate
        ? await HTTP.put(uri, body: json.encode(employee)).timeout(_TIMEOUT)
        : await HTTP.post(uri, body: json.encode(employee)).timeout(_TIMEOUT);

    if (response.statusCode == 200) {
      debugPrint('BODY: ${response.body}');
      return json.decode(response.body);
    } else
      badStatusCode(response);
  }

  Future<dynamic> deleteEmployee(String id) async {
    var uri = '$_BASE_URL/delete/$id';
    final response = await HTTP.delete(uri).timeout(_TIMEOUT);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else
      badStatusCode(response);
  }

  badStatusCode(Response response) {
    debugPrint('Bad Status code ${response.statusCode} returned form server.');
    debugPrint('Respponse Body ${response.body} returned from server.');
    throw Exception('Bad Status code ${response.statusCode} returned form server.');
  }
}
