/*
 * Copyright (c) 2019. Libre de droit
 */
import 'package:flutter/material.dart';

class Chap22 extends StatelessWidget {
  String title;
  String etude;

  Chap22(this.title, {Key key, this.etude}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var chap22_SnakBar = Chap22_SnackBar(title);
    var chap22_Spacer = Chap22_Spacer(title);
    var chap22_Tab = Chap22_Tab(title);
    var chap22_Table = Chap22_Table(title);

    return chap22_Table;
  }
}

class Chap22_Table extends StatelessWidget {
  String title;
  Chap22_Table(this.title, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TableRow tableRow = TableRow(
      children: [
        Text(
          'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
          overflow: TextOverflow.fade,
        ),
        Text(
          'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb',
          overflow: TextOverflow.fade,
        ),
        Text(
          'ccccccccccccccccccccccccccccccccccc',
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );

    return Scaffold(
        appBar: AppBar(title: Text(title + '\nTable')),
        body: Column(children: <Widget>[
          Expanded(
              child: SingleChildScrollView(
            child:
                //
                Table(
              children: [
                tableRow,
                tableRow,
                tableRow,
                tableRow,
                tableRow,
                tableRow,
                tableRow,
                tableRow,
                tableRow,
                tableRow,
                tableRow,
                tableRow,
                tableRow,
                tableRow,
                tableRow,
                tableRow,
                tableRow,
                tableRow,
                tableRow,
                tableRow,
                tableRow,
                tableRow,
                tableRow,
                tableRow,
                tableRow,
                tableRow,
                tableRow,
                tableRow,
                tableRow,
                tableRow,
                tableRow,
                tableRow,
                tableRow,
                tableRow,
                tableRow,
                tableRow,
                tableRow,
              ],
              columnWidths: <int, TableColumnWidth>{
                0: FlexColumnWidth(0.1),
                1: FlexColumnWidth(0.3),
                2: FlexColumnWidth(0.6),
              },
              border: TableBorder.all(),
            ),
            //
          ))
        ])

        /*  Si pas de simpleScrollView
      body : Table(children: [tableRow,..,tableRow,],
        columnWidths: <int, TableColumnWidth>{
          0: FlexColumnWidth(0.1),
          1: FlexColumnWidth(0.3),
          2: FlexColumnWidth(0.6),
        },
        border: TableBorder.all(),
      ),
      */

        );
  }
}

class Chap22_Tab extends StatelessWidget {
  String title;
  Chap22_Tab(this.title, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title + '\nTabBar'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: 'Tab #1',
                icon: Icon(Icons.keyboard_arrow_left),
              ),
              Tab(
                text: 'Tab #2',
                icon: Icon(Icons.keyboard_arrow_up),
              ),
              Tab(
                text: 'Tab #3',
                icon: Icon(Icons.keyboard_arrow_right),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[Tab1(), Tab3(), Tab2()],
        ),
        bottomNavigationBar: Container(
          child: TabBar(
            //Apple
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(color: Colors.blue, fontWeight: FontWeight.w800),
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(
                text: 'Tab #1',
                icon: Icon(Icons.keyboard_arrow_left),
              ),
              Tab(
                text: 'Tab #2',
                icon: Icon(Icons.keyboard_arrow_up),
              ),
              Tab(
                text: 'Tab #3',
                icon: Icon(Icons.keyboard_arrow_right),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Chap22_Spacer extends StatelessWidget {
  String _title;
  Chap22_Spacer(this._title, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Spacer(),
          Center(
              child: Text(
            _title + '\nSpacer',
            style: TextStyle(fontSize: 20.0),
          )),
          Spacer(
            flex: 5,
          ),
          IconButton(
            icon: Icon(Icons.settings_overscan),
            onPressed: () {},
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.settings_overscan),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text('Dummy')],
        ),
      ),
    );
  }
}

class Chap22_SnackBar extends StatelessWidget {
  String title;

  Chap22_SnackBar(this.title, {Key key}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _showSnackBar() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('An unexcpected error occured : Error'),
      duration: Duration(seconds: 1),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(title + '\nSnakBar'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Content goes here'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Throw error'),
        onPressed: () => _showSnackBar(),
        icon: Icon(Icons.explicit),
        tooltip: 'Throw error',
      ),
    );
  }
}

class Tab1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.network('http://placekitten.com/200/200');
  }
}

class Tab2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.network('http://placekitten.com/200/300');
  }
}

class Tab3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.network('http://placekitten.com/200/400');
  }
}
