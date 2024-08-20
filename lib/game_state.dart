import 'package:flutter_roguelike/world.dart';

import 'rltk/rltk.dart';

abstract class GameState {
  void tick({required RoguelikeToolkit ctx});
  World get world;
}
