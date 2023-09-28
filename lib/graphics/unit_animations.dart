import 'dart:math';

import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flame/geometry.dart';
import 'package:skygame_2d/bloc/combat/events.dart';
import 'package:skygame_2d/game/helper.dart';
import 'package:skygame_2d/graphics/animations.dart';
import 'package:skygame_2d/models/match_unit/unit_assets.dart';
import 'package:skygame_2d/game/stage.dart';
import 'package:skygame_2d/scenes/combat.dart';
import 'package:skygame_2d/scenes/team_builder/team_builder.dart';
import 'package:skygame_2d/utils.dart/enums.dart';

enum UnitAniState {
  none,
  idle,
  enterCombat,
  challenge,
  attack,
  hit,
  critStart,
  critEnd,
  block,
  dodgeStart,
  dodgeEnd,
  counter,
  counteredAttack,
  staggeredAttack,
  lethal,
  knockback,
  exitChallenge,
  exitCombat,
  end,
}

extension UnitAssetsAnimationExt on MatchUnitAssets {
  void _enterCombat() {
    sprite.position = Stage.zones(parent.ownerID)[CombatPosition.challenger]!;
    animationState.value = UnitAniState.challenge;
  }

  void _challenge(double dt, UnitAniState nextState, {Vector2? offset}) {
    final targetPos = Stage.zones(parent.ownerID)[CombatPosition.hitbox]!;
    sprite.add(MoveEffect.to(
      targetPos + (offset ?? Vector2.all(0.0)),
      EffectController(duration: 0.72),
      onComplete: () {
        parent.asset.animationState.value = nextState;
      },
    ));
  }

  void _attack(double dt) {
    final attackDist = MatchHelper.isLeftTeam(parent) ? 40.0 : -40.0;
    sprite.add(MoveEffect.to(
      Stage.zones(parent.ownerID)[CombatPosition.hitbox]! +
          Vector2(attackDist, 0),
      EffectController(duration: 0.005 / dt),
      onComplete: () {
        if (parent.incomingCharge > 0) {
          AnimationsManager.fireCharge(dt,
              unit: parent,
              startPos: sprite.position -
                  (MatchHelper.isLeftTeam(parent)
                      ? Vector2.all(60)
                      : Vector2(-60, 60)),
              charge: parent.incomingCharge);
        }
        parent.render(dt);
        animationState.value = UnitAniState.exitChallenge;
      },
    ));
  }

  void _exitChallenge(double dt) {
    final targetPos = Stage.zones(parent.ownerID)[CombatPosition.challenger]!;

    sprite.add(MoveEffect.to(
      targetPos,
      EffectController(duration: 0.76),
      onComplete: () {
        parent.asset.animationState.value = UnitAniState.exitCombat;
      },
    ));
  }

  void _exitCombat(MatchPosition position) {
    _idle(position);
  }

  void _idle(MatchPosition position, {bool isRecursive = false}) {
    if (position != MatchPosition.defeated && isRecursive == false) {
      sprite.position = Stage.positions(parent.ownerID)[position]!;
      animationState.value = UnitAniState.idle;
    }
    final scene =
        SceneManager.scenes.firstWhere((e) => e is CombatScene) as CombatScene?;
    if (scene == null || !scene.isMounted) return;
    if (scene.combatBloc.state.attacker != parent) return;
    if (scene.combatBloc.state.defender?.asset.animationState.value ==
        UnitAniState.idle) {
      scene.combatBloc.add(CombatAnimationEndEvent());
    } else {
      Future.delayed(const Duration(milliseconds: 100))
          .whenComplete(() => _idle(position, isRecursive: true));
    }
  }

  void _dodgeStart(double dt, UnitAniState nextState) {
    final dodgeDist = Vector2(MatchHelper.isLeftTeam(parent) ? 30 : -30, -25);
    sprite.add(MoveEffect.to(
      Stage.zones(parent.ownerID)[CombatPosition.hitbox]! + dodgeDist,
      EffectController(duration: 0.12),
      onComplete: () => animationState.value = nextState,
    ));
  }

  void _dodgeEnd(double dt) {
    final dodgeDist = Vector2(MatchHelper.isLeftTeam(parent) ? 30 : -30, -25);

    sprite.add(MoveEffect.to(
      Stage.zones(parent.ownerID)[CombatPosition.hitbox]! - dodgeDist,
      EffectController(duration: 0.12),
      onComplete: () {
        parent.render(dt);
        animationState.value = UnitAniState.exitChallenge;
      },
    ));
  }

