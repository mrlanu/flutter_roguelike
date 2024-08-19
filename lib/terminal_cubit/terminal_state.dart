part of 'terminal_cubit.dart';

class TerminalState extends Equatable {
  TerminalState({
    this.rows = 41,
    this.columns = 20,
    List<String>? buffer,
    Player? player,
  })  : buffer = buffer ??
            List.generate(
              rows * columns,
              (index) => ' ',
            ),
        player = player ?? Player(x: 3, y: 4, symbol: '@');

  final int rows;
  final int columns;
  late final List<String> buffer;
  final Player player;

  @override
  List<Object> get props => [buffer, player];

  TerminalState copyWith({
    int? rows,
    int? columns,
    List<String>? buffer,
    Player? player,
  }) {
    return TerminalState(
      rows: rows ?? this.rows,
      columns: columns ?? this.columns,
      buffer: buffer ?? this.buffer,
      player: player ?? this.player,
    );
  }
}
