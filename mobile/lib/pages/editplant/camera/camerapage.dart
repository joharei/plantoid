import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:plantoid/common/mvi/viewstate.dart';
import 'package:plantoid/common/widgets/loadingwidget.dart';
import 'package:plantoid/resources/constants.dart';
import 'package:plantoid/resources/dimens.dart';

import 'intent.dart';
import 'model.dart';
import 'state.dart';

const String CAMERA_PAGE_ROUTE = "/camera";

class CameraPage extends StatefulWidget {
  final CameraIntent intent;
  final CameraViewModel model;

  CameraPage._({
    Key key,
    @required this.intent,
    @required this.model,
  }) : super(key: key);

  factory CameraPage({
    Key key,
    CameraIntent intent,
    CameraViewModel model,
  }) {
    final _intent = intent ?? CameraIntent();
    final _model = model ??
        CameraViewModel(
          _intent.onShutterClicked,
        );

    return CameraPage._(intent: _intent, model: _model);
  }

  @override
  State<StatefulWidget> createState() =>
      _CameraPageState(intent: intent, model: model);
}

class _CameraPageState
    extends ViewState<CameraPage, CameraViewModel, CameraIntent, CameraState> {
  _CameraPageState({
    @required CameraIntent intent,
    @required CameraViewModel model,
  }) : super(intent, model);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<CameraState> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        return snapshot.data.join(
          (preview) => _buildPreviewWidget(preview.controller),
          (loading) => _buildLoadingWidget(),
          (error) => _buildErrorWidget(error.error),
        );
      },
    );
  }

  Widget _buildPreviewWidget(CameraController controller) {
    return Column(
      children: <Widget>[
        Expanded(child: _orientationAwareCameraPreview(controller)),
        _shutterButtonArea(),
      ],
    );
  }

  Widget _shutterButtonArea() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: Dimens.defaultMargin),
      color: Colors.black,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints.expand(width: 64.0, height: 64.0),
          child: RawMaterialButton(
            onPressed: intent.onShutterClicked,
            shape: CircleBorder(),
            elevation: 8.0,
            fillColor: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _orientationAwareCameraPreview(
      CameraController controller) {
    return NativeDeviceOrientationReader(builder: (context) {
      NativeDeviceOrientation orientation =
          NativeDeviceOrientationReader.orientation(context);

      int turns;
      switch (orientation) {
        case NativeDeviceOrientation.landscapeLeft:
          turns = -1;
          break;
        case NativeDeviceOrientation.landscapeRight:
          turns = 1;
          break;
        case NativeDeviceOrientation.portraitDown:
          turns = 2;
          break;
        default:
          turns = 0;
          break;
      }

      return RotatedBox(
        quarterTurns: turns,
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: CameraPreview(controller),
        ),
      );
    });
  }

  Widget _buildLoadingWidget() {
    return Container(
      color: Colors.black,
      padding: EdgeInsets.only(top: 10.0, bottom: 25.0),
      child: LoadingWidget(),
    );
  }

  Widget _buildErrorWidget(String error) {
    GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
    Future.delayed(Duration(milliseconds: 500)).then((_) {
      scaffoldKey.currentState?.showSnackBar(SnackBar(
        content: Text(error),
        duration: Constants.undoSnackBarDuration,
      ));
    });
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.black,
    );
  }
}
