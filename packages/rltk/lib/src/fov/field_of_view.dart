import 'dart:math';

import 'package:rltk/rltk.dart';

List<Point<int>> fieldOfView({
  required Point<int> start,
  required int range,
  required BaseMap map,
}) {
  final result = <Point<int>>[];
  final left = start.x - range;
  final right = start.x + range;
  final top = start.y - range;
  final bottom = start.y + range;
  final rangeSquared = range * range;

  for (var x = left; x <= right; x++) {
    for (final pt in scanFovLine(
      start: start,
      end: Point(x, top),
      rangeSquared: rangeSquared,
      map: map,
    )) {
      result.add(pt);
    }
    for (final pt in scanFovLine(
      start: start,
      end: Point(x, bottom),
      rangeSquared: rangeSquared,
      map: map,
    )) {
      result.add(pt);
    }
  }

  for (var y = top; y <= bottom; y++) {
    for (final pt in scanFovLine(
      start: start,
      end: Point(left, y),
      rangeSquared: rangeSquared,
      map: map,
    )) {
      result.add(pt);
    }
    for (final pt in scanFovLine(
      start: start,
      end: Point(right, y),
      rangeSquared: rangeSquared,
      map: map,
    )) {
      result.add(pt);
    }
  }

  return result;
}

List<Point<int>> scanFovLine({
  required Point<int> start,
  required Point<int> end,
  required int rangeSquared,
  required BaseMap map,
}) {
  final result = <Point<int>>[];
  final line = bresenham(start.x, start.y, end.x, end.y);

  var blocked = false;

  for (final point in line) {
    if (!blocked) {
      final target = Point(point.x, point.y);
      final dsq = distance2dSquared(start, target);
      if (dsq <= rangeSquared) {
        if (map.isOpaque(RoguelikeToolkit.getIndexByXy(
            x: target.x, y: target.y, columns: map.width,),)) {
          blocked = true;
        }
        result.add(target);
      } else {
        blocked = true;
      }
    }
  }
  return result;
}

double distance2dSquared(Point start, Point end) {
  final dx = (max(start.x, end.x) - min(start.x, end.x)).toDouble();
  final dy = (max(start.y, end.y) - min(start.y, end.y)).toDouble();
  return (dx * dx) + (dy * dy);
}
