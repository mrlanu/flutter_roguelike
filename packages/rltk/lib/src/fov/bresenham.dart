import 'dart:math';

List<Point<int>> bresenham(int startX, int startY, int endX, int endY) {
  final points = <Point<int>>[];

  final dx = (endX - startX).abs();
  final dy = (endY - startY).abs();

  final sx = startX < endX ? 1 : -1;
  final sy = startY < endY ? 1 : -1;

  var err = dx - dy;

  while (true) {
    points.add(Point(startX, startY));

    if (startX == endX && startY == endY) break;

    final e2 = err * 2;

    if (e2 > -dy) {
      err -= dy;
      startX += sx;
    }

    if (e2 < dx) {
      err += dx;
      startY += sy;
    }
  }

  return points;
}
