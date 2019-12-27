/*
 * Copyright (c) 2019. Libre de droit
 */
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

enum Language { english, french }

class Word {
  final int _id;

  final String _english;

  final String _french;

  Word(this._id, this._english, this._french);

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'english': _english,
      'french': _french,
    };
  }

  String get french => _french;
  String get english => _english;
  int get id => _id;

  operator ==(other) => other != null && other is Word && _id == other._id;

  int get hashCode => _id.hashCode;
}

class Chap311 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DbWidget(
      child: MaterialApp(
        title: 'Chap311 SqfLite',
        theme: ThemeData(brightness: Brightness.dark),
        home: HomeWidget(),
      ),
    );
  }
}

class DbWidget extends InheritedWidget {
  final _random = Random();
  Database _database;
  String _databasesPath;
  DbWidget({Key key, @required Widget child})
      : assert(child != null),
        super(key: key, child: child);

  Future<bool> loadDatabasesPath() async {
    debugPrint('loadDatabasesPath:');
    _databasesPath = await getDatabasesPath();
    debugPrint('_databasePath: ${_databasesPath}');
    return true;
  }

  /// TIPS PATH: /data/data/fr.lyazid.basic
  /// TIPS ADB Dans file structure Project positionner le SDK
  Future<bool> openAndInitDatabase() async {
    debugPrint('openAndInitDatabase');
    _database = await openDatabase(
      join(_databasesPath, 'vocabulary_1.db'),
      onCreate: (db, version) {
        debugPrint('Creating Database ....');

        db.execute('CREATE TABLE mots (id INTEGER PRIMARY KEY,english TEXT,french TEXT,'
            ' correct INTEGER, incorrect INTEGER)');
        db.execute('INSERT INTO mots(english,french) VALUES ("uncle","oncle")');
        db.execute('INSERT INTO mots(english,french) VALUES ("born","naitre")');
        db.execute('INSERT INTO mots(english,french) VALUES ("ten","dix")');
        db.execute('INSERT INTO mots(english,french) VALUES ("one","un")');
        db.execute('INSERT INTO mots(english,french) VALUES ("two","deux")');
        db.execute('INSERT INTO mots(english,french) VALUES ("three","trois")');
        db.execute('INSERT INTO mots(english,french) VALUES ("four","quatre")');
        db.execute('INSERT INTO mots(english,french) VALUES ("five","cinq")');
        debugPrint('Done');
      },
      version: 1,
      onOpen: (db) {
        debugPrint('Open Database ....');
      },
      onConfigure: (db) {
        debugPrint('Configure Database ....');
      },
    );
    return true;
  }

  Future<Word> loadNextWord(Word priorWord) async {
    debugPrint('loadNextWord:');
    final List<Map<String, dynamic>> words = await _database.query('mots');
    final List<Word> list = List.generate(words.length, (i) {
      return Word(
        words[i]['id'],
        words[i]['english'],
        words[i]['french'],
      );
    });
    Word nextWord = null;
    do {
      int nextWordIndex = _nextRandom(0, list.length);
      nextWord = list[nextWordIndex];
    } while (nextWord == priorWord);
    return nextWord;
  }

  Future<int> addWord(Word word) async {
    debugPrint('AddWord ${word.french} -> ${word.english}');
    return await _database.insert(
      'mots',
      word.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteWord(Word word) async {
    return _database.delete(
      'mots',
      where: 'id = ?',
      whereArgs: [word.id],
    );
  }

  static DbWidget of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(DbWidget) as DbWidget;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  int _nextRandom(int min, int max) => min + _random.nextInt(max - min);
}

class HomeWidget extends StatefulWidget {
  HomeWidget({Key key}) : super(key: key);

  HomeWidgetState createState() => HomeWidgetState();
}

class HomeWidgetState extends State<HomeWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _loadedDatabasePath = false;
  bool _openDatabase = false;

  Language _language = Language.english;
  Word _priorWord;
  Word _word;

  _showSnackBar(String content, {bool error = false}) {
    debugPrint(content);
    _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('${error ? "an unexpected error occured : " : ""} $content')));
  }

  _loadDatabasesPath(BuildContext context) {
    debugPrint('_loadDatabasesPath: ');
    try {
      DbWidget.of(context).loadDatabasesPath().then((b) {
        setState(() {
          _loadedDatabasePath = true;
        });
      }).catchError((error) {
        _showSnackBar(error.toString(), error: true);
      });
    } catch (e) {
      _showSnackBar(e.toString(), error: true);
    }
  }

  _openAndInitDatabases(BuildContext context) {
    debugPrint('_OpenAndInitDatabases:');
    try {
      DbWidget.of(context).openAndInitDatabase().then((b) {
        setState(() {
          debugPrint('Open Database');
          _openDatabase = true;
        });
      }).catchError((error) {
        _showSnackBar(error.toString(), error: true);
      });
    } catch (e) {
      _showSnackBar(e.toString(), error: true);
    }
  }

  _loadWord(BuildContext context) {
    try {
      DbWidget.of(context).loadNextWord(_priorWord).then((word) {
        setState(() {
          _word = word;
        });
      }).catchError((error) {
        _showSnackBar(error.toString(), error: true);
      });
    } catch (e) {
      _showSnackBar(e.toString(), error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('HomeWidgetState Build');
    if (!_loadedDatabasePath) {
      _loadDatabasesPath(context);
    } else if (!_openDatabase) {
      _openAndInitDatabases(context);
    } else if (_word == null) _loadWord(context);

    WordWidget englishWordWidget = WordWidget(Language.english, _language, _word);
    WordWidget frenchWordWidget = WordWidget(Language.french, _language, _word);

    Column wordWidgets = _language == Language.french
        ? Column(children: [englishWordWidget, frenchWordWidget])
        : Column(children: [frenchWordWidget, englishWordWidget]);

    AppBar appBar = AppBar(title: Text('Vocabulary'), actions: <Widget>[
      IconButton(icon: Icon(Icons.shuffle), onPressed: () => _switchLanguage()),
      IconButton(icon: Icon(Icons.add), onPressed: () => _addWord(context)),
      IconButton(icon: Icon(Icons.remove), onPressed: () => _deleteWord(context)),
    ]);

    // TODO : tapez i pour iterate puis CTRL <Espace>, puis entrer sur le type
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBar,
      body: wordWidgets,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () => _loadNextWord(),
      ),
    );
  }

  _loadNextWord() {
    setState(() {
      _priorWord = _word;
      _word = null;
    });
  }

  _switchLanguage() {
    Language newLanguage =
        _language == Language.french ? Language.english : Language.french;
    setState(() => _language = newLanguage);
  }

  _addWord(BuildContext context) async {
    Word word = await showDialog<Word>(
        context: context,
        builder: (BuildContext context) {
          return Dialog(child: AddDialogWidget());
        });
    if (word != null) {
      try {
        DbWidget.of(context).addWord(word).then((_) {
          _loadNextWord();
          _showSnackBar('Added word.');
        }).catchError((e) => _showSnackBar(e.toString(), error: true));
      } catch (e) {
        _showSnackBar(e.toString(), error: true);
      }
    }
  }

  _deleteWord(BuildContext context) {
    _showConfirmDialog(context, _word).then((result) {
      if (result == true) {
        try {
          DbWidget.of(context).deleteWord(_word).then((_) {
            _loadNextWord();
            _showSnackBar('Deleted word.');
          }).catchError((e) => _showSnackBar(e.toString(), error: true));
        } catch (e) {
          _showSnackBar(e.toString(), error: true);
        }
      }
    });
  }
}

