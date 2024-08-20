import 'dart:ui' as ui;

import 'package:flutter/services.dart';

import '../const/const.dart';

class RoguelikeToolkit {
  RoguelikeToolkit._internal({
    required this.image,
  }) : _buffer = List.filled(
            rows * columns, (const Offset(0.0, 0.0), const Offset(8.0, 8.0)));

  static RoguelikeToolkit? _instance;

  final ui.Image image;
  List<(Offset, Offset)> _buffer;
  final List<(Offset, Offset)> _symbols = fillSymbols();

  List<(Offset, Offset)> get buffer => _buffer;

  static Future<RoguelikeToolkit> instance() async {
    if (_instance == null) {
      final image = await _loadImage();
      _instance = RoguelikeToolkit._internal(image: image);
    }
    return _instance!;
  }

  static Future<ui.Image> _loadImage() async {
    final ByteData data =
        await rootBundle.load('assets/images/terminal8x8.png');
    final codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetHeight: 128,
      targetWidth: 128,
    );
    var frame = await codec.getNextFrame();
    return frame.image;
  }

  List<(Offset, Offset)> clx() =>
      List.filled(rows * columns, (const Offset(0.0, 0.0), const Offset(8.0, 8.0)));

  void set({required String symbol, required int x, required int y}) {
    List<(Offset, Offset)> newBuffer = clx();
    final startIndex = _getIndexByXY(x: x, y: y);
    final i = symbol.runes.first;
    newBuffer[startIndex] = _symbols[i];
    _buffer = newBuffer;
  }

  void printText({required String text, required int x, required int y}) {
    List<(Offset, Offset)> newBuffer = clx();
    final startIndex = _getIndexByXY(x: x, y: y);
    for (int i = 0; i < text.length; i++) {
      if (startIndex + i < newBuffer.length) {
        final index = text[i].runes.first;
        newBuffer[startIndex + i] = _symbols[index];
      }
    }
    _buffer = newBuffer;
  }

  static int _getIndexByXY({required int x, required int y}) => y * columns + x;

  static List<(ui.Offset, ui.Offset)> fillSymbols() {
    List<(ui.Offset, ui.Offset)> result = [];
    for (var row = 0; row < 16; row++) {
      for (var column = 0; column < 16; column++) {
        ui.Offset topLeft = ui.Offset(column * 8.0, row * 8.0);
        ui.Offset bottomRight = ui.Offset((column + 1) * 8.0, (row + 1) * 8.0);
        result.add((topLeft, bottomRight));
      }
    }
    return result;
  }
}
