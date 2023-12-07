import 'package:cornell_box/models/point.dart';

class Ray{
  final Point3D start, direction;
  const Ray({
    required this.start,
    required this.direction
  });
}