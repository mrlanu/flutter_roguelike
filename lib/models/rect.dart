class Rect {
  int x1;
  int x2;
  int y1;
  int y2;

  Rect(this.x1, this.y1, int width, int height)
      : x2 = x1 + width,
        y2 = y1 + height;

  bool intersects(Rect other) {
    return !(other.x1 > x2 ||
        other.x2 < x1 ||
        other.y1 > y2 ||
        other.y2 < y1);
  }

  // Returns the center point of the rectangle as a tuple (x, y)
  (int, int) center() {
    return ((x1 + x2) ~/ 2, (y1 + y2) ~/ 2);
  }
}
