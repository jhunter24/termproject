import 'package:flame/components/component.dart';
import 'package:flame/components/joystick/joystick_component.dart';
import 'package:flame/components/joystick/joystick_events.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/rendering.dart';

class Player extends SpriteComponent implements JoystickListener{
  Player() : super.fromSprite(64.0,64.0, new Sprite('mainGuy.png'));


  @override
  void resize(Size size){
    this.x = (size.width - this.width)/2;
    this.y = (size.height - this.height)/2;
  }

  void render(Canvas c){
  
    super.render(c);
  }


  void update(double t){
    
  }

  @override
  void joystickAction(JoystickActionEvent event) {
      // TODO: implement joystickAction
    }
  
    @override
    void joystickChangeDirectional(JoystickDirectionalEvent event) {
    // TODO: implement joystickChangeDirectional



  }


}