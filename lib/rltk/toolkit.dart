class RoguelikeToolkit {
  RoguelikeToolkit({this.rows = 41, this.columns = 20})
      : _buffer = List.filled(rows * columns, ' ');

  final int rows;
  final int columns;
  List<String> _buffer;

  List<String> get buffer => _buffer;

  /*void changePosition(Direction direction) {
    switch (direction) {
      case Direction.up:
        player.y = player.y - 1;
        break;
      case Direction.down:
        player.y = player.y + 1;
        break;
      case Direction.left:
        player.x = player.x - 1;
        break;
      case Direction.right:
        player.x = player.x + 1;
        break;
    }
  }*/

  List<String> clx() => List.generate(rows * columns, (index) => ' ');

  void set({required String symbol, required int x, required int y}) {
    List<String> newBuffer = clx();
    final startIndex = _getIndexByXY(x: x, y: y);
    newBuffer[startIndex] = symbol;
    _buffer = newBuffer;
  }

  void printText({required String text, required int x, required int y}) {
    List<String> newBuffer = clx();
    final startIndex = _getIndexByXY(x: x, y: y);
    for (int i = 0; i < text.length; i++) {
      if (startIndex + i < newBuffer.length) {
        newBuffer[startIndex + i] = text[i];
      }
    }
    _buffer = newBuffer;
  }

  int _getIndexByXY({required int x, required int y}) => y * columns + x;
}

