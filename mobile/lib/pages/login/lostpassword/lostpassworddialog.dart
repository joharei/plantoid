import 'dart:async';

import 'package:flutter/material.dart';
import 'package:plantoid/common/widgets/materialflatbutton.dart';
import 'package:plantoid/resources/localization/localization.dart';

Future<String> showLostPasswordDialog(BuildContext context) async {
  final emailController = TextEditingController();

  return showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
            title: Text(
              Localization
                  .of(context)
                  .forgotPasswordTitle,
              style: TextStyle(
                  fontFamily: "Google Sans", fontWeight: FontWeight.w500),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 16.0),
            children: <Widget>[
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        Localization
                            .of(context)
                            .forgotPasswordExplanation,
                        style: TextStyle(fontSize: 15.0),
                      ),
                      Padding(padding: EdgeInsets.only(top: 16.0)),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          icon: Icon(Icons.email),
                          hintText: Localization
                              .of(context)
                              .email,
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      Padding(padding: EdgeInsets.only(top: 25.0)),
                    ],
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  MaterialFlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    text: Localization
                        .of(context)
                        .cancel,
                    textColor: Theme.of(context).textTheme.title.color,
                  ),
                  MaterialFlatButton.primary(
                    context: context,
                    onPressed: () {
                      if (emailController.value.text.trim().isEmpty) {
                        _showEmptyEmailDialog(context);
                        return;
                      }

                      Navigator.of(context).pop(emailController.value.text);
                    },
                    text: Localization
                        .of(context)
                        .forgotPasswordResetCTA,
                  ),
                  Padding(padding: EdgeInsets.only(right: 8.0)),
                ],
              )
            ],
          ));
}

_showEmptyEmailDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              Localization
                  .of(context)
                  .forgotPasswordNoEmailTitle,
              style: TextStyle(
                fontFamily: "Google Sans",
                fontWeight: FontWeight.w500,
              ),
            ),
            content: Text(
              Localization
                  .of(context)
                  .forgotPasswordNoEmailExplanation,
              style: TextStyle(
                fontSize: 15.0,
              ),
            ),
            actions: <Widget>[
              MaterialFlatButton.primary(
                context: context,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                text: Localization
                    .of(context)
                    .ok,
              ),
            ],
          ));
}

showLostPasswordEmailSentSnackBar(BuildContext context) {
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(
      Localization
          .of(context)
          .forgotPasswordSuccessMessage,
    ),
    duration: Duration(seconds: 5),
  ));
}

showLostPasswordEmailErrorSendingSnackBar(BuildContext context, String error) {
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(
      "${Localization
          .of(context)
          .forgotPasswordErrorMessage} ($error)",
      style: TextStyle(
        color: Colors.red[600],
      ),
    ),
    duration: Duration(seconds: 5),
  ));
}
