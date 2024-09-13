import 'dart:math';


import 'package:plain_ecs/plain_ecs.dart' as plain;
import 'package:rltk/rltk.dart';

import '../const/const.dart';
import 'models.dart';

class Dungeon extends plain.Component implements BaseMap{
  List<TileType> tiles = [];
  List<Rect> rooms = [];
  @override
  final int width;
  final int height;

  List<bool> revealedTiles = [];
  List<bool> visibleTiles = [];

  Dungeon._(this.width, this.height);

  factory Dungeon.roomsAndCorridors(int width, int height) {
    // Create the map filled with wall tiles
    final dungeon = Dungeon._(width, height);
    dungeon.tiles = List<TileType>.filled(
        Constants.columns * Constants.rows, TileType.wall);

    dungeon.revealedTiles = List<bool>.filled(
        Constants.columns * Constants.rows, false);
    dungeon.visibleTiles = List<bool>.filled(
        Constants.columns * Constants.rows, false);

    dungeon.rooms = <Rect>[];
    const int maxRooms = 30;
    const int minSize = 6;
    const int maxSize = 10;

    final rng = Random();

    for (var i = 0; i < maxRooms; i++) {
      // Generate room dimensions
      final w = rng.nextInt(maxSize - minSize) + minSize;
      final h = rng.nextInt(maxSize - minSize) + minSize;
      final x = rng.nextInt(Constants.columns - w - 1);
      final y = rng.nextInt(Constants.rows - h - 1);

      final newRoom = Rect(x, y, w, h);

      // Check for room intersections
      var ok = true;
      for (Rect otherRoom in dungeon.rooms) {
        if (newRoom.intersects(otherRoom)) {
          ok = false;
          break;
        }
      }

      // If no intersection, apply the room to the map
      if (ok) {
        // Apply the room to the map
        dungeon._applyRoomToMap(newRoom);

        if (dungeon.rooms.isNotEmpty) {
          // Get the center coordinates of the new room and the previous room
          final newCenter = newRoom.center();
          final prevCenter = dungeon.rooms.last.center();

          final newX = newCenter.$1;
          final newY = newCenter.$2;
          final prevX = prevCenter.$1;
          final prevY = prevCenter.$2;

          // Randomly decide the tunnel path (horizontal-first or vertical-first)
          if (rng.nextInt(2) == 1) {
            dungeon._applyHorizontalTunnel(prevX, newX, prevY);
            dungeon._applyVerticalTunnel(prevY, newY, newX);
          } else {
            dungeon._applyVerticalTunnel(prevY, newY, prevX);
            dungeon._applyHorizontalTunnel(prevX, newX, newY);
          }
        }

        // Add the new room to the list of rooms
        dungeon.rooms.add(newRoom);
      }
    }
    return dungeon;
  }

  void _applyRoomToMap(Rect room) {
    for (var y = room.y1 + 1; y <= room.y2; y++) {
      for (var x = room.x1 + 1; x <= room.x2; x++) {
        tiles[RoguelikeToolkit.getIndexByXy(
            x: x, y: y, columns: Constants.columns)] = TileType.floor;
      }
    }
  }

  void _applyHorizontalTunnel(int x1, int x2, int y) {
    for (var x = x1 < x2 ? x1 : x2; x <= (x1 > x2 ? x1 : x2); x++) {
      final idx =
      RoguelikeToolkit.getIndexByXy(x: x, y: y, columns: Constants.columns);
      if (idx >= 0 && idx < tiles.length) {
        tiles[idx] = TileType.floor;
      }
    }
  }

  void _applyVerticalTunnel(int y1, int y2, int x) {
    for (var y = y1 < y2 ? y1 : y2; y <= (y1 > y2 ? y1 : y2); y++) {
      final idx =
      RoguelikeToolkit.getIndexByXy(x: x, y: y, columns: Constants.columns);
      if (idx >= 0 && idx < tiles.length) {
        tiles[idx] = TileType.floor;
      }
    }
  }

  int getIndexByXY({required int x, required int y}) => y * width + x;

  @override
  bool isOpaque(int x, int y) => tiles[getIndexByXY(x: x, y: y)] == TileType.wall;

  @override
  Point<int> dimension() => Point(width, height);

}
