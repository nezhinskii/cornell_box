import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cornell_box/models/camera.dart';
import 'package:cornell_box/models/intersection.dart';
import 'package:cornell_box/models/interfaces.dart';
import 'package:cornell_box/models/matrix.dart';
import 'package:cornell_box/models/point.dart';
import 'package:cornell_box/models/polygon.dart';
import 'package:cornell_box/models/ray.dart';

class Model implements IPoints, Object {
  final List<Polygon> polygons;
  @override
  final List<Point3D> points;
  final List<List<int>> polygonsByIndexes;
  final Color color;
  @override
  final double specularStrength;
  @override
  final double shininess;
  @override
  final double reflectivity;
  @override
  final double transparency;
  @override
  final double refractiveIndex ;

  Model({
    required this.points,
    required this.polygonsByIndexes,
    required this.color,
    this.shininess = 8,
    this.specularStrength = 0.5,
    this.reflectivity = 0.0,
    this.transparency = 0.0,
    this.refractiveIndex = 1.05
  }) : polygons = [] {
    for (var polygonIndexes in polygonsByIndexes) {
      polygons.add(Polygon(List.generate(
          polygonIndexes.length, (i) => points[polygonIndexes[i]])));
    }
  }

  @override
  Point3D get objectColor => Point3D(
    color.red / 255,
    color.green / 255,
    color.blue / 255,
    1.0
  );

  @override
  Intersection? intersect({
    required Ray ray,
    required Camera camera,
    required Matrix view,
    required Matrix projection
  }) {
    Intersection? nearestRes;
    double nearestZ = double.infinity;
    for (var polygon in polygons){
      // var camVector = polygon.center - camera.eye;
      // if (polygon.normal.dot(camVector) < 0) continue;

      var res = polygon.intersect(ray);
      if (res == null){
        continue;
      }

      final projectedIntersection = Point3D.fromVector(Matrix.point(Point3D.fromVector(Matrix.point(res) * view)) * projection);
      if (projectedIntersection.z < nearestZ){
        nearestZ = projectedIntersection.z;
        nearestRes = Intersection(
          inside: ray.direction.dot(-polygon.normal) > 0,
          normal: -polygon.normal,
          hit: res,
          z: projectedIntersection.z
        );
      }
    }
    return nearestRes;
  }

  Point3D get center {
    var sum = Point3D.zero();
    for (var point in points) {
      sum = sum + point;
    }
    return sum / points.length;
  }

  Model getTransformed(Matrix transform) {
    final res = copy();
    for (var point in res.points) {
      point.updateWithVector(Matrix.point(point) * transform);
    }
    return res;
  }

  Model copy() {
    return Model(
      reflectivity: reflectivity,
      shininess: shininess,
      specularStrength: specularStrength,
      color: color,
      transparency: transparency,
      refractiveIndex: refractiveIndex,
      points: List.generate(points.length, (index) => points[index].copy()),
      polygonsByIndexes: polygonsByIndexes
    );
  }

  Model concat(Model other) {
    List<Point3D> resPoints = [];
    List<List<int>> resIndexes = [];

    for (var p in points) {
      resPoints.add(p.copy());
    }
    for (var p in other.points) {
      resPoints.add(p.copy());
    }

    for (var pol in polygonsByIndexes) {
      resIndexes.add(List.from(pol));
    }
    int len = points.length;
    for (var pol in other.polygonsByIndexes) {
      resIndexes.add(pol.map((e) => e + len).toList());
    }

    return Model(
      color: color,
      points: resPoints,
      polygonsByIndexes: resIndexes
    );
  }



  Model.cube({
    required Color color,
    double specularStrength = 0.0,
    double shininess = 8,
    double reflectivity = 0.0,
    double transparency = 0.0,
  }) : this(
    reflectivity: reflectivity,
    transparency: transparency,
    specularStrength: specularStrength,
    shininess: shininess,
    points: [
      Point3D(1, 0, 0),
      Point3D(1, 1, 0),
      Point3D(0, 1, 0),
      Point3D(0, 0, 0),
      Point3D(0, 0, 1),
      Point3D(0, 1, 1),
      Point3D(1, 1, 1),
      Point3D(1, 0, 1),
    ],
    color: color,
    polygonsByIndexes: [
      [0, 1, 2],
      [2, 3, 0],

      [5, 2, 1],
      [1, 6, 5],

      [4, 5, 6],
      [6, 7, 4],

      [3, 4, 7],
      [7, 0, 3],

      [7, 6, 1],
      [1, 0, 7],

      [3, 2, 5],
      [5, 4, 3],
    ]);

