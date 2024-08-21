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
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        childAspectRatio: 1.0,
      ),
      itemCount: rows * columns,
      itemBuilder: (context, index) {
        return GridTile(
          child: SizedBox(
            child: CustomPaint(
              painter: TilePainter(
                image: widget.ctx.image,
                offsets: widget.ctx.buffer[index],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel(); // Clean up the timer when the widget is removed
    super.dispose();
  }

  void _tick(Timer t) {
    widget.gameState.tick(ctx: widget.ctx);
    if(mounted){
      setState(() {});
    }
  }
}

class TilePainter extends CustomPainter {
  final ui.Image image;
  final (Offset, Offset) offsets;

  TilePainter({required this.image, required this.offsets});

  @override
  void paint(Canvas canvas, Size size) {

    final Rect srcRect = Rect.fromPoints(offsets.$1, offsets.$2);
    final Rect destRect = Rect.fromPoints(
        const Offset(0.0, 0.0), Offset(size.width, size.height));
    canvas.drawImageRect(image, srcRect, destRect, Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

