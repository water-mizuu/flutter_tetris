import "package:flutter_tetris/extension_types/point.dart";

typedef List2<T> = List<List<T>>;

extension MatrixMethods<T> on List2<T> {
  Iterable<(int, int)> get indices sync* {
    for (int y = 0; y < length; ++y) {
      for (int x = 0; x < this[y].length; ++x) {
        yield (y, x);
      }
    }
  }

  Iterable<Point> get points sync* {
    for (int y = 0; y < length; ++y) {
      for (int x = 0; x < this[y].length; ++x) {
        yield Point(y, x);
      }
    }
  }

  bool containsIndex((int, int) index) {
    return (0 <= index.$1 && index.$1 < length) && (0 <= index.$2 && index.$2 < this[0].length);
  }

  bool containsPoint(Point point) => containsIndex(point as (int, int));
}