  void _counter(double dt) {
    var target = MatchHelper.isLeftTeam(parent) ? tau : -tau;
    sprite.add(RotateEffect.to(target, EffectController(duration: 0.008 / dt),
        onComplete: () {
      sprite.angle = 0;
      sprite.y = Stage.zones(parent.ownerID)[CombatPosition.hitbox]!.y;
      AnimationsManager.fireCharge(dt,
          unit: parent,
          startPos: sprite.position -
              (MatchHelper.isLeftTeam(parent)
                  ? Vector2.all(60)
                  : Vector2(-60, 60)),
          charge: parent.incomingCharge);
      parent.render(dt);
      animationState.value = UnitAniState.exitChallenge;
    }));
  }

  void _block(double dt) {
    final dist = MatchHelper.isLeftTeam(parent) ? -40.0 : 40.0;
    parent.render(dt);
    sprite.add(MoveEffect.to(
        Stage.zones(parent.ownerID)[CombatPosition.hitbox]! - Vector2(dist, 0),
        EffectController(duration: 0.003), onComplete: () async {
      await Future.delayed(Duration(milliseconds: 10 ~/ dt));
      if (parent.incomingDamage > 0) {
        AnimationsManager.fireDamage(dt,
            unit: parent,
            startPos: sprite.position -
                (MatchHelper.isLeftTeam(parent)
                    ? Vector2(0, 25)
                    : Vector2(0, 25)),
            damage: parent.incomingDamage);
      }
      AnimationsManager.fireCharge(
        dt,
        unit: parent,
        startPos: sprite.position -
            (MatchHelper.isLeftTeam(parent)
                ? Vector2.all(60)
                : Vector2(-60, 60)),
        charge: parent.incomingCharge,
      );

      animationState.value = UnitAniState.exitChallenge;
    }));
  }

// TODO: change attack and hit to look better
  void _hit(double dt) {
    sprite.add(ScaleEffect.to(Vector2(sprite.scale.x * -1.0, 1),
        EffectController(duration: 0.005 / dt, repeatCount: 2), onComplete: () {
      sprite.scale.x *= -1;
      AnimationsManager.fireDamage(
        dt,
        unit: parent,
        startPos: sprite.position -
            (MatchHelper.isLeftTeam(parent) ? Vector2(0, 25) : Vector2(0, 25)),
        damage: parent.incomingDamage,
      );
      parent.render(dt);
      animationState.value = UnitAniState.exitChallenge;
    }));
  }

  void _critStart(double dt) {
    final critDistX = MatchHelper.isLeftTeam(parent) ? 80.0 : -80.0;
    final critDist = sprite.position - Vector2(critDistX, 40);
    sprite.angle = MatchHelper.isLeftTeam(parent) ? -pi * 0.25 : pi * 0.25;
    sprite.add(MoveEffect.to(critDist, EffectController(duration: 0.12),
        onComplete: () {
      parent.asset.animationState.value = UnitAniState.critEnd;
    }));
  }

  void _critEnd(double dt) {
    parent.render(dt);
    final critDistX = MatchHelper.isLeftTeam(parent) ? 60.0 : -60.0;
    final critDist = sprite.position - Vector2(critDistX, -60);
    sprite.angle = MatchHelper.isLeftTeam(parent) ? -pi * 0.5 : pi * 0.5;
    sprite.add(MoveEffect.to(critDist, EffectController(duration: 0.12),
        onComplete: () async {
      AnimationsManager.fireDamage(dt,
          unit: parent,
          startPos: sprite.position -
              (MatchHelper.isLeftTeam(parent)
                  ? Vector2(0, 50)
                  : Vector2(0, 50)),
          damage: parent.incomingDamage);
      await Future.delayed(Duration(milliseconds: 20 ~/ dt));

      sprite.angle = 0;
      parent.asset.animationState.value = UnitAniState.exitChallenge;
    }));
  }

// TODO:
  void _missedAttack(double dt) {
    final attackDist = MatchHelper.isLeftTeam(parent) ? 40.0 : -40.0;

    sprite.add(MoveEffect.to(
      Stage.zones(parent.ownerID)[CombatPosition.hitbox]! +
          Vector2(attackDist, 0),
      EffectController(duration: 0.01 / dt),
      onComplete: () {
        animationState.value = UnitAniState.counteredAttack;
      },
    ));
  }

