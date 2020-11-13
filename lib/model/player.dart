import 'package:flame/components/component.dart';
import 'package:flame/components/joystick/joystick_component.dart';

import 'package:flame/components/joystick/joystick_events.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/rendering.dart';

class Player extends SpriteComponent implements JoystickListener {
  Player() : super.fromSprite(64.0, 64.0, new Sprite('mainGuy.png'));
  final JUMP_HEIGHT = 25;

  double currentSpeed = 0;
  double speed = 5;
  JoystickMoveDirectional _moveDirectional = JoystickMoveDirectional.IDLE;

  @override
  void resize(Size size) {
    this.x = (size.width - this.width) / 2;
    this.y = (size.height - this.height) / 2;
  }

  void render(Canvas c) {
    super.render(c);
  }

  void update(double t) {
    super.update(t);

    // Takes the direction and then moves player sprite appropriately
    switch (_moveDirectional) {
      case JoystickMoveDirectional.MOVE_RIGHT:
        this.renderFlipX = false;
        this.x += (currentSpeed + speed);
        break;
      case JoystickMoveDirectional.MOVE_LEFT:
        this.renderFlipX = true;
        this.x -= (currentSpeed + speed);
        break;
      case JoystickMoveDirectional.MOVE_UP:
        this.y -= (currentSpeed + speed);
        break;
      case JoystickMoveDirectional.MOVE_DOWN:
        this.y += (currentSpeed + speed);
        break;
      case JoystickMoveDirectional.MOVE_UP_RIGHT:
        this.x += (currentSpeed + speed);
        this.y -= (currentSpeed + speed);
        break;
      case JoystickMoveDirectional.MOVE_UP_LEFT:
        this.x -= (currentSpeed + speed);
        this.y -= (currentSpeed + speed);
        break;
      case JoystickMoveDirectional.MOVE_DOWN_RIGHT:
        this.x += (currentSpeed + speed);
        this.y += (currentSpeed + speed);
        break;
      case JoystickMoveDirectional.MOVE_DOWN_LEFT:
        this.x -= (currentSpeed + speed);
        this.y += (currentSpeed + speed);
        break;
      case JoystickMoveDirectional.IDLE:
        break;
    }
  }

  @override
  void joystickAction(JoystickActionEvent event) {}

  @override
  void joystickChangeDirectional(JoystickDirectionalEvent event) {
    _moveDirectional = event
        .directional; //take the direction of the joystick and give to our direction variable
  }
}
