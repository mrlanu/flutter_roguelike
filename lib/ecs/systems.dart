import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_roguelike/const/const.dart';
import 'package:flutter_roguelike/models/dungeon.dart';
import 'package:rltk/rltk.dart';

import 'components.dart';

class DrawMapSystem extends EntityProcessingSystem {
  late Mapper<Player> playerMapper;
  late Mapper<Viewshed> viewshedMapper;
  final RoguelikeToolkit ctx;
  final Dungeon dungeon;

  DrawMapSystem({required this.dungeon, required this.ctx})
      : super(Aspect.forAllOf([Player, Viewshed]));

  @override
  void initialize() {
    playerMapper = Mapper<Player>(world);
    viewshedMapper = Mapper<Viewshed>(world);
  }

  @override
  void processEntity(int entity) {
    Viewshed viewshed = viewshedMapper[entity];
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
        if (!dungeon.visibleTiles[i]) { fg = Colors.grey; }
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

class RenderSystem extends EntityProcessingSystem {
  late Mapper<Position> positionMapper;
  late Mapper<Renderable> renderableMapper;
  final RoguelikeToolkit ctx;

  RenderSystem(this.ctx) : super(Aspect.forAllOf([Position, Renderable]));

  @override
  void initialize() {
    positionMapper = Mapper<Position>(world);
    renderableMapper = Mapper<Renderable>(world);
  }

  @override
  void processEntity(int entity) {
    Position position = positionMapper[entity];
    Renderable renderable = renderableMapper[entity];
    ctx.set(
        symbol: renderable.glyph,
        color: renderable.color,
        x: position.x,
        y: position.y);
  }
}

class VisibilitySystem extends EntityProcessingSystem {
  final Dungeon map;
  late Mapper<Position> positionMapper;
  late Mapper<Viewshed> viewshedMapper;

  VisibilitySystem({required this.map})
      : super(Aspect.forAllOf([Position, Viewshed]));

  @override
  void initialize() {
    positionMapper = Mapper<Position>(world);
    viewshedMapper = Mapper<Viewshed>(world);
  }

  @override
  void processEntity(int entity) {
    Position position = positionMapper[entity];
    Viewshed viewshed = viewshedMapper[entity];
    if (viewshed.dirty) {
      viewshed.dirty = false;
      viewshed.visibleTiles.clear();
      viewshed.visibleTiles = fieldOfView(
          start: Point(position.x, position.y),
          range: viewshed.range,
          map: map);
      viewshed.visibleTiles.removeWhere((p) =>
          p.x < 0 ||
          p.x >= Constants.columns ||
          p.y < 0 ||
          p.y >= Constants.rows);
      for(var i = 0; i < map.visibleTiles.length; i++){
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

class LeftWalkerSystem extends EntityProcessingSystem {
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
}
