import 'package:flutter/material.dart';
import 'package:plantoid/common/mvi/viewstate.dart';
import 'package:plantoid/common/widgets/loadingwidget.dart';
import 'package:plantoid/common/widgets/materialflatbutton.dart';
import 'package:plantoid/common/widgets/materialraisedbutton.dart';
import 'package:plantoid/resources/localization/localization.dart';
import 'package:plantoid/service/authenticationservice.dart';

import 'intent.dart';
import 'model.dart';
import 'state.dart';

const String LOGIN_PAGE_ROUTE = "/login";

class LoginPage extends StatefulWidget {
  final LoginIntent intent;
  final LoginViewModel model;

  LoginPage._({Key key, @required this.intent, @required this.model})
      : super(key: key);

  factory LoginPage(
      {Key key,
      LoginIntent intent,
      LoginViewModel model,
      AuthenticationService authService}) {
    final _intent = intent ?? LoginIntent();
    final _model = model ??
        LoginViewModel(
          authService ?? AuthenticationService.instance,
          _intent.showSignIn,
          _intent.showSignUp,
          _intent.signUp,
          _intent.signIn,
          _intent.signInWithGoogle,
          _intent.signUpWithGoogle,
          _intent.signInWithFacebook,
          _intent.signUpWithFacebook,
          _intent.forgotPassword,
          _intent.signUpEmailInputChanged,
          _intent.signUpPasswordInputChanged,
          _intent.signInEmailInputChanged,
          _intent.signInPasswordInputChanged,
        );

    return LoginPage._(key: key, intent: _intent, model: _model);
  }

  @override
  _LoginPageState createState() =>
      _LoginPageState(intent: intent, model: model);
}

