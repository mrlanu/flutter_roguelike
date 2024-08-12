import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_roguelike/terminal_cubit/terminal_cubit.dart';

class Terminal extends StatelessWidget {
  const Terminal({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          TerminalCubit()..printText(text: 'Roguelike', x: 6, y: 20),
      child: const TerminalView(),
    );
  }
}

class TerminalView extends StatelessWidget {
  const TerminalView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(body: BlocBuilder<TerminalCubit, TerminalState>(
      builder: (context, state) {
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: state.columns,
            childAspectRatio: 1.0,
          ),
          itemCount: state.rows * state.columns,
          itemBuilder: (context, index) {
            return GridTile(
              child: Container(
                color: Colors.black,
                child: Center(
                  child: Text(
                    state.buffer[index],
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            );
          },
        );
      },
    )));
  }
}
