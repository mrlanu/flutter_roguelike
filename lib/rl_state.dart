import 'package:plain_ecs/plain_ecs.dart';
import 'package:rltk/rltk.dart';


class RoguelikeGameState implements GameState {
  final World _world;

  RoguelikeGameState({
    required World world,
  }): _world = world;

  @override
  World get world => _world;

  @override
  void tick({required RoguelikeToolkit ctx}) {
    //Stopwatch stopwatch = Stopwatch()..start();
    ctx.clx();
    world.run();
    //stopwatch.stop();
    //print('Time >>> ${stopwatch.elapsedMilliseconds}');

    //ctx.printText(text: 'Hello Rogualike', color: Colors.yellowAccent, x: 3, y: 15);
  }
}
