class Logger {
  Logger();
  void log(dynamic text) {
    print(DateTime.now().toString() + ' Log ' + text);
  }

  Logger.trace(dynamic text) {
    print(DateTime.now().toString() + ' Trace ' + text);
  }
}
