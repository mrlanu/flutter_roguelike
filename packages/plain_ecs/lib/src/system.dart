import 'package:plain_ecs/plain_ecs.dart';

abstract class System{
  late final World _parentWorld;

  World get parentWorld => _parentWorld;
  void setWorld(World world) => _parentWorld = world;

  void run();
}
