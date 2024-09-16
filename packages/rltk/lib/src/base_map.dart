import 'dart:math';

abstract class BaseMap {
  bool isOpaque(int x, int y);
  bool isBlocked(int x, int y);
  Point<int> dimension();
  int getIndexByXY({required int x, required int y});
}