  void _counteredAttack(double dt) {
    final angleDir = MatchHelper.isLeftTeam(parent) ? pi * 0.5 : -pi * 0.5;
    sprite.add(RotateEffect.to(
        0,
        EffectController(
          duration: 0,
          startDelay: 0.1,
        ), onComplete: () async {
      AnimationsManager.fireDamage(dt,
          unit: parent,
          startPos: sprite.position -
              (MatchHelper.isLeftTeam(parent)
                  ? Vector2(0, 25)
                  : Vector2(0, 25)),
          damage: parent.incomingDamage);
      sprite.y = Stage.zones(parent.ownerID)[CombatPosition.hitbox]!.y + 20.0;
      sprite.angle = angleDir;
      await Future.delayed(Duration(milliseconds: (20.0 ~/ dt)));
      sprite.angle = 0;
      parent.render(dt);
      animationState.value = UnitAniState.exitChallenge;
    }));
  }

  void _lethal(double dt) {
    final dir = MatchHelper.isLeftTeam(parent) ? -1400.0 : 1400.0;
    sprite.angle -= pi * (MatchHelper.isLeftTeam(parent) ? 0.25 : -0.25);
    parent.render(dt);

    sprite.add(
      MoveEffect.to(
          Vector2(Stage.zones(parent.ownerID)[CombatPosition.hitbox]!.x + dir,
              -300),
          EffectController(duration: 0.75), onComplete: () {
        sprite.angle = 0;
        AnimationsManager.fireDamage(dt,
            unit: parent,
            startPos: sprite.position -
                (MatchHelper.isLeftTeam(parent)
                    ? Vector2(0, 25)
                    : Vector2(0, 25)),
            damage: parent.incomingDamage);
        animationState.value = UnitAniState.exitChallenge;
      }),
    );
  }

  void _staggeredAttack(double dt) {
    var target = MatchHelper.isLeftTeam(parent) ? -tau : tau;
    parent.render(dt);

    sprite.add(RotateEffect.to(target, EffectController(duration: 0.008 / dt),
        onComplete: () async {
      sprite.angle = 0;
      AnimationsManager.fireCharge(dt,
          unit: parent,
          startPos: sprite.position -
              (MatchHelper.isLeftTeam(parent)
                  ? Vector2.all(60)
                  : Vector2(-60, 60)),
          charge: parent.incomingCharge);
      await Future.delayed(Duration(milliseconds: (20.0 ~/ dt)));
      animationState.value = UnitAniState.exitChallenge;
    }));
  }

  void _knockback(double dt) {
    final targetPos = MatchHelper.isLeftTeam(parent) ? 120.0 : -120.0;
    sprite.angle = pi * (MatchHelper.isLeftTeam(parent) ? -0.25 : 0.25);
    parent.render(dt);
    sprite.add(MoveEffect.to(sprite.position - Vector2(targetPos, 0),
        EffectController(duration: 0.008 / dt), onComplete: () async {
      AnimationsManager.fireDamage(dt,
          unit: parent,
          startPos: sprite.position -
              (MatchHelper.isLeftTeam(parent)
                  ? Vector2(0, 25)
                  : Vector2(0, 25)),
          damage: parent.incomingDamage);
      AnimationsManager.fireCharge(dt,
          unit: parent,
          startPos: sprite.position -
              (MatchHelper.isLeftTeam(parent)
                  ? Vector2.all(60)
                  : Vector2(-60, 60)),
          charge: parent.incomingCharge);
      await Future.delayed(Duration(milliseconds: 3 ~/ dt));
      sprite.angle = 0;
      animationState.value = UnitAniState.exitChallenge;
    }));
  }

  void animateAttack(double dt) {
    switch (animationState.value) {
      case UnitAniState.enterCombat:
        _enterCombat();
        break;
      case UnitAniState.challenge:
        _challenge(dt, UnitAniState.attack);
        break;
      case UnitAniState.attack:
        _attack(dt);
        break;
      case UnitAniState.exitChallenge:
        _exitChallenge(dt);
        break;
      case UnitAniState.exitCombat:
        _exitCombat(parent.position);
        break;
      default:
        _idle(parent.position);
        break;
    }
  }

  void animateDodge(double dt) {
    switch (animationState.value) {
      case UnitAniState.enterCombat:
        _enterCombat();
        break;
      case UnitAniState.challenge:
        _challenge(dt, UnitAniState.dodgeStart,
            offset: Vector2(MatchHelper.isLeftTeam(parent) ? -30 : 30, 0));
        break;
      case UnitAniState.dodgeStart:
        _dodgeStart(dt, UnitAniState.dodgeEnd);

        break;
      case UnitAniState.dodgeEnd:
        _dodgeEnd(dt);
        break;
      case UnitAniState.exitChallenge:
        _exitChallenge(dt);
        break;
      case UnitAniState.exitCombat:
        _exitCombat(parent.position);
        break;
      default:
        _idle(parent.position);
        break;
    }
  }

