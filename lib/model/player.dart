import 'package:flame/components/component.dart';
import 'package:flame/components/joystick/joystick_component.dart';

import 'package:flame/components/joystick/joystick_events.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/rendering.dart';
import 'package:platformsOfEndurance/model/gold.dart';


class Player extends SpriteComponent implements JoystickListener {
  static const COLLECTION_NAME = 'player';
  static const PLAYER_GOLD = 'gold';
  static const PLAYER_EXPERIENCE = 'experience';
  static const PLAYER_LEVEL = 'level';
  static const PLAYER_SCORE = 'score';
  //final JUMP_HEIGHT = 25;

  Player() : super.fromSprite(64.0, 64.0, new Sprite('mainGuy.png')) {
    experienceNeeded = 4000 + (level * 25);
    userName = 'Test';
  }
  
  String userName;
  int experienceNeeded;
  double health = 100;
  int gold = 0;
  double experience = 0;
  int level = 1;
  int score = 0;
  double currentSpeed = 0;
  double speed = 0.5;

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
        this.x += speed;
        break;
      case JoystickMoveDirectional.MOVE_LEFT:
        this.renderFlipX = true;
        this.x -= speed;
        break;
      case JoystickMoveDirectional.MOVE_UP:
        this.y -= speed;
        break;
      case JoystickMoveDirectional.MOVE_DOWN:
        this.y += speed;
        break;
      case JoystickMoveDirectional.MOVE_UP_RIGHT:
        this.x += speed;
        this.y -= speed;
        break;
      case JoystickMoveDirectional.MOVE_UP_LEFT:
        this.x -= speed;
        this.y -= speed;
        break;
      case JoystickMoveDirectional.MOVE_DOWN_RIGHT:
        this.x += speed;
        this.y += speed;
        break;
      case JoystickMoveDirectional.MOVE_DOWN_LEFT:
        this.x -= speed;
        this.y += speed;
        break;
      case JoystickMoveDirectional.IDLE:
        break;
    }
  }

  void gainExperience(int xp){
    this.experience += xp;
    if(this.experience >= this.experienceNeeded){
      levelUp();
    }
  }

  void levelUp(){
    this.level++;
    experience = 0;
  }

  void pickUp(Gold gold){
    
      this.gold += gold.count;
      this.score += (gold.count * 5);
  }

  @override
  void joystickAction(JoystickActionEvent event) {}

  @override
  void joystickChangeDirectional(JoystickDirectionalEvent event) {
    _moveDirectional = event
        .directional; //take the direction of the joystick and give to our direction variable
  }
}
