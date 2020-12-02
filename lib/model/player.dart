import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame/components/animation_component.dart';

import 'package:flame/components/joystick/joystick_component.dart';

import 'package:flame/components/joystick/joystick_events.dart';
import 'package:flame/position.dart';

import 'package:flutter/rendering.dart';
import 'package:platformsOfEndurance/model/defensepotion.dart';
import 'package:platformsOfEndurance/model/experiencePotion.dart';
import 'package:platformsOfEndurance/model/gold.dart';
import 'package:platformsOfEndurance/model/healthpotion.dart';

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
  double _maxHealth = 100;
  int _defense = 5;
  int _gold = 0;
  int _experience = 0;
  int _level = 1;
  int _score = 0;
  int _damage = 5;
  double _speed = 0.5;
  final List<HealthPotion> _healthPotionList = [];
  final List<DefensePotion> _defPotionList = [];
  final List<ExperiencePotion> _xpPotionList = [];
  JoystickMoveDirectional _moveDirectional = JoystickMoveDirectional.IDLE;

  double h, w;
  @override
  void resize(Size size) {
    this.x = (size.width - this.width) / 2;
    this.y = (size.height - this.height) / 2;
    w = size.width;
    h = size.height;
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

    if (this.x <= 0) this.x = this.w;
    if (this.x >= w) this.x = 0.0;
    if (this.y <= 0) this.y = this.h;
    if (this.y >= h) this.y = 0.0;
  }

  //player upgrade functions
  int _hpUpgradeCount = 0;
  int _hpUpgradeCost = 50;
  int _hpUpgradeLevel = 1;
  int hpUpgradeCost() => _hpUpgradeCost;
  int hpUpgradeLevel() => _hpUpgradeLevel;

  int _defenseUpgradeCount = 0;
  int _defenseUpgradeCost = 50;
  int _defenseUpgradeLevel = 1;
  int defUpgradeCost() => _defenseUpgradeCost;
  int defUpgradeLevel() => _defenseUpgradeLevel;

  void upgradeHealth() {
    if (this._gold >= this._hpUpgradeCost) {
      this._gold -= this._hpUpgradeCost;
      this._hpUpgradeCount++;
      this._hpUpgradeLevel += 2;
      this._hpUpgradeCost += (25 * this._hpUpgradeCount);
    } else
      return;
  }

  void upgradeDefense() {
    if (this._gold >= this._defenseUpgradeCost) {
      this._gold -= this._defenseUpgradeCost;
      this._defenseUpgradeCount++;
      this._defenseUpgradeCost += (25 * this._defenseUpgradeCount);
      this._defenseUpgradeLevel += 2;
    }
  }

  //util functions
  void gainScore(int eLevel) {
    _score += (5 * eLevel);
  }

  void pickUpHealthPotion(HealthPotion potion) {
    _healthPotionList.add(potion);
    _score++;
  }

  void pickUpExperiencePotion(ExperiencePotion potion) {
    _xpPotionList.add(potion);
    _score++;
  }

  void pickUpDefensePotion(DefensePotion potion) {
    _defPotionList.add(potion);
    _score++;
  }

  void useXpPotion() {
    ExperiencePotion potion = _xpPotionList.removeLast();
    _experience += potion.usePotion();

    if (_experience >= _experienceNeeded) levelUp();
  }

  void useHealthPotion() {
    HealthPotion potion = _healthPotionList.removeLast();
    _health += potion.use();

    if (_health >= _maxHealth) _health = _maxHealth;
  }

  void useDefensePotion() {
    DefensePotion potion = _defPotionList.removeLast();
    _defense += potion.usePotion();
  }

  void gainExperience(int enemyLevel) {
    this._experience += 100 + (enemyLevel * 100);
    if (this._experience >= this._experienceNeeded) {
      levelUp();
    }
  }

  void levelUp() {
    this._level++;
    if (_experience > _experienceNeeded) {
      int temp = _experience - _experienceNeeded;
      _experience = temp;
    }
    _experience = 0;
    _health = _maxHealth;
  }

  void pickUp(Gold _gold) {
    this._gold += _gold.count;
    this._score += (_gold.count * 5);
  }

  void takeDamage() {
    _health -= 1 / _defense;

    if (_health <= 0) {
      _death = true;
      destroy();
    }
  }

  //getter functions
  int getScore() => _score;
  double getHealth() => _health;
  int getExperience() => _experience;
  int getGold() => _gold;
  int getLevel() => _level;
  String getUserName() => _userName;
  bool death() => _death;
  int getDamage() => _damage;
  int getXpNeeded() => _experienceNeeded;
  int getHPlistCount() => _healthPotionList.length;
  int getDefListCount() => _defPotionList.length;
  int getXPlistCount() => _xpPotionList.length;
  Position getPostion() => this.toPosition();

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
}
