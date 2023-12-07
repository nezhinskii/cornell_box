import 'dart:math';

import 'package:cornell_box/models/matrix.dart';

class Point3D {
  double x, y, z;
  double h;

  Point3D(this.x, this.y, this.z, [this.h = 1]);

  Point3D.fromVector(Matrix m) : x = m[0][0], y = m[0][1], z = m[0][2], h = m[0][3];

  Point3D.zero() : this(0, 0, 0);

  updateWithVector(Matrix matrix) {
    x = matrix[0][0];
    y = matrix[0][1];
    z = matrix[0][2];
    h = matrix[0][3];
  }

  Point3D copy() => Point3D(x, y, z);

  Point3D normalized() {
    double len = length();
    return Point3D(x/len, y/len, z/len);
  }

  Point3D cross(Point3D other) {
    return Point3D(
      y * other.z - z * other.y,
      z * other.x - x * other.z,
      x * other.y - y * other.x,
    );
  }

  double dot(Point3D other) {
    return x * other.x + y * other.y + z * other.z;
  }

  Point3D multiply(Point3D other){
    return Point3D(x * other.x, y * other.y, z * other.z);
  }

  Point3D operator *(double value){
    return Point3D(x * value, y * value, z * value);
  }

  Point3D operator -(Point3D other) {
    return Point3D(x - other.x, y - other.y, z - other.z, h);
  }

  Point3D operator -() {
    return Point3D(-x, -y, -z, h);
  }

  Point3D operator +(Point3D other) {
    return Point3D(x + other.x, y + other.y, z + other.z, h);
  }

  Point3D operator /(num d) {
    return Point3D(x / d, y / d, z / d);
  }

  double length(){
    return sqrt(x * x + y * y + z * z);
  }

  void limitTop(double value){
    x = min(x, value);
    y = min(y, value);
    z = min(z, value);
  }

  @override
  String toString() {
    return '${x.toStringAsFixed(2)} ${y.toStringAsFixed(2)} ${z.toStringAsFixed(2)}';
  }
}