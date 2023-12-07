import 'dart:ui';

import 'package:cornell_box/models/point.dart';

class Intersection{
  final double z;
  final Point3D hit;
  final Point3D normal;
  final bool inside;

  const Intersection({
    required this.z,
    required this.hit,
    required this.normal,
    required this.inside
  });
}