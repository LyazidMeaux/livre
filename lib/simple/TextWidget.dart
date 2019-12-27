/*
 * Copyright (c) 2019. Libre de droit
 */

import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String _text;

  TextWidget(this._text);

  @override
  Widget build(BuildContext context) {
    return Text(_text);
  }
}
