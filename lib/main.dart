import 'package:flutter/material.dart';
import 'package:flutter_roguelike/ecs/ecs.dart';
import 'package:flutter_roguelike/models/dungeon.dart';
import 'package:flutter_roguelike/rl_state.dart';
import 'package:flutter_roguelike/widgets/cross_buttons.dart';
import 'package:lite_ecs/lite_ecs.dart';
import 'package:rltk/rltk.dart';

import 'const/const.dart';
import 'init.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final rltk = await RoguelikeToolkit.instance();
  final dungeon = Dungeon.roomsAndCorridors(Constants.columns, Constants.rows);
  final world = Init.initializeWorld(dungeon: dungeon, ctx: rltk);

  final (playerX, playerY) = dungeon.rooms[0].center();

  final coordinator = Coordinator();

  final drawMapSystem = DrawMapSystem(dungeon: dungeon, ctx: rltk);
  final visibilitySystem = VisibilitySystem(coordinator: coordinator, map: dungeon);
  final renderSystem = RenderSystem(coordinator: coordinator, ctx: rltk);
  coordinator
    ..registerComponent<Player>()
    ..registerComponent<Position>()
    ..registerComponent<Viewshed>()
    ..registerComponent<Renderable>()
    ..registerSystem(visibilitySystem)
    ..registerSystem(drawMapSystem)
    ..registerSystem(renderSystem);

  final signatureDrawMapSystem = Signature(32)
    ..set(coordinator.getComponentType<Player>())
    ..set(coordinator.getComponentType<Viewshed>());

  final signatureVisibilitySystem = Signature(32)
    ..set(coordinator.getComponentType<Position>())
    ..set(coordinator.getComponentType<Viewshed>());

  final signatureRenderSystem = Signature(32)
    ..set(coordinator.getComponentType<Position>())
    ..set(coordinator.getComponentType<Renderable>());

  coordinator.setSystemSignature<DrawMapSystem>(signatureDrawMapSystem);
  coordinator.setSystemSignature<RenderSystem>(signatureRenderSystem);
  coordinator.setSystemSignature<VisibilitySystem>(signatureVisibilitySystem);

  final player = coordinator.createEntity();

  coordinator
    ..addComponent(player, Player())
    ..addComponent(player, Position(playerX, playerY))
    ..addComponent(player, Renderable(glyph: '@', color: Colors.red))
    ..addComponent(player, Viewshed([], 8, true));

  final rlState =
      RoguelikeGameState(world: world, playerId: player, map: dungeon.tiles, t: () {
        visibilitySystem.update();
        drawMapSystem.update();
        renderSystem.update();
      },);

  runApp(Roguelike(
    rltk: rltk,
    gameState: rlState,
  ));
}

class Roguelike extends StatelessWidget {
  const Roguelike({super.key, required this.rltk, required this.gameState});

  final RoguelikeToolkit rltk;
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
            rltk: rltk,
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
    /*final player = gameState.player;
    final Position position = Mapper<Position>(gameState.world)[player];
    final Viewshed viewshed = Mapper<Viewshed>(gameState.world)[player];
    final destinationIdx =
        rltk.getIndexByXY(x: position.x + deltaX, y: position.y + deltaY);
    if (gameState.map[destinationIdx] != TileType.wall) {
      position.x = min(Constants.columns - 1, max(0, position.x + deltaX));
      position.y = min(Constants.rows - 1, max(0, position.y + deltaY));
      viewshed.dirty = true;
    }*/
  }
}
