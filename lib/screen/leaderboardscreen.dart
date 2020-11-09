import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LeaderboardScreen extends StatefulWidget {
  static const routeName = '/leaderboard';

  @override
  State<StatefulWidget> createState() {
    return _LeaderboardState();
  }
}

class _LeaderboardState extends State<LeaderboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/mainmenubg.jpg'),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ' Scoring Leaderboard ',
                    style: TextStyle(fontFamily: 'GreatVibes', fontSize: 42),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _LeaderboardState _state;
  _Controller(this._state);
}
