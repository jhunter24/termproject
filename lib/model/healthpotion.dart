import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class HealthPotion extends SpriteComponent {
  static const SIZE = 16.0;
  static const SPRITE = 'healthpotion.png';
  int _hpRestore = 100;
  bool _pickedUp = false;

  HealthPotion(double x, double y,int pLevel)
      : super.fromSprite(SIZE, SIZE, Sprite(SPRITE)) {
    this.x = x;
    this.y = y;
    _hpRestore = 100 + (pLevel * 10 );
  }


  int use(){
    return _hpRestore;
  }

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

  void resize(Size size) {
    super.resize(size);
  }

  void update(double t) {
    super.update(t);
  }
}
