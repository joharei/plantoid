import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Scrolling performance test', () {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('Measure', () async {
      Timeline timeline = await driver.traceAction(() async {
        SerializableFinder plantsList = find.byType('ListView');

        for (int i = 0; i < 5; i++) {
          await driver.scroll(
              plantsList, 0.0, -300.0, Duration(milliseconds: 300));
        }
      });
    });
  });
}
