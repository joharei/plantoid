import 'package:flutter/material.dart';
import 'package:plantoid/resources/localization/localization.dart';

class ErrorOccurredWidget extends StatelessWidget {
  ErrorOccurredWidget({
    Key key,
    @required this.error,
  }) : super(key: key);

  final String error;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(Localization
                .of(context)
                .errorOccurred),
            Padding(padding: EdgeInsets.only(top: 10.0)),
            Text(
              error,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
