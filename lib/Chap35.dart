/*
 * Copyright (c) 2019. Libre de droit
 */
import 'dart:math';

import 'package:flutter/material.dart';

class Chap35 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chap35',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Chap350(title: 'Chap35'),
    );
  }
}

class Chap350 extends StatefulWidget {
  final String title;
  Chap350({this.title, Key key}) : super(key: key);
  // Chap351State createState() => Chap351State();
  // Chap352State createState() => Chap352State();
  // Chap353State createState() => Chap353State();
  // Chap354State createState() => Chap354State();
  // Chap355State createState() => Chap355State();
  Chap356State createState() => Chap356State();
}

class Chap351State extends State<Chap350> {
  bool b = false;

  void _changeMode() {
    setState(() {
      b = !b;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            AnimatedContainer(
              duration: Duration(milliseconds: 100),
              child: Center(
                child: Text(
                  'Top',
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w200),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            AnimatedContainer(
              color: b ? Colors.redAccent : Colors.orangeAccent,
              height: b ? 200.0 : 400.0,
              duration: Duration(milliseconds: 100),
              child: Center(
                child: Text(
                  'Bottom',
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w200),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _changeMode,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class Chap352State extends State<Chap350> {
  TextStyle textStyle1 = const TextStyle(
    color: Colors.blue,
    fontSize: 40.0,
    fontWeight: FontWeight.w200,
  );
  TextStyle textStyle2 = const TextStyle(
    color: Colors.green,
    fontSize: 40.0,
    fontWeight: FontWeight.w600,
  );

  int _counter = 0;
  _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = _counter % 2 == 0 ? textStyle1 : textStyle2;
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedDefaultTextStyle(
              child: Text('Ligne 1'),
              textAlign: TextAlign.center,
              duration: Duration(seconds: 1),
              style: textStyle,
            ),
            AnimatedDefaultTextStyle(
              child: Text('Ligne 2 et peut etre la suivant'),
              textAlign: TextAlign.center,
              duration: Duration(seconds: 1),
              style: textStyle,
            ),
            AnimatedDefaultTextStyle(
              child: Text('Ligne 3  et on arrete la'),
              textAlign: TextAlign.center,
              duration: Duration(seconds: 1),
              style: textStyle,
            ),
            AnimatedDefaultTextStyle(
              child: Text('$_counter'),
              textAlign: TextAlign.center,
              duration: Duration(seconds: 1),
              style: textStyle,
            ),
            AnimatedDefaultTextStyle(
              child: Text('Ligne 1'),
              textAlign: TextAlign.center,
              duration: Duration(seconds: 1),
              style: textStyle,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class Chap353State extends State<Chap350> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  List<String> CAT_NAMES = [
    'A_1',
    'A_2',
    'A_3',
    'A_4',
    'A_5',
    'A_6',
    'A_7',
  ];

  Random _random = Random();

  List<Cat> _cats = [];

  int next(int min, int max) => min + (_random.nextInt(max - min));

  Chap353State() : super() {
    for (int i = 200; i < 250; i += 10) {
      _cats.add(Cat(
        'http://placekitten.com/200/$i',
        CAT_NAMES[next(00, 6)],
        next(1, 32),
        0,
      ));
    }
  }

  _buildItem(Cat cat, {int index = -1}) {
    return ListTile(
      key: Key('ListTile:${cat.hashCode.toString()}'),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(cat.imageSrc),
        radius: 32.0,
      ),
      title: Text(
        '${cat.name}',
        style: TextStyle(fontSize: 25),
      ),
      subtitle: Text(
        'This little thug is ${cat.age} years old.',
        style: TextStyle(fontSize: 15.0),
      ),
      onLongPress: index != null ? () => _remove(index) : null,
    );
  }

  _add() {
    setState(() {
      _cats.add(Cat('http://placekitten.com/200/${next(200, 300)}', CAT_NAMES[next(0, 6)],
          next(1, 32), 0));
    });
    _listKey.currentState.insertItem(_cats.length - 1, duration: Duration(seconds: 2));
  }

  _remove(int index) {
    setState(() {
      Cat cat = _cats[index];
      _cats.remove(cat);
      _listKey.currentState.removeItem(
        index,
        (context, animation) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Interval(0.5, 1.0),
            ),
            child: SizeTransition(
              sizeFactor: CurvedAnimation(parent: animation, curve: Interval(0.0, 1.0)),
              axisAlignment: 0.0,
              child: _buildItem(cat),
            ),
          );
        },
        duration: Duration(milliseconds: 600),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: AnimatedList(
          key: _listKey,
          initialItemCount: _cats.length,
          itemBuilder: (BuildContext context, int index, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: _buildItem(_cats[index], index: index),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _add,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class Chap354State extends State<Chap350> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  CurvedAnimation _curvedAnimation;

  void _performAnimation() {
    setState(() {
      if (_controller.status != AnimationStatus.forward) {
        _controller.forward(from: 0.0);
      }
    });
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(() {
        setState(() {});
      });

    _curvedAnimation = CurvedAnimation(parent: _controller, curve: Curves.bounceInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('_controller: ${_controller.value}')),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CustomPaint(
            foregroundPainter: ProgressCirclePainter(
                lineColor: Colors.amber,
                completeColor: Colors.blueAccent,
                completePercent: _controller.value * 100,
                //completePercent: _curvedAnimation.value * 100,
                width: 18.0),
          ),
        ),
        constraints: BoxConstraints.expand(),
        margin: EdgeInsets.all(8.0),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _performAnimation,
        child: Icon(Icons.refresh),
      ),
    );
  }
}

class Chap355State extends State<Chap350> {
  _yesOnTap() {
    print('Yes');
  }

  _noOnTap() {
    print('No');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'Do you want to \nbuy this item?',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontSize: 40.0, fontWeight: FontWeight.w200),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Spacer(),
              SelectButton(text: 'YES', onTap: _yesOnTap()),
              Spacer(),
              SelectButton(text: 'NO', onTap: _noOnTap()),
              Spacer(
                flex: 2,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Chap356State extends State<Chap350> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(duration: Duration(seconds: 10), vsync: this)
      ..addListener(() {
        setState(() {/* Force Build */});
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.dismissed) {
          _controller.forward();
        } else if (status == AnimationStatus.completed) {
          _controller.reverse();
        }
      });
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Transform.scale(
            scale: 1.6,
            child: Transform.rotate(
              angle: pi * _controller.value,
              child: Image.network('https://ak7.picdn'
                  '.net/shutterstock/videos/3010597/thumb/1.jpg'),
            )),
      ),
    );
  }
}

class SelectButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  SelectButton({@required this.text, @required this.onTap});

  @override
  SelectButtonState createState() => SelectButtonState();
}

class SelectButtonState extends State<SelectButton> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Color> _circleTween;
  Animation<Color> _textTween;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 5))
      ..addListener(() {
        setState(() {/* Force build */});
      })
      ..addStatusListener((AnimationStatus status) {
        /*
        if (status == AnimationStatus.completed)
          _controller.reverse();
        else if (status == AnimationStatus.dismissed) _controller.forward();
       */
        if (status == AnimationStatus.completed) waitThenReset();
      });
    _circleTween = ColorTween(begin: Colors.teal, end: Colors.white).animate(_controller);

    _textTween = ColorTween(begin: Colors.white, end: Colors.teal).animate(_controller);
  }

