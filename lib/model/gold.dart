import 'dart:math';
import 'package:flame/components/animation_component.dart';
import 'package:flame/position.dart';
import 'package:flutter/material.dart';

class Gold extends AnimationComponent {
  bool _pickedUp = false;
  var random = Random();
  int count = 1;
  int level = 1;
  double w,h;
  Position position = Position(0,0);
  static const SPRITE_COUNT = 7;
  static const ANIMATION_FILE = 'goldcoinAnimation.png';
  static const COIN_SIZE = 24.0;
  //Gold(this.px,this.py) : super.fromSprite(32, 32, new Sprite('goldCoin.png'));

  /* Gold.multipleCoins(this.count,int level,this.px,this.py) : super.fromSprite(32,32,new Sprite('multiCoin.png')){

      count += (level * random.nextInt(5));

        
  } */

  Gold.multiCoin(
    this.level, {
    this.w,
    this.h,
    this.count,
    this.position,
  }) : super.sequenced(
            Gold.COIN_SIZE, Gold.COIN_SIZE, ANIMATION_FILE, SPRITE_COUNT,
            textureWidth: 34, textureHeight: 32, stepTime: .25) {
    if (position != null) {
      this.x = position.x;
      this.y = position.y;
      
    }else{
      this.x = w;
      this.y = h;
    }

    this.count = 1;
    
    
    this.count += (this.level * random.nextInt(5));
    
  }
  Gold.sequence({
    this.w,
    this.h,
  }) : super.sequenced(
            Gold.COIN_SIZE, Gold.COIN_SIZE, ANIMATION_FILE, SPRITE_COUNT,
            textureWidth: 34, textureHeight: 32, stepTime: .25){
              this.x = w;
              this.y = h;
            }

  @override
  void resize(Size size) {
    
  }

  void render(Canvas c) {
    super.render(c);
  }

  @override
  bool destroy() {
    super.destroy();
    return _pickedUp;
  }

  void pickUp() {
    _pickedUp = true;
    destroy();
  }

  void update(t) {
    super.update(t);
  }
}
