import 'dart:math';
import 'package:flame/components/animation_component.dart';
import 'package:flutter/material.dart';

class Gold extends AnimationComponent  {
  bool _pickedUp = false;
  var random = Random();
  int count = 1;
  int level = 1;
  double px;// percent of screen on the x axis
  double py;// percent of screen on the y axis
  static const SPRITE_COUNT = 7;
  static const ANIMATION_FILE = 'goldcoinAnimation.png';
  static const COIN_SIZE = 24.0;
  //Gold(this.px,this.py) : super.fromSprite(32, 32, new Sprite('goldCoin.png'));

  /* Gold.multipleCoins(this.count,int level,this.px,this.py) : super.fromSprite(32,32,new Sprite('multiCoin.png')){

      count += (level * random.nextInt(5));

        
  } */

  Gold.multiCoin(double width,double height, String imagePath, int amount,{this.px,this.py,this.count,this.level}) : super.sequenced(width,height,imagePath,amount, textureWidth: 34, textureHeight: 32,stepTime: .25)
  {
    count += (level * random.nextInt(5));
  }
  Gold.sequence(double width,double height,String imagePath,int amount,{this.px,this.py,}): super.sequenced(width,height,imagePath, amount,textureWidth:34,textureHeight:32, stepTime: .25);



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
