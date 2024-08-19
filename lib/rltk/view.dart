import 'package:flutter/material.dart';


class RoguelikeToolkitView extends StatelessWidget {
  const RoguelikeToolkitView(
      {super.key, required this.buffer, this.rows = 41, this.columns = 20});

  final int rows;
  final int columns;
  final List<String> buffer;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        childAspectRatio: 1.0,
      ),
      itemCount: rows * columns,
      itemBuilder: (context, index) {
        return GridTile(
          child: Container(
            color: Colors.black,
            child: Center(
              child: Text(
                buffer[index],
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        );
      },
    );
  }
}
