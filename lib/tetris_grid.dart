import "package:flutter/material.dart";
import "package:flutter_tetris/extension_types/point.dart";
import "package:flutter_tetris/extensions/matrix_iteration.dart";
import "package:flutter_tetris/game_state.dart";
import "package:flutter_tetris/shape.dart";
import "package:provider/provider.dart";

class TetrisGrid extends StatelessWidget {
  const TetrisGrid({super.key});

  static const BoxDecoration topLeftBorder = BoxDecoration(
    border: Border(
      top: BorderSide(width: 0.5),
      left: BorderSide(width: 0.5),
    ),
  );
  static const BoxDecoration bottomRightBorder = BoxDecoration(
    border: Border(
      right: BorderSide(width: 0.5),
      bottom: BorderSide(width: 0.5),
    ),
  );
  static const double tileSize = 28.0;

  @override
  Widget build(BuildContext context) {
    GameState state = context.watch<GameState>();

    /// We overlay over the board (because I do NOT know how to use positioned yet.)
    List<List<int>> overlayedBoard = <List<int>>[
      for (List<int> row in state.board) <int>[...row],
    ];

    if (state case GameState(:Point position, activeShape: Shape shape, :Point ghostPosition)) {
      /// Overlay the ghost.
      for (var (int y, int x) in shape.grid.indices) {
        int newY = y + ghostPosition.y;
        int newX = x + ghostPosition.x;
        if (shape.grid[y][x] == 0 ||
            !(0 <= newY && newY < GameState.rows) ||
            !(0 <= newX && newX < GameState.columns)) {
          continue;
        }

        overlayedBoard[newY][newX] = shape.grid[y][x] | 32;
      }

      /// Overlay the actual piece.
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

    return Stack(
      children: <Widget>[
        Container(
          width: tileSize * GameState.columns,
          height: tileSize * GameState.rows,
          decoration: bottomRightBorder,
        ),

        /// This is the grid.
        for (var (int y, int x) in state.board.indices)
          Positioned(
            left: x * tileSize,
            top: y * tileSize,
            child: Container(
              decoration: topLeftBorder.copyWith(
                color: Shape.colorFrom(state.board[y][x]) ?? Colors.transparent,
              ),
              width: tileSize,
              height: tileSize,
            ),
          ),

        /// This is the active piece.
        if ((state.position, state.activeShape) case ((int y, int x), Shape shape))
          for (var (int dy, int dx) in shape.grid.indices)
            if (shape.grid[dy][dx] != 0)
              Transform.translate(
                offset: Offset(
                  (x + dx) * tileSize,
                  (y + dy) * tileSize,
                ),
                child: Container(
                  decoration: topLeftBorder.copyWith(color: Shape.colorFrom(shape.grid[dy][dx])),
                  width: tileSize,
                  height: tileSize,
                ),
              ),

        /// This is the ghost piece.
        if ((state.ghostPosition, state.activeShape) case ((int y, int x), Shape shape))
          for (var (int dy, int dx) in shape.grid.indices)
            if (shape.grid[dy][dx] != 0)
              Transform.translate(
                offset: Offset(
                  (x + dx) * tileSize,
                  (y + dy) * tileSize,
                ),
                child: Container(
                  decoration: topLeftBorder.copyWith(
                    color: Shape.colorFrom(shape.grid[dy][dx])?.withAlpha(64),
                  ),
                  width: tileSize,
                  height: tileSize,
                ),
              ),
      ],
    );
  }
}
