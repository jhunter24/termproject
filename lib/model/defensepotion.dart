import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class DefensePotion extends SpriteComponent {
  static const SIZE = 16.0;
  static const SPRITE = 'defensePotion.png';

  bool _pickedUp = false;
  int _defGranted = 1;

  DefensePotion(double x, double y)
      : super.fromSprite(SIZE, SIZE, Sprite(SPRITE)) {
    this.x = x;
    this.y = y;
  }

  int usePotion() => _defGranted;

  void pickedUp() {
    _pickedUp = true;
    destroy();
  }

  bool destroy() {
    super.destroy();
    return _pickedUp;
  }

  void render(Canvas c) {
    super.render(c);
  }

  void update(double t) {
    super.update(t);
  }
}
