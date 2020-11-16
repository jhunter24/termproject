import 'dart:ui';


import 'package:flame/box2d/box2d_component.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:platformsOfEndurance/platformOfEndurance.dart';

import '../model/player.dart';

class TowerWorld extends Box2DComponent {
  final PlatformOfEndurance poe;
  Player player;

  TowerWorld(this.poe) : super(scale: 4.0);
  TowerGround ground;
  @override
  void initializeWorld() {
    ground = TowerGround(
      this,
    );
  }

  @override
  void render(Canvas c) {
    super.render(c);
    ground.render(c);
  }

  @override
  void update(double t) {
    super.update(t);
  }
}

class TowerGround extends BodyComponent {
  static const height = 10.0;

  TowerGround(
    Box2DComponent box,
  ) : super(box);

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }
}
