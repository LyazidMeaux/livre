/*
 * Copyright (c) 2019. Libre de droit
 */
import 'package:flutter/material.dart';

class Chap19State extends StatefulWidget {
  Chap19State({Key key, this.title, String comment}) : super(key: key);

  final String title;
  final PleaseWaitWidget _pleaseWaitWidget =
      PleaseWaitWidget(key: ObjectKey('pleaseWaiutWidget'));
  final AppWidget _appWidget = AppWidget(key: ObjectKey('appWidget'));

  @override
  //Chap19StateFlex createState_Flex() => new Chap19StateFlex();
  //Chap19StateTiles createState() => new Chap19StateTiles();
  Chap19StateStack createState() => new Chap19StateStack();
}

class Chap19StateTiles extends State<Chap19State> {
  int _selectedIndex = 0;
  static const TEXT_STYLE_NORMAL = const TextStyle(
    color: Colors.black,
    fontSize: 18.0,
    fontWeight: FontWeight.normal,
  );
  static const TEXT_STYLE_SELECTED = const TextStyle(
    color: Colors.black,
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
  );

  final TextFormField _fontSizeTextField = TextFormField(
    decoration: InputDecoration(
        icon: Icon(Icons.format_size),
        hintText: 'Font Size',
        labelText: 'Enter the font size'),
  );

  final TextFormField _historyTextFormField = TextFormField(
      decoration: InputDecoration(
          icon: Icon(Icons.history), hintText: 'Days', labelText: 'Enter days'));

  final TextFormField _languageTextFormField = TextFormField(
    decoration: InputDecoration(
        icon: Icon(Icons.language),
        hintText: 'Language',
        labelText: 'Enter your language'),
  );

  select(index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ListTile accessibilityListTile = ListTile(
      leading: Icon(Icons.accessibility),
      title: Text(
        'Accessibility',
        style: _selectedIndex == 0 ? TEXT_STYLE_SELECTED : TEXT_STYLE_NORMAL,
      ),
      subtitle: Text('Accessibility Settings'),
      trailing: Icon(Icons.settings),
      onTap: () => select(0), //     onTap: (){select(0);},
    );

    final ListTile histoyTile = ListTile(
      leading: Icon(Icons.history),
      title: Text(
        'History',
        style: _selectedIndex == 1 ? TEXT_STYLE_SELECTED : TEXT_STYLE_NORMAL,
      ),
      subtitle: Text('History Settings'),
      onTap: () => select(1),
      trailing: Icon(Icons.settings),
    );

    final ListTile languageTile = ListTile(
      leading: Icon(Icons.language),
      title: Text('Language',
          style: _selectedIndex == 2 ? TEXT_STYLE_SELECTED : TEXT_STYLE_NORMAL),
      subtitle: Text('Language Settings'),
      trailing: Icon(Icons.language),
      onTap: () => select(2),
    );
    final String selectionTitle = (_selectedIndex == 0
            ? 'Accessibility'
            : _selectedIndex == 1 ? 'History' : 'Language') +
        ' Setting';
    final TextFormField selectionTextFormField = _selectedIndex == 0
        ? _fontSizeTextField
        : _selectedIndex == 1 ? _historyTextFormField : _languageTextFormField;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: <Widget>[accessibilityListTile, histoyTile, languageTile],
      ),
      bottomSheet: Container(
          color: Color(0xFFB3E5FC),
          padding: EdgeInsets.all(20.0),
          child: Container(
            constraints: BoxConstraints(maxHeight: 250.0),
            child: Column(
              children: <Widget>[
                Icon(Icons.settings),
                Text(selectionTitle),
                Expanded(
                  child: selectionTextFormField,
                )
              ],
            ),
          )),
    );
  }
}

class Chap19StateFlex extends State<Chap19State> {
  List<MainAxisAlignment> _alignments = [
    MainAxisAlignment.start,
    MainAxisAlignment.spaceBetween,
    MainAxisAlignment.spaceEvenly,
    MainAxisAlignment.spaceAround,
    MainAxisAlignment.end,
    MainAxisAlignment.center,
  ];

  List<String> _textAlignments = [
    'Start',
    'SpaceBetween',
    'SpaceEvenly',
    'SpaceAround',
    'End',
    'Center',
  ];

  bool _vertical = true;
  int _alignmentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.rotate_right),
              tooltip: 'Direction',
              onPressed: () {
                setState(() {
                  _vertical = !_vertical;
                });
              }),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Text(_vertical ? 'Vertical' : 'Horizontal'),
          ),
          IconButton(
              icon: Icon(Icons.aspect_ratio),
              onPressed: () {
                setState(() {
                  _alignmentIndex++;
                  if (_alignmentIndex >= _alignments.length) _alignmentIndex = 0;
                });
              }),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Text(_textAlignments[_alignmentIndex]),
          ),
          Padding(padding: EdgeInsets.all(10.0)),
        ],
      ),
      body: Flex(
        direction: _vertical ? Axis.vertical : Axis.horizontal,
        mainAxisAlignment: _alignments[_alignmentIndex],
        children: <Widget>[
          RMB.getOne(Colors.red),
          RMB.getOne(Colors.green),
          RMB.getOne(Colors.blue)
        ],
      ),
    );
  }
}

class Chap19StateStack extends State<Chap19State> {
  bool _pleaseWait = false;

  void _togglePleaseWait() {
    setState(() {
      _pleaseWait = !_pleaseWait;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> childWidgets =
        _pleaseWait ? [widget._appWidget, widget._pleaseWaitWidget] : [widget._appWidget];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        key: ObjectKey('stack'),
        children: childWidgets,
      ),
      floatingActionButton: new FloatingActionButton.extended(
        onPressed: _togglePleaseWait,
        label: Text('Please wait ON/OFF'),
        icon: Icon(Icons.cached),
      ),
    );
  }
}

class PleaseWaitWidget extends StatelessWidget {
  PleaseWaitWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 8.0,
        ),
      ),
      color: Colors.grey.withOpacity(0.3),
    );
  }
}

class AppWidget extends StatelessWidget {
  AppWidget({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            'Ligne 1.0',
            style: TextStyle(fontSize: 20.0),
          ),
          Text(
            'Ligne 1.1',
            style: TextStyle(fontSize: 20.0),
          ),
          Text(
            'Ligne 1.2',
            style: TextStyle(fontSize: 20.0),
          ),
          Text(
            'Ligne 1.3',
            style: TextStyle(fontSize: 20.0),
          ),
          Text(
            'Ligne 1.4',
            style: TextStyle(fontSize: 20.0),
          ),
        ],
      ),
    );
  }
}

class RMB {
  static Widget getOne(Color color) {
    return RawMaterialButton(
      onPressed: () {},
      elevation: 2.0,
      fillColor: color,
    );
  }
}
