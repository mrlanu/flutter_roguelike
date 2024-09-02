import 'dart:math';

abstract class BaseMap {
  bool isOpaque(int x, int y);
  Point<int> dimension();
}
