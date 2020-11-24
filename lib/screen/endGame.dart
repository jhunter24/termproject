import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:platformsOfEndurance/controller/firebasecontroller.dart';
import 'package:platformsOfEndurance/model/player.dart';
import 'package:platformsOfEndurance/platformOfEndurance.dart';
import 'package:platformsOfEndurance/screen/mainMenu.dart';
import 'package:platformsOfEndurance/view/message_dialog.dart';

class EndGame extends StatefulWidget {
  static const routeName = 'endgame';

  @override
  State<StatefulWidget> createState() {
    return _EndGameState();
  }
}

class _EndGameState extends State<EndGame> {
  @override
  _Controller con;

  void initState() {
    super.initState();
    con = _Controller(this);
  }

  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  Player player;

  Widget build(BuildContext context) {
    player ??= ModalRoute.of(context).settings.arguments;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/mainmenubg.jpg'),
                fit: BoxFit.fill)),
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(160, 0, 160, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  autocorrect: false,
                  decoration: InputDecoration(hintText: 'User Name'),
                  onSaved: con.saveUsername,
                ),
                RaisedButton(
                  onPressed: con.submit,
                  child: Text('Submit'),
                ),
                RaisedButton(
                  onPressed: con.mainMenu,
                  child: Text('Main Menu'),
                ),
                RaisedButton(
                  onPressed: con.playAgain,
                  child: Text('Play Again'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _EndGameState _state;
  _Controller(this._state);
  String userName;
  int score;
  String createdBy;

  void saveUsername(String value) {
    userName = value;
  }

  void submit() async {
    try {
      await FirebaseController.uploadScore(
        score: _state.player.getScore(),
        userName: userName,
      );
      MessageDialog.errorMessage(
          context: _state.context,
          title: 'Successful Submit',
          content:
              'Leaderboard successfully submited. Hit main menu to return the main menu or play again to restart a new run.');
    } catch (e) {
      MessageDialog.errorMessage(
          context: _state.context,
          content: e.message ?? e.toString(),
          title: 'Submit error');
    }
  }

  void playAgain() {
    if (_state.player.user != null)
      Navigator.pushReplacementNamed(
          _state.context, PlatformOfEndurance.routeName,
          arguments: _state.player.user);
    else
      Navigator.pushReplacementNamed(
          _state.context, PlatformOfEndurance.routeName);
  }

  void mainMenu() {
    Navigator.pushReplacementNamed(_state.context, MainMenu.routeName);
  }
}
