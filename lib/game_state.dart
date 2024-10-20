import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_tetris/point.dart";
import "package:flutter_tetris/shape.dart";

class GameState with ChangeNotifier {
  GameState()
      : board = <List<int>>[
          for (int y = 0; y < rows; ++y) <int>[for (int x = 0; x < columns; ++x) 0],
        ],
        previousTickTime = 0;

  static const Point left = Point(0, -1);
  static const Point right = Point(0, 1);

  static const int columns = 10;
  static const int rows = 20;

  final List<List<int>> board;

  // Variables
  Shape? activeShape;
  Point? position;

  Timer? activeTimer;

  int previousTickTime;

  // Inputs
  void handleKeyPress(KeyEvent event) {
    print(event);
  }

  // Update
  void tick(int timeDelta) {
    print(timeDelta);
  }

  // Life-Cycle
  void init() {
    activeShape = Shape.chooseRandom();

    assert(activeShape != null);
    if (activeShape case Shape activeShape) {
      int startingX = (columns - activeShape.shape[0].length) ~/ 2;

      position = Point(-1, startingX);
    }

    /// Create the loop.
    activeTimer = Timer.periodic(const Duration(milliseconds: 8), (_) {
      int current = DateTime.now().millisecondsSinceEpoch;
      int timeDelta = current - previousTickTime;
      previousTickTime = current;

      tick(timeDelta);
    });
  }
}
