import 'dart:math';

import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flame/geometry.dart';
import 'package:skygame_2d/graphics/animations.dart';
import 'package:skygame_2d/models/unit_assets.dart';
import 'package:skygame_2d/game/stage.dart';
import 'package:skygame_2d/models/enums.dart';

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

extension UnitAssetsAnimationExt on UnitAssets {
  void _enterCombat() {
    final startPos = unit.owner == Owner.p1
        ? MatchPosition.p1Combatant
        : MatchPosition.p2Combatant;
    sprite.position = Stage.positions[startPos]!;
    animationState.value = UnitAniState.challenge;
  }

  void _challenge(double dt, UnitAniState nextState, {Vector2? offset}) {
    final targetPos = unit.owner == Owner.p1
        ? Stage.positions[MatchPosition.p1HitBox]!
        : Stage.positions[MatchPosition.p2HitBox]!;
    sprite.add(MoveEffect.to(
      targetPos + (offset ?? Vector2.all(0.0)),
      EffectController(duration: 0.03 / dt),
      onComplete: () {
        unit.asset.animationState.value = nextState;
      },
    ));
  }

  void _attack(double dt) {
    final attackDist = (unit.owner == Owner.p1) ? 40.0 : -40.0;
    final targetPos = (unit.owner == Owner.p1)
        ? MatchPosition.p1HitBox
        : MatchPosition.p2HitBox;
    sprite.add(MoveEffect.to(
      Stage.positions[targetPos]! + Vector2(attackDist, 0),
      EffectController(duration: 0.005 / dt),
      onComplete: () {
        if (unit.incomingCharge > 0) {
          AnimationsManager.fireCharge(dt,
              unit: unit,
              startPos: sprite.position -
                  (unit.owner == Owner.p1 ? Vector2.all(60) : Vector2(-60, 60)),
              charge: unit.incomingCharge);
        }
        animationState.value = UnitAniState.exitChallenge;
      },
    ));
  }

  void _exitChallenge(double dt) {
    final targetPos = unit.owner == Owner.p1
        ? Stage.positions[MatchPosition.p1Combatant]!
        : Stage.positions[MatchPosition.p2Combatant]!;

    sprite.add(MoveEffect.to(
      targetPos,
      EffectController(duration: 0.02 / dt),
      onComplete: () {
        unit.asset.animationState.value = UnitAniState.exitCombat;
      },
    ));
  }

  void _exitCombat(MatchPosition position) {
    _idle(position);
  }

  void _idle(position) {
    if (position != MatchPosition.defeated) {
      sprite.position = Stage.positions[position]!;
      animationState.value = UnitAniState.idle;
    }
  }

  void _dodgeStart(double dt, UnitAniState nextState) {
    final dodgeDist = Vector2(unit.owner == Owner.p1 ? 30 : -30, -25);
    sprite.add(MoveEffect.by(
      dodgeDist,
      EffectController(duration: 0.004 / dt),
      onComplete: () => animationState.value = nextState,
    ));
  }

  void _dodgeEnd(double dt) {
    final dodgeDist = Vector2(unit.owner == Owner.p1 ? 30 : -30, -25);

    sprite.add(MoveEffect.by(
      -dodgeDist,
      EffectController(duration: 0.004 / dt),
      onComplete: () => animationState.value = UnitAniState.exitChallenge,
    ));
  }

  void _counter(double dt) {
    var target = (unit.owner == Owner.p1) ? tau : -tau;
    sprite.add(RotateEffect.to(target, EffectController(duration: 0.008 / dt),
        onComplete: () {
      sprite.angle = 0;
      sprite.y = Stage.positions[MatchPosition.p1HitBox]!.y;
      AnimationsManager.fireCharge(dt,
          unit: unit,
          startPos: sprite.position -
              (unit.owner == Owner.p1 ? Vector2.all(60) : Vector2(-60, 60)),
          charge: unit.incomingCharge);
      animationState.value = UnitAniState.exitChallenge;
    }));
  }

  void _block(double dt) {
    final dist = (unit.owner == Owner.p1) ? -40.0 : 40.0;
    sprite.add(
        MoveEffect.by(Vector2(dist, 0), EffectController(duration: 0.003 / dt),
            onComplete: () async {
      await Future.delayed(Duration(milliseconds: 10 ~/ dt));
      if (unit.incomingDamage > 0) {
        AnimationsManager.fireDamage(dt,
            unit: unit,
            startPos: sprite.position -
                (unit.owner == Owner.p1 ? Vector2(0, 25) : Vector2(0, 25)),
            damage: unit.incomingDamage);
      }
      AnimationsManager.fireCharge(
        dt,
        unit: unit,
        startPos: sprite.position -
            (unit.owner == Owner.p1 ? Vector2.all(60) : Vector2(-60, 60)),
        charge: unit.incomingCharge,
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
        unit: unit,
        startPos: sprite.position -
            (unit.owner == Owner.p1 ? Vector2(0, 25) : Vector2(0, 25)),
        damage: unit.incomingDamage,
      );
      animationState.value = UnitAniState.exitChallenge;
    }));
  }

  void _critStart(double dt) {
    final critDistX = (unit.owner == Owner.p1) ? 80.0 : -80.0;
    final critDist = sprite.position - Vector2(critDistX, 40);
    sprite.angle = (unit.owner == Owner.p1) ? -pi * 0.25 : pi * 0.25;
    sprite.add(MoveEffect.to(critDist, EffectController(duration: 0.005 / dt),
        onComplete: () {
      unit.asset.animationState.value = UnitAniState.critEnd;
    }));
  }

