import 'package:lite_ecs/lite_ecs.dart';

class ComponentManager {
  final Map<Type, ComponentType> _componentTypes = {};
  final Map<Type, IComponentArray> _componentArrays = {};
  ComponentType _nextComponentType = 0;

  void registerComponent<T>() {
    final type = T;
    if (_componentTypes.containsKey(type)) {
      throw ArgumentError("Registering component type more than once.");
    }

    _componentTypes[type] = _nextComponentType;
    _componentArrays[type] = ComponentArray<T>();
    _nextComponentType++;
  }

  ComponentType getComponentType<T>() {
    final type = T;
    if (!_componentTypes.containsKey(type)) {
      throw ArgumentError("Component not registered before use.");
    }
    return _componentTypes[type]!;
  }

  void addComponent<T>(Entity entity, T component) {
    _getComponentArray<T>().insertData(entity, component);
  }

  void removeComponent<T>(Entity entity) {
    _getComponentArray<T>().removeData(entity);
  }

  T? getComponent<T>(Entity entity) {
    return _getComponentArray<T>().getData(entity);
  }

  void entityDestroyed(Entity entity) {
    _componentArrays.forEach((_, componentArray) {
      componentArray.entityDestroyed(entity);
    });
  }

  ComponentArray<T> _getComponentArray<T>() {
    final type = T;
    if (!_componentArrays.containsKey(type)) {
      throw ArgumentError("Component not registered before use.");
    }
    return _componentArrays[type] as ComponentArray<T>;
  }
}
