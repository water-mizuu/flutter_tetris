import "package:flutter_tetris/extension_types/point.dart";

enum Direction {
  up(Point.up),
  down(Point.down),
  left(Point.left),
  right(Point.right),
  ;

  const Direction(this.point);

  final Point point;
}
