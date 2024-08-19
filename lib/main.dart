import 'package:flutter/material.dart';
import 'package:flutter_roguelike/roguelike.dart';
import 'package:flutter_roguelike/rl_state.dart';

import 'rltk/rltk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final rlState = RoguelikeGameState();
    final ctx = RoguelikeToolkit();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Roguelike',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Roguelike(gameState: rlState, ctx: ctx,),
    );
  }
}

