import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:platformsOfEndurance/controller/firebasecontroller.dart';
import 'package:platformsOfEndurance/view/message_dialog.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings';

  @override
  State<StatefulWidget> createState() {
    return _SettingsState();
  }
}

class _SettingsState extends State<SettingsScreen> {
  _Controller con;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  User user;
  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  @override
  Widget build(BuildContext context) {
    user ??= ModalRoute.of(context).settings.arguments;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/mainmenubg.jpg'),
            ),
          ),
          child: Center(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Account Settings',
                    style: TextStyle(fontFamily: 'GreatVibes', fontSize: 42),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(160, 50, 160, 0),
                    child: Column(children: [
                      TextFormField(
                        autocorrect: false,
                        decoration:
                            InputDecoration(hintText: 'Change Username'),
                        onSaved: con.saveUsername,
                        validator: con.validateUsername,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            hintText: 'enter new password or leave blank'),
                        autocorrect: false,
                        obscureText: true,
                        onSaved: con.savePassword,
                        validator: con.validatePassword,
                      )
                    ]),
                  ),
                  RaisedButton(
                    onPressed: con.submit,
                    child: Text('Submit Changes'),
                  )
                ],
              ),
            ),
          ),
        ),
        FlatButton(
          child: Text('Return'),
          onPressed: con.back,
        )
      ]),
    );
  }
}

class _Controller {
  _SettingsState _state;
  _Controller(this._state);
  String username = '';
  String password = '';

  void submit() async {
    try {
      if (!_state.formKey.currentState.validate()) return;
      _state.formKey.currentState.save();

      if (password.length == 0) {
       
            await FirebaseController.updateUsername(_state.user, username);
      } else if ( username.trim().length == 0) {
        await FirebaseController.updatePassword(
            password: password, user: _state.user);
      } else {
        await FirebaseController.updatePassword(
            password: password, user: _state.user);
        
            await FirebaseController.updateUsername(_state.user, username);
      }

      MessageDialog.errorMessage(
          context: _state.context,
          title: 'Success',
          content: 'The profile update was successful');
    } catch (e) {
      MessageDialog.errorMessage(
          context: _state.context,
          title: 'Profile Update Error',
          content: e.message ?? e.toString());
    }
  }

  void back() => Navigator.pop(_state.context, _state.user);

  void saveUsername(String value) {
    username = value;
  }

  String validateUsername(String value) {
    if (value.trim().length < 4 && value.trim().length != 0)
      return 'usernames should be 4 chars minimum';
    else
      return null;
  }

  void savePassword(String value) {
    password = value;
  }

  String validatePassword(String value) {
    if (value.trim().length < 6 && value.trim().length != 0)
      return 'minimum of 6 chars for a new password';
    else
      return null;
  }
}
