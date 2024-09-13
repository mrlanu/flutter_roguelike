import 'package:plain_ecs/plain_ecs.dart';

class Player extends Component{}
class Enemy extends Component{}
class Position extends Component{
  int x;
  int y;

  Position(this.x, this.y);
}
class Velocity extends Component{}

class FirstSystem extends System{

  @override
  void run() {
    final players = parentWorld.gatherComponents<Player>();
    final positions = parentWorld.gatherComponents<Position>();
    for(var (player, position) in (players, positions).join()){
      position.x++;
    }
  }

}

void main() {
  final world = World();
  final player = world.createEntity([Player(), Position(5, 5)]);
  final enemy = world.createEntity([Enemy(), Position(10, 10), Velocity()]);
  final otherEnemy = world.createEntity([Enemy()]);

  world.storage.put(<int>[0,3]);
  final tst = world.storage.get<List<int>>();
  Stopwatch stopwatch = Stopwatch()..start();
  final players = world.gatherComponents<Player>();
  final positions = world.gatherComponents<Position>();
  final resultList = (players, positions).join();
  stopwatch.stop();
  world.registerSystem(FirstSystem());
  world.run();
  print('');
}
