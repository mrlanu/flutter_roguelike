import 'package:flutter/material.dart';
import 'package:flutter_roguelike/roguelike.dart';
import 'package:flutter_roguelike/rl_state.dart';

import 'rltk/rltk.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final ctx = await RoguelikeToolkit.instance();
  runApp(MyApp(ctx: ctx,));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.ctx});

  final RoguelikeToolkit ctx;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final rlState = RoguelikeGameState();
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

