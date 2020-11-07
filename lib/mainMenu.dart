import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:platformsOfEndurance/platformOfEndurance.dart';

class MainMenu extends StatefulWidget {
  static final routeName = '/mainMenu';
  Size screenSize;
  MainMenu(Size size) {
    screenSize = size;
  }

  @override
  State<StatefulWidget> createState() {
    return _MainMenuState(this.screenSize);
  }
}

class _MainMenuState extends State<MainMenu> {
  _Controller con;
  Size screenSize;
  _MainMenuState(Size size) {
    screenSize = size;
  }

  @override
  void initState() {
    super.initState();
    con = _Controller(this, screenSize);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: screenSize.width,
          height: screenSize.height,
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
              ),FlatButton(
                onPressed: con.loadLeaderboard,
                child: Text(
                  'Leaderboards',
                  style: TextStyle(
                    fontFamily: 'GreatVibes',
                    fontSize: 24,
                  ),
                ),
              ),FlatButton(
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
  _Controller(this._state, this._size);

  void startGame() {
    runApp(PlatformOfEndurance(_size).widget);
  }

  void loadLeaderboard(){ 
    //TODO LATER ONCE SCORE IS IMPLEMENTED
  }

  void signIn(){
    //TODO LATER
  }
}
