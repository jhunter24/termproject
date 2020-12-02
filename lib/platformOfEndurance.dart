import 'dart:math';

import 'package:flame/components/joystick/joystick_component.dart';
import 'package:flame/components/joystick/joystick_directional.dart';

import 'package:flame/game/base_game.dart';
import 'package:flame/game/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/sprite.dart';
import 'package:flame/widgets/sprite_button.dart';

import 'package:flutter/material.dart';
import 'package:platformsOfEndurance/game/gameUI.dart';
import 'package:platformsOfEndurance/model/background.dart';
import 'package:platformsOfEndurance/model/bullet.dart';
import 'package:platformsOfEndurance/model/defensepotion.dart';
import 'package:platformsOfEndurance/model/experiencePotion.dart';
import 'package:platformsOfEndurance/model/healthpotion.dart';

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
      size: 50,
      color: Colors.grey[100],
      opacityBackground: 0.0,
      opacityKnob: 1,
      margin: const EdgeInsets.only(left: 100, bottom: 100),
    ),
  );
  var rng = new Random();
  var playerPotionCount = [0, 0, 0];
  // list initializtion that deal with adding/removal of entities

  final List<ExperiencePotion> xpPotionList = [];
  final List<DefensePotion> defPotionList = [];
  final List<HealthPotion> potionList = [];
  final List<Bullet> bulletList = [];
  final List<Gold> goldList = [
    Gold.sequence(
      w: 300,
      h: 250,
    ), // adds a single gold to the goldList
    Gold.multiCoin(
      4,
      w: 500,
      h: 250,
      count: 1,
    ), // multiple coins added based of count(5) + count * level
  ];

  final List<Enemy> enemyList = [
    Enemy(true, 1, 3, 19),
    Enemy(true, 1, 3, 6),
    Enemy(true, 1, 3, 3),
    Enemy(true, 1, 3, 2.15),
    Enemy(false, 1, 1.8, 15),
    Enemy(false, 1, 1.2, 15),
    Enemy(false, 1, 4, 15),
    Enemy(false, 1, 10, 15),
  ];

  var _leftArrowSprite = Sprite('leftarrow.png');
  var _rightArrowSprite = Sprite('rightarrow.png');

  //beginning of game
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
    bulletControls();
    //test code for testing health bar and experience bar
    
  }
  //end game

  void onReceiveDrag(DragEvent drag) {
    joystick.onReceiveDrag(drag);
    super.onReceiveDrag(drag);
  }

  void updatePotionCount() {
    playerPotionCount[0] = p1.getHPlistCount();
    playerPotionCount[1] = p1.getXPlistCount();
    playerPotionCount[2] = p1.getDefListCount();
  }

  // ui functions

  void upgradeOverlay() {
    if (p1.getLevel() >= p1.hpUpgradeLevel() &&
        p1.getGold() >= p1.hpUpgradeCost())
      addWidgetOverlay(
          'hp',
          Positioned(
            right: 0,
            top: 60,
            child: Column(
              children: [
                RaisedButton(
                  onPressed: p1.upgradeHealth,
                  child: Text(
                    'Upgrade HP: ${p1.hpUpgradeCost()} gold',
                    style: TextStyle(fontSize: 8),
                  ),
                ),
              ],
            ),
          ));
    else
      removeWidgetOverlay('hp');

    if (p1.getLevel() >= p1.defUpgradeLevel() &&
        p1.getGold() >= p1.defUpgradeCost())
      addWidgetOverlay(
        'def',
        Positioned(
          right: 0,
          top: 20,
          child: Column(
            children: [
              RaisedButton(
                onPressed: p1.upgradeDefense,
                child: Text(
                  'Upgrade defense: ${p1.defUpgradeCost()} gold',
                  style: TextStyle(fontSize: 8),
                ),
              ),
            ],
          ),
        ),
      );
    else
      removeWidgetOverlay('def');
  }

  void showInventory() {
    double leftGap = 275;

    addWidgetOverlay(
        'hpPotion',
        Positioned(
          bottom: 10,
          left: leftGap,
          right: 50,
          child: Stack(children: [
            SpriteButton(
              onPressed: p1.useHealthPotion,
              label: null,
              sprite: Sprite(HealthPotion.SPRITE),
              pressedSprite: Sprite(HealthPotion.SPRITE),
              height: 30,
              width: 30,
            ),
            Material(
                color: Colors.transparent,
                child: Text(
                  '${playerPotionCount[0]}',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                )),
          ]),
        ));
    addWidgetOverlay(
        'xpPotion',
        Positioned(
          bottom: 10,
          left: leftGap + 50,
          child: Stack(
            children: [
              SpriteButton(
                  height: 30,
                  width: 30,
                  onPressed: p1.useXpPotion,
                  label: null,
                  sprite: Sprite(ExperiencePotion.SPRITE),
                  pressedSprite: Sprite(ExperiencePotion.SPRITE)),
              Material(
                color: Colors.transparent,
                child: Text(
                  '${playerPotionCount[1]}',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ));

    addWidgetOverlay(
        'defPotion',
        Positioned(
            bottom: 10,
            left: leftGap + 100,
            child: Stack(
              children: [
                SpriteButton(
                  height: 30,
                  width: 30,
                  label: null,
                  pressedSprite: Sprite(DefensePotion.SPRITE),
                  onPressed: p1.useDefensePotion,
                  sprite: Sprite(DefensePotion.SPRITE),
                ),
                Material(
                  color: Colors.transparent,
                  child: Text(
                    '${playerPotionCount[2]}',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            )));
  }

  void bulletControls() {
    addWidgetOverlay(
        'shoot right',
        Positioned(
          bottom: 20,
          right: 25,
          child: SpriteButton(
            label: null,
            onPressed: shootBulletRight,
            sprite: _rightArrowSprite,
            pressedSprite: _rightArrowSprite,
            width: 50,
            height: 50,
          ),
        ));
    addWidgetOverlay(
        'left',
        Positioned(
            bottom: 20,
            right: 100,
            child: SpriteButton(
                height: 50,
                width: 50,
                onPressed: shootBulletLeft,
                label: null,
                sprite: _leftArrowSprite,
                pressedSprite: _leftArrowSprite)));
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
  } // end showScore()

  // shooting functions

  void shootBulletRight() {
    bulletList.add(Bullet(false, p1.getDamage(), p1.toPosition()));
    print('right');
    bulletList.forEach((element) {
      add(element);
    });

    if (bulletList.length == 5) {
      var b = bulletList.first;
      b.hit();
      bulletList.remove(b);
    }
  } //end shootBulletRight()

  void shootBulletLeft() {
    print('left');
    bulletList.add(Bullet(true, p1.getDamage(), p1.toPosition()));
    bulletList.forEach((element) {
      add(element);
    });
    if (bulletList.length == 5) {
      var b = bulletList.first;
      b.hit();
      bulletList.remove(b);
    }
  } // end shootBulletLeft()

  //spawn functions

  void spawnGold(Enemy e) {
    Gold gold = Gold.multiCoin(e.getLevel(), position: e.toPosition());
    goldList.add(gold);
    add(gold);
  } // end spawnGold(Enemy e)

  void spawnHealthPotion(Enemy e) {
    HealthPotion potion =
        HealthPotion(e.toPosition().x, e.toPosition().y + 20, p1.getLevel());
    potionList.add(potion);
    add(potion);
    print('potionList.length: ${potionList.length}');
  } // end spawnHealthPotin()

  void spawnDefPotion(Enemy e) {
    DefensePotion potion =
        DefensePotion(e.toPosition().x, e.toPosition().y - 20);
    defPotionList.add(potion);
    add(potion);
    print('defPotionList.length: ${defPotionList.length}');
  }

  void spawnXpPotion(Enemy e) {
    ExperiencePotion potion =
        ExperiencePotion(e.toPosition().x + 20, e.toPosition().y, p1);
    xpPotionList.add(potion);
    add(potion);
    print('xpPotionList.length: ${xpPotionList.length}');
  }

  void spawnEnemy() {
    for (int i = enemyList.length; i < 8; i++) {
      var enemy = Enemy(rng.nextBool(), p1.getLevel(),
          rng.nextInt(32).toDouble()+1, rng.nextInt(32).toDouble()+1);
      enemyList.add(enemy);
      add(enemy);
    }
  }

  void enemyKill(Enemy e) {
    p1.gainExperience(e.getLevel());
    p1.gainScore(e.getLevel());
    e.death();
  }

  void bulletHit(Enemy e, Bullet b) {
    e.takeDamage(b.getDamage());
    b.hit();
  }

  // Collision function groups
  void potionCollision() {
    if (potionList.isNotEmpty) {
      final List<HealthPotion> remove = [];
      potionList.forEach((potion) {
        if (p1.toRect().intersect(potion.toRect()).height > 0 &&
            p1.toRect().intersect(potion.toRect()).width > 0) {
          potion.pickedUp();
          p1.pickUpHealthPotion(potion);
          remove.add(potion);
        }
      });

      if (remove.isNotEmpty) {
        remove.forEach((hpPotion) {
          potionList.remove(hpPotion);
        });
        remove.clear();
      }
    }
    if (defPotionList.isNotEmpty) {
      final List<DefensePotion> defRemove = [];
      defPotionList.forEach((defPotion) {
        if (p1.toRect().intersect(defPotion.toRect()).height > 0 &&
            p1.toRect().intersect(defPotion.toRect()).width > 0) {
          defPotion.pickedUp();
          p1.pickUpDefensePotion(defPotion);
          defRemove.add(defPotion);
        }
      });
      if (defRemove.isNotEmpty) {
        defRemove.forEach((defPotion) {
          defPotionList.remove(defPotion);
        });
        defRemove.clear();
      }
    }

    if (xpPotionList.isNotEmpty) {
      final List<ExperiencePotion> eRemove = [];
      xpPotionList.forEach((xpPotion) {
        if (p1.toRect().intersect(xpPotion.toRect()).width > 0 &&
            p1.toRect().intersect(xpPotion.toRect()).height > 0) {
          xpPotion.pickedUp();
          p1.pickUpExperiencePotion(xpPotion);
          eRemove.add(xpPotion);
        }
      });

      if (eRemove.isNotEmpty) {
        eRemove.forEach((xpPotion) {
          xpPotionList.remove(xpPotion);
        });
        eRemove.clear();
      }
    }
  }

  void bulletCollision() {
    final List<Bullet> remove = [];
    final List<Enemy> eRemove = [];
    if (bulletList.isNotEmpty) {
      bulletList.forEach((bullet) {
        enemyList.forEach((enemy) {
          if (bullet.toRect().intersect(enemy.toRect()).width > 0 &&
              bullet.toRect().intersect(enemy.toRect()).height > 0) {
            bulletHit(enemy, bullet);
            remove.add(bullet);
            if (enemy.getHealth() == 0) {
              spawnDefPotion(enemy);
              spawnXpPotion(enemy);
              spawnHealthPotion(enemy);
              spawnGold(enemy);
              enemyKill(enemy);
              eRemove.add(enemy);
            }
          }
        });
      });

      if (eRemove.isNotEmpty) {
        eRemove.forEach((element) {
          enemyList.remove(element);
        });
      }
      remove.forEach((element) {
        bulletList.remove(element);
      });
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
      }
      remove.clear();
    }
  }

  void handleCollisions() {
    enemyCollision();
    goldCollisions();
    if (enemyList.length < 8) {
      spawnEnemy();
      return;
    }
    potionCollision();
    bulletCollision();
  }

  //BaseGame function

  void update(double t) {
    super.update(t);
    ui.update(t);
    p1.update(t);
    showInventory();
    updatePotionCount();
    showScore();
    upgradeOverlay();
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
