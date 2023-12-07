import 'dart:math';
import 'dart:ui';

import 'package:cornell_box/models/interfaces.dart';
import 'package:cornell_box/models/point.dart';
import 'package:cornell_box/models/ray.dart';

class Polygon implements IPoints {
  Point3D? _normal;
  Point3D? _center;
  Polygon(this.points);

  @override
  final List<Point3D> points;

  Point3D? intersect(Ray ray) {
    var e1 = points[1] - points[0];
    var e2 = points[2] - points[0];
    var pVec = ray.direction.cross(e2);
    double det = e1.dot(pVec);
    if (det.abs() < 1e-18) {
      return null;
    }

    double invDet = 1.0 / det;
    var tVec = ray.start - points[0];
    double u = tVec.dot(pVec) * invDet;
    if (u < 0.0 || u > 1.0) {
      return null;
    }

    var q = tVec.cross(e1);
    double v = invDet * (ray.direction.dot(q));
    if (v < 0.0 || u + v > 1.0) {
      return null;
    }

    double t = invDet * (e2.dot(q));
    if (t > 1e-18) {
      return ray.start + ray.direction * t;
    }

    return null;
  }

  Point3D get normal {
    if (_normal != null) return _normal!;

    var v1 = points[1] - points[0];
    var v2 = points[2] - points[0];
    return v1.cross(v2).normalized();
  }

  Point3D get center {
    if (_center != null) return _center!;

    var sum = Point3D.zero();
    for (var point in points) {
      sum = sum + point;
    }
    return sum / points.length;
  }
}