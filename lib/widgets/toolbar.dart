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
            Center(
              child: ElevatedButton(
                onPressed: (){
                  context.read<MainCubit>().render(
                    '$_reflectiveWall${_sphereReflective ? 1:0}${_cubeReflective ? 1:0}${_sphereTransparent ? 1:0}${_cubeTransparent ? 1:0}'
                  );
                },
                child: Text('Применить')
              ),
            )
          ],
        ));
  }
}
