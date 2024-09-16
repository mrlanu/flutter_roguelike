import 'dart:math';
import 'package:flutter/material.dart';
import 'package:plain_ecs/plain_ecs.dart';

class Player extends Component{}

class Monster extends Component{}

class Name extends Component{
  final String name;

  Name(this.name);
}

class Position extends Component{
  int x, y;

  Position(this.x, this.y);
}

class Renderable extends Component{
  String glyph;
  Color color;

  Renderable({required this.glyph, this.color = Colors.white});
}

class Viewshed extends Component{
  List<Point<int>> visibleTiles;
  int range;
  bool dirty;

  Viewshed(this.visibleTiles, this.range, this.dirty);
}

class BlocksTile extends Component{}

class CombatStat extends Component{
  int maxHp;
  int hp;
  int defense;
  int power;

  CombatStat({
    required this.maxHp,
    required this.hp,
    required this.defense,
    required this.power,
  });
}

class LeftMover extends Component{}
