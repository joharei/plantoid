import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plantoid/resources/localization/localization_en.dart';
import 'package:plantoid/resources/localization/localization_no.dart';

abstract class Localization {
  static Localization of(BuildContext context) =>
      Localizations.of<Localization>(context, Localization);

  String get title;

  String get addPlant;

  String get loading;

  String get name;

  String get notes;

  String get wateringFrequency;

  String get save;

  String get cannotBeEmpty;

  String get mustBeNumber;

  String days(int days);

  String get failedSavingPlant;

  String lastWatered(String fuzzyTime);

  String get markWatered;

  String get wasWatered;

  String get undo;

  String get mustBeWatered;

  String get doneForNow;

  String get deleted;

  String get errorOccurred;

  String get loginSignInGoogle;

  String get forgotPasswordTitle;

  String get forgotPasswordExplanation;

  String get forgotPasswordResetCTA;

  String get forgotPasswordNoEmailTitle;

  String get forgotPasswordNoEmailExplanation;

  String get forgotPasswordSuccessMessage;

  String get forgotPasswordErrorMessage;

  String get email;

  String get cancel;

  String get ok;

  String get loginCreateYourAccount;

  String get loginSignUpCTA;

  String get loginOr;

  String get loginSignInFacebook;

  String get loginAlreadyHaveAccountCTA;

  String get loginSignIn;

  String get loginSignInCTA;

  String get loginForgotPasswordCTA;

  String get loginNoAccountCTA;

  String get password;

  String get cameraOpenError;

  String get cameraTakePictureError;

  String get saving;

  String get plants;

  String get house;
}

class AppLocalizationsDelegate extends LocalizationsDelegate<Localization> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'no', 'nb', 'nn'].contains(locale.languageCode);

  @override
  Future<Localization> load(Locale locale) => _load(locale);

  static Future<Localization> _load(Locale locale) async {
    final String name =
    (locale.countryCode == null || locale.countryCode.isEmpty)
        ? locale.languageCode
        : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    Intl.defaultLocale = localeName;

    if (['no', 'nb', 'nn'].contains(locale.languageCode)) {
      return LocalizationNO();
    } else {
      return LocalizationEN();
    }
  }

  @override
  bool shouldReload(LocalizationsDelegate<Localization> old) => false;
}
