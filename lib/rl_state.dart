import 'package:dartemis/dartemis.dart';
import 'package:flutter/material.dart';

import 'game_state.dart';
import 'models/models.dart';
import 'rltk/rltk.dart';

class RoguelikeGameState extends GameState {
  final World _world;
  final Player _player;
  final List<TileType> _map;

  RoguelikeGameState({
    required World world,
    required Player player,
    required List<TileType> map
  }): _world = world, _player = player, _map = map;

  @override
  World get world => _world;


  @override
  Player get player => _player;


  @override
  List<TileType> get map => _map;

  @override
  void tick({required RoguelikeToolkit ctx}) {
    ctx.clx();
    ctx.drawMap(map);
    ctx.set(symbol: _player.symbol, color: Colors.yellowAccent, x: _player.x, y: _player.y);
    _world.process();
    //ctx.printText(text: 'Hello Rogualike', color: Colors.yellowAccent, x: 3, y: 15);
  }
}
