import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_roguelike/models/dungeon.dart';
import 'package:flutter_roguelike/rl_state.dart';
import 'package:flutter_roguelike/widgets/cross_buttons.dart';
import 'package:rltk/rltk.dart';

import 'const/const.dart';
import 'ecs/components.dart';
import 'init.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final ctx = await RoguelikeToolkit.instance();
  final world = Init.initializeWorld(ctx: ctx);
  final dungeon = Dungeon.roomsAndCorridors();

  final (playerX, playerY) = dungeon.rooms[0].center();
  final player = world.createEntity(
      [Position(playerX, playerY), Renderable('@', color: Colors.yellow)]);

  final rlState =
      RoguelikeGameState(world: world, playerId: player, map: dungeon.tiles);

  runApp(Roguelike(
    ctx: ctx,
    gameState: rlState,
  ));
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
    final Position position = Mapper<Position>(gameState.world)[player];
    final destinationIdx =
        ctx.getIndexByXY(x: position.x + deltaX, y: position.y + deltaY);
    if (gameState.map[destinationIdx] != TileType.wall) {
      position.x = min(Constants.columns - 1, max(0, position.x + deltaX));
      position.y = min(Constants.rows - 1, max(0, position.y + deltaY));
    }
  }
}
