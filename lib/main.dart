import 'dart:math';

import 'package:dartemis/dartemis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_roguelike/models/models.dart';
import 'package:flutter_roguelike/rl_state.dart';
import 'package:flutter_roguelike/widgets/cross_buttons.dart';

import 'const/const.dart';
import 'ecs/ecs.dart';
import 'game_state.dart';
import 'rltk/rltk.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final ctx = await RoguelikeToolkit.instance();
  final player = Player(x: 5, y: 5, symbol: '@');
  final world = initializeWorld(ctx: ctx);
  final rlState = RoguelikeGameState(world: world, player: player);

  runApp(Roguelike(
    ctx: ctx,
    gameState: rlState,
  ));
}

World initializeWorld({required RoguelikeToolkit ctx}) {
  final world = World();

  for (var i = 0; i < 5; i++) {
    world.createEntity([
      Position(i * 4, 10),
      Renderable('#', color: Colors.green),
      LeftMover()
    ]);
  }
  world
    ..addSystem(LeftWalkerSystem())
    ..addSystem(RenderSystem(ctx));

  world.initialize();
  return world;
}

class Roguelike extends StatelessWidget {
  const Roguelike({super.key, required this.ctx, required this.gameState});

  final RoguelikeToolkit ctx;
  final GameState gameState;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Roguelike',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: SafeArea(
            child: Scaffold(
                body: Stack(children: [
          RoguelikeToolkitView(
            ctx: ctx,
            gameState: gameState,
          ),
          Positioned(
              bottom: 30,
              right: 30,
              child: CrossButtons(
                onTop: (direction) => _playerInput(direction),
              )),
        ]))));
  }

  void _playerInput(Direction direction) {
    switch (direction) {
      case Direction.up:
        _tryToMovePlayer(deltaX: 0, deltaY: -1);
        break;
      case Direction.down:
        _tryToMovePlayer(deltaX: 0, deltaY: 1);
        break;
      case Direction.left:
        _tryToMovePlayer(deltaX: -1, deltaY: 0);
        break;
      case Direction.right:
        _tryToMovePlayer(deltaX: 1, deltaY: 0);
        break;
    }
  }

  void _tryToMovePlayer({required int deltaX, required int deltaY}) {
    final player = gameState.player;
    player.x = min(columns - 1, max(0, player.x + deltaX));
    player.y = min(rows - 1, max(0, player.y + deltaY));
  }
}
