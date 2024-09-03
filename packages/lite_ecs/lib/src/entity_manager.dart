import 'dart:collection';

import 'package:lite_ecs/lite_ecs.dart';

class EntityManager {
  EntityManager() {
    for (var entity = 0; entity < MAX_ENTITIES; entity++) {
      _availableEntities.addLast(entity);
    }
  }

  final Queue<Entity> _availableEntities = Queue<Entity>();
  final List<Signature> _signaturesList = List.generate(
    MAX_ENTITIES,
    (_) => Signature(MAX_COMPONENTS),
  );
  int _livingEntityCount = 0;

  Entity createEntity() {
    assert(
        _livingEntityCount < MAX_ENTITIES, "Too many entities in existence.");

    // Take an ID from the front of the queue
    final id = _availableEntities.removeFirst();
    ++_livingEntityCount;

    return id;
  }

  void destroyEntity(Entity entity) {
    assert(entity >= 0 && entity < MAX_ENTITIES, "Entity ID out of range.");
    _signaturesList[entity].reset();
    _availableEntities.addLast(entity);
    _livingEntityCount--;
  }

  void setSignature(Entity entity, Signature signature) {
    assert(entity >= 0 && entity < MAX_ENTITIES, "Entity ID out of range.");

    // Put this entity's signature into the array
    _signaturesList[entity] = signature;
  }

  Signature getSignature(Entity entity) {
    assert(entity >= 0 && entity < MAX_ENTITIES, "Entity ID out of range.");

    // Get this entity's signature from the array
    return _signaturesList[entity];
  }
}
