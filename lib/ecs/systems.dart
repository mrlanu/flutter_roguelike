import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_roguelike/const/const.dart';
import 'package:flutter_roguelike/models/dungeon.dart';
import 'package:plain_ecs/plain_ecs.dart';
import 'package:rltk/rltk.dart';

import 'components.dart';

class DrawMapSystem extends System {
  final RoguelikeToolkit rltk;

  DrawMapSystem({required this.rltk});

  @override
  void run() {
    final dungeons = parentWorld.gatherComponents<Dungeon>();
    for (var (dungeon,) in (dungeons,).join()) {
      var x = 0;
      var y = 0;

      for (var i = 0; i < dungeon.tiles.length; i++) {
        if (dungeon.revealedTiles[i]) {
          var fg = Colors.yellow;
          var symbol = '';
          switch (dungeon.tiles[i]) {
            case TileType.floor:
              symbol = '.';
              fg = Colors.grey;
            case TileType.wall:
              symbol = '#';
          }
          if (!dungeon.visibleTiles[i]) {
            fg = Colors.grey;
          }
          rltk.set(symbol: symbol, color: fg, x: x, y: y);
        }

        // Move the coordinates
        x += 1;
        if (x > Constants.columns - 1) {
          x = 0;
          y += 1;
        }
      }
    }
  }
}

/*
class RenderSystem extends System {
  final RoguelikeToolkit ctx;

  RenderSystem({required this.ctx});

  @override
  void run() {
    final position = parentWorld.gatherComponents<Position>();
    final renderable = parentWorld.gatherComponents<Renderable>();
    final dungeon = parentWorld.storage.get<Dungeon>();
    for (var (pos, ren) in (position, renderable).join()) {
      final idx = dungeon.getIndexByXY(x: pos.x, y: pos.y);
      if (dungeon.visibleTiles[idx]) {
        ctx.set(symbol: ren.glyph, color: ren.color, x: pos.x, y: pos.y);
      }
    }
  }
}
*/

class VisibilitySystem extends System {
  late final Dungeon _dungeon;

  @override
  void init() {
    _dungeon = parentWorld.storage.get<Dungeon>();
  }

  @override
  void run() {
    final position = parentWorld.gatherComponents<Position>();
    final viewshed = parentWorld.gatherComponents<Viewshed>();
    final player = parentWorld.gatherComponents<Player>();
    for (var (pos, view) in (position, viewshed).join()) {
      if (view.dirty) {
        view.dirty = false;
        view.visibleTiles.clear();
        /*view.visibleTiles = fieldOfView(
            start: Point(pos.x, pos.y),
            range: view.range,
            map: _dungeon);*/
        view.visibleTiles =
            getVisiblePoints(_dungeon, Point(pos.x, pos.y), view.range);
        view.visibleTiles.removeWhere((p) =>
            p.x < 0 ||
            p.x >= Constants.columns ||
            p.y < 0 ||
            p.y >= Constants.rows);

        // If this is the player, reveal what he can see
        if (pos.entity == player[0].entity) {
          for (var i = 0; i < _dungeon.visibleTiles.length; i++) {
            _dungeon.visibleTiles[i] = false;
          }
          for (final pt in view.visibleTiles) {
            final idx = _dungeon.getIndexByXY(x: pt.x, y: pt.y);
            _dungeon.revealedTiles[idx] = true;
            _dungeon.visibleTiles[idx] = true;
          }
        }
      }
    }
  }
}

class MonsterAI extends System {
  final RoguelikeToolkit rltk;

  MonsterAI({required this.rltk});

  @override
  void run() {
    final monsters = parentWorld.gatherComponents<Monster>();
    final names = parentWorld.gatherComponents<Name>();
    final viewshed = parentWorld.gatherComponents<Viewshed>();
    final positions = parentWorld.gatherComponents<Position>();
    final playerPosition = parentWorld.storage.get<PositionPoint>();
    final dungeon = parentWorld.storage.get<Dungeon>();
    for (var (_, name, viewshed, pos)
        in (monsters, names, viewshed, positions).join()) {
      if (viewshed.visibleTiles
          .contains(Point(playerPosition.x, playerPosition.y))) {
        rltk.log('${name.name} shouts insult');
        final path = aStar(dungeon, Point<int>(pos.x, pos.y),
            Point<int>(playerPosition.x, playerPosition.y));

        if (path.length > 2) {
          pos.x = path[1].x;
          pos.y = path[1].y;
          viewshed.dirty = true;
        }
      }
    }
  }
}

class MapIndexingSystem extends System {
  @override
  void run() {
    final blockers = parentWorld.gatherComponentsAsMap<BlocksTile>();
    final positions = parentWorld.gatherComponents<Position>();
    final dungeon = parentWorld.storage.get<Dungeon>();
    dungeon.populateBlocked();
    dungeon.clearContentIndex();
    for (var (pos,) in (positions,).join()) {
      final index = dungeon.getIndexByXY(x: pos.x, y: pos.y);
      final blockerOption = blockers[pos.entity];
      if(blockerOption != null){
        dungeon.blocked[index] = true;
      }
      dungeon.tileContent[index].add(pos.entity);
    }
  }
}

/*class LeftWalkerSystem extends EntityProcessingSystem {
  late Mapper<Position> positionMapper;
  late Mapper<LeftMover> leftMoverMapper;

  LeftWalkerSystem() : super(Aspect.forAllOf([Position, LeftMover]));

  @override
  void initialize() {
    positionMapper = Mapper<Position>(world);
    leftMoverMapper = Mapper<LeftMover>(world);
  }

  @override
  void processEntity(int entity) {
    Position position = positionMapper[entity];
    position.x -= 1;
    if (position.x < 0) {
      position.x = Constants.columns - 1;
    }
  }
}*/
