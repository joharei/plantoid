import 'package:camera/camera.dart';
import 'package:plantoid/common/mvi/state.dart';
import 'package:sealed_unions/sealed_unions.dart';

class CameraState extends Union3Impl<CameraStatePreview, CameraStateLoading,
    CameraStateError> {
  static final Triplet<CameraStatePreview, CameraStateLoading, CameraStateError>
      factory = Triplet();

  CameraState._(
    Union3<CameraStatePreview, CameraStateLoading, CameraStateError> union,
  ) : super(union);

  factory CameraState.preview(CameraController controller) =>
      CameraState._(factory.first(CameraStatePreview(controller)));

  factory CameraState.loading() =>
      CameraState._(factory.second(CameraStateLoading()));

  factory CameraState.error(String error) =>
      CameraState._(factory.third(CameraStateError(error)));
}

class CameraStatePreview extends State {
  final CameraController controller;

  CameraStatePreview(this.controller);

  @override
  bool operator ==(other) {
    return identical(this, other) ||
        other is CameraStatePreview &&
            runtimeType == other.runtimeType &&
            controller == other.controller;
  }

  @override
  int get hashCode => super.hashCode ^ controller.hashCode;
}

class CameraStateLoading extends State {}

class CameraStateError extends State {
  final String error;

  CameraStateError(this.error);

  @override
  bool operator ==(other) {
    return identical(this, other) ||
        other is CameraStateError &&
            runtimeType == other.runtimeType &&
            error == other.error;
  }

  @override
  int get hashCode => super.hashCode ^ error.hashCode;
}
