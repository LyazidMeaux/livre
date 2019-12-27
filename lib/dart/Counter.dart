class Counter {
  int _count;
  String _letter;
  Counter(this._letter, this._count, bool asynchrone) {
    print('->Start Counter_$_letter');

    if (!asynchrone) {
      print('-->Adding Future API_$_letter.');
      Future<String> future = countFuture(_count);
      future
          .then((onValue) => handleCompletion(onValue))
          .catchError((onError) => handleError(onError));
    } else {
      print('-->Adding Future Asynchronous_$_letter.');
      countFutureAsynchronous(_count);
    }
    print('->Finish Counter_$_letter');
  }

  void handleCompletion(String value) => print('----> Value_$_letter: $value');
  void handleError(err) => print('---->Error on value_$_letter: $err');

  // Methode standard Dont le temps d'execution est grand
  String countUp(int count) {
    print('--->Start countUp_$_letter');
    if (count > 20) throw new Exception('Valeur superieure à 20');

    StringBuffer sb = StringBuffer();

    for (int i = 1; i < 10; i++) {
      sb.write('$i');
    }

    print('--->Finish countUp_$_letter');
    return sb.toString();
  }

  // Appel de la methode et retour lors de sa fin d'execution
  Future<String> countFuture(int count) {
    return new Future(() {
      return countUp(count);
    });
  }

  // Appel Asynchrone
  void countFutureAsynchronous(int count) async {
    print('Start countFutureAsynchronous_$_letter');
    //String value;
    try {
      String value = await countFuture(count);
      print('Finish countFutureAsynchronous_$_letter: $value');
    } catch (ex) {
      print(ex);
    }
  }
}
