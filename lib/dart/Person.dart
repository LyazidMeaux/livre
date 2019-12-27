class Person {
  String _firstName;
  String _lastName;
  int _age;

  Person(this._firstName, this._lastName, this._age);

  toString() {
    return _firstName + ' ' + _lastName + ' ' + _age.toString();
  }

  void checkAge() {
    assert(_age < 64, '$_firstName Too young');
  }

  int get age => _age;

  String get lastName => _lastName;

  String get firstName => _firstName;
}
