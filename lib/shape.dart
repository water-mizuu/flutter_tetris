import "dart:math";

import "package:flutter/material.dart";

enum Shape {
  O(
    <List<int>>[
      <int>[1, 1],
      <int>[1, 1],
    ],
    Colors.yellow,
  ),
  I(
    <List<int>>[
      <int>[0, 2, 0, 0],
      <int>[0, 2, 0, 0],
      <int>[0, 2, 0, 0],
      <int>[0, 2, 0, 0],
    ],
    Colors.cyan,
  ),
  S(
    <List<int>>[
      <int>[0, 0, 0],
      <int>[0, 3, 3],
      <int>[3, 3, 0],
    ],
    Colors.green,
  ),
  Z(
    <List<int>>[
      <int>[0, 0, 0],
      <int>[4, 4, 0],
      <int>[0, 4, 4],
    ],
    Colors.red,
  ),
  L(
    <List<int>>[
      <int>[0, 5, 0],
      <int>[0, 5, 0],
      <int>[0, 5, 5],
    ],
    Colors.orange,
  ),
  J(
    <List<int>>[
      <int>[0, 6, 0],
      <int>[0, 6, 0],
      <int>[6, 6, 0],
    ],
    Colors.blue,
  ),
  T(
    <List<int>>[
      <int>[0, 7, 0],
      <int>[7, 7, 7],
      <int>[0, 0, 0],
    ],
    Colors.purple,
  ),
  ;

  const Shape(this._shape, this.color);

  static final Random random = Random();

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

  static Shape chooseRandom() => values[random.nextInt(values.length)];

  final List<List<int>> _shape;
  final Color color;

  List<List<int>> get shape => <List<int>>[
        for (List<int> row in _shape) <int>[...row],
      ];
}
