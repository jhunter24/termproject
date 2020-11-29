import 'package:flame/components/component.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class Bullet extends SpriteComponent {
  static const String SPRITE = 'bullet.png';
  static const SIZE = 8.0;
  int _damage;
  double _speed = 1;
  bool _moveLeft = false;
  bool _hit = false;
  double w,h;


  Bullet(this._moveLeft, pDmg, Position spawnPoint)
      : super.fromSprite(SIZE, SIZE, Sprite(SPRITE)) {
    this.x = spawnPoint.x;
    this.y = spawnPoint.y;
    _damage = 5 + (pDmg);
  }

  void moveRight() {
    this.renderFlipY = _moveLeft;
    this.x += _speed;
  }

  void moveLeft() {
    this.renderFlipY = _moveLeft;
    this.x -= _speed;
  }

  void resize(Size size){
    w = size.width;
    
  }


  void update(double t) {
    if (_moveLeft) {
      this.renderFlipX = _moveLeft;
      moveLeft();
    } else {
      this.renderFlipX = _moveLeft;
      moveRight();
    }

    if(this.x == w)
      hit();
    super.update(t);
  }

  void render(Canvas c) {
    super.render(c);
  }

  int getDamage() => _damage;

  void hit() {
    _hit = true;
    destroy();
  }

  bool destroy() {
    super.destroy();

    return _hit;
  }
}
