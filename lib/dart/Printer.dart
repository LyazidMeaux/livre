class Printer {
  static final Printer _singleton = Printer._construct();

  factory Printer() {
    return _singleton;
  }

// Renvoie l'objet instancié car Constructeur Methode
  Printer._construct() {
    print('Appel du constructeur private');
  }

  void printMessage(String message) {
    print('$message');
  }
}
