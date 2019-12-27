/*
 * Copyright (c) 2019. Libre de droit
 */
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Chap22State extends StatefulWidget {
  final String etude;
  final String title;

  Chap22State({Key key, this.title, this.etude}) : super(key: key);
  //Chap22StateAlertDialog createState() => Chap22StateAlertDialog();
  //Chap22StateSimpleDialog createState() => Chap22StateSimpleDialog();
  //Chap22StateCustomDialog createState() )=> Chap22StateCustomDialog();
  //Chap22StateDismissible createState() => Chap22StateDismissible();
  //Chap22StateExpansionPanel createState() => Chap22StateExpansionPanel();
  //Chap22StateGridView createState() => Chap22StateGridView();

  Chap22StatePopup createState() => Chap22StatePopup();
}

class Chap22StatePopup extends State<Chap22State> {
  int _counter = 0;

  _increment(int by) {
    setState(() {
      _counter += by;
    });
  }

  void _onPopupMenuSelected(PopupMenuAction item) {
    if (PopupMenuAction.exit == item) {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    } else {
      _increment(
          PopupMenuAction.add1 == item ? 1 : PopupMenuAction.add10 == item ? 10 : 100);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title + '\nPopup'),
        actions: <Widget>[
          PopupMenuButton<PopupMenuAction>(
            onSelected: _onPopupMenuSelected,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<PopupMenuAction>>[
                  PopupMenuItem<PopupMenuAction>(
                    value: PopupMenuAction.add1,
                    child: Text('+1'),
                  ),
                  PopupMenuItem<PopupMenuAction>(
                    value: PopupMenuAction.add10,
                    child: Text('+10'),
                  ),
                  PopupMenuItem<PopupMenuAction>(
                    value: PopupMenuAction.add100,
                    child: Text('+100'),
                  ),
                  PopupMenuItem<PopupMenuAction>(
                    value: PopupMenuAction.exit,
                    child: Text('Exit'),
                  ),
                ],
          ),
        ],
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Text('You have pushed Button this many times: '),
          Text(
            '$_counter',
            style: Theme.of(context).textTheme.display1,
          ),
        ]),
      ),
    );
  }
}

class Chap22StateGridView extends State<Chap22State> {
  List<Widget> _kittenTiles = [];
  int _gridOptionIndex = 0;
  List<GridOptions> _gridOptions = [
    GridOptions(2, 3, 1.0, 10.0, 10.0),
    GridOptions(3, 4, 1.0, 10.0, 10.0),
    GridOptions(4, 5, 1.0, 10.0, 10.0),
    GridOptions(2, 3, 1.0, 10.0, 10.0),
    GridOptions(2, 3, 1.5, 10.0, 10.0),
    GridOptions(2, 3, 2.0, 10.0, 10.0),
    GridOptions(2, 3, 1.0, 10.0, 10.0),
    GridOptions(2, 3, 1.5, 20.0, 10.0),
    GridOptions(2, 3, 2.0, 30.0, 10.0),
    GridOptions(2, 3, 1.0, 10.0, 10.0),
    GridOptions(2, 3, 1.5, 10.0, 20.0),
    GridOptions(2, 3, 2.0, 10.0, 30.0),
  ];

  Chap22StateGridView() : super() {
    for (int i = 200; i < 1000; i += 100) {
      String imageUrl = 'http://placekitten.com/200/${i}';
      _kittenTiles.add(GridTile(
        header: GridTileBar(
          title: Text(
            'Cats',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color.fromRGBO(0, 0, 0, 0.5),
        ),
        footer: GridTileBar(
          title: Text('How cute ',
              textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),
      ));
    }
  }

  void _tryMoreOptions() {
    setState(() {
      _gridOptionIndex++;
      if (_gridOptionIndex >= _gridOptions.length) _gridOptionIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    GridOptions options = _gridOptions[_gridOptionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title + '\nGridView'),
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        return GridView.count(
          crossAxisCount: (orientation == Orientation.portrait)
              ? options._crossAxisCountPortrait
              : options._crossAxisCountLandscape,
          childAspectRatio: options._childAspectRatio,
          padding: EdgeInsets.all(options._padding),
          mainAxisSpacing: options._spacing,
          crossAxisSpacing: options._spacing,
          children: _kittenTiles,
        );
      }),
      bottomNavigationBar: Container(
        child: Text('Index: ' + _gridOptionIndex.toString() + ' ' + options.toString()),
        padding: EdgeInsets.all(20.0),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _tryMoreOptions,
        tooltip: 'Try more grid Options',
        child: Icon(Icons.refresh),
      ),
    );
  }
}

class Chap22StateExpansionPanel extends State<Chap22State> {
  List<ExpansionPanelData> _expansionPanelData = [
    ExpansionPanelData('a', 'aaa', false),
    ExpansionPanelData('b', 'bbb', false),
    ExpansionPanelData('c', 'ccc', false),
    ExpansionPanelData('d', 'ddd', false),
    ExpansionPanelData('e', 'eee', false),
  ];
  Chap22StateExpansionPanel() {}

