/*
 * Copyright (c) 2019. Libre de droit
 */
import 'dart:math';

import 'package:flutter/Material.dart';

class Chap20State extends StatefulWidget {
  Chap20State({Key key, this.title, this.etude}) : super(key: key);
  final String title;
  final String etude;

  @override
  //Chap20StatePadding createState() => new Chap20StatePadding();
  //Chap20StateContainer createState() => new Chap20StateContainer();
  //Chap20StateConstraints createState() => new Chap20StateConstraints();
  // Chap20StateExpanded createState() => Chap20StateExpanded();
  //Chap20StateFlex createState() => Chap20StateFlex();
  //Chap20StateCenter createState() => Chap20StateCenter();
  //Chap20StatePositioned createState() => Chap20StatePositioned();

  Chap20StateScroll createState() => Chap20StateScroll();
}

class Chap20StateScroll extends State<Chap20State> {
  CirclePainter circlePainter = CirclePainter();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title + '\nScroll'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
//        scrollDirection: Axis.horizontal,

        physics: AlwaysScrollableScrollPhysics(),
        child: CustomPaint(
          size: Size(2000.0, 2000.0),
          foregroundPainter: circlePainter,
        ),
      ),

/*
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: circlePainter._containers,
          ),
        ),
      ),
*/
    );
  }
}

class Chap20StatePositioned extends State<Chap20State> {
  double _top = 0.0;
  double _left = 0.0;

  List<Widget> widgetList = [];
  final _random = Random();

  int next(int min, int max) => min + _random.nextInt(max - min);

  void addLayer() {
    setState(() {
      widgetList.add(
        Positioned(
          left: _left,
          top: _top,
          child: Container(
            width: 100.0,
            height: 100.0,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 2.0,
              ),
              color: Color.fromRGBO(next(0, 255), next(0, 255), next(0, 255), 0.5),
            ),
          ),
        ),
      );
    });
    _top += 30;
    _left += 30;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title + '\nPositioned',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: new Stack(
        children: widgetList,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addLayer,
        child: Icon(Icons.add),
        tooltip: 'Increment',
      ),
    );
  }
}

class Chap20StateCenter extends State<Chap20State> {
  String _log = 'Log indiquant la festure\n\n';
  void _clear() {
    setState(() => _log = '');
  }

  void _logGesture(String logText) {
    setState(() {
      _log += '\n$logText';
      debugPrint('Debug $logText');
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title + '\nCenter',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            GestureDetector(
              child: Text('Gesture Me'),
              onTap: () => _logGesture('onTap'),
              onDoubleTap: () => _logGesture('onDoubleTap'),
              onForcePressEnd: (details) => _logGesture('onForcePressEnd $details'),
              onForcePressPeak: (details) => _logGesture('onForcePressPeak $details'),
              onForcePressStart: (details) => _logGesture('onForcePressStart $details'),
              onForcePressUpdate: (details) => _logGesture('onForcePressUpdate $details'),

              /* Vertical ou Horizontal
              onHorizontalDragCancel: () => _logGesture('onHorizontalDragCancel'),
              onHorizontalDragDown: (details) =>
                  _logGesture('onHorizontalDragDown $details'),
              onHorizontalDragEnd: (details) =>
                  _logGesture('onHorizontalDragEnd $details'),
              onHorizontalDragStart: (details) =>
                  _logGesture('onHorizontalDragStart $details'),
              onHorizontalDragUpdate: (details) =>
                  _logGesture('onHorizontalDragUpdate $details'),
              */
              onLongPress: () => _logGesture('onLongPress'),
              onLongPressEnd: (details) => _logGesture('onLongPressEnd $details'),
              onLongPressMoveUpdate: (details) =>
                  _logGesture('onLongPressMoveUpdate $details'),
              onLongPressStart: (details) => _logGesture('onLongPressStart $details'),
              onLongPressUp: () => _logGesture('onLongPressUp'),
              /* Pan ou Scale
              onPanCancel: () => _logGesture('onPanCancel'),
              onPanDown: (details) => _logGesture('onPanDown $details'),
              onPanEnd: (details) => _logGesture('onPanEnd $details'),
              onPanStart: (details) => _logGesture('onPanStart $details'),
              onPanUpdate: (details) => _logGesture('onPanUpdate $details'),
              */
              onScaleEnd: (details) => _logGesture('onScaleEnd $details'),
              onScaleStart: (details) => _logGesture('onScaleStart $details'),
              onScaleUpdate: (details) => _logGesture('onScaleUpdate $details'),
              onTapCancel: () => _logGesture('onTapCancel'),
              onTapDown: (details) => _logGesture('onTapDown $details'),
              onTapUp: (details) => _logGesture('onTapUp $details'),
              onVerticalDragCancel: () => _logGesture('onVerticalDragCancel'),
              onVerticalDragDown: (details) => _logGesture('onVerticalDragDown $details'),
              onVerticalDragEnd: (details) => _logGesture('onVerticalDragEnd $details'),
              onVerticalDragStart: (details) =>
                  _logGesture('onVerticalDragStart $details'),
              onVerticalDragUpdate: (details) =>
                  _logGesture('onVerticalDragUpdate $details'),
            ),
            Container(
              child: SingleChildScrollView(
                child: Text(_log),
              ),
              constraints: BoxConstraints(
                maxHeight: 200,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.0),
              ),
              padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.all(10.0),
            ),
            RaisedButton(child: Text('Clear'), onPressed: () => _clear()),
          ],
        ),
      ),
    );
  }
}

