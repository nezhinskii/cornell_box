import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cornell_box/painters/app_painter.dart';
import 'package:cornell_box/bloc/main_bloc.dart';
import 'package:cornell_box/widgets/toolbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple,),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => MainCubit(),
        child: MainPage(),
      ),
    );
  }
}

final canvasAreaKey = GlobalKey();

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _inited = false;

  @override
  void dispose() async {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: BlocConsumer<MainCubit, MainState>(
          listener: (context, state) {
            if (state.message != null) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                behavior: SnackBarBehavior.floating,
                width: 700,
                content: Text(
                  state.message!,
                  textAlign: TextAlign.center,
                ),
              ));
            }
          },
          builder: (context, state) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 300,
                  child: ToolBar()
                ),
                Expanded(
                  child: RepaintBoundary(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        context.read<MainCubit>().width = constraints.maxWidth.toInt();
                        context.read<MainCubit>().height = constraints.maxHeight.toInt();
                        return ClipRRect(
                          key: canvasAreaKey,
                          child: CustomPaint(
                            foregroundPainter: switch(state){
                              CommonState() => AppPainter(
                                pixels: state.pixels
                              ),
                              _ => null
                            },
                            child: Container(
                              color: Theme.of(context).colorScheme.background,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        );
                      }
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
