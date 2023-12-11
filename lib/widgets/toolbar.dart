import 'package:cornell_box/models/light.dart';
import 'package:cornell_box/models/point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cornell_box/bloc/main_bloc.dart';

class ToolBar extends StatefulWidget {
  const ToolBar({Key? key}) : super(key: key);

  @override
  State<ToolBar> createState() => _ToolBarState();
}

class _ToolBarState extends State<ToolBar> {
  int _reflectiveWall = 4;
  bool _sphereReflective = false;
  bool _cubeReflective = true;
  bool _sphereTransparent = true;
  bool _cubeTransparent = false;
  bool _softShadows = false;
  bool _secondLight = false;
  final _lightController = TextEditingController(text: '-0.96;0;1.4');

  void _radioOnChanged(int? value){
    if (value != null){
      setState(() {
        _reflectiveWall = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(child: Text('Отражающая стена')),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RadioListTile<int>(
                    dense: true,
                    value: 1,
                    groupValue: _reflectiveWall,
                    onChanged: _radioOnChanged,
                    title: const Text('Нет'),
                  ),
                  RadioListTile<int>(
                    dense: true,
                    value: 2,
                    groupValue: _reflectiveWall,
                    onChanged: _radioOnChanged,
                    title: const Text('Левая'),
                  ),
                  RadioListTile<int>(
                    dense: true,
                    value: 3,
                    groupValue: _reflectiveWall,
                    onChanged: _radioOnChanged,
                    title: const Text('Нижняя'),
                  ),
                  RadioListTile<int>(
                    dense: true,
                    value: 4,
                    groupValue: _reflectiveWall,
                    onChanged: _radioOnChanged,
                    title: const Text('Правая'),
                  ),
                  RadioListTile<int>(
                    dense: true,
                    value: 5,
                    groupValue: _reflectiveWall,
                    onChanged: _radioOnChanged,
                    title: const Text('Верхняя'),
                  ),
                  RadioListTile<int>(
                    dense: true,
                    value: 6,
                    groupValue: _reflectiveWall,
                    onChanged: _radioOnChanged,
                    title: const Text('Передняя'),
                  )
                ],
              ),
            ),
            const Center(child: Text('Зеркальное отражение у объекта')),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Column(
                children: [
                  Row(
                    children: <Widget>[
                      Checkbox(
                        value: _sphereReflective,
                        onChanged: (value) {
                          if (value != null){
                            setState(() {
                              _sphereReflective = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(width: 10,),
                      const Text('Сфера')
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: _cubeReflective,
                        onChanged: (value) {
                          if (value != null){
                            setState(() {
                              _cubeReflective = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(width: 10,),
                      const Text('Куб')
                    ],
                  )
                ],
              ),
            ),
            const Center(child: Text('Прозрачность у объекта')),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Column(
                children: [
                  Row(
                    children: <Widget>[
                      Checkbox(
                        value: _sphereTransparent,
                        onChanged: (value) {
                          if (value != null){
                            setState(() {
                              _sphereTransparent = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(width: 10,),
                      const Text('Сфера')
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: _cubeTransparent,
                        onChanged: (value) {
                          if (value != null){
                            setState(() {
                              _cubeTransparent = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(width: 10,),
                      const Text('Куб')
                    ],
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: _secondLight,
                  onChanged: (value) {
                    if (value != null){
                      setState(() {
                        _secondLight = value;
                      });
                    }
                  },
                ),
                const SizedBox(width: 10,),
                Text('Второй источник света'),
              ],
            ),
            Center(
              child: SizedBox(
                height: 50,
                width: 150,
                child: TextField(
                  controller: _lightController,
                ),
              ),
            ),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: _softShadows,
                  onChanged: (value) {
                    if (value != null){
                      setState(() {
                        _softShadows = value;
                      });
                    }
                  },
                ),
                const SizedBox(width: 10,),
                Text('Мягкие тени'),
              ],
            ),
            const SizedBox(height: 20,),
            Center(
              child: ElevatedButton(
                onPressed: (){
                  Light? secondLight;
                  if (_secondLight){
                    final values = _lightController.text.split(';').map((e) => double.parse(e.trim())).toList();
                    secondLight = Light(
                      position: Point3D(values[0], values[1], values[2]),
                      width: 1.0,
                      height: 0.5,
                      step: 0.03,
                      color: Point3D(0.6, 0.6, 0.6),
                    );
                  }
                  context.read<MainCubit>().render(
                    '$_reflectiveWall'
                    '${_sphereReflective ? 1:0}'
                    '${_cubeReflective ? 1:0}'
                    '${_sphereTransparent ? 1:0}'
                    '${_cubeTransparent ? 1:0}'
                    '${_softShadows ? 1:0}',
                    secondLight
                  );
                },
                child: Text('Применить')
              ),
            )
          ],
        ));
  }
}
