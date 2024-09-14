import 'package:plain_ecs/plain_ecs.dart';
import 'package:rltk/rltk.dart';

import 'ecs/components.dart';
import 'models/dungeon.dart';

enum RunState {
  paused, running,
}

class RoguelikeGameState implements GameState {
  final World _world;
  RunState runState;


  RoguelikeGameState({
    required World world,
    this.runState = RunState.running,
  }): _world = world;

  @override
  World get world => _world;

  @override
  void tick({required RoguelikeToolkit ctx}) {
    //Stopwatch stopwatch = Stopwatch()..start();
    if(runState == RunState.running){
      ctx.clx();
      world.run();
      runState = RunState.paused;
    }

    // rendering
    final position = _world.gatherComponents<Position>();
    final renderable = _world.gatherComponents<Renderable>();
    final dungeon = _world.storage.get<Dungeon>();
    for (var (pos, ren) in (position, renderable).join()) {
      final idx = dungeon.getIndexByXY(x: pos.x, y: pos.y);
      if (dungeon.visibleTiles[idx]) {
        ctx.set(symbol: ren.glyph, color: ren.color, x: pos.x, y: pos.y);
      }
    }
    //stopwatch.stop();
    //print('Time >>> ${stopwatch.elapsedMilliseconds}');

    //ctx.printText(text: 'Hello Rogualike', color: Colors.yellowAccent, x: 3, y: 15);
  }
}
