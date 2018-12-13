import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:plantoid/pages/editplant/camera/camerapage.dart';
import 'package:plantoid/pages/home/homepage.dart';
import 'package:plantoid/pages/login/loginpage.dart';
import 'package:plantoid/resources/localization/localization.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) => MaterialApp(
    onGenerateTitle: (BuildContext context) =>
    Localization
        .of(context)
        .title,
    theme: ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.green,
      scaffoldBackgroundColor: Colors.white,
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
        },
      ),
    ),
    home: HomePage(),
    routes: <String, WidgetBuilder>{
      LOGIN_PAGE_ROUTE: (BuildContext context) => LoginPage(),
      CAMERA_PAGE_ROUTE: (BuildContext context) => CameraPage(),
    },
    localizationsDelegates: [
      AppLocalizationsDelegate(),
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: [
      Locale('en'),
      Locale('nb'),
      Locale('nn'),
    ],
  );
}
