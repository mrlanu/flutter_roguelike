import 'dart:collection';

import 'package:lite_ecs/lite_ecs.dart';

abstract class IComponentArray {
  void entityDestroyed(int entity);
}

class ComponentArray<T> implements IComponentArray {
  List<T?> _componentArray;
  final Map<Entity, int> _entityToIndexMap;
  final Map<int, Entity> _indexToEntityMap;
  int _size = 0;

  ComponentArray()
      : _componentArray = List.filled(MAX_ENTITIES, null),
        _entityToIndexMap = {},
        _indexToEntityMap = {};

  void insertData(Entity entity, T component) {
    if (_entityToIndexMap.containsKey(entity)) {
      throw ArgumentError("Component added to same entity more than once.");
    }

    final newIndex = _size;
    _entityToIndexMap[entity] = newIndex;
    _indexToEntityMap[newIndex] = entity;
    _componentArray[newIndex] = component;
    _size++;
  }

  void removeData(Entity entity) {
    if (!_entityToIndexMap.containsKey(entity)) {
      throw ArgumentError("Removing non-existent component.");
    }

    final indexOfRemovedEntity = _entityToIndexMap[entity]!;
    final indexOfLastElement = _size - 1;
    final lastElement = _componentArray[indexOfLastElement];

    _componentArray[indexOfRemovedEntity] = lastElement;

    final entityOfLastElement = _indexToEntityMap[indexOfLastElement]!;
    _entityToIndexMap[entityOfLastElement] = indexOfRemovedEntity;
    _indexToEntityMap[indexOfRemovedEntity] = entityOfLastElement;

    _entityToIndexMap.remove(entity);
    _indexToEntityMap.remove(indexOfLastElement);

    _size--;
  }

  T? getData(int entity) {
    if (!_entityToIndexMap.containsKey(entity)) {
      throw ArgumentError("Retrieving non-existent component.");
    }

    return _componentArray[_entityToIndexMap[entity]!];
  }

  @override
  void entityDestroyed(int entity) {
    if (_entityToIndexMap.containsKey(entity)) {
      removeData(entity);
    }
  }
}
