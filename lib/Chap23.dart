/*
 * Copyright (c) 2019. Libre de droit
 */
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class Chap23 extends StatelessWidget {
  final String title;
  final String etude;

  Widget chap23;

  Chap23(this.title, {Key key, this.etude}) : super(key: key) {
    chap23 = Chap23_ListView(title);
    chap23 = Chap23_Stream(title);
  }

  @override
  Widget build(BuildContext context) {
    return chap23;
  }
}

class Chap23_Stream extends StatelessWidget {
  String title;
  Chap23_Stream(this.title, {Key key}) : super(key: key);
  final Bloc bloc = Bloc();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(bloc: bloc, child: Chap23_StreamBloc(title, bloc));
  }
}

class Chap23_StreamBloc extends StatelessWidget {
  String title;
  Bloc bloc;
  Chap23_StreamBloc(this.title, this.bloc, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title + '\nStreamBuilder'),
        actions: <Widget>[],
      ),
      body: StreamBuilder<List<Square>>(
        stream: bloc.squareListStream,
        initialData: bloc.initSquareList(),
        builder: (context, snapshot) {
          List<Square> squares = snapshot.data;
          if (squares == null) squares = [Square("Square -1-", Colors.red)];

          return OrientationBuilder(
            builder: (context, orientation) {
              return GridView.builder(
                itemCount: squares.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: (orientation == Orientation.portrait ? 3 : 4)),
                itemBuilder: (BuildContext context, int index) {
                  return GridTile(
                    child: Container(
                      color: squares[index].color,
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          squares[index].text,
                          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => bloc.addAction.add(null),
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
  }
}

class Chap23_ListView extends StatelessWidget {
  final String title;
  final String etude;
  List<dynamic> _nasaOffice = [
    {'Name': 'lyazid', 'Town': 'Meaux', 'Country': 'France'},
    {'Name': 'Ghemrani', 'Town': 'Bezons', 'Country': 'France'},
  ];

  Chap23_ListView(this.title, {Key key, this.etude}) : super(key: key) {
    for (int i = 0; i < 100; i++) {
      _nasaOffice.add({
        'Name': '-$i-',
        'Town': 'Creteil',
        'Country': 'France',
      });
    }

    _nasaOffice.sort((a, b) => a['Name'].compareTo(b['Name']));
  }

  @override
  Widget build(BuildContext context) {
    ListView builder = ListView.builder(
      itemCount: _nasaOffice.length,
      itemBuilder: (context, index) {
        print('Invoking ItemBuilder for index: $index');
        var nasaOffice = _nasaOffice[index];
        return Container(
            decoration: BoxDecoration(
                border: Border.all(
              color: Colors.white,
            )),
            padding: EdgeInsets.all(0.0),
            margin: EdgeInsets.all(10.0),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 0.0,
                vertical: 0.0,
              ),
              dense: false,
              title: Container(child: Text('${nasaOffice['Name']}'), color: Colors.green),
              subtitle: Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.white, width: 2.0)),
                margin: EdgeInsets.all(0.0),
                padding: EdgeInsets.all(0.0),
                child: Text(
                  '${nasaOffice['Town']} , ${nasaOffice['Country']}',
                ),
                // color: Colors.lightGreen,
              ),
              leading: Container(
                color: Colors.amber,
                child: IconButton(
                    icon: Icon(Icons.arrow_left),
                    onPressed: () {
                      print('Parent de $index');
                    }),
              ),
              trailing: Container(
                color: Colors.lightBlueAccent,
                padding: EdgeInsets.all(0.0),
                margin: EdgeInsets.all(0.0),
                child: IconButton(
                  onPressed: () {
                    print('Opening this Tile');
                  },
                  icon: Icon(
                    Icons.arrow_right,
                    //size: 1,
                  ),
                ),
              ),
            ));
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(title + '\nListView.Builder'),
      ),
      body: Center(
        child: builder,
      ),
    );
  }
}

class Square {
  String _text;
  Color _color;

  Square(this._text, this._color);

  operator ==(other) =>
      (other is Square) && (_text == other.text) && (_color == other.color);

  int get hashCode => _text.hashCode ^ _color.hashCode;

  String get text => _text;
  Color get color => _color;
}

class Bloc {
  Random _random = Random();

  List<Square> _squareList = [];

  final _streamController = StreamController();

  Bloc() {
    _streamController.stream.listen(handleAdd);
  }

  int next(int min, int max) => min + _random.nextInt(max - min);

  List<Square> initSquareList() {
    _squareList = [Square("Square -1-", Colors.red)];
    print('Size of _squareList: ${_squareList.length}');
  }

  void dispose() {
    _streamController.close();
  }

  Square createSquare() {
    String prefix = (_squareList.length + 1).toString();
    return Square('Square -$prefix-',
        Color.fromRGBO(next(0, 255), next(0, 255), next(0, 255), 0.5));
  }

  final squareListSubject = BehaviorSubject<List<Square>>();
  Stream<List<Square>> get squareListStream => squareListSubject.stream;

  void handleAdd(void v) {
    _squareList.add(createSquare());
    squareListSubject.add(_squareList);
  }

  Sink get addAction => _streamController.sink;
}

class BlocProvider extends InheritedWidget {
  final Bloc bloc;

  BlocProvider({Key key, @required this.bloc, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static Bloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(BlocProvider) as BlocProvider).bloc;
}
