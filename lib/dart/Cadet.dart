import 'TooOldException.dart';

class Cadet {
  String _name;
  int _age;

  Cadet(this._name, this._age);

  void misBehave() {
    try {
      dynamic foo = true;
      print(foo++);
    } catch (e) {
      print('misBehave ${e.runtimeType}');
      rethrow;
    }
  }

  // On peut appeler par _cadet.age
  int get age => _age;

  String get name => _name;

  static void validateCadet(Cadet cadet) {
    if (cadet.age > 50) throw new TooOldException(cadet);
  }
}
