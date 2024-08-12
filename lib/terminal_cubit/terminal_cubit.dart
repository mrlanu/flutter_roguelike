import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'terminal_state.dart';

class TerminalCubit extends Cubit<TerminalState> {
  TerminalCubit() : super(TerminalState());

  void printText({required String text, required int x, required int y}) {
    List<String> newBuffer = _clx();
    final startIndex = _getIndexByXY(x: x, y: y);
    for (int i = 0; i < text.length; i++) {
      if (startIndex + i < newBuffer.length) {
        newBuffer[startIndex + i] = text[i];
      }
    }
    emit(state.copyWith(buffer: newBuffer));
  }

  List<String> _clx() =>
      List.generate(state.rows * state.columns, (index) => ' ');

  int _getIndexByXY({required int x, required int y}) => y * state.columns + x;
}
