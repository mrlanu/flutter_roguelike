import 'package:rltk/src/rltk.dart';

abstract class GameState {
  void tick({required RoguelikeToolkit ctx});
}
