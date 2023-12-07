import 'dart:math';
import 'dart:ui';

import 'package:cornell_box/models/point.dart';
import 'package:cornell_box/models/ray.dart';
import 'package:vector_math/vector_math.dart' as vm;

class Camera{
  final Point3D eye, target, up;
  final double fov, nearPlane, farPlane;
  final random = Random();
  Camera({
    required this.eye,
    required this.target,
    required this.up,
    this.nearPlane = 1,
    this.farPlane = 100,
    this.fov = 60,
  });

  Ray getRay(double x, double y, int width, int height){
    double scale = tan(vm.radians(fov) * 0.5);
    Point3D forward = (target - eye).normalized();
    Point3D right = (up.cross(forward)).normalized();
    Point3D u = -forward.cross(right).normalized();
    Point3D rayDirection = forward +
      right * ((2 * x/width - 1) * (width/height) * scale) +
      u * ((1 - 2 * y/height) * scale);
    return Ray(
      start: eye,
      direction: rayDirection.normalized()
    );
  }

  List<({Offset pixel, List<Ray> rays})> getRays(int width, int height){
    final rays = <({Offset pixel, List<Ray> rays})>[];
    for (double x = 0; x < width; ++x){
      for (double y = 0; y < height; ++y){
        rays.add((
          pixel: Offset(x, y),
          rays: [
            getRay(x, y, width, height),
            ...List.generate(0, (index) => getRay(x + random.nextDouble() - 0.5, y + random.nextDouble() - 0.5, width, height))
          ]
        ));
      }
    }
    return rays;
  }

  Camera copyWith({
    Point3D? eye,
    Point3D? target,
    Point3D? up,
    double? nearPlane,
    double? farPlane,
    double? fov,
    double? aspect,
  }) => Camera(
    eye: eye ?? this.eye,
    target: target ?? this.target,
    up: up ?? this.up,
    nearPlane: nearPlane ?? this.nearPlane,
    farPlane: farPlane ?? this.farPlane,
    fov: fov ?? this.fov,
  );
}