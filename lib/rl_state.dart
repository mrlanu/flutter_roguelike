import 'package:flutter/material.dart';
import 'package:rltk/rltk.dart';


class RoguelikeGameState extends GameState {
  final World _world;
  final int _playerId;
  final List<TileType> _map;

  RoguelikeGameState({
    required World world,
    required int playerId,
    required List<TileType> map
  }): _world = world, _playerId = playerId, _map = map;

  @override
  World get world => _world;


  @override
  int get player => _playerId;


  @override
  List<TileType> get map => _map;

  @override
  void tick({required RoguelikeToolkit ctx}) {
    ctx.clx();
    //ctx.drawMap(map);
    //ctx.set(symbol: _player.symbol, color: Colors.yellowAccent, x: _player.x, y: _player.y);
    _world.process();
    //ctx.printText(text: 'Hello Rogualike', color: Colors.yellowAccent, x: 3, y: 15);
  }
}
