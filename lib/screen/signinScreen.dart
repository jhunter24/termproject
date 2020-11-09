import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:platformsOfEndurance/controller/firebasecontroller.dart';

class SignInScreen extends StatefulWidget {
  static const routeName = '/signin';

  @override
  State<StatefulWidget> createState() {
    return _SignInState();
  }
}

class _SignInState extends State<SignInScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  _Controller con;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/mainmenubg.jpg'),
            ),
          ),
          child: Center(
            child: Form(
              key: formKey,
              child: Container(
                padding: EdgeInsets.fromLTRB(160, 75, 160, 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Sign In',
                      style: TextStyle(fontSize: 24),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Email',
                      ),
                      onSaved: con.emailSaved,
                      validator: con.emailValidator,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Password'),
                      onSaved: con.savePassword,
                      validator: con.passwordValidator,
                      obscureText: true,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RaisedButton(
                          onPressed: con.goBack,
                          child: Text('Back'),
                        ),
                        RaisedButton(
                          onPressed: con.signIn,
                          child: Text('Sign In'),
                        ),
                        RaisedButton(
                          onPressed: con.signUp,
                          child: Text('Sign Up'),
                        )
                      ],
                    )
                    /*  Trying to figure out google API error 10
                   SignInButton(
                      Buttons.Google,
                      onPressed: con.googleSignIn,
                    ), */
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

class _Controller {
  String email, password;
  _SignInState _state;
  _Controller(this._state);

  void goBack() {
    Navigator.pop(_state.context);
  }

  /* void googleSignIn() async {
    User user = await FirebaseController.googleSignIn();
    Navigator.pop(_state.context, user);
  } */

  void signIn() async {
    if (!_state.formKey.currentState.validate()) return;

    _state.formKey.currentState.save();
    User user;

    try {
      user = await FirebaseController.signIn(email: email, password: password);
      Navigator.pop(_state.context, user);
    } catch (e) {
      print(e.message() ?? e.toString());
    }
  }

  void emailSaved(String value) {
    email = value;
  }

  String emailValidator(String value) {
    if (!(value.trim().contains('@') && value.trim().contains('.')))
      return 'invalid email';
    else
      return null;
  }

  void savePassword(String value) {
    password = value;
  }

  String passwordValidator(String value) {
    if (value.toLowerCase().trim().length < 4)
      return 'Min length of pasword of 4';
    return null;
  }

  void signUp() async {
    if (!_state.formKey.currentState.validate()) return;

    _state.formKey.currentState.save();
    try {
      await FirebaseController.signUp(email, password);

    } catch (e) {
      print(e.message ?? e.toString());
    }
  }
}
