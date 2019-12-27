/*
 * Copyright (c) 2019. Libre de droit
 */

class Person {
  String name;
  String addr;
  String city;
  String state;

  List<Person> children = [];

  Person(this.name, this.addr, this.city, this.state);

  @override
  String toString() {
    return 'Person{name: $name, addr: $addr, city: $city, state: $state} Children => ' +
        children.toString();
  }

  factory Person.fromSimpleJson(Map<String, dynamic> json) {
    if (json == null) throw FormatException('Null JSON');
    return new Person(
      json['name'] as String,
      json['addr'] as String,
      json['city'] as String,
      json['state'] as String,
    );
  }

  factory Person.fromRecursifJson(Map<String, dynamic> json) {
    if (json == null) throw FormatException('Null JSON');
    Person person = Person.fromSimpleJson(json);
    List<Person> children = person.children;

    List<dynamic> decodedChildren = json['children'];
    if (decodedChildren != null) {
      decodedChildren.forEach((decodedChild) {
        children.add(Person.fromRecursifJson(decodedChild));
      });
    }
    return person;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'addr': addr,
        'city': city,
        'state': state,
        'children': children,
      };
}

//Form Root Project : basic>  flutter packages pub run build_runner build