  Future waitThenReset() async {
    await Future.delayed(Duration(milliseconds: 5000), () {
      _controller.reverse(from: 0.9);
      widget.onTap();
    });
  }

  _onTap() {
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    double leftPos = widget.text.length == 3 ? 22.0 : 27.0;
    return GestureDetector(
        onTap: _onTap,
        child: Material(
          type: MaterialType.transparency,
          child: Ink(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 1),
              color: _circleTween.value,
              shape: BoxShape.circle,
            ),
            width: 100.0,
            height: 100.0,
            child: Padding(
              padding: EdgeInsets.only(left: leftPos, top: 32.0),
              child: Text(
                widget.text,
                style: TextStyle(
                    color: _textTween.value,
                    fontSize: 28.0,
                    fontWeight: _controller.status == AnimationStatus.completed
                        ? FontWeight.w500
                        : FontWeight.w200),
              ),
            ),
          ),
        ));
  }
}

class ProgressCirclePainter extends CustomPainter {
  Color lineColor;
  Color completeColor;
  double completePercent;
  double width;

  ProgressCirclePainter(
      {this.lineColor, this.completeColor, this.completePercent, this.width});

  @override
  void paint(Canvas canvas, Size size) {
    Paint line = Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    Paint complete = Paint()
      ..color = completeColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);
    canvas.drawCircle(center, radius, line);

    double arcAngle = 2 * pi * (completePercent / 100);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      arcAngle,
      false,
      complete,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
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
