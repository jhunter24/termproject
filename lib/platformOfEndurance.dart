import 'dart:math';

import 'package:flame/components/joystick/joystick_component.dart';
import 'package:flame/components/joystick/joystick_directional.dart';
import 'package:flame/game/base_game.dart';
import 'package:flame/game/game.dart';
import 'package:flame/gestures.dart';

import 'package:flutter/material.dart';
import 'package:platformsOfEndurance/game/gameUI.dart';
import 'package:platformsOfEndurance/model/background.dart';

import 'package:platformsOfEndurance/model/player.dart';

import 'model/gold.dart';

class PlatformOfEndurance extends BaseGame
    with HasWidgetsOverlay, MultiTouchDragDetector {
  static const routeName = '/platformsGame';
  //Size screenSize;
  Player p1 = Player();
  UserInfoDisplay ui;
  var joystick = JoystickComponent(
    componentPriority: 0,
    directional: JoystickDirectional(
      isFixed: true,
      size: 125,
      color: Colors.grey[100],
      opacityBackground: 0.0,
      opacityKnob: 1,
      margin: const EdgeInsets.only(left: 100, bottom: 100),
    ),
  );

  final List<Gold> goldList = [
    Gold(1.2, 2), // adds a single gold to the goldList
    Gold.multipleCoins(5, 1, 1.2, 4), // multiple coins added based of count(5) + count * level
    
  ];

  var rng = new Random();
  Gold gold = Gold(1.2, 2);

  PlatformOfEndurance() {
    joystick.addObserver(p1); // attaches our joystick to our player sprite
    // initialize the gameUI by associating it with the player

    goldList.forEach((element) {
      this.add(element);
    });

    add(Background()); // adds background to screen render
    add(p1); // adds player to screen

    

    add(joystick); // adds the visual joystick

    //adding UI elements to render
    ui = UserInfoDisplay(150, 60, p1);
    //test code for testing health bar and experience bar

    addWidgetOverlay(
      'button',
      Positioned(
        top: 100,
        left: 300,
        child: RaisedButton(
          onPressed: () {
            p1.health -= 5;
            if (p1.health == 0) p1.health = 100;
          },
          child: Text('damage player'),
        ),
      ),
    );
    addWidgetOverlay(
      'experience',
      Positioned(
        top: 50,
        left: 275,
        child: RaisedButton(
          onPressed: () {
            p1.gainExperience(rng.nextInt(1000));
            print(p1.level.toString());
          },
          child: Text('give random experience'),
        ),
      ),
    );
    addWidgetOverlay(
      'gold',
      Positioned(
        top: 150,
        left: 300,
        child: RaisedButton(
          onPressed: () {
            p1.gold++;
            print(p1.gold.toString());
          },
          child: Text('gold'),
        ),
      ),
    );
    //end test code for testing health bar and experience bar
  }

  void onReceiveDrag(DragEvent drag) {
    joystick.onReceiveDrag(drag);
    super.onReceiveDrag(drag);
  }

  void showScore() {
    addWidgetOverlay(
      'score',
      Positioned(
        top: 1,
        right: 25,
        child: Row(
          children: [
            Material(
              child: Text(
                'Score: ${p1.score}',
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Material(
              child: Text(
                'Gold: ${p1.gold}',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handleCollisions() {
    List<Gold> remove = [];
    for (Gold e in goldList) {
      if (e != null &&
          p1.toRect().intersect(e.toRect()).width > 0 &&
          p1.toRect().intersect(e.toRect()).height > 0) {
        print(goldList.length);
        p1.pickUp(e);
        e.pickUp();
        
        remove.add(e);
      }
    }
    for (var e in remove) {
      goldList.remove(e);
      print(goldList.length);
    }
  }

  void update(double t) {
    super.update(t);
    ui.update(t);
    p1.update(t);
    showScore();
    handleCollisions();
   
  }

  void render(Canvas c) {
    super.render(c);
    ui.render(c);
    for(Gold e in goldList){
      e.render(c);
    }
    /* goldList.forEach((element) {
      element.render(c);
    }); */
  }

  void resize(Size size) {
    this.size = size;
    super.resize(size);
  }
}
