import 'Cadet.dart';

class TooOldException implements Exception {
  Cadet _cadet;

  TooOldException(this._cadet);

  @override
  String toString() {
    return _cadet.name + ' est trop vieux !!!';
  }
}
