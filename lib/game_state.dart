import 'rltk/rltk.dart';

abstract class GameState {
  void tick({required RoguelikeToolkit ctx});
}