class Chap20StateFlex extends State<Chap20State> {
  bool _topTightFit = false;
  bool _bottomExpanded = false;

  toggleTop() {
    setState(() {
      _topTightFit = !_topTightFit;
    });
  }

  toggleBottom() {
    setState(() {
      _bottomExpanded = !_bottomExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    Container topContainer = Container(
      child: Text('Top Container'),
      constraints: BoxConstraints(
        minWidth: 100,
        minHeight: 100,
        maxWidth: 200,
        maxHeight: 200,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blue,
          width: 2.0,
        ),
        color: Colors.blue,
      ),
      padding: EdgeInsets.all(10.0),
    );

    Container bottomContainer = Container(
      child: Text(
        'Bottom Container',
      ),
      constraints: BoxConstraints(
        minWidth: 100.0,
        minHeight: 100,
        maxWidth: 200.0,
        maxHeight: 200.0,
      ),
      decoration: BoxDecoration(
          border: Border.all(
            width: 2.0,
            color: Colors.blue,
          ),
          color: Colors.yellow),
      padding: EdgeInsets.all(10.0),
    );

    Widget topWidget =
        Flexible(child: topContainer, fit: _topTightFit ? FlexFit.tight : FlexFit.loose);

    Widget bottomWidget =
        _bottomExpanded ? Expanded(child: bottomContainer) : bottomContainer;

    String toolBarTop = 'Top\n(' + (_topTightFit ? 'tight)' : 'loose)');
    String toolBarBottom = 'Bottom\n(' +
        (_bottomExpanded
            ? 'Expanded)'
            : 'Not '
                'Expanded)');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title + '\nFlexible',
          style: TextStyle(fontSize: 18.0),
        ),
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () => toggleTop(),
              icon: Icon(
                _topTightFit ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              ),
              label: Text(toolBarTop)),
          FlatButton.icon(
              onPressed: () => toggleBottom(),
              icon: Icon(
                _bottomExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              ),
              label: Text(toolBarBottom)),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[topWidget, bottomWidget],
        ),
      ),
    );
  }
}

class Chap20StateExpanded extends State<Chap20State> {
  bool _topExpanded = false;
  bool _bottomExpanded = false;

  void _toggleTop() {
    setState(() {
      _topExpanded = !_topExpanded;
    });
  }

  void _toggleBottom() {
    setState(() => _bottomExpanded = !_bottomExpanded);
  }

  @override
  Widget build(BuildContext context) {
    Container topContainer = Container(
      child: Text(
        'Top Container',
        style: TextStyle(fontSize: 24, color: Colors.white),
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1.0),
        color: Colors.blue,
      ),
      padding: EdgeInsets.all(10.0),
    );

