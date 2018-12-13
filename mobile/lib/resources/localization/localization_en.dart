import "package:plantoid/resources/localization/localization.dart";

class LocalizationEN implements Localization {
  @override
  String get title => "Plantoid";

  @override
  String get addPlant => "Add plant";

  @override
  String get loading => "Loading…";

  @override
  String get name => "Name";

  @override
  String get notes => "Notes";

  @override
  String get wateringFrequency => "How often does it need watering?";

  @override
  String get save => "Save";

  @override
  String get cannotBeEmpty => "Cannot be empty";

  @override
  String get mustBeNumber => "Must be a number";

  @override
  String days(int days) => days == 1 ? "Every day" : "Every $days days";

  @override
  String get failedSavingPlant => "Failed to save plant 😔";

  @override
  String lastWatered(String fuzzyTime) => "Last watered $fuzzyTime";

  @override
  String get markWatered => "Mark as watered";

  @override
  String get wasWatered => "Watered!";

  @override
  String get undo => "Undo";

  @override
  String get mustBeWatered => "Needs watering!";

  @override
  String get doneForNow => "Done for now";

  @override
  String get deleted => "Deleted!";

  @override
  String get errorOccurred => "An error occurred";

  @override
  String get loginSignInGoogle => "Sign in with Google";

  @override
  String get forgotPasswordTitle => "Retrieve password";

  @override
  String get forgotPasswordExplanation =>
      "Enter your login email and we'll send you instructions to reset your password";

  @override
  String get forgotPasswordResetCTA => "Reset password";

  @override
  String get forgotPasswordNoEmailTitle => "Empty email";

  @override
  String get forgotPasswordNoEmailExplanation => "Please provide an email";

  @override
  String get forgotPasswordSuccessMessage =>
      "Email with instructions has been sent.";

  @override
  String get forgotPasswordErrorMessage =>
      "An error occurred while sending the email with instructions";

  @override
  String get email => "Email";

  @override
  String get cancel => "Cancel";

  @override
  String get ok => "OK";

  @override
  String get loginCreateYourAccount => "Create your account";

  @override
  String get loginSignUpCTA => "Sign-up";

  @override
  String get loginOr => "OR";

  @override
  String get loginSignInFacebook => "Sign-in with Facebook";

  @override
  String get loginAlreadyHaveAccountCTA => "Already have an account? Sign-in";

  @override
  String get loginSignIn => "Sign-in with your account";

  @override
  String get loginSignInCTA => "Sign-in";

  @override
  String get loginForgotPasswordCTA => "Forgot password?";

  @override
  String get loginNoAccountCTA => "Don't have an account yet? Sign-up";

  @override
  String get password => "Password";

  @override
  String get cameraOpenError => "Couldn't open camera 😔";

  @override
  String get cameraTakePictureError => "Couldn't take picture 😔";

  @override
  String get saving => "Saving…";

  @override
  String get plants => "Plants";

  @override
  String get house => "House";
}
