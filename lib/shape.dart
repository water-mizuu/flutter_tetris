// ignore_for_file: prefer_constructors_over_static_methods

import "dart:math";

import "package:flutter/material.dart";

class Shape {
  Shape(this.grid);

  static Shape get O => Shape(
        <List<int>>[
          <int>[1, 1],
          <int>[1, 1],
        ],
      );

  static Shape get I => Shape(
        <List<int>>[
          <int>[0, 2, 0, 0],
          <int>[0, 2, 0, 0],
          <int>[0, 2, 0, 0],
          <int>[0, 2, 0, 0],
        ],
      );

  static Shape get S => Shape(
        <List<int>>[
          <int>[0, 3, 3],
          <int>[3, 3, 0],
          <int>[0, 0, 0],
        ],
      );
  static Shape get Z => Shape(
        <List<int>>[
          <int>[4, 4, 0],
          <int>[0, 4, 4],
          <int>[0, 0, 0],
        ],
      );
  static Shape get L => Shape(
        <List<int>>[
          <int>[0, 5, 0],
          <int>[0, 5, 0],
          <int>[0, 5, 5],
        ],
      );
  static Shape get J => Shape(
        <List<int>>[
          <int>[0, 6, 0],
          <int>[0, 6, 0],
          <int>[6, 6, 0],
        ],
      );
  static Shape get T => Shape(
        <List<int>>[
          <int>[0, 7, 0],
          <int>[7, 7, 7],
          <int>[0, 0, 0],
        ],
      );

  final List<List<int>> grid;

  static List<(int, int)> _rotationPoints(
    int layer,
    int dimensions,
    int i, {
    required bool clockwise,
  }) {
    /// Some math was involved. Check the paper.
    /// Michael has it.
    List<(int, int)> indices = <(int, int)>[
      (layer, i + layer),
      (i + layer, dimensions - layer - 1),
      (dimensions - layer - 1, dimensions - i - layer - 1),
      (dimensions - i - layer - 1, layer),
    ];

    if (!clockwise) {
      return indices.reversed.toList();
    }
    return indices;
  }

  void rotate({required bool clockwise}) {
    assert(grid.length == grid[0].length);

    int dimensions = grid.length;
    for (int layer = 0; layer < dimensions / 2; ++layer) {
      for (int i = 0; i < dimensions - 2 * layer - 1; ++i) {
        List<(int, int)> indices = _rotationPoints(layer, dimensions, i, clockwise: clockwise);
        int temp = grid[indices.last.$1][indices.last.$2];
        for (int i = indices.length - 2; i >= 0; --i) {
          var (int fromY, int fromX) = indices[i];
          var (int toY, int toX) = indices[i + 1];

          grid[toY][toX] = grid[fromY][fromX];
        }
        grid[indices.first.$1][indices.first.$2] = temp;
        print(indices);
      }
    }
  }

  static final Random _random = Random();

  static Color? colorFrom(int value) => switch (value) {
        1 => Colors.yellow,
        2 => Colors.cyan,
        3 => Colors.green,
        4 => Colors.red,
        5 => Colors.orange,
        6 => Colors.blue,
        7 => Colors.purple,
        _ => null,
      };

  static Shape chooseRandom() => switch (_random.nextInt(7)) {
        0 => Shape.O,
        1 => Shape.I,
        2 => Shape.S,
        3 => Shape.Z,
        4 => Shape.L,
        5 => Shape.J,
        6 => Shape.T,
        _ => throw Error(), // This is not possible, unless the previous call is changed.
      };
}
