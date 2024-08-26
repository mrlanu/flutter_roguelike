import 'package:rltk/rltk.dart';

import 'ecs/ecs.dart';

class Init {
  static World initializeWorld({required RoguelikeToolkit ctx}) {
    final world = World();
    world.addSystem(RenderSystem(ctx));
    world.initialize();
    return world;
  }
}
