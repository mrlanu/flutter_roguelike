import 'package:flutter_roguelike/models/dungeon.dart';
import 'package:rltk/rltk.dart';

import 'ecs/ecs.dart';

class Init {
  static World initializeWorld(
          {required Dungeon dungeon, required RoguelikeToolkit ctx}) =>
      World()
        ..addSystem(VisibilitySystem(map: dungeon))
        ..addSystem(DrawMapSystem(dungeon: dungeon, ctx: ctx))
        ..addSystem(RenderSystem(ctx))
        ..initialize();
}
