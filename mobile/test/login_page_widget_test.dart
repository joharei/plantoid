// This is a basic Flutter widget test.
// To perform an interaction with a widget in your test, use the WidgetTester utility that Flutter
// provides. For example, you can send tap and scroll gestures. You can also use WidgetTester to
// find child widgets in the widget tree, read text, and verify that the values of widget properties
// are correct.

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantoid/pages/login/loginpage.dart';
import 'package:plantoid/resources/localization/localization.dart';

void main() {
  testWidgets('Login page contains create account text',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: [
          AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        locale: Locale('en'),
        home: LoginPage(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify that the app displays the text
    expect(find.text('Sign-in with your account'), findsOneWidget);
  });
}
