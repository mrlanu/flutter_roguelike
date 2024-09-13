import 'package:plain_ecs/plain_ecs.dart';
import 'package:plain_ecs/src/entity_handle.dart';

class Component{
  Entity _entity = -1;

  Entity get entity => _entity;

  Component setEntity(Entity e){
    _entity = e;
    return this;
  }
}
