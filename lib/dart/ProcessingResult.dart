class ProcessingResult {
  // Variables privées
  bool _error;
  String _errorMessage;

  // Multi Constructeur
  ProcessingResult.success() {
    _error = false;
    _errorMessage = '';
  }

  ProcessingResult.failure(this._errorMessage) {
    _error = true;
  }

  // 2 facons de faire un return (comme un print ou standard)
  String toString() {
    if (_error)
      return ('Error: $_error Message: $_errorMessage');
    else
      return 'Error: ' + _error.toString();
  }
}
