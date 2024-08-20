import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter_roguelike/rltk/rltk.dart';

import '../const/const.dart';


class RoguelikeToolkitView extends StatelessWidget {
  const RoguelikeToolkitView(
      {super.key, required this.toolkit});

  final RoguelikeToolkit toolkit;

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
                image: toolkit.image,
                offsets: toolkit.buffer[index],
              ),
            ),
          ),
        );
      },
    );
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

