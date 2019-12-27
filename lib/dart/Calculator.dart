/// A Calculator.
class Calculator {
  Calculator() {
    print('Création de la classe Calculator');
  }

  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;

  dynamic methodeDynamique(int a, int b) {
    return a * b;
  }

  void printType(dynamic variable) {
    if (variable is int)
      print('Integer');
    else if (variable is String)
      print('String');
    else if (variable is double)
      print('Double');
    else
      print('Type Inconnu.');
  }

  void printVar(var variable) {
    print(variable.runtimeType);
  }
}
