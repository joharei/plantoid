import "package:plantoid/resources/localization/localization.dart";

class LocalizationNO implements Localization {
  @override
  String get title => "Plantoid";

  @override
  String get addPlant => "Legg til plante";

  @override
  String get loading => "Laster…";

  @override
  String get name => "Navn";

  @override
  String get notes => "Merknader";

  @override
  String get wateringFrequency => "Hvor ofte må den vannes?";

  @override
  String get save => "Lagre";

  @override
  String get cannotBeEmpty => "Må fylles ut";

  @override
  String get mustBeNumber => "Må være et tall";

  @override
  String days(int days) => days == 1 ? "Hver dag" : "Hver $days. dag";

  @override
  String get failedSavingPlant => "Kunne ikke lagre planten 😔";

  @override
  String lastWatered(String fuzzyTime) => "Sist vannet $fuzzyTime";

  @override
  String get markWatered => "Marker som vannet";

  @override
  String get wasWatered => "Vannet!";

  @override
  String get undo => "Angre";

  @override
  String get mustBeWatered => "Må vannes!";

  @override
  String get doneForNow => "Ferdig vannet";

  @override
  String get deleted => "Slettet!";

  @override
  String get errorOccurred => "Noe feilet";

  @override
  String get loginSignInGoogle => "Logg inn med Google";

  @override
  String get forgotPasswordTitle => "Gjenopprett passord";

  @override
  String get forgotPasswordExplanation =>
      "Skriv inn epostadressen din, så sender vi deg instruksjoner for å gjenopprette passordet";

  @override
  String get forgotPasswordResetCTA => "Gjenopprett passord";

  @override
  String get forgotPasswordNoEmailTitle => "Epostadressen var tom";

  @override
  String get forgotPasswordNoEmailExplanation =>
      "Vennligst skriv inn epostadressen din";

  @override
  String get forgotPasswordSuccessMessage =>
      "En epost med instruksjoner har blitt sendt.";

  @override
  String get forgotPasswordErrorMessage =>
      "Det skjedde en feil mens vi prøvde å sende eposten med instruksjoner";

  @override
  String get email => "Epost";

  @override
  String get cancel => "Avbryt";

  @override
  String get ok => "OK";

  @override
  String get loginCreateYourAccount => "Opprett bruker";

  @override
  String get loginSignUpCTA => "Opprett";

  @override
  String get loginOr => "ELLER";

  @override
  String get loginSignInFacebook => "Logg inn med Facebook";

  @override
  String get loginAlreadyHaveAccountCTA =>
      "Har du en bruker allerede? Logg inn";

  @override
  String get loginSignIn => "Logg inn med din bruker";

  @override
  String get loginSignInCTA => "Logg inn";

  @override
  String get loginForgotPasswordCTA => "Glemt passord?";

  @override
  String get loginNoAccountCTA => "Har du ingen bruker ennå? Opprett en";

  @override
  String get password => "Passord";

  @override
  String get cameraOpenError => "Klarte ikke å åpne kameraet 😔";

  @override
  String get cameraTakePictureError => "Klarte ikke å ta bilde 😔";

  @override
  String get saving => "Lagrer…";

  @override
  String get plants => "Planter";

  @override
  // TODO: implement household
  String get house => "Hus";
}
