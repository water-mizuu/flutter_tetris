import "dart:async";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
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
    // We only handle the keydown events.
    if (event is KeyUpEvent) {
      return;
    }

    assert(activeShape != null && position != null, "The game must be started at this point.");

    /// FRST layout.
    switch (event.logicalKey) {
      /// Hard drop.
      case LogicalKeyboardKey.keyF:
        position = position! + Point.up;

      /// Move left
      case LogicalKeyboardKey.keyR:
        position = position! + Point.left;

      /// Move down
      case LogicalKeyboardKey.keyS:
        position = position! + Point.down;

      /// Move right
      case LogicalKeyboardKey.keyT:
        position = position! + Point.right;

      /// Rotate counter-clockwise
      case LogicalKeyboardKey.keyN:
        activeShape!.rotate(clockwise: false);
        print("Rotate counter-clockwise");

      /// Rotate clockwise.
      case LogicalKeyboardKey.keyE:
        activeShape!.rotate(clockwise: true);
        print("Rotate clockwise");
      case _:
    }

    // print(position);
    notifyListeners();
  }

  // Update
  void tick(int timeDelta) {
    // print(timeDelta);
  }

  // Life-Cycle
  void init() {
    activeShape = Shape.chooseRandom();

    assert(activeShape != null);
    if (activeShape case Shape activeShape) {
      int startingX = (columns - activeShape.grid[0].length) ~/ 2;

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
