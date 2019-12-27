/*
 * Copyright (c) 2019. Libre de droit
 */
import 'package:flutter/material.dart';

final String webImage =
    'https://storage.googleapis.com/spec-host-backup/mio-material%2Fassets%2F1vLISEi-mDu8fXoQovUTAwsDkKnQcR2_T%2Fdevelop-android-1x1-small.png';

class CarWidget extends StatelessWidget {
  final String _make;
  final String _model;
  final String _imageSrc;

  CarWidget(this._make, this._model, this._imageSrc);

  String get make => _make;
  String get model => _model;
  String get imageSrc => _imageSrc;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10.0),
        child: Container(
            decoration: BoxDecoration(border: Border.all()),
            padding: EdgeInsets.all(20.0),
            child: Center(
                child: Column(children: <Widget>[
              Text(
                '$_make $_model',
                style: TextStyle(fontSize: 24),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0),
                  child: Image.network(
                    _imageSrc,
                    scale: 4,
                  ))
            ]))));
  }
}
