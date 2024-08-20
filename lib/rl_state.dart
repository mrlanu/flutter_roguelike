import 'package:flutter_roguelike/world.dart';

import 'game_state.dart';
import 'rltk/rltk.dart';

class RoguelikeGameState extends GameState {

  final World w = World(player: Player(x: 5, y: 10, glyph: '@'));

  @override
  World get world => w;

  @override
  void tick({required RoguelikeToolkit ctx}) {
    ctx.clx();
    ctx.set(symbol: w.player.glyph, x: w.player.x, y: w.player.y);
    //ctx.printText(text: 'Hello Rogualike', x: 3, y: 15);
  }


}
