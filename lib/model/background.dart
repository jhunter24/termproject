import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flutter/cupertino.dart';

class Background extends Component with Resizable{
 static final Paint _paint = Paint()..color = Color(0xFFFFFFFF);


 @override
 void render(Canvas c){
   c.drawRect(Rect.fromLTWH(0,0,size.width,size.height),_paint);
 }

  @override
  void update(double t) {
    
  }
  
}