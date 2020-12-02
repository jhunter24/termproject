import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:platformsOfEndurance/model/player.dart';

class ExperiencePotion extends SpriteComponent {
  static const SIZE = 16.0;
  static const SPRITE = 'xpPotion.png';
  bool _pickedUp = false;
  int _xpGranted = 0;

  ExperiencePotion(double x, double y, Player p)
      : super.fromSprite(SIZE, SIZE, Sprite(SPRITE)) {
    this.x = x - 10;
    this.y = y - 10;
    _xpGranted = p.getXpNeeded();
  }

  int usePotion() => _xpGranted;

  void pickedUp() {
    _pickedUp = true;
    destroy();
  }

  bool destroy() {
    return _pickedUp;
  }

  void render(Canvas c) {
    super.render(c);
  }

  void update(double t) {
    super.update(t);
  }
}
