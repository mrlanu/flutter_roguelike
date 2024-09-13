import 'package:plain_ecs/plain_ecs.dart';

typedef ComponentFamilyIndex = int;

class World {
  late final EntityManager _entityManager;
  late final List<System> _systems;
  final Map<ComponentFamilyIndex, Map<Entity, Component>> _componentMaps = {};

  World() {
    _entityManager = EntityManager();
    _systems = [];
  }

  List<ComponentType> gatherComponents<ComponentType>() {
    final componentFamilyId = ComponentFamily.getBitIndex(ComponentType);
    final t = _componentMaps[componentFamilyId];
    final tp = t?.values
        .map((e) => e as ComponentType)
        .toList();
    return tp ?? [];
  }

  EntityHandle createEntity<ComponentType extends Component>(
      [List<ComponentType> components = const []]) {
    final result = EntityHandle(_entityManager.createEntity(), this);
    for (var component in components) {
      addComponent(result.entity, component);
    }
    return result;
  }

  void addComponent<ComponentType extends Component>(
      Entity entity, ComponentType c) {
    final componentFamilyId = ComponentFamily.getBitIndex(c.runtimeType);
    final componentMap = _componentMaps.putIfAbsent(
      componentFamilyId,
      () => {},
    );
    componentMap.putIfAbsent(
      entity,
      () => c.setEntity(entity),
    );
  }

  void registerSystem<T extends System>(T system) {
    system.setWorld(this);
    _systems.add(system);
  }

  void run() {
    for (var s in _systems) {
      s.run();
    }
  }
}
