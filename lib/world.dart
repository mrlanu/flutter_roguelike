class World {

  World({
    required this.player,
  });

  Player player;

}

class Player {

  Player({
    required this.x,
    required this.y,
    required this.glyph,
  });

  int x;
  int y;
  String glyph;
}