  _onExpansion(int panelIndex, bool isExpanded) {
    setState(() {
      _expansionPanelData[panelIndex]._expanded =
          !_expansionPanelData[panelIndex]._expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<ExpansionPanel> expansionPanels = [];
    for (int i = 0; i < _expansionPanelData.length; i++) {
      var expansionPanelData = _expansionPanelData[i];
      expansionPanels.add(
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                expansionPanelData._title,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            );
          },
          body: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              expansionPanelData._body,
              style: TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic),
            ),
          ),
          isExpanded: expansionPanelData._expanded,
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title + '\nExpansionPanel'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(24.0),
          child: ExpansionPanelList(
            children: expansionPanels,
            expansionCallback: _onExpansion,
          ),
        ),
      ),
    );
  }
}

class Chap22StateDismissible extends State<Chap22State> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  List<String> CAT_NAME = [
    'Ange',
    'Brigitte',
    'Cecile',
    'Danny',
    'Evelyne',
    'Fouzia',
    'Gania'
  ];

  Random _random = Random();
  List<Cat> _cats = [];
  Chap22StateDismissible() : super() {
    for (int i = 0; i < 7; i++) {
      _cats.add(Cat(
        'http://placekitten.com/200/210',
        CAT_NAME[i],
        next(1, 32),
        0,
      ));
    }
  }

  int next(int min, int max) => min + _random.nextInt(max - min);

  _buildItem(Cat cat, {int index = -1}) {
    print('_buildItem');
    return ListTile(
      key: Key('ListTile:${cat.hashCode.toString()}'),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(cat.imageScr),
        radius: 32.0,
      ),
      title: Text(
        cat.name,
        style: TextStyle(fontSize: 25.0),
      ),
      subtitle: Text(
        'This little thug is ${cat.age} years(s) old.',
        style: TextStyle(fontSize: 15.0),
      ),
    );
  }

  _onDismissed(int index) {
    _cats.removeAt(index);
  }

//  Future<bool> _confirmDismiss(DismissDirection direction, int index) async {
  Future<bool> _confirmDismiss(int index) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm'),
          content: Text('Are you sure you want to delete ?'),
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
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title + '\nDismissible')),
      body: ListView.builder(
        itemCount: _cats != null ? _cats.length : 0,
        itemBuilder: (context, index) {
          debugPrint('Index: $index ${_cats.length}');
          Cat cat = _cats[index];
          return Dismissible(
            // Il n'est lancé qu'une seule fois il gere lui meme la
            // suppression du Widget dans l'arbre; Mais pas du tableau.
            confirmDismiss: (direction) => _confirmDismiss(index),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _onDismissed(index),
            key: ValueKey(
              cat.hashCode.toString(),
            ),
            child: _buildItem(cat, index: index),
          );
        },
      ),
    );
  }
}

class Chap22StateCustomDialog extends State<Chap22State> {
  List<Widget> _kittenTiles = [];
  GridOptions _gridOptions = GridOptions(2, 3, 1.0, 4.0, 4.0);