  Model.tetrahedron(Color color) : this(
      points: [
        Point3D(1, 0, 0),
        Point3D(0, 0, 1),
        Point3D(0, 1, 0),
        Point3D(1, 1, 1),
      ],
      polygonsByIndexes :[
        [0, 2, 1],
        [1, 2, 3],
        [0, 3, 2],
        [0, 1, 3]
      ],
      color: color
  );

  Model.octahedron(Color color): this(
      points: [
        Point3D(0.5, 1, 0.5),
        Point3D(0.5, 0.5, 1),
        Point3D(0, 0.5, 0.5),
        Point3D(0.5, 0.5, 0),
        Point3D(1, 0.5, 0.5),
        Point3D(0.5, 0, 0.5),
      ],
      polygonsByIndexes: [
        [0, 4, 1],
        [0, 3, 4],
        [0, 2, 3],
        [0, 1, 2],
        [5, 1, 4],
        [5, 4, 3],
        [5, 3, 2],
        [5, 2, 1],
      ],
      color: color
  );

  // static double phi = (1 + sqrt(5)) / 2;
  //
  // static get icosahedron => Model(
  //         [
  //           Point3D(0, phi, 1),
  //           Point3D(0, phi, -1),
  //           Point3D(phi, 1, 0),
  //           Point3D(-phi, 1, 0),
  //           Point3D(1, 0, phi),
  //           Point3D(1, 0, -phi),
  //           Point3D(-1, 0, phi),
  //           Point3D(-1, 0, -phi),
  //           Point3D(phi, -1, 0),
  //           Point3D(-phi, -1, 0),
  //           Point3D(0, -phi, 1),
  //           Point3D(0, -phi, -1),
  //         ].map((e) => e / phi).toList(),
  //         [
  //           [0, 1, 2],
  //           [0, 1, 3],
  //           [0, 2, 4],
  //           [0, 3, 6],
  //           [0, 4, 6],
  //           [1, 2, 5],
  //           [1, 3, 7],
  //           [1, 5, 7],
  //           [2, 4, 8],
  //           [2, 5, 8],
  //           [3, 6, 9],
  //           [3, 7, 9],
  //           [4, 6, 10],
  //           [4, 8, 10],
  //           [5, 7, 11],
  //           [5, 8, 11],
  //           [6, 9, 10],
  //           [7, 9, 11],
  //           [8, 10, 11],
  //           [9, 10, 11],
  //         ]);
  //
  // static get dodecahedron {
  //   final double iphi = 1 / phi;
  //   return Model(
  //       [
  //         Point3D(1, 1, 1), // 0
  //         Point3D(1, 1, -1), // 1
  //         Point3D(1, -1, 1), // 2
  //         Point3D(1, -1, -1), // 3
  //         Point3D(-1, 1, 1), // 4
  //         Point3D(-1, 1, -1), // 5
  //         Point3D(-1, -1, 1), // 6
  //         Point3D(-1, -1, -1), // 7
  //         Point3D(0, phi, iphi), // 8
  //         Point3D(0, phi, -iphi), // 9
  //         Point3D(0, -phi, iphi), // 10
  //         Point3D(0, -phi, -iphi), // 11
  //         Point3D(iphi, 0, phi), // 12
  //         Point3D(-iphi, 0, phi), // 13
  //         Point3D(iphi, 0, -phi), // 14
  //         Point3D(-iphi, 0, -phi), // 15
  //         Point3D(phi, iphi, 0), // 16
  //         Point3D(phi, -iphi, 0), // 17
  //         Point3D(-phi, iphi, 0), // 18
  //         Point3D(-phi, -iphi, 0), // 19
  //       ].map((e) => e / phi).toList(),
  //       [
  //         [8, 9, 1, 16, 0],
  //         [8, 9, 5, 18, 4],
  //         [10, 11, 3, 17, 2],
  //         [10, 11, 7, 19, 6],
  //         [12, 13, 4, 8, 0],
  //         [12, 13, 6, 10, 2],
  //         [14, 15, 5, 9, 1],
  //         [14, 15, 7, 11, 3],
  //         [16, 17, 2, 12, 0],
  //         [16, 17, 3, 14, 1],
  //         [18, 19, 6, 13, 4],
  //         [18, 19, 7, 15, 5],
  //       ]);
  // }
}
