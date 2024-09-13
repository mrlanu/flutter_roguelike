import 'package:plain_ecs/plain_ecs.dart';
import 'package:rltk/rltk.dart';


class RoguelikeGameState extends GameState {
  final World _world;
  final List<TileType> _map;

  RoguelikeGameState({
    required World world,
    required List<TileType> map,
  }): _world = world, _map = map;

  @override
  World get world => _world;


  @override
  List<TileType> get map => _map;

  @override
  void tick({required RoguelikeToolkit ctx}) {
    ctx.clx();
    world.run();
    //ctx.drawMap(map);
    //ctx.set(symbol: _player.symbol, color: Colors.yellowAccent, x: _player.x, y: _player.y);
    //_world.process();
    //system.update();
    //ctx.printText(text: 'Hello Rogualike', color: Colors.yellowAccent, x: 3, y: 15);
  }
}
