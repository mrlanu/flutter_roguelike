import 'package:flutter/material.dart';

class CrossButtons extends StatefulWidget {
  const CrossButtons({
    super.key,
    this.onTop,
  });

  final Function(Direction direction)? onTop;

  @override
  State<CrossButtons> createState() => _CrossButtonsState();
}

class _CrossButtonsState extends State<CrossButtons> {

  bool isMoving = false;
  Direction direction = Direction.right;

  void _startMoving(Direction direction) {
    isMoving = true;
    this.direction = direction;
    _keepMoving();
  }

  void _keepMoving() async {
    while (isMoving) {
      widget.onTop!(direction);
      await Future.delayed(const Duration(milliseconds: 50)); // Adjust for movement speed
    }
  }

  void _stopMoving() {
    isMoving = false;
  }

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
            child: GestureDetector(
              onTap: () => widget.onTop!(Direction.up),
              onLongPressStart: (_) => _startMoving(Direction.up),
              onLongPressEnd: (_) => _stopMoving(),
              child: const Icon(Icons.arrow_circle_up_outlined, size: 30, color: Colors.lightBlueAccent,),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 75,
            child: GestureDetector(
              onTap: () => widget.onTop!(Direction.down),
              onLongPressStart: (_) => _startMoving(Direction.down),
              onLongPressEnd: (_) => _stopMoving(),
              child: const Icon(Icons.arrow_circle_down_outlined,size: 30, color: Colors.lightBlueAccent,),
            ),
          ),
          Positioned(
            left: 0,
            top: 75,
            child: GestureDetector(
              onTap: () => widget.onTop!(Direction.left),
              onLongPressStart: (_) => _startMoving(Direction.left),
              onLongPressEnd: (_) => _stopMoving(),
              child: const Icon(Icons.arrow_circle_left_outlined, size: 30, color: Colors.lightBlueAccent,),
            ),
          ),
          Positioned(
            right: 20,
            top: 75,
            child: GestureDetector(
              onTap: () => widget.onTop!(Direction.right),
              onLongPressStart: (_) => _startMoving(Direction.right),
              onLongPressEnd: (_) => _stopMoving(),
              child: const Icon(Icons.arrow_circle_right_outlined, size: 30, color: Colors.lightBlueAccent,),
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
