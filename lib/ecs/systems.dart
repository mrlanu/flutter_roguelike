import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_roguelike/const/const.dart';
import 'package:flutter_roguelike/models/dungeon.dart';
import 'package:plain_ecs/plain_ecs.dart';
import 'package:rltk/rltk.dart';

import 'components.dart';

class DrawMapSystem extends System {

  final RoguelikeToolkit ctx;

  DrawMapSystem({required this.ctx});

  @override
  void run() {
    final dungeons = parentWorld.gatherComponents<Dungeon>();
    for (var(dungeon,) in (dungeons,).join()) {
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

  final RoguelikeToolkit ctx;

  RenderSystem({required this.ctx});

  @override
  void run() {
    final position = parentWorld.gatherComponents<Position>();
    final renderable = parentWorld.gatherComponents<Renderable>();
    for(var(pos, ren) in (position, renderable).join()){
      ctx.set(
          symbol: ren.glyph,
          color: ren.color,
          x: pos.x,
          y: pos.y);
    }
  }
}

class VisibilitySystem extends System {
  final Dungeon map;

  VisibilitySystem({required this.map});

  @override
  void run() {
    final position = parentWorld.gatherComponents<Position>();
    final viewshed = parentWorld.gatherComponents<Viewshed>();
    for(var(pos, view) in (position, viewshed).join()){

      if (view.dirty) {
        view.dirty = false;
        view.visibleTiles.clear();
        view.visibleTiles = fieldOfView(
            start: Point(pos.x, pos.y),
            range: view.range,
            map: map);
        view.visibleTiles.removeWhere((p) =>
        p.x < 0 ||
            p.x >= Constants.columns ||
            p.y < 0 ||
            p.y >= Constants.rows);
        for (var i = 0; i < map.visibleTiles.length; i++) {
          map.visibleTiles[i] = false;
        }
        for (final pt in view.visibleTiles) {
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
