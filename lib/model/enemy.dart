import 'dart:math';
import 'dart:ui';
import 'package:flame/components/animation_component.dart';


class Enemy extends AnimationComponent {
  static const ANIMATION_COUNT = 7;
  static const ENEMY_SPRITE = 'enemySprites.png';
  static const ENEMY_SIZE = 24.0;
  static const _speed = 0.6;
  double w,h;
  bool right = true;
  bool _death = false;
  int _level;
  int _hp;
  double px;
  double py;

  var random = new Random();
  Enemy(this.right, width, double height, String imagePath, int amount,
      int playerLevel, this.px, this.py)
      : super.sequenced(width, height, imagePath, amount,
            textureWidth: 32, textureHeight: 32) {
    _level = (playerLevel + random.nextInt(3));
    _hp = 100 + (_level * 10);
  }

  void resize(Size size) {
    this.x = size.width / px;
    this.y = size.width / py;
    w = size.width;
    h = size.height;
    print(w.toString());
  }

  void death() {
    _death = true;
    destroy();
  }

  @override
  bool destroy() {
    super.destroy();
    return _death;
  }

  void update(t) {
    super.update(t);

    if (right == true)
      this.x += _speed;
    else if (right == false) this.y += _speed;

    if (this.x.toInt() == w.toInt()) this.x = 0;
    if(this.y.toInt() == h.toInt()) this.y = 0;
  }

  void render(Canvas c) {
    super.render(c);
  }

  
}
