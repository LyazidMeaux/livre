/*
 * Copyright (c) 2019. Libre de droit
 */
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Chap37 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ('Chap 37'),
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Chap370(title: 'Chap370'),
    );
  }
}

class Chap370 extends StatefulWidget {
  final String title;

  Chap370({Key key, this.title}) : super(key: key);

  @override
  Chap370State createState() => Chap370State();
}

class Chap370State extends State<Chap370> {
  Random _random = Random();

  List<Cat> _cats = [];

  int next(int min, int max) => min + (_random.nextInt(max - min));

  Chap370State() : super() {
    for (int i = 200; i < 250; i += 10) {
      _cats.add(Cat(
        'http://placekitten.com/200/$i',
        CAT_NAMES[next(0, 6)],
        next(1, 32),
        0,
      ));
    }
  }

  void _shuffle() {
    setState(() {
      _cats.shuffle(_random);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chap370 Value Key'),
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        return GridView.builder(
            itemCount: _cats.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
            ),
            itemBuilder: (context, index) {
              return CatTile(_cats[index]);
            });
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: _shuffle,
        tooltip: 'Try more Grid',
        child: Icon(Icons.refresh),
      ),
    );
  }
}

class Chap371 extends StatefulWidget {
  Chap371();
  Chap371State createState() => Chap371State();
}

class Chap371State extends State<Chap371> {
  GlobalKey _counterWidgetGlobalKey = GlobalKey();
  bool _widget1 = true;

  void _selectPage() {
    setState(() => _widget1 = !_widget1);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chap371 GlobalKey',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: _widget1
          ? Widget1(_counterWidgetGlobalKey, _selectPage)
          : Widget2(_counterWidgetGlobalKey, _selectPage),
    );
  }
}

final key = GlobalKey<WidgetStateA>();

class Chap372 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              child: WidgetA(key: key),
              color: Colors.greenAccent,
            ),
            Container(
              child: WidgetB(),
              color: Colors.blueAccent,
            )
          ],
        ),
      ),
    );
  }
}

class WidgetA extends StatefulWidget {
  WidgetA({Key key}) : super(key: key);
  State createState() => WidgetStateA();
}

class WidgetStateA extends State<WidgetA> {
  String _state = 'Some state';
  String get state => _state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          Text('Widget A',
              textAlign: TextAlign.center, style: Theme.of(context).textTheme.display1),
          Text('State: $_state',
              textAlign: TextAlign.center, style: Theme.of(context).textTheme.display2),
        ],
        crossAxisAlignment: CrossAxisAlignment.stretch,
      ),
    );
  }
}

class WidgetB extends StatefulWidget {
  State createState() => WidgetStateB();
}

class WidgetStateB extends State<WidgetB> {
  String _text = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Widget B',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.display2,
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: RaisedButton(
                child: Text('Getstate '
                    'from WidgetA'),
                onPressed: () {
                  setState(() {
                    _text = key.currentState.state;
                  });
                }),
          ),
          Text('State: $_text',
              textAlign: TextAlign.center, style: Theme.of(context).textTheme.display1),
        ],
      ),
    );
  }
}

class Widget1 extends StatelessWidget {
  final GlobalKey _counterWidgetGlobalKey;
  final VoidCallback _selectPageCallback;

  Widget1(this._counterWidgetGlobalKey, this._selectPageCallback);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Widget 1'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh), onPressed: () => _selectPageCallback())
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text('Widget 1',
              textAlign: TextAlign.center, style: Theme.of(context).textTheme.display2),
          CounterWidget(_counterWidgetGlobalKey),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceAround,
      ),
    );
  }
}

class Widget2 extends StatelessWidget {
  final GlobalKey _counterWidgetGlobalKey;
  final VoidCallback _selectPageCallback;
  Widget2(this._counterWidgetGlobalKey, this._selectPageCallback);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Widget 2'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh), onPressed: () => _selectPageCallback())
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text('Widget 2',
              textAlign: TextAlign.center, style: Theme.of(context).textTheme.display2),
          CounterWidget(_counterWidgetGlobalKey),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceAround,
      ),
    );
  }
}

class CounterWidget extends StatefulWidget {
  CounterWidget(Key key) : super(key: key);

  @override
  CounterWidgetState createState() => CounterWidgetState();
}

class CounterWidgetState extends State<CounterWidget> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
      debugPrint('Counter: $_counter');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Counter Widget',
          style: Theme.of(context).textTheme.display2,
        ),
        Text(
          'You have: ',
          style: Theme.of(context).textTheme.display1,
        ),
        Text(
          '$_counter',
          style: Theme.of(context).textTheme.display1,
        ),
        IconButton(
          iconSize: 36.0,
          icon: Icon(Icons.add),
          onPressed: () => _incrementCounter(),
        ),
      ],
    );
  }
}

class CatTile extends StatefulWidget {
  Cat _cat;
  //CatTile(this._cat);
  CatTile(this._cat) : super(key: ValueKey(_cat.imageSrc));

  @override
  CatTileState createState() => CatTileState(_cat);
}

class CatTileState extends State<CatTile> {
  Cat _cat;
  CatTileState(this._cat);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: _vote,
        child: GridTile(
          header: GridTileBar(
            title: Text(
              '${_cat.name} ${_cat.age} years old',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Color.fromRGBO(0, 0, 0, 0.5),
          ),
          footer: GridTileBar(
            title: Text(
              _cat.votes == 0 ? 'No votes.' : '${_cat.votes}',
              textAlign: TextAlign.right,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          child: Image.network(_cat.imageSrc, fit: BoxFit.cover),
        ));
  }

  _vote() {
    setState(() => _cat.votes++);
  }
}

class Cat {
  String imageSrc;
  String name;
  int age;
  int votes;

  Cat(this.imageSrc, this.name, this.age, this.votes);
  operator ==(other) => (other is Cat && other.imageSrc == imageSrc);

  int get hashCode => imageSrc.hashCode;
}

const List<String> CAT_NAMES = [
  'A_1',
  'A_2',
  'A_3',
  'A_4',
  'A_5',
  'A_6',
  'A_7',
];
