/// An ℤ × ℤ wrapper class that allows element-wise arithmetic operations.
extension type const Point._((int, int) raw) {
  const Point(int y, int x) : this._((y, x));
  const Point.singleton(int value) : this._((value, value));

  static const Point up = Point(-1, 0);
  static const Point down = Point(1, 0);
  static const Point left = Point(0, -1);
  static const Point right = Point(0, 1);

  int get y => raw.$1;
  int get x => raw.$2;

  Point operator +(Point other) => Point(y + other.y, x + other.x);
  Point operator -(Point other) => Point(y - other.y, x - other.x);
  
  // ignore: avoid_annotating_with_dynamic
  Point operator *(Object? other) => switch (other) {
        Point(:int y, :int x) => Point(this.y * y, this.x * x),
        int scalar => Point(y * scalar, x * scalar),
        _ => throw UnsupportedError("Unsupported '*' operation between "
            "Point and ${other.runtimeType}"),
      };
  Point operator ~/(Point other) => Point(y ~/ other.y, x ~/ other.x);
}
