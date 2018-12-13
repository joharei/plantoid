import 'dart:async';

import 'package:flutter/material.dart';
import 'package:plantoid/common/exceptionprint.dart';
import 'package:plantoid/common/mvi/viewmodel.dart';
import 'package:plantoid/pages/login/lostpassword/lostpassworddialog.dart';
import 'package:plantoid/service/authenticationservice.dart';

import 'intent.dart';
import 'state.dart';

class LoginViewModel extends BaseViewModel<LoginState> {
  final AuthenticationService _authService;

  LoginViewModel(
    this._authService,
      Stream<Null> onShowSignInButtonPressed,
      Stream<Null> onShowSignUpButtonPressed,
      Stream<LoginFormData> onSignUpButtonPressed,
      Stream<LoginFormData> onSignInButtonPressed,
    Stream<Null> onSignInWithGoogleButtonPressed,
    Stream<Null> onSignUpWithGoogleButtonPressed,
      Stream<Null> onSignInWithFacebookButtonPressed,
      Stream<Null> onSignUpWithFacebookButtonPressed,
      Stream<BuildContext> onForgotPasswordButtonPressed,
      Stream<Null> onSignUpEmailInputChanged,
      Stream<Null> onSignUpPasswordInputChanged,
      Stream<Null> onSignInEmailInputChanged,
      Stream<Null> onSignInPasswordInputChanged,
  ) {
    onShowSignInButtonPressed.listen(_showSignIn);
    onShowSignUpButtonPressed.listen(_showSignUp);

    onSignUpButtonPressed.listen(_signUp);
    onSignUpEmailInputChanged.listen(_hideSignUpError);
    onSignUpPasswordInputChanged.listen(_hideSignUpError);

    onSignInButtonPressed.listen(_signIn);
    onSignInEmailInputChanged.listen(_hideSignInError);
    onSignInPasswordInputChanged.listen(_hideSignInError);

    onSignInWithGoogleButtonPressed.listen(_signInWithGoogle);
    onSignUpWithGoogleButtonPressed.listen(_signUpWithGoogle);

    onSignInWithFacebookButtonPressed.listen(_signInWithFacebook);
    onSignUpWithFacebookButtonPressed.listen(_signUpWithFacebook);

    onForgotPasswordButtonPressed.listen(_showLostPasswordDialog);
  }

  @override
  LoginState initialState() => LoginState.signIn();

  _signInWithGoogle(Null event) async {
    setState(LoginState.authenticating());

    try {
      await _authService.signInWithGoogle();

      pushReplacementNamed("/");
    } catch (e, stackTrace) {
      printException(e, stackTrace, "Error while _signInWithGoogle");
      setState(LoginState.signInError(e.toString()));
    }
  }

  _signUpWithGoogle(Null event) async {
    setState(LoginState.authenticating());

    try {
      await _authService.signInWithGoogle();

      pushReplacementNamed("/");
    } catch (e, stackTrace) {
      printException(e, stackTrace, "Error while _signUpWithGoogle");
      setState(LoginState.signUpError(e.toString()));
    }
  }

  _signInWithFacebook(Null event) async {
    setState(LoginState.authenticating());

    try {
      await _authService.signInWithFacebook();

      pushReplacementNamed("/");
    } catch (e, stackTrace) {
      printException(e, stackTrace, "Error while _signInWithFacebook");
      setState(LoginState.signInError(e.toString()));
    }
  }

  _signUpWithFacebook(Null event) async {
    setState(LoginState.authenticating());

    try {
      await _authService.signInWithFacebook();

      pushReplacementNamed("/");
    } catch (e, stackTrace) {
      printException(e, stackTrace, "Error while _signUpWithFacebook");
      setState(LoginState.signUpError(e.toString()));
    }
  }

  _showLostPasswordDialog(BuildContext context) async {
    final email = await showLostPasswordDialog(context);
    if (email != null) {
      try {
        await _authService.sendResetPasswordEmail(email);
        showLostPasswordEmailSentSnackBar(context);
      } catch (e, stackTrace) {
        printException(
            e, stackTrace, "Error sending email into _showLostPasswordDialog");
        showLostPasswordEmailErrorSendingSnackBar(context, e.toString());
      }
    }
  }

  _showSignIn(Null event) {
    setState(LoginState.signIn());
  }

  _showSignUp(Null event) {
    setState(LoginState.signUp());
  }

  _signUp(LoginFormData formData) async {
    if (formData.email
        .trim()
        .isEmpty) {
      setState(LoginState.signUpError("Please provide an email"));
      return;
    }

    if (formData.password
        .trim()
        .isEmpty) {
      setState(LoginState.signUpError("Please provide a password"));
      return;
    }

    setState(LoginState.authenticating());

    try {
      await _authService.signUpWithAccount(formData.email, formData.password);

      pushReplacementNamed("/");
    } catch (e, stackTrace) {
      printException(e, stackTrace, "Error while creating an account");
      setState(LoginState.signUpError(e.toString()));
    }
  }

  _signIn(LoginFormData formData) async {
    if (formData.email
        .trim()
        .isEmpty) {
      setState(LoginState.signInError("Please provide an email"));
      return;
    }

    if (formData.password
        .trim()
        .isEmpty) {
      setState(LoginState.signInError("Please provide a password"));
      return;
    }

    setState(LoginState.authenticating());

    try {
      await _authService.signInWithAccount(formData.email, formData.password);

      pushReplacementNamed("/");
    } catch (e, stackTrace) {
      printException(e, stackTrace, "Error while ligging in with an account");
      setState(LoginState.signInError(e.toString()));
    }
  }

  _hideSignInError(Null event) {
    setState(LoginState.signIn());
  }

  _hideSignUpError(Null event) {
    setState(LoginState.signUp());
  }
}
