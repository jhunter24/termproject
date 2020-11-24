import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame/components/animation_component.dart';

import 'package:flame/components/joystick/joystick_component.dart';

import 'package:flame/components/joystick/joystick_events.dart';
import 'package:flame/position.dart';

import 'package:flutter/rendering.dart';
import 'package:platformsOfEndurance/model/gold.dart';

class Player extends AnimationComponent implements JoystickListener {
  static const COLLECTION_NAME = 'player';
  static const PLAYER_GOLD = '_gold';
  static const PLAYER_EXPERIENCE = '_experience';
  static const PLAYER_LEVEL = '_level';
  static const PLAYER_SCORE = 'score';
  //final JUMP_HEIGHT = 25;
  static const ANIMATION_FILE = 'playerAnimation.png';
  static const SPRITE_COUNT = 9;
  Player.sequenced(double width, double height, String imagePath, int amount)
      : super.sequenced(width, height, imagePath, amount,
            textureWidth: 32, textureHeight: 32, stepTime: .25) {
    _experienceNeeded = 4000 + (_level * 25);
    _userName = 'Test';
  }
  User user;
  bool _death = false;
  String _userName;
  int _experienceNeeded;
  double _health = 100;
  int _gold = 0;
  double _experience = 0;
  int _level = 1;
  int _score = 0;

  double _speed = 0.5;

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
        this.x += _speed;
        break;
      case JoystickMoveDirectional.MOVE_LEFT:
        this.renderFlipX = true;
        this.x -= _speed;
        break;
      case JoystickMoveDirectional.MOVE_UP:
        this.y -= _speed;
        break;
      case JoystickMoveDirectional.MOVE_DOWN:
        this.y += _speed;
        break;
      case JoystickMoveDirectional.MOVE_UP_RIGHT:
        this.renderFlipX = false;
        this.x += _speed;
        this.y -= _speed;
        break;
      case JoystickMoveDirectional.MOVE_UP_LEFT:
        this.renderFlipX = true;
        this.x -= _speed;
        this.y -= _speed;
        break;
      case JoystickMoveDirectional.MOVE_DOWN_RIGHT:
        this.renderFlipX = false;
        this.x += _speed;
        this.y += _speed;
        break;
      case JoystickMoveDirectional.MOVE_DOWN_LEFT:
        this.renderFlipX = true;
        this.x -= _speed;
        this.y += _speed;
        break;
      case JoystickMoveDirectional.IDLE:
        break;
    }
  }

  void gainExperience(int xp) {
    this._experience += xp;
    if (this._experience >= this._experienceNeeded) {
      levelUp();
    }
  }

  void levelUp() {
    this._level++;
    _experience = 0;
  }

  void pickUp(Gold _gold) {
    this._gold += _gold.count;
    this._score += (_gold.count * 5);
  }

  void takeDamage() {
    _health -= 5;// / 100;

    if (_health == 0) {
      _death = true;
      destroy();
    }
  }

  int getScore() => _score;
  double getHealth() => _health;
  double getExperience() => _experience;
  int getGold() => _gold;
  int getLevel() => _level;
  String getUserName() => _userName;
  bool death() => _death;

  @override
  void joystickAction(JoystickActionEvent event) {}

  @override
  void joystickChangeDirectional(JoystickDirectionalEvent event) {
    _moveDirectional = event
        .directional; //take the direction of the joystick and give to our direction variable
  }

  bool destroy() {
    super.destroy();
    return _death;
  }

  Position getPostion() {
    return this.toPosition();
  }
}