class _LoginPageState
    extends ViewState<LoginPage, LoginViewModel, LoginIntent, LoginState> {
  final signUpEmailController = TextEditingController();
  final signUpPassController = TextEditingController();
  final signInEmailController = TextEditingController();
  final signInPassController = TextEditingController();

  _LoginPageState(
      {@required LoginIntent intent, @required LoginViewModel model})
      : super(intent, model);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<LoginState> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        return snapshot.data.join(
              (signUp) => _buildSignUpScreen(context),
              (signIn) => _buildLoginScreen(context),
              (authenticating) => _buildAuthenticatingScreen(context),
              (signUpError) =>
              _buildSignUpScreen(context, error: signUpError.error),
              (signInError) =>
              _buildLoginScreen(context, error: signInError.error),
        );
      },
    );
  }

  Widget _buildSignUpScreen(BuildContext context, {String error}) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding:
            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  Localization
                      .of(context)
                      .loginCreateYourAccount,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 22.0,
                    fontFamily: "Google Sans",
                  ),
                ),
                Offstage(
                  offstage: error == null,
                  child: Column(
                    children: <Widget>[
                      const Padding(padding: EdgeInsets.only(top: 16.0)),
                      Text(
                        error ?? "",
                        style: TextStyle(
                          color: Colors.red[600],
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 16.0)),
                TextField(
                  decoration: InputDecoration(
                    hintText: Localization
                        .of(context)
                        .email,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  controller: signUpEmailController,
                  onChanged: (val) {
                    intent.signUpEmailInputChanged();
                  },
                ),
                const Padding(padding: EdgeInsets.only(top: 16.0)),
                TextField(
                  decoration: InputDecoration(
                    hintText: Localization
                        .of(context)
                        .password,
                  ),
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  controller: signUpPassController,
                  onChanged: (val) {
                    intent.signUpPasswordInputChanged();
                  },
                ),
                const Padding(padding: EdgeInsets.only(top: 25.0)),
                Center(
                  child: MaterialRaisedButton.primary(
                    context: context,
                    onPressed: () {
                      intent.signUp(LoginFormData(signUpEmailController.text,
                          signUpPassController.text));
                    },
                    text: Localization
                        .of(context)
                        .loginSignUpCTA,
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 25.0)),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 2.0,
                        decoration: BoxDecoration(
                          color: Theme
                              .of(context)
                              .textTheme
                              .title
                              .color,
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 16.0)),
                    Text(
                      Localization
                          .of(context)
                          .loginOr,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontFamily: "Google Sans",
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 16.0)),
                    Expanded(
                      child: Container(
                        height: 2.0,
                        decoration: BoxDecoration(
                          color: Theme
                              .of(context)
                              .textTheme
                              .title
                              .color,
                        ),
                      ),
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.only(top: 25.0)),
                Center(
                  child: MaterialRaisedButton.primary(
                    context: context,
                    onPressed: intent.signUpWithGoogle,
                    text: Localization
                        .of(context)
                        .loginSignInGoogle,
                    leading: Image.asset("assets/icons/google.webp"),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 16.0)),
                Center(
                  child: MaterialRaisedButton.primary(
                    context: context,
                    onPressed: intent.signUpWithFacebook,
                    text: Localization
                        .of(context)
                        .loginSignInFacebook,
                    leading: Image.asset("assets/icons/facebook.webp"),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 30.0)),
                Center(
                  child: MaterialFlatButton.primary(
                    context: context,
                    onPressed: intent.showSignIn,
                    text: Localization
                        .of(context)
                        .loginAlreadyHaveAccountCTA,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginScreen(BuildContext context, {String error}) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Builder(builder: (BuildContext context) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding:
              const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Localization
                        .of(context)
                        .loginSignIn,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 22.0,
                      fontFamily: "Google Sans",
                    ),
                  ),
                  Offstage(
                    offstage: error == null,
                    child: Column(
                      children: <Widget>[
                        const Padding(padding: EdgeInsets.only(top: 16.0)),
                        Text(
                          error ?? "",
                          style: TextStyle(
                            color: Colors.red[600],
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 16.0)),
                  TextField(
                    decoration: InputDecoration(
                      hintText: Localization
                          .of(context)
                          .email,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    controller: signInEmailController,
                    onChanged: (val) {
                      intent.signInEmailInputChanged();
                    },
                  ),
                  const Padding(padding: EdgeInsets.only(top: 16.0)),
                  TextField(
                    decoration: InputDecoration(
                      hintText: Localization
                          .of(context)
                          .password,
                    ),
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    controller: signInPassController,
                    onChanged: (val) {
                      intent.signInPasswordInputChanged();
                    },
                  ),
                  const Padding(padding: EdgeInsets.only(top: 25.0)),
                  Center(
                    child: MaterialRaisedButton.primary(
                      context: context,
                      onPressed: () {
                        intent.signIn(LoginFormData(signInEmailController.text,
                            signInPassController.text));
                      },
                      text: Localization
                          .of(context)
                          .loginSignInCTA,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 16.0)),
                  Center(
                    child: MaterialFlatButton.primary(
                      context: context,
                      onPressed: () {
                        intent.forgotPassword(context);
                      },
                      text: Localization
                          .of(context)
                          .loginForgotPasswordCTA,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 20.0)),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: 2.0,
                          decoration: BoxDecoration(
                              color: Theme
                                  .of(context)
                                  .textTheme
                                  .title
                                  .color),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(left: 16.0)),
                      Text(
                        Localization
                            .of(context)
                            .loginOr,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontFamily: "Google Sans",
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(left: 16.0)),
                      Expanded(
                        child: Container(
                          height: 2.0,
                          decoration: BoxDecoration(
                              color: Theme
                                  .of(context)
                                  .textTheme
                                  .title
                                  .color),
                        ),
                      ),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.only(top: 25.0)),
                  Center(
                    child: MaterialRaisedButton.primary(
                      context: context,
                      onPressed: intent.signInWithGoogle,
                      text: Localization
                          .of(context)
                          .loginSignInGoogle,
                      leading: Image.asset("assets/icons/google.webp"),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 16.0)),
                  Center(
                    child: MaterialRaisedButton.primary(
                      context: context,
                      onPressed: intent.signInWithFacebook,
                      text: Localization
                          .of(context)
                          .loginSignInFacebook,
                      leading: Image.asset("assets/icons/facebook.webp"),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 30.0)),
                  Center(
                    child: MaterialFlatButton.primary(
                      context: context,
                      onPressed: intent.showSignUp,
                      text: Localization
                          .of(context)
                          .loginNoAccountCTA,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildAuthenticatingScreen(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: LoadingWidget(),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        Localization
            .of(context)
            .title,
        style: TextStyle(fontFamily: "Google Sans"),
      ),
    );
  }
}
