import 'package:flutter/material.dart';

class CrossButtons extends StatelessWidget {
  const CrossButtons({
    super.key,
    this.onTop,
  });

  final Function(Direction direction)? onTop;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200, // Size of the entire widget
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 75,
            child: IconButton(
              onPressed: () => onTop!(Direction.up),
              icon: const Icon(Icons.arrow_circle_up_outlined),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 75,
            child: IconButton(
              onPressed: () => onTop!(Direction.down),
              icon: const Icon(Icons.arrow_circle_down_outlined),
            ),
          ),
          Positioned(
            left: 0,
            top: 75,
            child: IconButton(
              onPressed: () => onTop!(Direction.left),
              icon: const Icon(Icons.arrow_circle_left_outlined),
            ),
          ),
          Positioned(
            right: 0,
            top: 75,
            child: IconButton(
              onPressed: () => onTop!(Direction.right),
              icon: const Icon(Icons.arrow_circle_right_outlined),
            ),
          ),
        ],
      ),
    );
  }
}

enum Direction {
  up,
  down,
  left,
  right,
}
