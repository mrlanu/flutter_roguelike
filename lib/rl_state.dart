import 'package:flutter_roguelike/world.dart';

import 'game_state.dart';
import 'rltk/rltk.dart';

class RoguelikeGameState extends GameState {

  final World world = World();

  @override
  void tick({required RoguelikeToolkit ctx}) {
    //ctx.set(symbol: '@', x: 10, y: 10);
    ctx.printText(text: 'Hello Rogualike', x: 3, y: 15);
  }
}
