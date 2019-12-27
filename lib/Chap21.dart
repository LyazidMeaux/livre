/*
 * Copyright (c) 2019. Libre de droit
 */

import 'package:flutter/material.dart';

class Chap21 extends StatelessWidget {
  Chap21({Key key, this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title + '\nScaffold'),
        backgroundColor: Colors.amber,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => print('AddIcon Button pressed'),
          ),
        ],
      ),
      backgroundColor: Colors.lightBlueAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[Text("BODY"), Text("BOD"), Text("BO"), Text("B")],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        onTap: (index) => debugPrint('BottomNavigationBar typed on Index: $index'),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail),
            title: Text('Mail'),
          ),
        ],
      ),
      bottomSheet: Container(
        color: Colors.amberAccent,
        padding: EdgeInsets.all(20.0),
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.update),
              onPressed: () {
                print('BottomSheet Icon pressed');
              },
            ),
            Text('BottomSheet '
                'Text'),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    print('Drawer Pressed: Menu 1');
                  },
                ),
                Text('Menu 1'),
              ],
            ),
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.keyboard),
                  onPressed: () {
                    print('Drawer Pressed: Menu 2');
                  },
                ),
                Text('Menu 2'),
              ],
            ),
          ],
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          children: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    print('EndDrawer Pressed: Menu 1');
                  },
                ),
                Text('Menu 1'),
              ],
            ),
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.keyboard),
                  onPressed: () {
                    print('EndDrawer Pressed: Menu 2');
                  },
                ),
                Text('Menu 2'),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          print('FloatingActionButton Pressed');
        },
        tooltip: 'Add',
      ),
      persistentFooterButtons: <Widget>[
        IconButton(
          icon: Icon(Icons.rotate_right),
          onPressed: () {
            print('PersistentFooterButtton Pressed');
          },
        ),
        Text('PersitentFooterButton'),
      ],
    );
  }

  Widget build_fullScreen(BuildContext context) {
    return Text('$title \nFullScreen');
  }

  Widget build_FullCenterScreen(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('$title \n FullCenterScreen'),
      ),
    );
  }

  Widget build_fullDisplay(BuildContext context) {
    return Scaffold(
      body: Text('$title \nDisplay'),
    );
  }
}
