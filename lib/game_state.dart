import "dart:async";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_tetris/enum/direction.dart";
import "package:flutter_tetris/enum/rotation_direction.dart";
import "package:flutter_tetris/extension_types/point.dart";
import "package:flutter_tetris/extensions/matrix_iteration.dart";
import "package:flutter_tetris/shape.dart";

class GameState with ChangeNotifier {
  GameState()
      : board = <List<int>>[
          for (int y = 0; y < rows; ++y) <int>[for (int x = 0; x < columns; ++x) 0],
        ],
        previousTickTime = 0,
        timeSincePreviousDrag = 0;

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
  int timeSincePreviousDrag;

  // Inputs
  void handleKeyPress(KeyEvent event) {
    assert(activeShape != null && position != null, "The game must be started at this point.");

    if (event is KeyDownEvent) {
      /// FRST layout.
      switch (event.logicalKey) {
        /// Hard drop.
        case LogicalKeyboardKey.keyF:
          _jump();

        /// Move left
        case LogicalKeyboardKey.keyR:
          _move(Direction.left);

        /// Move down
        case LogicalKeyboardKey.keyS:
          _move(Direction.down);

        /// Move right
        case LogicalKeyboardKey.keyT:
          _move(Direction.right);

        case LogicalKeyboardKey.shiftLeft:
        case LogicalKeyboardKey.shiftRight:
          _reset();

        /// Rotate counter-clockwise
        case LogicalKeyboardKey.keyN:
          _rotate(RotationDirection.counterClockwise);

        /// Rotate clockwise.
        case LogicalKeyboardKey.keyE:
          _rotate(RotationDirection.clockwise);
        case LogicalKeyboardKey.space:
          print(_canMove(Direction.down));
      }
    }

    // print(position);
    notifyListeners();
  }

  // Update
  void tick(int timeDelta) {
    timeSincePreviousDrag += timeDelta;

    if (timeSincePreviousDrag > 1000) {
      // We want to drag.
      if (_canMove(Direction.down)) {
        _move(Direction.down);
      } else {
        _harden();
      }

      timeSincePreviousDrag = 0;
      notifyListeners();
    }
  }

  // Life-Cycle
  void init() {
    _reset();

    /// Create the loop.
    activeTimer = Timer.periodic(const Duration(milliseconds: 8), (_) {
      int current = DateTime.now().millisecondsSinceEpoch;
      int timeDelta = current - previousTickTime;
      previousTickTime = current;

      tick(timeDelta);
    });
  }

  Point? get ghostPosition {
    if ((activeShape, position) case (Shape shape, Point position)) {
      while (_isValidPiece(shape, position + Point.down)) {
        position += Point.down;
      }

      return position;
    }
    return null;
  }

  // Private functions

  void _harden() {
    /// Save to the current board.
    if ((activeShape, position) case (Shape shape, Point position)) {
      for (Point point in shape.grid.points) {
        var Point(:int y, :int x) = point + position;
        if (!board.containsIndex((y, x))) {
          continue;
        }

        if (shape.grid[point.y][point.x] case int v && != 0) {
          board[y][x] = v;
        }
      }

      _clearLines();
      _reset();
    }
  }

  /// Replaces [activeShape] with a new one, and updating the held piece.
  void _reset() {
    if (activeShape = Shape.chooseRandom() case Shape activeShape) {
      int startingX = (columns - activeShape.grid[0].length) ~/ 2;

      position = Point(0, startingX);
      timeSincePreviousDrag = 0;
    }
  }

  /// Moves the [activeShape] if it's possible.
  void _move(Direction direction) {
    if (_canMove(direction)) {
      position = position! + direction.point;

      timeSincePreviousDrag = 0;
    }
  }

  /// Skips to the bottom.
  void _jump() {
    position = ghostPosition;
    _harden();
  }

  /// Clears the lines from the board if they're full.
  void _clearLines() {
    List<int> rows = <int>[
      /// NOTE: This is in descending order, so that the indices aren't affected once removed.
      for (int y = board.length - 1; y >= 0; --y)
        if (board[y].every((int v) => v != 0)) y,
    ];

    rows
      ..forEach(board.removeAt)
      ..forEach((_) => board.insert(0, List<int>.filled(columns, 0)));
  }

  /// Rotates the piece, and moves it if it's reached an improbable state.
  void _rotate(RotationDirection rotationDirection) {
    bool clockwise = rotationDirection == RotationDirection.clockwise;

    if ((activeShape, position) case (Shape shape, Point position)) {
      shape.rotate(clockwise: clockwise);

      /// If the result of the rotation is invalid, we must:
      if (_isValidPiece(shape, position)) {
        return;
      }

      /// This is a hack. I have no idea how to do this better.
      int tries = shape.grid.length ~/ 2;
      for (int i = 1; i <= tries; ++i) {
        if (_isValidPiece(shape, position + Point.down * i)) {
          this.position = position + Point.down * i;
          break;
        } else if (_isValidPiece(shape, position + Point.right * i)) {
          this.position = position + Point.right * i;
          break;
        } else if (_isValidPiece(shape, position + Point.left * i)) {
          this.position = position + Point.left * i;
          break;
        }
      }
    }
  }

  /// Returns true if a piece (usually after a transformation) is valid within the game.
  bool _isValidPiece(Shape shape, Point position) {
    var (int dy, int dx) = position.raw;

    for (var (int y, int x) in shape.grid.indices) {
      if (shape.grid[y][x] case 0 || -1) {
        continue;
      }

      var (int boardY, int boardX) = (y + dy, x + dx);
      if (!board.containsIndex((boardY, boardX))) {
        return false;
      }

      if (board[boardY][boardX] case != 0) {
        return false;
      }
    }

    return true;
  }

  /// Returns true if a movement of the [activeShape] is acceptable to a direction.
  bool _canMove(Direction direction) {
    if ((activeShape, position) case (Shape shape, Point position)) {
      return _isValidPiece(shape, position + direction.point);
    }

    return false;
  }
}