class WordWidget extends StatefulWidget {
  final Language _widgetLanguage;
  final Language _language;
  final Word _word;

  WordWidget(this._widgetLanguage, this._language, this._word);

  @override
  _WordWidgetState createState() => _WordWidgetState();
}

class _WordWidgetState extends State<WordWidget> {
  bool _revealed = false;

  _WordWidgetState();

  @override
  void didUpdateWidget(Widget oldWidget) {
    _revealed = false;
  }

  @override
  Widget build(BuildContext context) {
    bool isReveal = widget._widgetLanguage == widget._language;

    List<Widget> widgets = [];
    String titleText = isReveal
        ? 'What the word in ${getLanguageName(widget._widgetLanguage)}?'
        : 'Word in ${getLanguageName(widget._widgetLanguage)} is: ';

    widgets.add(Padding(
      padding: EdgeInsets.only(bottom: 20.0),
      child: Text(
        titleText,
        style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    ));

    if (isReveal && !_revealed) {
      widgets.add(FloatingActionButton(
        child: Icon(Icons.remove_red_eye),
        onPressed: () => {setState(() => _revealed = true)},
      ));
    } else {
      String word = widget._word == null
          ? ''
          : widget._widgetLanguage == Language.english
              ? widget._word.english
              : widget._word.french;

      widgets.add(Text(
        word,
        style: TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
        ),
        textAlign: TextAlign.center,
      ));
    }

    return Expanded(
      child: Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: widgets),
        decoration: BoxDecoration(
            image: DecorationImage(
          colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.3), BlendMode.dstATop),
          image: NetworkImage(widget._widgetLanguage == Language.english
              ? 'https://upload.wikimedia'
                  '.org/wikipedia/en/thumb/a/ae/Flag_of_the_United_Kingdom'
                  '.svg/510px-Flag_of_UUnited_Kingdom.svg.png'
              : 'https://upload.wikimedia'
                  '.org/wikipedia/en/thumb/9/9a/Flag_of_Spain'
                  '.svg/400px-Flag_of_Spain.svg.png'),
          fit: BoxFit.cover,
        )),
        padding: EdgeInsets.all(10.0),
      ),
    );
  }

  getLanguageName(Language widgetLanguage) {
    return widget._widgetLanguage == Language.english ? 'English' : 'French';
  }
}

class AddDialogWidget extends StatelessWidget {
  static final _formKey = GlobalKey<FormState>();
  static final TextEditingController _englishTextController = TextEditingController();
  static final TextEditingController _frenchTextController = TextEditingController();

  AddDialogWidget() : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260.0,
      width: 250.0,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Add word',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter the word in english';
                  }
                },
                decoration: InputDecoration(
                    icon: Icon(Icons.location_city),
                    hintText: 'English',
                    labelText: 'Enter the word in english'),
                onSaved: (String value) {},
                controller: _englishTextController,
              ),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter the word in french';
                  }
                },
                decoration: InputDecoration(
                    icon: Icon(Icons.location_city),
                    hintText: 'French',
                    labelText: 'Enter the word in french'),
                onSaved: (String value) {},
                controller: _frenchTextController,
              ),
              FlatButton(
                child: Text('Add'),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    Navigator.pop(
                        context,
                        Word(null, _englishTextController.text,
                            _frenchTextController.text));
                    _englishTextController.text = '';
                    _frenchTextController.text = '';
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool> _showConfirmDialog(BuildContext context, Word word) async {
  return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm'),
          content: Text('Are you sure to delete the word "${word.english}?'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text('Yes'),
            ),
            FlatButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text('No'),
            )
          ],
        );
      });
}
