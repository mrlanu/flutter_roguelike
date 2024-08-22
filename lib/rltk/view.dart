import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter_roguelike/rltk/rltk.dart';

import '../const/const.dart';
import '../game_state.dart';

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
    final size = MediaQuery.of(context).size;
    return CustomPaint(
      size: size,
      painter: GridPainter(
        image: widget.ctx.image,
        offsets: widget.ctx.buffer,
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
  final List<(Offset, Offset)> offsets;
  final double cellSize;
  final ui.Image image;

  GridPainter(
      {required this.image, required this.offsets, this.cellSize = 10.0});

  @override
  void paint(Canvas canvas, Size size) {
    final tileSize = size.width / columns;
    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < columns; c++) {
        final Rect destRect = Rect.fromPoints(
            Offset(c * tileSize, r * tileSize),
            Offset(c * tileSize + tileSize, r * tileSize + tileSize));
        final i = _getIndexByXY(x: c, y: r);
        final Rect srcRect = Rect.fromPoints(offsets[i].$1, offsets[i].$2);
        canvas.drawImageRect(image, srcRect, destRect, Paint());
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  int _getIndexByXY({required int x, required int y}) => y * columns + x;
}
