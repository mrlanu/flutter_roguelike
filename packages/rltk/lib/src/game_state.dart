import 'package:dartemis/dartemis.dart';
import 'package:rltk/src/rltk.dart';

abstract class GameState {
  void tick({required RoguelikeToolkit ctx});
  World get world;
  int get player;
  List<TileType> get map;
}
