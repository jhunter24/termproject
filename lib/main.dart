import 'package:flame/util.dart';
import 'package:flutter/material.dart';
import 'package:platformsOfEndurance/platformOfEndurance.dart';
import 'package:platformsOfEndurance/screen/endGame.dart';
import 'package:platformsOfEndurance/screen/leaderboardscreen.dart';
import 'package:platformsOfEndurance/screen/mainMenu.dart';
import 'package:platformsOfEndurance/screen/settingScreen.dart';
import 'package:platformsOfEndurance/screen/signinScreen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Util flameUtil = Util();

  await Firebase.initializeApp();
  runApp(GameInitializer());

  flameUtil.fullScreen();
  flameUtil.setLandscape();
}

class GameInitializer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: MainMenu.routeName,
      routes: {
        MainMenu.routeName: (context) => MainMenu(),
        SignInScreen.routeName: (context) => SignInScreen(),
        LeaderboardScreen.routeName: (context) => LeaderboardScreen(),
        SettingsScreen.routeName: (context) => SettingsScreen(),
        PlatformOfEndurance.routeName: (context) => PlatformOfEndurance(context).widget,
        EndGame.routeName: (context) => EndGame(),
      },
    );
  }
}
