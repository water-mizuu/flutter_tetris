import "package:flutter/material.dart";
import "package:flutter_tetris/game_state.dart";
import "package:flutter_tetris/point.dart";
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

    if ((state.position, state.activeShape) case (Point position, Shape shape)) {
      for (int y = 0; y < shape.grid.length; ++y) {
        for (int x = 0; x < shape.grid[y].length; ++x) {
          if (y + position.y case int y_ when 0 <= y_ && y_ < GameState.rows) {
            if (x + position.x case int x_ when 0 <= x_ && x_ < GameState.columns) {
              overlayedBoard[y_][x_] = shape.grid[y][x];
            }
          }
        }
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
