import 'package:flutter_roguelike/world.dart';

import 'game_state.dart';
import 'rltk/rltk.dart';

class RoguelikeGameState extends GameState {

  final World world = World();

  @override
  void tick({required RoguelikeToolkit ctx}) {
    ctx.printText(text: 'text', x: 5, y: 10);
  }
}
