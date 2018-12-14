import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mockito/mockito.dart';
import 'package:plantoid/models/plant.dart';
import 'package:plantoid/pages/home/plantsoverview/plantsoverviewpage.dart';
import 'package:plantoid/resources/localization/localization.dart';
import 'package:plantoid/service/firestoreservice.dart';

class MockFirestoreService extends Mock implements FirestoreService {}

void main() {
  enableFlutterDriverExtension();

  final service = MockFirestoreService();

  final plants = List<Plant>.generate(
    50,
        (_) =>
        Plant(
          reference: null,
          name: "",
          notes: "",
          wateringFrequency: 7,
          lastWatered: DateTime.now().subtract(Duration(days: 10)),
          photoUrl: null,
        ),
  );
  when(service.listenForPlants())
      .thenAnswer((_) => Stream.fromIterable([plants]));

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var app = MaterialApp(
    localizationsDelegates: [
      AppLocalizationsDelegate(),
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    locale: Locale('en'),
    home: Scaffold(
      key: scaffoldKey,
      body: PlantsOverviewPage(
        scaffoldKey: scaffoldKey,
        dataService: service,
      ),
    ),
  );

  runApp(app);
}
