/*
 * Copyright (c) 2019. Libre de droit
 */
import 'package:flutter/material.dart';

class TextBlock {
  final Color _color;
  final String _text;

  TextBlock(this._text, this._color);

  String get text => _text;
  Color get color => _color;
}
