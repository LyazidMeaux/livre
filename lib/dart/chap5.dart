/*
 * Copyright (c) 2019. Libre de droit
 */

library chap5;

import '../model/Car.dart';
import 'Cadet.dart';
import 'Calculator.dart';
import 'Counter.dart';
import 'IsSilly.dart';
import 'Lambda.dart';
import 'Logger.dart';
import 'Person.dart';
import 'Printer.dart';
import 'ProcessingResult.dart';

void main() {
  print("Start Dart.");
  var calculator = new Calculator();
  int somme = calculator.addOne(10);
  print('${somme.toString()}');

  print(calculator.methodeDynamique(5, 2));

  dynamic x = 1;
  dynamic y = "I Grec";

  calculator.printVar(x);
  calculator.printVar(y);
  calculator.printVar(0.1);
  calculator.printVar(true);

  calculator.printType(x);
  calculator.printType(y);
  calculator.printType(0.1);
  calculator.printType(true);

  Person person = new Person('Lyazid', 'Ghemrani', 55);
  print(
      'Je m\'appelle ${person.firstName} ${person.lastName} et j\'ai ${person.age} ans');

  print('Ligne1\nLigne2');
  print(r'Mot1\nMot2');
  double cout = 125.25;
  print('Cout : \$$cout');

  print(ProcessingResult.success().toString()); // Constructeur
  print(ProcessingResult.failure('Connexion impossible').toString());

  Printer().printMessage('Message 1');
  Printer().printMessage('Message 2');
  Printer().printMessage('Message 3');

  Car car1 = Car.optional('Renault', 'Twingo');
  Car car2 = Car.optional('Peugeot');
  Car car3 = Car('Renault', model: 'Twingo', color: 'Rouge');

  Car('Fiat');
  Car('Skoda', model: 'Fabia', color: 'Noir');

  print('Identique car1-2 ${car1 == car2}');
  print('Identique car1-5 ${car1 == car3}');

  IsSillly clown = Clown();
  IsSillly comedian = Comedian();
  clown.makePeopleLaugh();
  comedian.makePeopleLaugh();

  new Logger().log('Line 1');
  new Logger().log('Line 2');
  new Logger().log('line 3');

  Logger().log('Line 4');
  Logger.trace('Line 5');

  new Logger()..log('text 1')..log('Text 2')..log('Text 3');

  print(new Lambda().divideStandard(10, 2));
  print(new Lambda().divideLambda(2, 5));
  print(new Lambda().divideLambda(4, 52));

  // LIST
  List<Person> persons = [
    Person('Lyazid', 'Ghemrani', 55),
    Person('Yasmina', 'Ghemrani', 51),
    Person('Sakina', 'Ghemrani', 51),
    Person('Mehdi', 'Ghemrani', 26)
  ];
  print('Not Sorted:  $persons');

  persons.sort((a, b) => a.firstName.compareTo(b.firstName));
  print('Sorted by FirstName: $persons');

  persons.sort((a, b) => (a.age > b.age) ? 1 : -1);
  print('Sorted by Age: $persons');

  persons.sort((a, b) => (a.age < b.age) ? 1 : -1);
  print('Sorted by Age: $persons');

  for (Person person in persons) person.checkAge();

  // MAP
  Map<String, String> countries = {
    'FR': 'France',
    'U8A': 'United State',
    'D': 'Germany',
    'I': 'Italia'
  };

  countries['SP'] = 'Spain';

  for (String key in countries.keys) {
    print(key + ' ' + countries[key]);
  }

  // EXCEPTION
  int value = 0;
  try {
    value = int.parse("12u");
  } on FormatException {
    print('Valeur forcée à -1');
    value = -1;
  } catch (ex, stacktrace) {
    print('Exception');
    print(ex);
    print(stacktrace);
  }

  print('Value: $value');

  Cadet cadet = Cadet("Lyazid", 55);
  try {
    cadet.misBehave();
  } catch (e) {
    print('Exception remontée');
  }

  List<Cadet> cadets = [Cadet('Lyazid', 55), Cadet('Yasmina', 51), Cadet('Mehdi', 26)];
  List<Cadet> validCadetList = [];
  for (Cadet cadet in cadets) {
    try {
      Cadet.validateCadet(cadet);
      validCadetList.add(cadet);
    } catch (e) {
      print(e);
    }
  }

  print('Valid Cadet: ${validCadetList.length} / ${cadets.length}');

  // Asynchrone

  print('\nASYNCHONOUS API\n***********\n');
  Counter('A', 10, false);
  Counter('B', 100, false);

  print('\nASYNCHONOUS AWAIT\n***********\n');
  Counter('C', 10, true);
  Counter('D', 1000, true);

  print('\nNULL MANIPULATION\n***********');
  Person personA = null;
  Person personDefault = Person('Lyazid', 'Ghemrani', 55);

  String name = personA?.firstName;
  print('FisrtName: $name');
  name = (personA ??= personDefault).firstName;
  print('Else FisrtName: $name');

  print("\nEnd Dart.");
}
