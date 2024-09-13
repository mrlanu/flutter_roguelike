import 'dart:collection';

import 'package:plain_ecs/plain_ecs.dart';

class EntityManager {
  final Queue<Entity> _availableEntities = Queue<Entity>();
  int _aliveEntityCount = 0;

  EntityManager() {
    for (var i = 0; i < MAX_ENTITIES; i++) {
      _availableEntities.addLast(i);
    }
  }

  Entity createEntity() {
    final entity = _availableEntities.removeFirst();
    _aliveEntityCount++;
    return entity;
  }

  void destroyEntity(Entity entity) {
    assert(entity >= 0 && entity < MAX_ENTITIES, "Entity ID out of range.");
    _availableEntities.addLast(entity);
    _aliveEntityCount--;
  }
}
