/*
 * Copyright (c) 2019. Libre de droit
 */
class Employee {
  String id;
  String name;
  String salary;
  String age;
  String photo;

  Employee(this.id, this.name, this.salary, this.age, this.photo);

  Employee.empty() {
    id = '';
    name = '';
    salary = '';
    age = '';
    photo = '';
  }

  factory Employee.fromJson(Map<String, dynamic> json) {
    if (json == null) throw FormatException('Json is null');
    Employee employee = Employee(
      json['id'],
      json['employee_name'],
      json['employee_salary'],
      json['employee_age'],
      json['profile_image'],
    );
    return employee;
  }

  Map<String, dynamic> toJson() {
    var map = {'name': name, 'salary': salary, 'age': age};
    if (id.isNotEmpty) map['id'] = id;
    if (photo.isNotEmpty) map['profile_image'] = photo;
    return map;
  }

  get hasEmptyId => id.isEmpty;
}
