import 'package:flutter_stream_friends/flutter_stream_friends.dart';

class CameraIntent {
  final VoidStreamCallback onShutterClicked;

  CameraIntent({
    final VoidStreamCallback onShutterClicked,
  }) : this.onShutterClicked = onShutterClicked ?? VoidStreamCallback();
}