  void animateBlock(double dt) {
    switch (animationState.value) {
      case UnitAniState.enterCombat:
        _enterCombat();
        break;
      case UnitAniState.challenge:
        _challenge(dt, UnitAniState.block);

        break;
      case UnitAniState.block:
        _block(dt);
        break;
      case UnitAniState.exitChallenge:
        _exitChallenge(dt);
        break;
      case UnitAniState.exitCombat:
        _exitCombat(parent.position);
        break;
      default:
        _idle(parent.position);
        break;
    }
  }

  void animateHit(double dt) {
    switch (animationState.value) {
      case UnitAniState.enterCombat:
        _enterCombat();
        break;
      case UnitAniState.challenge:
        _challenge(dt, UnitAniState.hit);

        break;
      case UnitAniState.hit:
        _hit(dt);
        break;
      case UnitAniState.exitChallenge:
        _exitChallenge(dt);
        break;
      case UnitAniState.exitCombat:
        _exitCombat(parent.position);
        break;
      default:
        _idle(parent.position);
        break;
    }
  }

  void animateCriticalHit(double dt) {
    switch (animationState.value) {
      case UnitAniState.enterCombat:
        _enterCombat();
        break;
      case UnitAniState.challenge:
        _challenge(dt, UnitAniState.critStart);

        break;
      case UnitAniState.critStart:
        _critStart(dt);
        break;
      case UnitAniState.critEnd:
        _critEnd(dt);
        break;
      case UnitAniState.exitChallenge:
        _exitChallenge(dt);
        break;
      case UnitAniState.exitCombat:
        _exitCombat(parent.position);
        break;
      default:
        _idle(parent.position);
        break;
    }
  }

  void animateCounter(double dt) {
    switch (animationState.value) {
      case UnitAniState.enterCombat:
        _enterCombat();
        break;
      case UnitAniState.challenge:
        _challenge(dt, UnitAniState.dodgeStart,
            offset: Vector2(MatchHelper.isLeftTeam(parent) ? -30 : 30, 0));
        break;
      case UnitAniState.dodgeStart:
        _dodgeStart(dt, UnitAniState.counter);
        break;
      case UnitAniState.counter:
        _counter(dt);
        break;
      case UnitAniState.exitChallenge:
        _exitChallenge(dt);
        break;
      case UnitAniState.exitCombat:
        _exitCombat(parent.position);
        break;
      default:
        _idle(parent.position);
    }
  }

  void animateCounteredAttack(double dt) {
    switch (animationState.value) {
      case UnitAniState.enterCombat:
        _enterCombat();
        break;
      case UnitAniState.challenge:
        _challenge(dt, UnitAniState.attack);

        break;
      case UnitAniState.attack:
        _missedAttack(dt);
        break;
      case UnitAniState.counteredAttack:
        _counteredAttack(dt);
        break;
      case UnitAniState.exitChallenge:
        _exitChallenge(dt);
        break;
      case UnitAniState.exitCombat:
        _exitCombat(parent.position);
        break;
      default:
        _idle(parent.position);
        break;
    }
  }

  void animateLethalHit(double dt) {
    switch (animationState.value) {
      case UnitAniState.enterCombat:
        _enterCombat();
        break;
      case UnitAniState.challenge:
        _challenge(dt, UnitAniState.lethal);

        break;
      case UnitAniState.lethal:
        _lethal(dt);
        break;
      case UnitAniState.exitChallenge:
        _exitChallenge(dt);
        break;
      case UnitAniState.exitCombat:
        _exitCombat(parent.position);
        break;
      default:
        _idle(parent.position);
        break;
    }
  }

  void animateStaggeredAttack(double dt) {
    switch (animationState.value) {
      case UnitAniState.enterCombat:
        _enterCombat();
        break;
      case UnitAniState.challenge:
        _challenge(dt, UnitAniState.staggeredAttack);

        break;
      case UnitAniState.staggeredAttack:
        _staggeredAttack(dt);
        break;
      case UnitAniState.exitChallenge:
        _exitChallenge(dt);
        break;
      case UnitAniState.exitCombat:
        _exitCombat(parent.position);
        break;
      default:
        _idle(parent.position);
        break;
    }
  }

  void animatePushback(double dt) {
    switch (animationState.value) {
      case UnitAniState.enterCombat:
        _enterCombat();
        break;
      case UnitAniState.challenge:
        _challenge(dt, UnitAniState.knockback);

        break;
      case UnitAniState.knockback:
        _knockback(dt);

        break;

      case UnitAniState.exitChallenge:
        _exitChallenge(dt);
        break;
      case UnitAniState.exitCombat:
        _exitCombat(parent.position);
        break;
      default:
        _idle(parent.position);
        break;
    }
  }
}
