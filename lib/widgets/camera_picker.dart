import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cornell_box/bloc/main_bloc.dart';
import 'package:cornell_box/models/point.dart';

class CameraPicker extends StatefulWidget {
  const CameraPicker({Key? key}) : super(key: key);

  @override
  State<CameraPicker> createState() => _CameraPickerState();
}

class _CameraPickerState extends State<CameraPicker> {
  final _posController = TextEditingController();
  final _viewPointController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final camera = context.watch<MainCubit>().camera;
    _posController.text = "${camera.eye.x.toStringAsFixed(2)} ${camera.eye.y.toStringAsFixed(2)} ${camera.eye.z.toStringAsFixed(2)}";
    _viewPointController.text = "${camera.target.x.toStringAsFixed(2)} ${camera.target.y.toStringAsFixed(2)} ${camera.target.z.toStringAsFixed(2)}";
  }

  void _onApply(){
    final posList = _posController.text.split(' ');
    if (posList.length != 3) {
      context.read<MainCubit>().showMessage('Неверно заданы точки');
    }
    final viewPointList = _viewPointController.text.split(' ');
    if (viewPointList.length != 3) {
      context.read<MainCubit>().showMessage('Неверно заданы точки');
    }
    late final Point3D pos, viewPoint;
    try {
      pos = Point3D(double.parse(posList[0]), double.parse(posList[1]), double.parse(posList[2]));
      viewPoint = Point3D(double.parse(viewPointList[0]), double.parse(viewPointList[1]), double.parse(viewPointList[2]));
    } catch (_) {
      context.read<MainCubit>().showMessage('Неверно заданы точки');
      return;
    }
    final camera = context.read<MainCubit>().camera;
    context.read<MainCubit>().updateCamera(camera.copyWith(eye: pos, target: viewPoint));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 65,
          width: 220,
          child: TextField(
            controller: _posController,
            decoration: const InputDecoration(
                contentPadding: EdgeInsets.zero, label: Text('Положение камеры')),
          ),
        ),
        SizedBox(
          height: 65,
          width: 220,
          child: TextField(
            controller: _viewPointController,
            decoration: const InputDecoration(
                contentPadding: EdgeInsets.zero, label: Text('Куда смотрит камера')),
          ),
        ),
        ElevatedButton(
          onPressed: _onApply,
          child: Text("Применить")
        )
      ],
    );
  }
}
