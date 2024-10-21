/// An ℤ × ℤ wrapper class that allows element-wise arithmetic operations.
extension type const Point._((int, int) self) {
  const Point(int y, int x) : this._((y, x));

  static const Point up = Point(-1, 0);
  static const Point down = Point(1, 0);
  static const Point left = Point(0, -1);
  static const Point right = Point(0, 1);

  int get y => self.$1;
  int get x => self.$2;

  Point operator +(Point other) => Point(y + other.y, x + other.x);
  Point operator -(Point other) => Point(y - other.y, x - other.x);
}
