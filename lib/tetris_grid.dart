import "package:flutter/material.dart";
import "package:flutter_tetris/extension_types/point.dart";
import "package:flutter_tetris/extensions/matrix_iteration.dart";
import "package:flutter_tetris/game_state.dart";
import "package:flutter_tetris/shape.dart";
import "package:provider/provider.dart";

class TetrisGrid extends StatelessWidget {
  const TetrisGrid({super.key});

  static const double tileSize = 28.0;

  @override
  Widget build(BuildContext context) {
    GameState state = context.watch<GameState>();

    /// We overlay over the board (because I do NOT know how to use positioned yet.)
    List<List<int>> overlayedBoard = <List<int>>[
      for (List<int> row in state.board) <int>[...row],
    ];

    if (state case GameState(:Point position, activeShape: Shape shape)) {
      for (var (int y, int x) in shape.grid.indices) {
        int newY = y + position.y;
        int newX = x + position.x;
        if (shape.grid[y][x] == 0 ||
            !(0 <= newY && newY < GameState.rows) ||
            !(0 <= newX && newX < GameState.columns)) {
          continue;
        }

        overlayedBoard[newY][newX] = shape.grid[y][x];
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (int y = 0; y < GameState.rows; ++y)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (int x = 0; x < GameState.columns; ++x) //
                Container(
                  decoration: BoxDecoration(
                    color: Shape.colorFrom(overlayedBoard[y][x]) ?? Colors.transparent,
                    border: Border.all(width: 0.5),
                  ),
                  width: tileSize,
                  height: tileSize,
                ),
            ],
          ),
      ],
    );
  }
}
