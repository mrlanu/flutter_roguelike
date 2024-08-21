import 'package:dartemis/dartemis.dart';
import 'package:flutter_roguelike/models/models.dart';

import 'rltk/rltk.dart';

abstract class GameState {
  void tick({required RoguelikeToolkit ctx});
  World get world;
  Player get player;
}
