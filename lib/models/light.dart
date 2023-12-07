import 'package:cornell_box/models/point.dart';

class Light {
  Point3D position;
  double width;
  double height;
  double step;
  Point3D color;

  Light({
    required this.width,
    required this.height,
    required this.step,
    required this.position,
    required this.color
  });
}