/*
 * Copyright (c) 2019. Libre de droit
 */
import 'package:flutter/material.dart';

class Chap20 extends StatelessWidget {
  final String title;

  Chap20({this.title});

  List<News> _newsList = [
    News(DateTime(2018, 12, 1), 'Meaux', 'Tres beau temps prevu ce jour\n Couvrez vous'),
    new News(
        DateTime(2018, 12, 1),
        'Dijon',
        'Tu peux y manger\nde la moutarde\ndes bonbons et'
            ' \n'
            ' du casuis'
            'Tres beau '
            'temps prevu ce jour\n Couvrez vous'),
    new News(
        DateTime(2018, 12, 1),
        'Bezons',
        'Y travailler c'
            'est deja pas tres facile y '
            'vivre '
            'est dur, \n y manger  il faut le vouloir')
  ];

  @override
  Widget build(BuildContext context) {
    List<Widget> newsCards = _newsList.map((news) => NewCard(news)).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Card'),
      ),
      body: Container(
          color: Colors.lightBlueAccent,
          child: ListView(padding: EdgeInsets.all(20.0), children: newsCards)),
    );
  }
}

class News {
  DateTime _dt;
  String _title;
  String _text;

  News(this._dt, this._title, this._text);
}

class NewCard extends StatelessWidget {
  News _news;
  NewCard(this._news);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.0),
      child: Card(
        child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Image.network(
                    'https://ichef.bbci.co.uk/wwfeatures/live/960_540/images/live/p0/77/yz/p077yzlp.jpg'),
                Padding(
                  padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                  child: Text(
                    '${_news._dt.day}//${_news._dt.month}//${_news._dt.year}',
                    style: TextStyle(fontSize: 10.0, fontStyle: FontStyle.italic),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text('${_news._title}',
                        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold))),
                Text(
                  '${_news._text}',
                  maxLines: 2,
                  style: TextStyle(fontSize: 14.0),
                  overflow: TextOverflow.visible,
                ),
                Row(
                  children: <Widget>[
                    FlatButton(
                      child: Text('Share'),
                      onPressed: () {},
                    ),
                    FlatButton(
                      child: Text('Bookmark'),
                      onPressed: () {},
                    ),
                    FlatButton(child: Text('Link'), onPressed: () {})
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