  void _critEnd(double dt) {
    final critDistX = (unit.owner == Owner.p1) ? 60.0 : -60.0;
    final critDist = sprite.position - Vector2(critDistX, -60);
    sprite.angle = (unit.owner == Owner.p1) ? -pi * 0.5 : pi * 0.5;
    sprite.add(MoveEffect.to(critDist, EffectController(duration: 0.005 / dt),
        onComplete: () async {
      AnimationsManager.fireDamage(dt,
          unit: unit,
          startPos: sprite.position -
              (unit.owner == Owner.p1 ? Vector2(0, 50) : Vector2(0, 50)),
          damage: unit.incomingDamage);
      await Future.delayed(Duration(milliseconds: 20 ~/ dt));

      sprite.angle = 0;
      unit.asset.animationState.value = UnitAniState.exitChallenge;
    }));
  }

// TODO:
  void _missedAttack(double dt) {
    final attackDist = (unit.owner == Owner.p1) ? 40.0 : -40.0;
    final targetPos = (unit.owner == Owner.p1)
        ? MatchPosition.p1HitBox
        : MatchPosition.p2HitBox;
    sprite.add(MoveEffect.to(
      Stage.positions[targetPos]! + Vector2(attackDist, 0),
      EffectController(duration: 0.01 / dt),
      onComplete: () {
        animationState.value = UnitAniState.counteredAttack;
      },
    ));
  }

  void _counteredAttack(double dt) {
    final angleDir = (unit.owner == Owner.p1) ? pi * 0.5 : -pi * 0.5;
    sprite.add(RotateEffect.to(
        0,
        EffectController(
          duration: 0,
          startDelay: 0.1,
        ), onComplete: () async {
      AnimationsManager.fireDamage(dt,
          unit: unit,
          startPos: sprite.position -
              (unit.owner == Owner.p1 ? Vector2(0, 25) : Vector2(0, 25)),
          damage: unit.incomingDamage);
      sprite.y = Stage.positions[MatchPosition.p1HitBox]!.y + 20.0;
      sprite.angle = angleDir;
      await Future.delayed(Duration(milliseconds: (20.0 ~/ dt)));
      sprite.angle = 0;
      animationState.value = UnitAniState.exitChallenge;
    }));
  }

  void _lethal(double dt) {
    final dir = (unit.owner == Owner.p1) ? -1400.0 : 1400.0;
    sprite.angle -= pi * (unit.owner == Owner.p1 ? 0.25 : -0.25);

    sprite.add(
      MoveEffect.by(Vector2(dir, -300), EffectController(duration: 0.05 / dt),
          onComplete: () {
        sprite.angle = 0;
        AnimationsManager.fireDamage(dt,
            unit: unit,
            startPos: sprite.position -
                (unit.owner == Owner.p1 ? Vector2(0, 25) : Vector2(0, 25)),
            damage: unit.incomingDamage);
        animationState.value = UnitAniState.exitChallenge;
      }),
    );
  }

  void _staggeredAttack(double dt) {
    var target = (unit.owner == Owner.p1) ? -tau : tau;
    sprite.add(RotateEffect.to(target, EffectController(duration: 0.008 / dt),
        onComplete: () async {
      sprite.angle = 0;
      AnimationsManager.fireCharge(dt,
          unit: unit,
          startPos: sprite.position -
              (unit.owner == Owner.p1 ? Vector2.all(60) : Vector2(-60, 60)),
          charge: unit.incomingCharge);
      await Future.delayed(Duration(milliseconds: (20.0 ~/ dt)));
      animationState.value = UnitAniState.exitChallenge;
    }));
  }

  void _knockback(double dt) {
    final targetPos = unit.owner == Owner.p1 ? 120.0 : -120.0;
    sprite.angle = pi * ((unit.owner == Owner.p1) ? -0.25 : 0.25);
    sprite.add(MoveEffect.to(sprite.position - Vector2(targetPos, 0),
        EffectController(duration: 0.008 / dt), onComplete: () async {
      AnimationsManager.fireDamage(dt,
          unit: unit,
          startPos: sprite.position -
              (unit.owner == Owner.p1 ? Vector2(0, 25) : Vector2(0, 25)),
          damage: unit.incomingDamage);
      AnimationsManager.fireCharge(dt,
          unit: unit,
          startPos: sprite.position -
              (unit.owner == Owner.p1 ? Vector2.all(60) : Vector2(-60, 60)),
          charge: unit.incomingCharge);
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
        _exitCombat(unit.position);
        break;
      default:
        _idle(unit.position);
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
            offset: Vector2(unit.owner == Owner.p1 ? -30 : 30, 0));
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
        _exitCombat(unit.position);
        break;
      default:
        _idle(unit.position);
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
        _exitCombat(unit.position);
        break;
      default:
        _idle(unit.position);
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
        _exitCombat(unit.position);
        break;
      default:
        _idle(unit.position);
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
        _exitCombat(unit.position);
        break;
      default:
        _idle(unit.position);
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
            offset: Vector2(unit.owner == Owner.p1 ? -30 : 30, 0));
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
        _exitCombat(unit.position);
        break;
      default:
        _idle(unit.position);
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
        _exitCombat(unit.position);
        break;
      default:
        _idle(unit.position);
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
        _exitCombat(unit.position);
        break;
      default:
        _idle(unit.position);
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
        _exitCombat(unit.position);
        break;
      default:
        _idle(unit.position);
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
        _exitCombat(unit.position);
        break;
      default:
        _idle(unit.position);
        break;
    }
  }
}
