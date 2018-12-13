import 'package:flutter/foundation.dart';

void printException(dynamic e, StackTrace stackTrace, [String message]) {
  if (message != null) {
    debugPrint("$message: $e");
  } else {
    debugPrint(e.toString());
  }

  // TODO: set up Sentry
//  if (!(e is IOException) &&
//      !(e is AuthCancelledException) &&
//      !_isFirestoreIOException(e)) {
//    final Event event = new Event(
//      exception: e,
//      stackTrace: stackTrace,
//      message: message,
//    );
//    MyApp.sentry.capture(event: event);
//  }

  print(stackTrace);
}
//
//bool _isFirestoreIOException(dynamic e) {
//  return e.toString().contains("because the client is offline");
//}
