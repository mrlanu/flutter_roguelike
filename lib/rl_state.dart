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

  static int count = 0;

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
      _render(ctx: ctx);
      runState = RunState.paused;
    }

    //stopwatch.stop();
    //print('Time >>> ${stopwatch.elapsedMilliseconds}');
    //ctx.printText(text: 'Hello Rogualike', color: Colors.yellowAccent, x: 3, y: 15);
  }

  void _render({required RoguelikeToolkit ctx}){
    final position = _world.gatherComponents<Position>();
    final renderable = _world.gatherComponents<Renderable>();
    final dungeon = _world.storage.get<Dungeon>();
    for (var (pos, ren) in (position, renderable).join()) {
      final idx = dungeon.getIndexByXY(x: pos.x, y: pos.y);
      if (dungeon.visibleTiles[idx]) {
        ctx.set(symbol: ren.glyph, color: ren.color, x: pos.x, y: pos.y);
      }
    }
  }
}
