import 'dart:ui';

import 'package:flame/position.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:platformsOfEndurance/model/player.dart';

class UserInfoDisplay {
  Player _observer;
  double width;
  double height;
  Paint paint, paintBG, healthPaint, experiencePaint;
  Position position;
  Rect backgroundRect;
  Rect healthBarBG;
  Rect experienceBar;
  Offset offset;
  TextPainter tp;
  TextSpan ts, userTS;

  UserInfoDisplay(this.width, this.height, this._observer)  {
    paint = Paint();
    paintBG = Paint();
    healthPaint = Paint();
    experiencePaint = Paint();
    experiencePaint.color = Colors.lightBlue[400];
    paint.color = Colors.tealAccent;
    paintBG.color = Colors.red;
    healthPaint.color = Colors.green;
    position = Position.fromInts(0, 0);
    offset = Offset(width / 2, height / 2);
    userTS = TextSpan(text: _observer.getUserName());

    backgroundRect =
        Rect.fromCenter(height: height, width: width, center: offset);
    healthBarBG =
        Rect.fromLTRB(5, (height - 36), (_observer.getHealth() + 2), (height - 24));
  }

  void render(Canvas c) {
    c.translate(this.position.x, this.position.y);
    c.drawRect(backgroundRect, paint);
    //eperience bar
    c.drawRect(
      Rect.fromLTRB(
          5,
          (height - 15),
          102,
          (height - 5)),
      paintBG,
    ); // xp background

    
    c.drawRect(
      Rect.fromLTRB(
          6,
          (height - 14),
          ((_observer.getExperience() / (40 + ((_observer.getLevel() * 25) / 100))) + 6),
          (height - 6)),
      experiencePaint,
    ); //xp bar
    //end xp bar

    // dispaly experience on the experience bar
    ts = TextSpan(text: 'Experience', style: TextStyle(fontSize: 10));
    tp = TextPainter(text: ts, textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(c, Offset(15, height - 15));


    // health bar
    c.drawRect(healthBarBG, paintBG); // health bar background
    c.drawRect(
        Rect.fromLTRB(6, (height - 35), (_observer.getHealth() + 1), (height - 25)),
        healthPaint); // health bar foreground

    // display health on the healt bar
    ts = TextSpan(text: 'Health', style: TextStyle(fontSize: 10));
    tp.text = ts;
    tp.layout();
    tp.paint(c, Offset(15,  height - 35));
    // end health bar

    //draw user name
    tp.text = userTS;
    tp.layout();
    tp.paint(c, Offset(5.0, 5.0));
  }

  

  void update(double t) {
    _observer.update(t);


  }
}
