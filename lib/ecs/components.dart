import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rltk/rltk.dart';

class Player extends Component{}

class Position extends Component {
  int x, y;

  Position(this.x, this.y);
}

class Renderable extends Component {
  String glyph;
  Color color;

  Renderable({required this.glyph, this.color = Colors.white});
}

class Viewshed extends Component {
  List<Point<int>> visibleTiles;
  int range;
  bool dirty;

  Viewshed(this.visibleTiles, this.range, this.dirty);
}

class LeftMover extends Component{}
