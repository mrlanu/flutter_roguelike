part of 'terminal_cubit.dart';

class TerminalState extends Equatable{

  TerminalState({
    this.rows = 41,
    this.columns = 20,
    List<String>? buffer,
  }): buffer = buffer ?? List.generate(rows * columns, (index) => ' ',);

  final int rows;
  final int columns;
  late final List<String> buffer;

  @override
  List<Object> get props => [buffer];

  TerminalState copyWith({
    int? rows,
    int? columns,
    List<String>? buffer,
  }) {
    return TerminalState(
      rows: rows ?? this.rows,
      columns: columns ?? this.columns,
      buffer: buffer ?? this.buffer,
    );
  }
}
