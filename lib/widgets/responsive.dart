import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  const Responsive({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: kIsWeb
            ? const BoxConstraints(maxWidth: 400)
            : const BoxConstraints(maxWidth: 500),
        child: child,
      ),
    );
  }
}
