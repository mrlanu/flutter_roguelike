import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'const/const.dart';
import 'game_state.dart';
import 'rltk/rltk.dart';
import 'widgets/widgets.dart';

class Roguelike extends StatefulWidget {
  const Roguelike(
      {super.key, required this.gameState, required this.ctx});

  final GameState gameState;
  final RoguelikeToolkit ctx;

  @override
  State<Roguelike> createState() => _RoguelikeState();
}

class _RoguelikeState extends State<Roguelike> {
  late Timer? _timer;

  @override
  void initState() {
    super.initState();
    final ms = (1000 / fps).floor();
    _timer = Timer.periodic(Duration(milliseconds: ms), _tick);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Stack(children: [
      RoguelikeToolkitView(toolkit: widget.ctx,),
      Positioned(
          bottom: 30,
          right: 30,
          child: CrossButtons(
            onTop: (direction) {
              playerInput(direction);
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

  void tryToMovePlayer({required int deltaX, required int deltaY}){
    final player = widget.gameState.world.player;
    player.x = min(columns - 1, max(0, player.x + deltaX));
    player.y = min(rows - 1, max(0, player.y + deltaY));
  }

  void playerInput(Direction direction) {
    switch (direction) {
      case Direction.up:
        tryToMovePlayer(deltaX: 0, deltaY: -1);
        break;
      case Direction.down:
        tryToMovePlayer(deltaX: 0, deltaY: 1);
        break;
      case Direction.left:
        tryToMovePlayer(deltaX: -1, deltaY: 0);
        break;
      case Direction.right:
        tryToMovePlayer(deltaX: 1, deltaY: 0);
        break;
    }
  }

}
