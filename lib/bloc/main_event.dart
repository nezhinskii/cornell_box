part of 'main_bloc.dart';

@immutable
abstract class MainEvent {
  const MainEvent();
}

class UpdateCamera extends MainEvent {
  final Camera camera;
  const UpdateCamera(this.camera);
}

class SaveObjEvent extends MainEvent{
  const SaveObjEvent();
}

class LoadObjEvent extends MainEvent{
  const LoadObjEvent();
}

class ShowMessageEvent extends MainEvent{
  final String message;
  const ShowMessageEvent(this.message);
}

class CameraRotationEvent extends MainEvent{
  final Offset delta;
  const CameraRotationEvent(this.delta);
}

class CameraScaleEvent extends MainEvent{
  final double delta;
  const CameraScaleEvent(this.delta);
}