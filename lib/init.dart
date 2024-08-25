import 'dart:math';

import 'package:dartemis/dartemis.dart';

import 'const/const.dart';
import 'ecs/ecs.dart';
import 'models/models.dart';
import 'rltk/toolkit.dart';

class Init {
  static World initializeWorld({required RoguelikeToolkit ctx}) {
    final world = World();

    world.addSystem(RenderSystem(ctx));

    world.initialize();
    return world;
  }

  static List<TileType> newMap() {
    // Initialize the map with floors
    List<TileType> map = List<TileType>.filled(
        Constants.columns * Constants.rows, TileType.floor);

    // Make the boundaries walls
    for (int x = 0; x < Constants.columns; x++) {
      map[RoguelikeToolkit.getIndexByXY(x: x, y: 0)] = TileType.wall;
      map[RoguelikeToolkit.getIndexByXY(x: x, y: Constants.rows - 1)] =
          TileType.wall;
    }
    for (int y = 0; y < Constants.rows; y++) {
      map[RoguelikeToolkit.getIndexByXY(x: 0, y: y)] = TileType.wall;
      map[RoguelikeToolkit.getIndexByXY(x: Constants.columns - 1, y: y)] =
          TileType.wall;
    }

    // Randomly place walls inside the map
    Random rng = Random();

    for (int i = 0; i < 200; i++) {
      int x = rng.nextInt(Constants.columns - 1) + 1;
      int y = rng.nextInt(Constants.rows - 1) + 1;
      int idx = RoguelikeToolkit.getIndexByXY(x: x, y: y);
      if (idx !=
          RoguelikeToolkit.getIndexByXY(
              x: Constants.playerX, y: Constants.playerY)) {
        map[idx] = TileType.wall;
      }
    }

    return map;
  }
}
