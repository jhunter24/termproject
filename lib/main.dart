import 'package:flame/util.dart';
import 'package:flutter/material.dart';
import 'package:platformsOfEndurance/mainMenu.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Util flameUtil = Util();
  final size = await flameUtil.initialDimensions();

  

  runApp(GameInitializer(size));

  flameUtil.fullScreen();
  flameUtil.setLandscape();
}

class GameInitializer extends StatelessWidget {
  Size size;

  GameInitializer(Size size){
    this.size = size;
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: MainMenu.routeName,
      routes: {
        MainMenu.routeName: (context) => MainMenu(size),
      },
    );
  }
}