  Chap22StateCustomDialog() : super() {
    for (int i = 200; i < 1000; i += 100) {
      String imageUrl = 'http://placekitten.com/200/${i}';
      _kittenTiles.add(GridTile(
        header: GridTileBar(
          title: Text(
            'Cats',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color.fromRGBO(0, 0, 0, 0.5),
        ),
        footer: GridTileBar(
          title: Text(
            'How Cute',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        child: Image.network(imageUrl),
      ));
    }
  }

  void _showGridOptionsDialog() async {
    GridOptions gridOptions = await showDialog<GridOptions>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: CustomDialog(this._gridOptions),
        );
      },
    );
    if (gridOptions != null) {
      setState(() {
        this._gridOptions = gridOptions;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title + '\nCustom Dialog',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return GridView.count(
            crossAxisCount: (orientation == Orientation.portrait)
                ? _gridOptions._crossAxisCountPortrait
                : _gridOptions._crossAxisCountLandscape,
            childAspectRatio: _gridOptions._childAspectRatio,
            padding: EdgeInsets.all(_gridOptions._padding),
            crossAxisSpacing: _gridOptions._spacing,
            mainAxisSpacing: _gridOptions._spacing,
            children: _kittenTiles,
          );
        },
      ),
      bottomNavigationBar: Container(
        child: Text(_gridOptions.toString()),
        padding: EdgeInsets.all(20.0),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: _showGridOptionsDialog,
        tooltip: 'Try more grid options',
      ),
    );
  }
}

class Chap22StateSimpleDialog extends State<Chap22State> {
  BoxFit _boxFit = BoxFit.cover;

  Future<BoxFit> _showFitDialog() async {
    BoxFit boxFit = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Select Box Fit'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, BoxFit.cover);
              },
              child: Text("Cover"),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, BoxFit.contain);
              },
              child: Text('Contain'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, BoxFit.fill);
              },
              child: Text('Fill'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, BoxFit.fitHeight);
              },
              child: Text('FitHeight'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, BoxFit.fitWidth);
              },
              child: Text('FitWidth'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, BoxFit.scaleDown);
              },
              child: Text('ScaleDown'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, BoxFit.none);
              },
              child: Text('None'),
            ),
          ],
        );
      },
    );
    if (boxFit != null) {
      setState(() {
        _boxFit = boxFit;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> kittenTiles = [];

    for (int i = 200; i < 1000; i += 100) {
      String imageUrl = 'http://placekitten.com/200/${i}';
      kittenTiles.add(GridTile(
        child: Image.network(
          imageUrl,
          fit: _boxFit,
        ),
      ));
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title + '\nSimpleDialog'),
        ),
        /*
        body: OrientationBuilder(
          builder: (context, orientation) {
            return GridView.count(
              crossAxisCount: (orientation == Orientation.portrait ? 2 : 3),
              childAspectRatio: 1.0,
              mainAxisSpacing: 1.0,
              crossAxisSpacing: 1.0,
              children: kittenTiles,
            );
          },
        ),
        */

        body: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
          mainAxisSpacing: 1.0,
          crossAxisSpacing: 1.0,
          children: kittenTiles,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showFitDialog,
          child: Icon(Icons.select_all),
        ));
  }
}

class Chap22StateAlertDialog extends State<Chap22State> {
  int _counter = 0;

  void _incrementCounter() => setState(() => _counter++);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title + '\nAlertDialog'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('you Increment Value is '),
            Text('$_counter'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _requestIncrementCounter,
        child: Icon(Icons.add),
        tooltip: 'Add',
      ),
    );
  }

  void _requestIncrementCounter() {
    _showConfirmDialog().then((result) {
      if (result) _incrementCounter();
    });
  }

  Future<bool> _showConfirmDialog() async {
    return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm'),
          content: Text('Are you sure to increment Counter ?'),
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
            ),
          ],
        );
      },
    );
  }
}

class CustomDialog extends StatefulWidget {
  GridOptions _gridOption;
  CustomDialog(this._gridOption) : super();

  CustomDialogState createState() => CustomDialogState(GridOptions.copyOf(_gridOption));
}

class CustomDialogState extends State<CustomDialog> {
  GridOptions _gridOptions;
  List<DropdownMenuItem<int>> _itemsPortrait = [];

