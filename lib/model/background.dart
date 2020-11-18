import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';

class Background extends Component with Resizable{
 
  var image = Sprite('background.png');

 @override
 void render(Canvas c){
   image.renderRect(c, Rect.fromLTWH(0,0,size.width,size.height));
   
 }

  @override
  void update(double t) {
    
  }
  
}