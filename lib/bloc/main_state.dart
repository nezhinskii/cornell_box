part of 'main_bloc.dart';

@immutable
sealed class MainState {
  final String? message;
  const MainState({
    this.message
  });

  MainState copyWith({
    String? message,
  });
}

class CommonState extends MainState {
  final List<List<({Color color, Offset pos})?>> pixels;
  const CommonState({
    super.message,
    required this.pixels,
  });

  @override
  CommonState copyWith({
    List<List<({Color color, Offset pos})?>>? pixels,
    String? message,
  }) => CommonState(
    pixels: pixels ?? this.pixels,
    message: message
  );
}

class LoadingState extends MainState{
  const LoadingState({
    super.message,
  });

  @override
  LoadingState copyWith({
    String? message,
  }) => LoadingState(
    message: message
  );
}
