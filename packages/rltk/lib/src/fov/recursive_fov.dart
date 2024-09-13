import 'dart:math';
import 'package:rltk/rltk.dart';

List<Point<int>> getVisiblePoints(BaseMap map, Point<int> center, int range) {
  final visiblePoints = <Point<int>>[];

  void castLight(int row, double startSlope, double endSlope, int xx, int xy,
      int yx, int yy,) {
    if (startSlope < endSlope) return;
    var nextStartSlope = startSlope;
    for (var i = row; i < range; i++) {
      var blocked = false;
      for (var dx = -i, dy = -i; dx <= 0; dx++) {
        final lSlope = (dx - 0.5) / (dy + 0.5);
        final rSlope = (dx + 0.5) / (dy - 0.5);
        if (startSlope < rSlope) continue;
        if (endSlope > lSlope) break;
        final sax = dx * xx + dy * xy;
        final say = dx * yx + dy * yy;
        final ax = center.x + sax;
        final ay = center.y + say;
        if (ax >= 0 &&
            ax < map.dimension().x &&
            ay >= 0 &&
            ay < map.dimension().y) {
          final point = Point(ax, ay);
          visiblePoints.add(point);
          if (map.isOpaque(ax, ay)) {
            if (blocked) {
              nextStartSlope = rSlope;
              continue;
            } else {
              blocked = true;
              castLight(i + 1, nextStartSlope, lSlope, xx, xy, yx, yy);
              nextStartSlope = rSlope;
            }
          } else {
            if (blocked) {
              blocked = false;
              startSlope = nextStartSlope;
            }
          }
        }
      }
      if (blocked) break;
    }
  }

  for (var octant = 0; octant < 8; octant++) {
    switch (octant) {
      case 0:
        castLight(1, 1, 0, 1, 0, 0, 1);
      case 1:
        castLight(1, 1, 0, 0, 1, 1, 0);
      case 2:
        castLight(1, 1, 0, 0, 1, -1, 0);
      case 3:
        castLight(1, 1, 0, -1, 0, 0, 1);
      case 4:
        castLight(1, 1, 0, -1, 0, 0, -1);
      case 5:
        castLight(1, 1, 0, 0, -1, -1, 0);
      case 6:
        castLight(1, 1, 0, 0, -1, 1, 0);
      case 7:
        castLight(1, 1, 0, 1, 0, 0, -1);
    }
  }

  return visiblePoints;
}
