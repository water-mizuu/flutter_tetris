/// An ℤ × ℤ wrapper class that allows element-wise arithmetic operations.
extension type const Point._((int, int) self) {
  const Point(int y, int x) : this._((y, x));

  int get y => self.$1;
  int get x => self.$2;

  Point operator +(Point other) => Point(y + other.y, x + other.x);
  Point operator -(Point other) => Point(y - other.y, x - other.x);
}
