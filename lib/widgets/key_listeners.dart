import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/models.dart';

class KeyListenerWidget extends StatefulWidget {
  const KeyListenerWidget({super.key, this.onTop});

  final Function(Direction direction)? onTop;

  @override
  State<KeyListenerWidget> createState() => _KeyListenerWidgetState();
}

class _KeyListenerWidgetState extends State<KeyListenerWidget> {
  final FocusNode _focusNode = FocusNode();
  bool isMoving = false;
  Direction direction = Direction.right;

  void _startMoving(Direction direction) {
    isMoving = true;
    this.direction = direction;
    _keepMoving();
  }

  void _keepMoving() async {
    while (isMoving) {
      widget.onTop!(direction);
      await Future.delayed(
          const Duration(milliseconds: 30)); // Adjust for movement speed
    }
  }

  void _stopMoving() {
    isMoving = false;
  }

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyPress(KeyEvent event) {
    if (event.runtimeType == KeyDownEvent) {
      switch (event.logicalKey.keyLabel) {
        case 'Arrow Up':
          _startMoving(Direction.up);
        case 'Arrow Down':
          _startMoving(Direction.down);
        case 'Arrow Left':
          _startMoving(Direction.left);
        case 'Arrow Right':
          _startMoving(Direction.right);
        default:
          return;
      }
    } else if (event.runtimeType == KeyUpEvent){
      _stopMoving();
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyPress,
      child: Container(),
    );
  }
}
