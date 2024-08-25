import 'dart:math';
import 'package:rltk/rltk.dart';

import 'const/const.dart';
import 'ecs/ecs.dart';

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
      map[RoguelikeToolkit.getIndexByXy(
          x: x, y: 0, columns: Constants.columns)] = TileType.wall;
      map[RoguelikeToolkit.getIndexByXy(
          x: x,
          y: Constants.rows - 1,
          columns: Constants.columns)] = TileType.wall;
    }
    for (int y = 0; y < Constants.rows; y++) {
      map[RoguelikeToolkit.getIndexByXy(
          x: 0, y: y, columns: Constants.columns)] = TileType.wall;
      map[RoguelikeToolkit.getIndexByXy(
          x: Constants.columns - 1,
          y: y,
          columns: Constants.columns)] = TileType.wall;
    }

    // Randomly place walls inside the map
    Random rng = Random();

    for (int i = 0; i < 200; i++) {
      int x = rng.nextInt(Constants.columns - 1) + 1;
      int y = rng.nextInt(Constants.rows - 1) + 1;
      int idx =
          RoguelikeToolkit.getIndexByXy(x: x, y: y, columns: Constants.columns);
      if (idx !=
          RoguelikeToolkit.getIndexByXy(
              x: Constants.playerX,
              y: Constants.playerY,
              columns: Constants.columns)) {
        map[idx] = TileType.wall;
      }
    }

    return map;
  }
}
