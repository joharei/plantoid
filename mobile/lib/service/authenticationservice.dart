import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthenticationService {
  static final AuthenticationService instance =
      _AuthenticationServiceImpl(FirebaseAuth.instance);

  Future<FirebaseUser> signInWithGoogle();

  Future<FirebaseUser> signInWithFacebook();

  Future<FirebaseUser> signInWithAccount(String email, String password);

  Future<FirebaseUser> signUpWithAccount(String email, String password);

  Future<void> sendResetPasswordEmail(String email);

  Future<FirebaseUser> getCurrentUser();

  Future<void> signOut();
}

class AuthCancelledException implements Exception {
  final String message;

  AuthCancelledException(this.message);

  @override
  String toString() => message;
}

class _AuthenticationServiceImpl implements AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  _AuthenticationServiceImpl(this._firebaseAuth);

  @override
  Future<FirebaseUser> getCurrentUser() async {
    return await _firebaseAuth.currentUser().timeout(Duration(seconds: 5),
        onTimeout: () => Future.error(Exception(
            "unable to get your user data. Please check your network connection.")));
  }

  @override
  Future<FirebaseUser> signUpWithAccount(String email, String password) async {
    if (email == null || email.isEmpty) {
      throw AuthCancelledException("Email is empty");
    }

    if (password == null || password.isEmpty) {
      throw AuthCancelledException("Password is empty");
    }

    try {
      final user = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .timeout(Duration(seconds: 5),
              onTimeout: () => Future.error(
                  "Unable to sign up. Please check your network connection."));

      if (user == null) {
        throw Exception("Unable to sign up");
      }

      assert(user.email != null);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      return user;
    } on PlatformException catch (e) {
      if (e.details != null && e.details is String) {
        throw Exception(e.details);
      }

      throw e;
    }
  }

  @override
  Future<FirebaseUser> signInWithAccount(String email, String password) async {
    if (email == null || email.isEmpty) {
      throw Exception("Email is empty");
    }

    if (password == null || password.isEmpty) {
      throw Exception("Password is empty");
    }

    try {
      final user = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password)
          .timeout(Duration(seconds: 5),
              onTimeout: () => Future.error(
                  "Unable to sign in. Please check your network connection."));
      if (user == null) {
        throw Exception("Unable to sign in");
      }

      assert(user.email != null);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      return user;
    } on PlatformException catch (e) {
      if (e.details != null && e.details is String) {
        throw Exception(e.details);
      }

      throw e;
    }
  }

  @override
  Future<void> sendResetPasswordEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email).timeout(
        Duration(seconds: 5),
        onTimeout: () => Future.error(
            "Unable to send reset password request. Please check your network connection."));
  }

  @override
  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    GoogleSignInAccount googleUser = await _googleSignIn.signInSilently();
    if (googleUser == null) {
      googleUser = await _googleSignIn.signIn();
    }

    if (googleUser == null) {
      throw AuthCancelledException("User cancelled");
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final FirebaseUser user = await _firebaseAuth
        .signInWithGoogle(
            accessToken: googleAuth.accessToken, idToken: googleAuth.idToken)
        .timeout(Duration(seconds: 5),
            onTimeout: () => Future.error(Exception(
                "Unable to sign in. Please check your network connection.")));

    if (user == null) {
      throw Exception("Unable to sign-in with Google");
    }

    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    return user;
  }

  @override
  Future<FirebaseUser> signInWithFacebook() async {
    final facebookLogin = FacebookLogin();
    FacebookLoginResult result =
        await facebookLogin.logInWithReadPermissions(['email']);

    switch (result.status) {
      case FacebookLoginStatus.cancelledByUser:
        throw AuthCancelledException("User cancelled");
      case FacebookLoginStatus.error:
        throw Exception("Error occurred: ${result.errorMessage}");
      case FacebookLoginStatus.loggedIn:
        // continue
        break;
    }

    final token = result.accessToken.token;
    final FirebaseUser user = await _firebaseAuth
        .signInWithFacebook(accessToken: token)
        .timeout(Duration(seconds: 5),
            onTimeout: () => Future.error(Exception(
                "Unable to sign in. Please check your network connection.")));

    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    return user;
  }

  @override
  signOut() async {
    await _firebaseAuth.signOut();
  }
}
