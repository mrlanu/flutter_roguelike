import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_roguelike/models/models.dart';
import 'package:flutter_roguelike/terminal.dart';

class Logic extends StatefulWidget {
  const Logic({super.key});

  @override
  State<Logic> createState() => _LogicState();
}

class _LogicState extends State<Logic> {
  late Timer? _timer;
  final int rows = 41;
  final int columns = 20;
  late List<String> buffer;
  final Player player = Player(x: 10, y: 10, symbol: '@');

  @override
  void initState() {
    super.initState();
    buffer = List.generate(rows * columns, (index) => ' ');
    _timer = Timer.periodic(const Duration(milliseconds: 20), _tick);
  }

  void _tick(Timer timer) {
    final pl = player;
    _set(symbol: pl.symbol, x: pl.x, y: pl.y);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Stack(children: [
      Terminal(buffer: buffer, rows: rows, columns: columns),
      Positioned(
          bottom: 30,
          right: 30,
          child: CrossButtonWidget(
            onTop: (direction) => _changePosition(direction),
          ))
    ])));
  }

  void _changePosition(Direction direction) {
    switch (direction) {
      case Direction.up:
        player.y = player.y - 1;
        break;
      case Direction.down:
        player.y = player.y + 1;
        break;
      case Direction.left:
        player.x = player.x - 1;
        break;
      case Direction.right:
        player.x = player.x + 1;
        break;
    }
  }

  List<String> _clx() => List.generate(rows * columns, (index) => ' ');

  void _set({required String symbol, required int x, required int y}) {
    List<String> newBuffer = _clx();
    final startIndex = _getIndexByXY(x: x, y: y);
    newBuffer[startIndex] = symbol;
    buffer = newBuffer;
  }

  int _getIndexByXY({required int x, required int y}) => y * columns + x;

  @override
  void dispose() {
    _timer?.cancel(); // Clean up the timer when the widget is removed
    super.dispose();
  }
}

enum Direction {
  up,
  down,
  left,
  right,
}

class CrossButtonWidget extends StatelessWidget {
  const CrossButtonWidget({
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
