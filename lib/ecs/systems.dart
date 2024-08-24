import 'package:dartemis/dartemis.dart';
import 'package:flutter_roguelike/const/const.dart';

import 'components.dart';
import '../rltk/rltk.dart';

class RenderSystem extends EntityProcessingSystem {
  late Mapper<Position> positionMapper;
  late Mapper<Renderable> renderableMapper;
  final RoguelikeToolkit ctx;

  RenderSystem(this.ctx) : super(Aspect.forAllOf([Position, Renderable]));

  @override
  void initialize() {
    positionMapper = Mapper<Position>(world);
    renderableMapper = Mapper<Renderable>(world);
  }

  @override
  void processEntity(int entity) {
    Position position = positionMapper[entity];
    Renderable renderable = renderableMapper[entity];
    ctx.set(symbol: renderable.glyph, color: renderable.color, x: position.x, y: position.y);
  }
}

class LeftWalkerSystem extends EntityProcessingSystem {
  late Mapper<Position> positionMapper;
  late Mapper<LeftMover> leftMoverMapper;

  LeftWalkerSystem() : super(Aspect.forAllOf([Position, LeftMover]));

  @override
  void initialize() {
    positionMapper = Mapper<Position>(world);
    leftMoverMapper = Mapper<LeftMover>(world);
  }

  @override
  void processEntity(int entity) {
    Position position = positionMapper[entity];
    position.x -= 1;
    if (position.x < 0) { position.x = columns - 1; }
  }
}
