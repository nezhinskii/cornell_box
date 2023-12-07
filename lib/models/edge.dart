import 'package:cornell_box/models/interfaces.dart';
import 'package:cornell_box/models/point.dart';

class Edge implements IPoints {
  final Point3D start, end;

  Edge(this.start, this.end);

  @override
  List<Point3D> get points => [start, end];
}
