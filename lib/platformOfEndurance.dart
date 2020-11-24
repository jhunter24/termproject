import 'dart:math';
import 'package:flame/components/joystick/joystick_component.dart';
import 'package:flame/components/joystick/joystick_directional.dart';

import 'package:flame/game/base_game.dart';
import 'package:flame/game/game.dart';
import 'package:flame/gestures.dart';

import 'package:flutter/material.dart';
import 'package:platformsOfEndurance/game/gameUI.dart';
import 'package:platformsOfEndurance/model/background.dart';

import 'package:platformsOfEndurance/model/player.dart';
import 'package:platformsOfEndurance/screen/endGame.dart';

import 'model/enemy.dart';
import 'model/gold.dart';

class PlatformOfEndurance extends BaseGame
    with HasWidgetsOverlay, MultiTouchDragDetector {
  BuildContext _context;
  static const routeName = '/platformsGame';
  Size screenSize = Size(0, 0);
  Player p1 =
      Player.sequenced(42, 42, Player.ANIMATION_FILE, Player.SPRITE_COUNT);
  UserInfoDisplay ui;
  bool gameEnd = false;
  var joystick = JoystickComponent(
    componentPriority: 0,
    directional: JoystickDirectional(
      isFixed: true,
      size: 125,
      color: Colors.grey[100],
      opacityBackground: 0.0,
      opacityKnob: 1,
      margin: const EdgeInsets.only(left: 100, bottom: 100),
    ),
  );

  final List<Gold> goldList = [
    Gold.sequence(
      Gold.COIN_SIZE,
      Gold.COIN_SIZE,
      Gold.ANIMATION_FILE,
      Gold.SPRITE_COUNT,
      px: 1.5,
      py: 2,
    ), // adds a single gold to the goldList
    Gold.multiCoin(
      Gold.COIN_SIZE,
      Gold.COIN_SIZE,
      Gold.ANIMATION_FILE,
      Gold.SPRITE_COUNT,
      px: 1.5,
      py: 1.5,
      count: 1,
      level: 4,
    ), // multiple coins added based of count(5) + count * level
  ];

  final List<Enemy> enemyList = [
    Enemy(true, Enemy.ENEMY_SIZE, Enemy.ENEMY_SIZE, Enemy.ENEMY_SPRITE,
        Enemy.ANIMATION_COUNT, 1, 3, 19),
    Enemy(true, Enemy.ENEMY_SIZE, Enemy.ENEMY_SIZE, Enemy.ENEMY_SPRITE,
        Enemy.ANIMATION_COUNT, 1, 3, 6),
    Enemy(true, Enemy.ENEMY_SIZE, Enemy.ENEMY_SIZE, Enemy.ENEMY_SPRITE,
        Enemy.ANIMATION_COUNT, 1, 3, 3),
    Enemy(true, Enemy.ENEMY_SIZE, Enemy.ENEMY_SIZE, Enemy.ENEMY_SPRITE,
        Enemy.ANIMATION_COUNT, 1, 3, 2.15),
    Enemy(false, Enemy.ENEMY_SIZE, Enemy.ENEMY_SIZE, Enemy.ENEMY_SPRITE,
        Enemy.ANIMATION_COUNT, 1, 1.8, 15),
    Enemy(false, Enemy.ENEMY_SIZE, Enemy.ENEMY_SIZE, Enemy.ENEMY_SPRITE,
        Enemy.ANIMATION_COUNT, 1, 1.2, 15),
    Enemy(false, Enemy.ENEMY_SIZE, Enemy.ENEMY_SIZE, Enemy.ENEMY_SPRITE,
        Enemy.ANIMATION_COUNT, 1, 4, 15),
    Enemy(false, Enemy.ENEMY_SIZE, Enemy.ENEMY_SIZE, Enemy.ENEMY_SPRITE,
        Enemy.ANIMATION_COUNT, 1, 10, 15),
  ];

  var rng = new Random();

  PlatformOfEndurance(this._context) {
    p1.user ??= ModalRoute.of(_context).settings.arguments;
    add(Background()); // adds background to screen render
    goldList.forEach((element) {
      this.add(element);
    });
    enemyList.forEach((enemy) {
      this.add(enemy);
    });
    add(p1); // adds player to screen

    joystick.addObserver(p1); // attaches our joystick to our player sprite
    // adds the visual joystick
    add(joystick);
    //adding UI elements to render
    ui = UserInfoDisplay(150, 60, p1);
    //test code for testing health bar and experience bar
  }

  void onReceiveDrag(DragEvent drag) {
    joystick.onReceiveDrag(drag);
    super.onReceiveDrag(drag);
  }

  void showScore() {
    addWidgetOverlay(
      'score',
      Positioned(
        top: 1,
        right: 25,
        child: Row(
          children: [
            Material(
              child: Text(
                'Score: ${p1.getScore()}',
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Material(
              child: Text(
                'Gold: ${p1.getGold()}',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handleCollisions() {
    enemyCollision();
    goldCollisions();
  }

  void goldCollisions() {
    //handles picking up of coins
    if (goldList.isNotEmpty) {
      List<Gold> remove = [];
      for (Gold e in goldList) {
        if (e != null &&
            p1.toRect().intersect(e.toRect()).width > 0 &&
            p1.toRect().intersect(e.toRect()).height > 0) {
          print(goldList.length);
          p1.pickUp(e);
          e.pickUp();

          remove.add(e);
        }
      }

      for (var e in remove) {
        goldList.remove(e);
        print(goldList.length);
      }
    }
  }

  void enemyCollision() {
    if (enemyList.isNotEmpty) {
      enemyList.forEach((enemy) {
        if (enemy != null &&
            enemy.toRect().intersect(p1.toRect()).width > 0 &&
            enemy.toRect().intersect(p1.toRect()).height > 0) {
          p1.takeDamage();
        }
      });
    }
  }

  void spawnGold() {}

  void spawnEnemy() {
    if (enemyList.isEmpty) {
      for (int i = 0; i < 3; i++) {
        enemyList.add(Enemy(
            rng.nextBool(),
            Enemy.ENEMY_SIZE,
            Enemy.ENEMY_SIZE,
            Enemy.ENEMY_SPRITE,
            Enemy.ANIMATION_COUNT,
            p1.getLevel(),
            rng.nextInt(20).toDouble(),
            rng.nextInt(20).toDouble()));
      }
    }
  }

  void update(double t) {
    super.update(t);
    ui.update(t);
    p1.update(t);

    showScore();

    handleCollisions();

    if (p1.death()) {
      endGame();
    }
  }

  void render(Canvas c) {
    super.render(c);
    ui.render(c);
  }

  void resize(Size size) {
    screenSize = size;
    super.resize(size);
  }

  void endGame() {
    this.pauseEngine();
    Navigator.pushReplacementNamed(_context, EndGame.routeName, arguments: p1);
  }
}
