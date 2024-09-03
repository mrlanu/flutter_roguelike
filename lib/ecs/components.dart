import 'dart:math';
import 'package:flutter/material.dart';

class Player{}

class Position{
  int x, y;

  Position(this.x, this.y);
}

class Renderable{
  String glyph;
  Color color;

  Renderable({required this.glyph, this.color = Colors.white});
}

class Viewshed{
  List<Point<int>> visibleTiles;
  int range;
  bool dirty;

  Viewshed(this.visibleTiles, this.range, this.dirty);
}

class LeftMover{}
