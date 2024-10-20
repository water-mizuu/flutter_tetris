import "package:flutter/material.dart";
import "package:flutter_tetris/game_state.dart";
import "package:flutter_tetris/shape.dart";
import "package:provider/provider.dart";

class TetrisGrid extends StatelessWidget {
  const TetrisGrid({super.key});

  static const double tileSize = 24.0;

  @override
  Widget build(BuildContext context) {
    GameState state = context.read<GameState>();
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
                    color: Shape.colorFrom(state.board[y][x]) ?? Colors.transparent,
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