  CustomDialogState(this._gridOptions) {
    for (int i = 1; i < 7; i++) {
      _itemsPortrait.add(DropdownMenuItem<int>(value: i, child: Text('$i')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400.0,
      width: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(
            'Grid Option',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Spacer(),
              Text('Cross Axis Count Portrait'),
              Spacer(),
              DropdownButton<int>(
                value: _gridOptions._crossAxisCountPortrait,
                items:
                    /*
                <int>[2, 3, 4, 5, 6].map((int value) {
                  return new DropdownMenuItem<int>(
                    value: value,
                    child: Text('$value'),
                  );
                }).toList(),
                */
                    _itemsPortrait,
                onChanged: (value) {
                  setState(() {
                    _gridOptions._crossAxisCountPortrait = value;
                  });
                },
              ),
              Spacer(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Spacer(),
              Text('Cross Axis Count Landscape'),
              Spacer(),
              DropdownButton<int>(
                value: _gridOptions._crossAxisCountLandscape,
                items: <int>[1, 2, 3, 4, 5, 6].map((int value) {
                  return DropdownMenuItem<int>(
                      value: value,
                      child: Text(
                        value.toString(),
                      ));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _gridOptions._crossAxisCountLandscape = value;
                  });
                },
              ),
              Spacer(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Spacer(),
              Text('Child Aspect Ration'),
              Spacer(),
              DropdownButton<double>(
                value: _gridOptions._childAspectRatio,
                items: <double>[1.0, 1.5, 2.0, 2.5].map((double value) {
                  return DropdownMenuItem<double>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _gridOptions._childAspectRatio = value;
                  });
                },
              ),
              Spacer(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Spacer(),
              Text('Padding'),
              Spacer(),
              DropdownButton<double>(
                value: _gridOptions._padding,
                items: <double>[1.0, 2.0, 4.0, 8.0, 16.0, 32.0].map((double value) {
                  return DropdownMenuItem<double>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _gridOptions._padding = value;
                  });
                },
              ),
              Spacer(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Spacer(),
              Text('Spacing'),
              Spacer(),
              DropdownButton<double>(
                value: _gridOptions._spacing,
                items: <double>[1.0, 2.0, 4.0, 8.0, 16.0, 32.0].map((double value) {
                  return DropdownMenuItem<double>(
                    value: value,
                    child: Text('$value'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _gridOptions._spacing = value;
                  });
                },
              )
            ],
          ),
          FlatButton(
            child: Text('Apply'),
            onPressed: () {
              Navigator.pop(context, _gridOptions);
            },
          ),
        ],
      ),
    );
  }
}

class GridOptions {
  int _crossAxisCountPortrait;
  int _crossAxisCountLandscape;

  double _childAspectRatio;
  double _padding;
  double _spacing;

  GridOptions(this._crossAxisCountPortrait, this._crossAxisCountLandscape,
      this._childAspectRatio, this._padding, this._spacing);

  GridOptions.copyOf(GridOptions gridOption) {
    this._crossAxisCountPortrait = gridOption._crossAxisCountPortrait;
    this._crossAxisCountLandscape = gridOption._crossAxisCountLandscape;
    this._childAspectRatio = gridOption._childAspectRatio;
    this._padding = gridOption._padding;
    this._spacing = gridOption._spacing;
  }
  @override
  String toString() {
    return '\nCrossAxisCountPortrait = $_crossAxisCountPortrait' +
        '\nCrossAxisCountLandscape = $_crossAxisCountLandscape' +
        '\nChildAspectRatio = $_childAspectRatio' +
        '\nPadding = $_padding' +
        '\nSpacing = $_spacing';
  }
}

class Cat {
  String imageScr;
  String name;
  int age;
  int vote;

  Cat(this.imageScr, this.name, this.age, this.vote) : super();

  operator ==(other) => (other is Cat) && (name == other.name);

  int get hashCode => name.hashCode;
}

class ExpansionPanelData {
  String _title;
  String _body;
  bool _expanded;

  ExpansionPanelData(this._title, this._body, this._expanded);

  String get title => _title;

  @override
  String toString() {
    return 'ExpansionPanelData Title:$_title';
  }

  bool get expanded => _expanded;

  set expanded(bool value) {
    _expanded = value;
  }

  String get body => _body;
}

enum PopupMenuAction { add1, add10, add100, exit }
