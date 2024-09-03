import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_roguelike/const/const.dart';
import 'package:flutter_roguelike/models/dungeon.dart';
import 'package:lite_ecs/lite_ecs.dart';
import 'package:rltk/rltk.dart';

import 'components.dart';

class DrawMapSystem extends System {

  final RoguelikeToolkit ctx;
  final Dungeon dungeon;

  DrawMapSystem({required this.dungeon, required this.ctx});

  void update() {
    for (Entity e in entities) {
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
          ctx.set(symbol: symbol, color: fg, x: x, y: y);
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

class RenderSystem extends System {

  final Coordinator coordinator;
  final RoguelikeToolkit ctx;

  RenderSystem({required this.coordinator, required this.ctx});

  void update() {
    for(Entity e in entities){
      final position = coordinator.getComponent<Position>(e);
      final renderable = coordinator.getComponent<Renderable>(e);
      ctx.set(
          symbol: renderable!.glyph,
          color: renderable.color,
          x: position!.x,
          y: position.y);
    }
  }
}

class VisibilitySystem extends System {
  final Dungeon map;
  final Coordinator coordinator;

  VisibilitySystem({required this.coordinator, required this.map});

  void update() {
    for(Entity e in entities){
      final position = coordinator.getComponent<Position>(e);
      final viewshed = coordinator.getComponent<Viewshed>(e);
      if (viewshed!.dirty) {
        viewshed.dirty = false;
        viewshed.visibleTiles.clear();
        viewshed.visibleTiles = fieldOfView(
            start: Point(position!.x, position.y),
            range: viewshed.range,
            map: map);
        viewshed.visibleTiles.removeWhere((p) =>
        p.x < 0 ||
            p.x >= Constants.columns ||
            p.y < 0 ||
            p.y >= Constants.rows);
        for (var i = 0; i < map.visibleTiles.length; i++) {
          map.visibleTiles[i] = false;
        }
        for (final pt in viewshed.visibleTiles) {
          final idx = map.getIndexByXY(x: pt.x, y: pt.y);
          map.revealedTiles[idx] = true;
          map.visibleTiles[idx] = true;
        }
      }
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
