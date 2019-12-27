/*
 * Copyright (c) 2019. Libre de droit
 */
class PersonInfo {
  String _fName = '';
  String _lName = '';
  String _sex = 'm';
  String _adr1 = '';
  String _adr2 = '';
  String _city = '';
  String _state = '';
  String _zip = '';
  bool _fiveYears = false;
  DateTime _dob;

  PersonInfo(this._fName, this._lName, this._sex, this._adr1, this._adr2, this._city,
      this._state, this._zip, this._fiveYears, this._dob);

  PersonInfo.empty();

  DateTime get dob => _dob;

  bool get fiveYears => _fiveYears;

  String get zip => _zip;

  String get state => _state;

  String get city => _city;

  String get adr2 => _adr2;

  String get adr1 => _adr1;

  String get sex => _sex;

  String get lName => _lName;

  String get fName => _fName;

  @override
  String toString() {
    return 'FName: $_fName, LName: $_lName, Sex: $_sex, Adr1: $_adr1, Adr2: $_adr2, City: '
        '$_city, State: $_state, Zip:$_zip, FiveYears: $_fiveYears, Dob: $_dob';
  }
}
