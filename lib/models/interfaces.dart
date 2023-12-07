import 'dart:ui';

import 'package:cornell_box/models/camera.dart';
import 'package:cornell_box/models/intersection.dart';
import 'package:cornell_box/models/matrix.dart';
import 'package:cornell_box/models/point.dart';
import 'package:cornell_box/models/ray.dart';

abstract interface class IPoints {
  List<Point3D> get points;
}

abstract interface class Object {
  Point3D get objectColor;

  double get specularStrength;

  double get shininess;

  double get reflectivity;

  double get transparency;

  double get refractiveIndex;

  Intersection? intersect({
    required Ray ray,
    required Camera camera,
    required Matrix view,
    required Matrix projection
  });
}