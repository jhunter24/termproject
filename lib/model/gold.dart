import 'dart:math';

import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class Gold extends SpriteComponent {
  bool _pickedUp = false;
  var random = Random();
  int count = 1;
  double px;// percent of screen on the x axis
  double py;// percent of screen on the y axis

  Gold(this.px,this.py) : super.fromSprite(32, 32, new Sprite('goldCoin.png'));

  Gold.multipleCoins(this.count,int level,this.px,this.py) : super.fromSprite(32,32,new Sprite('multiCoin.png')){

      count += (level * random.nextInt(5));

        
  }



  @override
  void resize(Size size) {
    this.x = size.width / px;
    this.y = size.height / py;
  }



  void render(Canvas c) {
    super.render(c);
  }

  @override
  bool destroy(){
    super.destroy();
    return _pickedUp;
  }
   
   void pickUp(){
     _pickedUp = true;
     destroy();
   }

  void update(t) {
    super.update(t);
  }
}
