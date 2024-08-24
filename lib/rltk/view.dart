import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter_roguelike/rltk/rltk.dart';

import '../const/const.dart';
import '../game_state.dart';
import '../models/models.dart';

class RoguelikeToolkitView extends StatefulWidget {
  const RoguelikeToolkitView(
      {super.key, required this.gameState, required this.ctx});

  final GameState gameState;
  final RoguelikeToolkit ctx;

  @override
  State<RoguelikeToolkitView> createState() => _RoguelikeToolkitViewState();
}

class _RoguelikeToolkitViewState extends State<RoguelikeToolkitView> {
  late Timer? _timer;

  @override
  void initState() {
    super.initState();
    final ms = (1000 / fps).floor();
    _timer = Timer.periodic(Duration(milliseconds: ms), _tick);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    return CustomPaint(
      size: size,
      painter: GridPainter(
        image: widget.ctx.image,
        tiles: widget.ctx.buffer,
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel(); // Clean up the timer when the widget is removed
    super.dispose();
  }

  void _tick(Timer t) {
    widget.gameState.tick(ctx: widget.ctx);
    if (mounted) {
      setState(() {});
    }
  }
}

class GridPainter extends CustomPainter {
  final List<Tile> tiles;
  final ui.Image image;

  GridPainter({required this.image, required this.tiles});

  @override
  void paint(Canvas canvas, Size size) {
    final tileSize = size.width / columns;
    Paint backgroundPaint = Paint()..color = Colors.black; // Set the background color
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);
    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < columns; c++) {
        final Rect destRect = Rect.fromPoints(
            Offset(c * tileSize, r * tileSize),
            Offset(c * tileSize + tileSize, r * tileSize + tileSize));
        final i = _getIndexByXY(x: c, y: r);
        final Rect srcRect = Rect.fromPoints(tiles[i].topLeft, tiles[i].bottomRight);
        final color = ColorFilter.mode(
          tiles[i].color, // Apply a red tint with some transparency
          BlendMode.srcATop,
        );
        canvas.drawImageRect(image, srcRect, destRect, Paint()..colorFilter = color);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  int _getIndexByXY({required int x, required int y}) => y * columns + x;
}
