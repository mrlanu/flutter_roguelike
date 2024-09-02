import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:rltk/rltk.dart';
import 'package:rltk/src/const/const.dart';

class RoguelikeToolkitView extends StatefulWidget {
  const RoguelikeToolkitView(
      {required this.gameState, required this.rltk, super.key,});

  final GameState gameState;
  final RoguelikeToolkit rltk;

  @override
  State<RoguelikeToolkitView> createState() => _RoguelikeToolkitViewState();
}

class _RoguelikeToolkitViewState extends State<RoguelikeToolkitView> {
  late Timer? _timer;

  @override
  void initState() {
    super.initState();
    final ms = (1000 / ConstantsRltk.fps).floor();
    _timer = Timer.periodic(Duration(milliseconds: ms), _tick);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return CustomPaint(
      size: size,
      painter: GridPainter(
        rows: widget.rltk.rows,
        columns: widget.rltk.columns,
        image: widget.rltk.image,
        tiles: widget.rltk.buffer,
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel(); // Clean up the timer when the widget is removed
    super.dispose();
  }

  void _tick(Timer t) {
    widget.gameState.tick(ctx: widget.rltk);
    if (mounted) {
      setState(() {});
    }
  }
}

class GridPainter extends CustomPainter {
  final List<Tile> tiles;
  final ui.Image image;
  final int rows;
  final int columns;

  GridPainter(
      {required this.rows,
      required this.columns,
      required this.image,
      required this.tiles});

  @override
  void paint(Canvas canvas, Size size) {
    final tileSize = size.width / columns;
    Paint backgroundPaint = Paint()
      ..color = Colors.black; // Set the background color
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);
    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < columns; c++) {
        final Rect destRect = Rect.fromPoints(
            Offset(c * tileSize, r * tileSize),
            Offset(c * tileSize + tileSize, r * tileSize + tileSize));
        final i = RoguelikeToolkit.getIndexByXy(x: c, y: r, columns: columns);
        final Rect srcRect =
            Rect.fromPoints(tiles[i].topLeft, tiles[i].bottomRight);
        final color = ColorFilter.mode(
          tiles[i].color, // Apply a red tint with some transparency
          BlendMode.srcATop,
        );
        canvas.drawImageRect(
            image, srcRect, destRect, Paint()..colorFilter = color);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
