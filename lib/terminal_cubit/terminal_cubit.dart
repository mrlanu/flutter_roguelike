import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_roguelike/models/models.dart';

part 'terminal_state.dart';

class TerminalCubit extends Cubit<TerminalState> {
  TerminalCubit() : super(TerminalState()) {
    _startTimer();
  }

  Timer? _timer;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 20), _tick);
  }

  void _tick(Timer timer) {
   // _printText(text: 'Roguelike', x: state.x, y: 20);
    _set(symbol: state.player.symbol, x: state.player.x, y: state.player.y);
  }

  void _printText({required String text, required int x, required int y}) {
    List<String> newBuffer = _clx();
    final startIndex = _getIndexByXY(x: x, y: y);
    for (int i = 0; i < text.length; i++) {
      if (startIndex + i < newBuffer.length) {
        newBuffer[startIndex + i] = text[i];
      }
    }
    emit(state.copyWith(buffer: newBuffer));
  }

  void _set({required String symbol, required int x, required int y}) {
    List<String> newBuffer = _clx();
    final startIndex = _getIndexByXY(x: x, y: y);
    newBuffer[startIndex] = symbol;
    emit(state.copyWith(buffer: newBuffer));
  }

  List<String> _clx() =>
      List.generate(state.rows * state.columns, (index) => ' ');

  int _getIndexByXY({required int x, required int y}) => y * state.columns + x;

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  void changePosition() {
    //emit(state.copyWith(player: state.player.copyWith(x: state.player.x + 1)));
  }
}
