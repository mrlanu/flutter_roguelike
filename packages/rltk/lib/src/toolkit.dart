import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rltk/src/const/const.dart';

import 'package:rltk/src/models/models.dart';


class RoguelikeToolkit {
  RoguelikeToolkit._internal({
    required this.image,
    this.rows = 82, this.columns = 40,
  }) : _buffer = List.filled(rows * columns, const Tile());

  static RoguelikeToolkit? _instance;

  final int rows;
  final int columns;
  final ui.Image image;
  List<Tile> _buffer;
  final List<Tile> _symbols = fillSymbols();

  List<Tile> get buffer => _buffer;

  static Future<RoguelikeToolkit> instance() async {
    if (_instance == null) {
      final image = await _loadImage();
      _instance = RoguelikeToolkit._internal(image: image);
    }
    return _instance!;
  }

  static Future<ui.Image> _loadImage() async {
    final data = await rootBundle.load(ConstantsRltk.terminalImagePath);
    final codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetHeight: 128,
      targetWidth: 128,
    );
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  List<Tile> clx() => _buffer = List.filled(rows * columns, const Tile());

  void set(
      {required String symbol,
      ui.Color color = Colors.transparent,
      required int x,
      required int y,}) {
    final newBuffer = <Tile>[..._buffer];
    final startIndex = getIndexByXY(x: x, y: y,);
    final i = symbol.runes.first;
    final tile = _symbols[i];
    newBuffer[startIndex] = Tile(
        topLeft: tile.topLeft, bottomRight: tile.bottomRight, color: color);
    _buffer = newBuffer;
  }

  void printText(
      {required String text,
      ui.Color color = Colors.transparent,
      required int x,
      required int y,}) {
    final newBuffer = clx();
    final startIndex = getIndexByXY(x: x, y: y,);
    for (var i = 0; i < text.length; i++) {
      if (startIndex + i < newBuffer.length) {
        final index = text[i].runes.first;
        final tile = _symbols[index];
        newBuffer[startIndex + i] = Tile(
            topLeft: tile.topLeft, bottomRight: tile.bottomRight, color: color);
      }
    }
    _buffer = newBuffer;
  }

  int getIndexByXY({required int x, required int y}) => y * columns + x;

  static int getIndexByXy(
      {required int x, required int y, required int columns,}) =>
      y * columns + x;

  static List<Tile> fillSymbols() {
    final result = <Tile>[];
    for (var row = 0; row < 16; row++) {
      for (var column = 0; column < 16; column++) {
        final topLeft = ui.Offset(column * 8.0, row * 8.0);
        final bottomRight = ui.Offset((column + 1) * 8.0, (row + 1) * 8.0);
        result.add(Tile(
            topLeft: topLeft, bottomRight: bottomRight, color: Colors.white,),);
      }
    }
    return result;
  }
}
