import 'package:dartemis/dartemis.dart';

import 'game_state.dart';
import 'models/models.dart';
import 'rltk/rltk.dart';

class RoguelikeGameState extends GameState {
  final World _world;
  final Player _player;

  RoguelikeGameState({
    required World world,
    required Player player,
  }): _world = world, _player = player;

  @override
  World get world => _world;


  @override
  Player get player => _player;

  @override
  void tick({required RoguelikeToolkit ctx}) {
    ctx.clx();
    ctx.set(symbol: _player.symbol, x: _player.x, y: _player.y);
    _world.process();
    //ctx.printText(text: 'Hello Rogualike', x: 3, y: 15);
  }
}
