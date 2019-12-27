class Customer {
  String _firstName;
  String _lastName;
  bool _upButton;
  bool _downButton;

  Customer(this._firstName, this._lastName) {
    _upButton = false;
    _downButton = false;
  }
  String get name => _firstName + ' ' + _lastName;
  bool get upButton => _upButton;
  bool get downButton => _downButton;

  set upButton(bool value) => _upButton = value;
  set downButton(bool value) => _downButton = value;

  operator ==(other) => other is Customer && _firstName == other._firstName && _lastName == other._lastName;

  int get hashCode => _firstName.hashCode ^ _lastName.hashCode;
}
