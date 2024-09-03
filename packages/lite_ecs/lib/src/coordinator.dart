import 'package:lite_ecs/lite_ecs.dart';

class Coordinator {
  late final ComponentManager _componentManager;
  late final EntityManager _entityManager;
  late final SystemManager _systemManager;

  Coordinator() {
    _componentManager = ComponentManager();
    _entityManager = EntityManager();
    _systemManager = SystemManager();
  }

  // Entity methods
  Entity createEntity() {
    return _entityManager.createEntity();
  }

  void destroyEntity(Entity entity) {
    _entityManager.destroyEntity(entity);
    _componentManager.entityDestroyed(entity);
    _systemManager.entityDestroyed(entity);
  }

  // Component methods
  void registerComponent<T>() {
    _componentManager.registerComponent<T>();
  }

  void addComponent<T>(Entity entity, T component) {
    _componentManager.addComponent<T>(entity, component);
    final signature = _entityManager.getSignature(entity)
      ..set(_componentManager.getComponentType<T>());
    _entityManager.setSignature(entity, signature);
    _systemManager.entitySignatureChanged(entity, signature);
  }

  void removeComponent<T>(Entity entity) {
    _componentManager.removeComponent<T>(entity);
    final signature = _entityManager.getSignature(entity)
      ..set(_componentManager.getComponentType<T>());
    _entityManager.setSignature(entity, signature);
    _systemManager.entitySignatureChanged(entity, signature);
  }

  T? getComponent<T>(Entity entity) {
    return _componentManager.getComponent<T>(entity);
  }

  ComponentType getComponentType<T>() {
    return _componentManager.getComponentType<T>();
  }

  // System methods
  System registerSystem<T extends System>(T system) {
    return _systemManager.registerSystem<T>(system);
  }

  void setSystemSignature<T extends System>(Signature signature) {
    _systemManager.setSignature<T>(signature);
  }
}
