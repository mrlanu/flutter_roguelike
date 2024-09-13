import '../plain_ecs.dart';

typedef Entity = int;

class EntityHandle {
  final Entity _entity;
  final World _world;
  EntityHandle(this._entity, this._world);

  Entity get entity => _entity;

  void addComponent<ComponentType extends Component>(ComponentType component){
    _world.addComponent(_entity, component);
  }

  /*void removeComponent<ComponentType>(){
    _world.removeComponent<ComponentType>(_entity);
  }*/
}
