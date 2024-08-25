import 'package:flutter/material.dart';
import 'package:rltk/rltk.dart';

class Position extends Component {
  int x, y;

  Position(this.x, this.y);
}

class Renderable extends Component {
  String glyph;
  Color color;

  Renderable(this.glyph, {this.color = Colors.white});
}

class LeftMover extends Component{}
