import 'package:flame/components/joystick/joystick_action.dart';
import 'package:flame/components/joystick/joystick_component.dart';
import 'package:flame/components/joystick/joystick_directional.dart';

import 'package:flame/game/base_game.dart';
import 'package:flame/game/game.dart';
import 'package:flame/gestures.dart';

import 'package:flutter/material.dart';
import 'package:platformsOfEndurance/model/background.dart';
import 'package:platformsOfEndurance/model/player.dart';

class PlatformOfEndurance extends BaseGame
    with HasWidgetsOverlay, MultiTouchDragDetector {
  static const routeName = '/platformsGame';
  Size screenSize;
  Player p1 = Player();
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

  PlatformOfEndurance() {
    joystick.addObserver(p1);

    add(Background());
    add(p1);
    add(joystick);
  }

  void onReceiveDrag(DragEvent drag) {
    joystick.onReceiveDrag(drag);
    super.onReceiveDrag(drag);
  }

  void update(double t) {
    super.update(t);
  }

  void render(Canvas c) {
    super.render(c);
  }

  void resize(Size size) {
    screenSize = size;
    super.resize(size);
  }

 
}
