import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_roguelike/ecs/ecs.dart';
import 'package:flutter_roguelike/rl_state.dart';
import 'package:plain_ecs/plain_ecs.dart';
import 'package:rltk/rltk.dart';

import 'const/const.dart';
import 'models/models.dart';
import 'widgets/widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final rltk = await RoguelikeToolkit.instance();

  final rlState = RoguelikeGameState(
    world: _initWorld(rltk),
  );

  runApp(Roguelike(
    rltk: rltk,
    gameState: rlState,
  ));
}

World _initWorld(RoguelikeToolkit rltk) {
  final dungeon = Dungeon.roomsAndCorridors(Constants.columns, Constants.rows);
  final (playerX, playerY) = dungeon.rooms[0].center();
  final world = World()
    ..storage.put(dungeon)
    ..storage.put(PositionPoint(playerX, playerY))
    ..createEntity([dungeon])
    ..createEntity([
      Player(),
      Name('Player'),
      Position(playerX, playerY),
      Renderable(glyph: '@', color: Colors.red),
      Viewshed([], 8, true)
    ])
    ..registerSystem(VisibilitySystem())
    ..registerSystem(MonsterAI(rltk: rltk))
    ..registerSystem(DrawMapSystem(rltk: rltk));

  for (var i = 1; i < dungeon.rooms.length; i++) {
    final room = dungeon.rooms[i];
    final (x, y) = room.center();
    final random = Random().nextInt(2) + 1;
    final (:glyph, :name) = switch (random) {
      1 => (glyph: 'g', name: 'Goblin'),
      2 => (glyph: 'o', name: 'Ork'),
      _ => (glyph: '', name: ''),
    };
    world.createEntity([
      Monster(),
      Name('$name $i'),
      Position(x, y),
      Renderable(glyph: glyph, color: Colors.deepOrange),
      Viewshed([], 8, true)
    ]);
  }

  world.init();
  return world;
}

class Roguelike extends StatelessWidget {
  const Roguelike({super.key, required this.rltk, required this.gameState});

  final RoguelikeToolkit rltk;
  final RoguelikeGameState gameState;

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
            rltk: rltk,
            gameState: gameState,
          ),
          kIsWeb
              ? KeyListenerWidget(onTop: (direction) => _playerInput(direction))
              : Positioned(
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
    final dungeon = gameState.world.storage.get<Dungeon>();
    final player = gameState.world.gatherComponents<Player>();
    final position = gameState.world.gatherComponents<Position>();
    final viewshed = gameState.world.gatherComponents<Viewshed>();
    for (var (_, pos, view) in (player, position, viewshed).join()) {
      final destinationIdx =
          rltk.getIndexByXY(x: pos.x + deltaX, y: pos.y + deltaY);
      if (dungeon.tiles[destinationIdx] != TileType.wall) {
        pos.x = min(Constants.columns - 1, max(0, pos.x + deltaX));
        pos.y = min(Constants.rows - 1, max(0, pos.y + deltaY));
        view.dirty = true;
      }
      var playerPosition = gameState.world.storage.get<PositionPoint>();
      playerPosition.x = pos.x;
      playerPosition.y = pos.y;
    }
    gameState.runState = RunState.running;
  }
}
