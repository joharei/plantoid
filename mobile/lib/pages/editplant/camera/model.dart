import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:plantoid/common/exceptionprint.dart';
import 'package:plantoid/common/mvi/viewmodel.dart';
import 'package:plantoid/resources/localization/localization.dart';

import 'state.dart';

class CameraViewModel extends BaseViewModel<CameraState> {
  List<CameraDescription> _cameras;
  CameraController _controller;

  CameraViewModel(Stream<Null> onShutterClicked,) {
    onShutterClicked.listen(_shootPhoto);
  }

  @override
  CameraState initialState() => CameraState.loading();

  @override
  Stream<CameraState> bind(BuildContext context) {
    _setUpCameras();

    return super.bind(context);
  }

  @override
  unbind() {
    _controller?.dispose();

    return super.unbind();
  }

  void _setUpCameras() async {
    try {
      _cameras = await availableCameras();

      _controller = CameraController(_cameras[0], ResolutionPreset.medium);
      await _controller.initialize();

      setState(CameraState.preview(_controller));
    } catch (e, stackTrace) {
      printException(e, stackTrace, "Failed setting up camera");

      setState(CameraState.error(
        Localization
            .of(getBuildContext())
            .cameraOpenError,
      ));
    }
  }

  String timestamp() =>
      DateTime
          .now()
          .millisecondsSinceEpoch
          .toString();

  _shootPhoto(Null event) async {
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/plants';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (_controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return;
    }

    try {
      await _controller.takePicture(filePath);
    } on CameraException catch (e, stackTrace) {
      printException(e, stackTrace, "Failed to take picture");

      setState(CameraState.error(Localization
          .of(getBuildContext())
          .cameraOpenError));
      return;
    }

    pop(filePath);
  }
}
