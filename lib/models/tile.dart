import 'package:flutter/material.dart';

enum TileType{
  wall, floor,
}

class Tile {
  final Offset topLeft;
  final Offset bottomRight;
  final Color color;

  const Tile({
    this.topLeft = const Offset(0.0, 0.0),
    this.bottomRight = const Offset(8.0, 8.0),
    this.color = Colors.black,
  });
}
