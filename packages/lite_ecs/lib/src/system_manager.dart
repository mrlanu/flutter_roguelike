import 'package:lite_ecs/lite_ecs.dart';

class SystemManager {

  final Map<Type, Signature> _signatures = {};
  final Map<Type, System> _systems = {};

  System registerSystem<T extends System>(T system) {
    final type = T;
    if (_systems.containsKey(type)) {
      throw ArgumentError('Registering system more than once.');
    }
    _systems[type] = system;
    return system;
  }

  void setSignature<T extends System>(Signature signature) {
    final type = T;

    if (!_systems.containsKey(type)) {
      throw ArgumentError('System used before registered.');
    }

    _signatures[type] = signature;
  }

  void entityDestroyed(Entity entity) {
    for (var system in _systems.values) {
      system.entities.remove(entity);
    }
  }

  void entitySignatureChanged(Entity entity, Signature entitySignature) {
    for (var type in _systems.keys) {
      final system = _systems[type]!;
      final systemSignature = _signatures[type]!;

      if ((entitySignature & systemSignature) == systemSignature) {
        system.entities.add(entity);
      } else {
        system.entities.remove(entity);
      }
    }
  }
}