    Container bottomContainer = Container(
      child:
          Text('Bottom Container', style: TextStyle(fontSize: 24, color: Colors.white)),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1.0),
        color: Colors.red,
      ),
      padding: EdgeInsets.all(1.0),
    );
    Widget topWidget = _topExpanded ? Expanded(child: topContainer) : topContainer;
    Widget bottomWidget =
        _bottomExpanded ? Expanded(child: bottomContainer) : bottomContainer;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title + '\nExpanded'),
        actions: <Widget>[
          FlatButton.icon(
            onPressed: _toggleTop,
            icon: Icon(_topExpanded ? Icons.expand_less : Icons.expand_more),
            label: Text('Top'),
          ),
          FlatButton.icon(
            onPressed: _toggleBottom,
            icon: Icon(_bottomExpanded ? Icons.expand_less : Icons.expand_more),
            label: Text('Bottom'),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[topWidget, bottomWidget],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}

class Chap20StatePadding extends State<Chap20State> {
  static const double TWENTY = 20.0;
  static const List<String> _titles = [
    'all 20.0',
    'left 20.0',
    'right 20.0',
    'top 20.0',
    'bottom 20.0',
    'sym horiz 20.0',
    'sym vert 20.0'
  ];

  static const List<EdgeInsets> _edgeInsets = [
    EdgeInsets.all(TWENTY),
    EdgeInsets.only(left: TWENTY),
    EdgeInsets.only(right: TWENTY),
    EdgeInsets.only(top: TWENTY),
    EdgeInsets.only(bottom: TWENTY),
    EdgeInsets.symmetric(horizontal: 20.0),
    EdgeInsets.symmetric(vertical: 20.0)
  ];

  int _index = 0;
  final Container _childContainer = Container(
    color: Colors.blue,
  );

  void _next() {
    setState(() {
      _index++;
      if (_index >= _titles.length) _index = 0;
    });
  }

  Widget build(BuildContext context) {
    Padding padding = Padding(
      padding: _edgeInsets[_index],
      child: _childContainer,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title + '\nPadding'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => _next(),
          )
        ],
      ),
      body: Center(
        child: Container(
          child: padding,
          decoration: BoxDecoration(border: Border.all(color: Colors.redAccent)),
        ),
      ),
    );
  }
}

class Chap20StateContainer extends State<Chap20State>
    with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _controler;

  @override
  void initState() {
    super.initState();
    _controler = AnimationController(duration: Duration(seconds: 20), vsync: this);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controler)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: Text(widget.title),
        title: Text(widget.title + '\nContainer'),
      ),
      body: new Center(
        child: Container(
          child: RotationTransition(
              turns: AlwaysStoppedAnimation(_animation.value),
              child: Icon(
                Icons.airplanemode_active,
                size: 150.0,
              )),
          decoration: BoxDecoration(
              border: Border.all(width: 2.0, color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              color: Colors.redAccent),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _spin,
        //onPressed: (() => _controler.forward(from: 0)),

        tooltip: 'Increment',
        child: Icon(Icons.refresh),
      ),
    );
  }

  _spin() {
    _controler.forward(from: 0.0);
  }
}

class Chap20StateConstraints extends State<Chap20State> {
  int _counter = 0;
  void _incrementCounter() {
    setState(() => _counter++);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    for (int i = 0; i < _counter; i++) {
      children.add(Container(child: Text('Row ${i}')));
    }
    return Scaffold(
      appBar: AppBar(title: Text(widget.title + '\nConstrainedBox')),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: 350, minHeight: 300, minWidth: 200, maxWidth: 250),
          child: Container(
            decoration: BoxDecoration(border: Border.all()),
            padding: EdgeInsets.all(5.0),
            child: ListView(children: children),
          ),
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

class CirclePainter extends CustomPainter {
  final _random = Random();

  List<Color> _colors = [];
  List<Widget> _containers = [];

  CirclePainter() {
    for (int i = 0; i < 100; i++) {
      _colors.add(Colors.green
          .withRed(_next(0, 255))
          .withGreen(_next(0, 255))
          .withBlue(_next(0, 255)));

      _containers.add(Container(
        height: 100,
        width: 100,
        //color: Colors.green,
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.blue,
          border: Border.all(color: Colors.black),
        ),
        child: Text('$i'),
      ));
    }
  }

  int _next(int min, int max) => min + _random.nextInt(max - min);

  List<Widget> get containers => _containers;

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < 100; i++) {
      var radius = (i * 10).toDouble();
      canvas.drawCircle(
        Offset(1000.0, 1000.0),
        radius,
        Paint()
          ..color = _colors[i]
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke
          ..strokeWidth = 15.0,
      );
    }
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) => false;
}
