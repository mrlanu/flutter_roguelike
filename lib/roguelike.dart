import 'dart:async';

import 'package:flutter/material.dart';

import 'game_state.dart';
import 'rltk/rltk.dart';
import 'widgets/widgets.dart';

class Roguelike extends StatefulWidget {
  const Roguelike(
      {super.key, required this.gameState, required this.ctx, this.fps = 60});

  final GameState gameState;
  final RoguelikeToolkit ctx;
  final int fps;

  @override
  State<Roguelike> createState() => _RoguelikeState();
}

class _RoguelikeState extends State<Roguelike> {
  late Timer? _timer;

  @override
  void initState() {
    super.initState();
    final ms = (1000 / widget.fps).floor();
    _timer = Timer.periodic(Duration(milliseconds: ms), _tick);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Stack(children: [
      RoguelikeToolkitView(
          buffer: widget.ctx.buffer,
          rows: widget.ctx.rows,
          columns: widget.ctx.columns),
      Positioned(
          bottom: 30,
          right: 30,
          child: CrossButtons(
            onTop: (direction) {
              //widget.terminal.changePosition(direction);
            },
          ))
    ])));
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
