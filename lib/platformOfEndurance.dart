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

  var rng = new Random();


  PlatformOfEndurance() {
    joystick.addObserver(p1); // attaches our joystick to our player sprite
    // initialize the gameUI by associating it with the player

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
    //end test code for testing health bar and experience bar
  }

  void onReceiveDrag(DragEvent drag) {
    joystick.onReceiveDrag(drag);
    super.onReceiveDrag(drag);
  }

  void update(double t) {
    super.update(t);
    ui.update(t);
    p1.update(t);
  }

  void render(Canvas c) {
    super.render(c);
    ui.render(c);
  }

  void resize(Size size) {
    this.size = size;
    super.resize(size);
  }
}
