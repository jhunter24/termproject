import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:platformsOfEndurance/model/leaderboard.dart';

class LeaderboardScreen extends StatefulWidget {
  static const routeName = '/leaderboard';
  static const COLLECTION_NAME = 'leaderboard';
  @override
  State<StatefulWidget> createState() {
    return _LeaderboardState();
  }
}

class _LeaderboardState extends State<LeaderboardScreen> {
  List<Leaderboard> leaderboard;
  _Controller con;
  User user;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;

    leaderboard ??= args['leaderboard'];
    user ??= args['user'];

    return Container(
      decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.fill, image: AssetImage('assets/images/leaderboardbg.jpg'))),
      padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: leaderboard.length == 0
            ? Text('Leaderboard is currently empty')
            : 
              
            ListView.builder(
                itemCount: leaderboard.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    child: Row(
                      children: [
                        SizedBox(width:160,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text((index + 1).toString())],
                        ),
                        SizedBox(
                          width: 100,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text(leaderboard[index].user ?? 'n/a')],
                        ),
                        SizedBox(
                          width: 100,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text(leaderboard[index].score.toString())],
                        )
                      ],
                    ),
                  );
                },
              ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.transparent,
          tooltip: 'Back',
          onPressed: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back),
        ),
      ),
    );
  }



  
}

class _Controller {
  // ignore: unused_field
  _LeaderboardState _state;
  _Controller(this._state);
}
