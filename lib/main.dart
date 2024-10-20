import "package:flutter/material.dart";
import "package:flutter_tetris/game_state.dart";
import "package:flutter_tetris/tetris_grid.dart";
import "package:provider/provider.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Demo",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: "Flutter Demo Home Page"),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, super.key});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final FocusNode keyboardFocusNode;
  late final GameState gameState;

  @override
  void initState() {
    super.initState();

    keyboardFocusNode = FocusNode();
    gameState = GameState()..init();
  }

  @override
  void dispose() {
    gameState.dispose();
    keyboardFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GameState>.value(
      value: gameState,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: KeyboardListener(
          autofocus: true,
          focusNode: keyboardFocusNode,
          onKeyEvent: gameState.handleKeyPress,
          child: Column(
            children: <Widget>[
              const Row(children: <Widget>[Text("Hello World!")]),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(child: Container()),
                    const Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TetrisGrid(),
                        ],
                      ),
                    ),
                    Expanded(child: Container()),
                  ],
                ),
              ),
              const Row(),
            ],
          ),
        ),
      ),
    );
  }
}
