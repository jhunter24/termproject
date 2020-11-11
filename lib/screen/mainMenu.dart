import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:platformsOfEndurance/controller/firebasecontroller.dart';
import 'package:platformsOfEndurance/model/leaderboard.dart';

import 'package:platformsOfEndurance/platformOfEndurance.dart';
import 'package:platformsOfEndurance/screen/leaderboardscreen.dart';
import 'package:platformsOfEndurance/screen/settingScreen.dart';
import 'package:platformsOfEndurance/screen/signinScreen.dart';
import 'package:platformsOfEndurance/view/message_dialog.dart';

class MainMenu extends StatefulWidget {
  static final routeName = '/mainMenu';

  @override
  State<StatefulWidget> createState() {
    return _MainMenuState();
  }
}

class _MainMenuState extends State<MainMenu> {
  User user;
  _Controller con;
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  render(fn) => setState(fn);

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/mainmenubg.jpg'),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Platforms Of Endurance',
                style: TextStyle(fontFamily: 'GreatVibes', fontSize: 32),
              ),
              FlatButton(
                onPressed: con.startGame,
                child: Text(
                  'Start Game!',
                  style: TextStyle(
                    fontFamily: 'GreatVibes',
                    fontSize: 24,
                  ),
                ),
              ),
              FlatButton(
                onPressed: con.loadLeaderboard,
                child: Text(
                  'Leaderboards',
                  style: TextStyle(
                    fontFamily: 'GreatVibes',
                    fontSize: 24,
                  ),
                ),
              ),
              user == null
                  ? FlatButton(
                      onPressed: con.signIn,
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          fontFamily: 'GreatVibes',
                          fontSize: 24,
                        ),
                      ),
                    )
                  : FlatButton(
                      child: Text(
                        'Settings',
                        style: TextStyle(
                          fontFamily: 'GreatVibes',
                          fontSize: 24,
                        ),
                      ),
                      onPressed: con.settings,
                    ),
              user == null
                  ? SizedBox(
                      height: 10,
                    )
                  : Card(
                      color: Colors.transparent,
                      child: Column(
                        children: [
                          user.photoURL != null
                              ? Image.network(user.photoURL)
                              : SizedBox(
                                  height: 1,
                                ),
                          Text('Welcome! ${user.displayName}'),
                          FlatButton(
                            child: Text('Sign Out'),
                            onPressed: con.signOut,
                          )
                        ],
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _MainMenuState _state;
  Size _size;

  _Controller(this._state);

  void startGame() {
    runApp(PlatformOfEndurance(_size).widget);
  }

  void loadLeaderboard() async {
    try {
      List<Leaderboard> leaderboardList =
          await FirebaseController.getLeaderboard();
      Navigator.pushNamed(_state.context, LeaderboardScreen.routeName,
          arguments: {'user': _state.user, 'leaderboard': leaderboardList});
    } catch (e) {
      MessageDialog.errorMessage(
          context: _state.context,
          title: 'Error in Leaderboard fetch',
          content: e.message ?? e.toString());
    }
  }

  void signIn() async {
    try {
      var user =
          await Navigator.pushNamed(_state.context, SignInScreen.routeName);

      if (user != null) {
        _state.render(
          () {
            _state.user = user;
          },
        );
      }
      print('user $_state.user');
    } catch (e) {
      print(e.message ?? e.toString());
    }
  }

  void settings() async {
    try {
      var user = await Navigator.pushNamed(
          _state.context, SettingsScreen.routeName,
          arguments: _state.user);
      if (_state.user != user) print(user);
      _state.render(() {
        _state.user = user;
      });
    } catch (e) {
      MessageDialog.errorMessage(
          context: _state.context,
          title: 'Navigation Error',
          content: e.message ?? e.toString());
    }
  }

  void signOut() async {
    try {
      await FirebaseController.signOut(_state.user);
      _state.render(() {
        _state.user = null;
      });
    } catch (e) {
      MessageDialog.errorMessage(
          context: _state.context,
          title: 'Sign Out Error',
          content: e.message ?? e.toString());
    }
  }
}
