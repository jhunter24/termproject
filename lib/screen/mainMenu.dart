import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:platformsOfEndurance/controller/firebasecontroller.dart';
import 'package:platformsOfEndurance/platformOfEndurance.dart';
import 'package:platformsOfEndurance/screen/leaderboardscreen.dart';
import 'package:platformsOfEndurance/screen/signinScreen.dart';

class MainMenu extends StatefulWidget {
  static final routeName = '/mainMenu';
  Size screenSize;


  @override
  State<StatefulWidget> createState() {
    return _MainMenuState();
  }
}

class _MainMenuState extends State<MainMenu> {
  User user;
  _Controller con;
  Size screenSize;
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
              FlatButton(
                onPressed: con.signIn,
                child: Text(
                  'Sign In',
                  style: TextStyle(
                    fontFamily: 'GreatVibes',
                    fontSize: 24,
                  ),
                ),
              ),
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
  User user;

  _Controller(this._state);

  void startGame() {
    runApp(PlatformOfEndurance(_size).widget);
  }

  void loadLeaderboard() {
    Navigator.pushNamed(_state.context, LeaderboardScreen.routeName);
  }

  void signIn() async {
    try{
    final user =await Navigator.pushNamed(_state.context, SignInScreen.routeName);
   _state.render((){});
   print('user $user');
    }
    catch(e){
      print(e.message ?? e.toString());
    }
  }
}
