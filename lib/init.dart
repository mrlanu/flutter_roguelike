import 'dart:math';
import 'package:rltk/rltk.dart';

import 'const/const.dart';
import 'ecs/ecs.dart';
import 'models/models.dart';

class Init {
  static World initializeWorld({required RoguelikeToolkit ctx}) {
    final world = World();

    world.addSystem(RenderSystem(ctx));

    world.initialize();
    return world;
  }

  static void applyHorizontalTunnel(List<TileType> map, int x1, int x2, int y) {
    for (var x = x1 < x2 ? x1 : x2; x <= (x1 > x2 ? x1 : x2); x++) {
      var idx =
          RoguelikeToolkit.getIndexByXy(x: x, y: y, columns: Constants.columns);
      if (idx >= 0 && idx < map.length) {
        map[idx] = TileType.floor;
      }
    }
  }

  static void applyVerticalTunnel(List<TileType> map, int y1, int y2, int x) {
    for (var y = y1 < y2 ? y1 : y2; y <= (y1 > y2 ? y1 : y2); y++) {
      var idx =
          RoguelikeToolkit.getIndexByXy(x: x, y: y, columns: Constants.columns);
      if (idx >= 0 && idx < map.length) {
        map[idx] = TileType.floor;
      }
    }
  }

  static (List<Rect>, List<TileType>) newMapRoomsAndCorridors() {
    // Create the map filled with wall tiles
    List<TileType> map = List<TileType>.filled(
        Constants.columns * Constants.rows, TileType.wall);

    final rooms = <Rect>[];
    const int maxRooms = 30;
    const int minSize = 6;
    const int maxSize = 10;

    final rng = Random();

    for (int i = 0; i < maxRooms; i++) {
      // Generate room dimensions
      final w = rng.nextInt(maxSize - minSize) + minSize;
      final h = rng.nextInt(maxSize - minSize) + minSize;
      final x = rng.nextInt(Constants.columns - w - 1);
      final y = rng.nextInt(Constants.rows - h - 1);

      final newRoom = Rect(x, y, w, h);

      // Check for room intersections
      bool ok = true;
      for (Rect otherRoom in rooms) {
        if (newRoom.intersects(otherRoom)) {
          ok = false;
          break;
        }
      }

      // If no intersection, apply the room to the map
      if (ok) {
        // Apply the room to the map
        applyRoomToMap(newRoom, map);

        if (rooms.isNotEmpty) {
          // Get the center coordinates of the new room and the previous room
          var newCenter = newRoom.center();
          var prevCenter = rooms.last.center();

          var newX = newCenter.$1;
          var newY = newCenter.$2;
          var prevX = prevCenter.$1;
          var prevY = prevCenter.$2;

          // Randomly decide the tunnel path (horizontal-first or vertical-first)
          if (rng.nextInt(2) == 1) {
            applyHorizontalTunnel(map, prevX, newX, prevY);
            applyVerticalTunnel(map, prevY, newY, newX);
          } else {
            applyVerticalTunnel(map, prevY, newY, prevX);
            applyHorizontalTunnel(map, prevX, newX, newY);
          }
        }

        // Add the new room to the list of rooms
        rooms.add(newRoom);
      }
    }

    return (rooms, map);
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

  static void applyRoomToMap(Rect room, List<TileType> map) {
    for (var y = room.y1 + 1; y <= room.y2; y++) {
      for (var x = room.x1 + 1; x <= room.x2; x++) {
        map[RoguelikeToolkit.getIndexByXy(
            x: x, y: y, columns: Constants.columns)] = TileType.floor;
      }
    }
  }
}
