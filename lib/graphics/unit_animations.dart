import 'dart:math';

import 'package:flame/game.dart';
import 'package:skygame_2d/models/unit_assets.dart';
import 'package:skygame_2d/game/stage.dart';
import 'package:skygame_2d/models/enums.dart';
import 'package:skygame_2d/models/unit_assets_ext.dart';

enum UnitAniState {
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
}

extension UnitAssetsAnimationExt on UnitAssets {
  void _enterCombat() {
    final startPos = unit.owner == Owner.p1
        ? MatchPosition.p1Combatant
        : MatchPosition.p2Combatant;
    sprite.position = Stage.positions[startPos]!;
    animationState = UnitAniState.challenge;
  }

  bool _challenge() {
    if (unit.owner == Owner.p1 && sprite.x < 910) {
      sprite.x += 8;
    } else if (unit.owner == Owner.p2 && sprite.x > 990) {
      sprite.x -= 8;
    } else {
      return true;
    }
    return false;
  }

  void _attack(double dt) {
    if (elapsedTime <= 0.5) {
      sprite.x += (unit.owner == Owner.p1) ? 4 : -4;
    }
    if (elapsedTime > 1) {
      elapsedTime = 0;
      animationState = UnitAniState.exitChallenge;
      if (unit.incomingCharge > 0) {
        fireCharge(
            sprite.position -
                (unit.owner == Owner.p1 ? Vector2.all(60) : Vector2(-60, 60)),
            unit.incomingCharge);
      }
      return;
    }
    elapsedTime += dt;
  }

  void _exitChallenge() {
    if (unit.owner == Owner.p1 &&
        sprite.x > Stage.positions[MatchPosition.p1Combatant]!.x) {
      sprite.x -= 8;
    } else if (unit.owner == Owner.p2 &&
        sprite.x < Stage.positions[MatchPosition.p2Combatant]!.x) {
      sprite.x += 8;
    } else {
      animationState = UnitAniState.exitCombat;
    }
  }

  void _exitCombat(MatchPosition position) {
    _idle(position);
  }

  void _idle(position) {
    sprite.position = Stage.positions[position]!;
    animationState = UnitAniState.idle;
  }

  bool _dodge(double dt) {
    sprite.x += unit.owner == Owner.p1 ? 4 : -4;
    sprite.y -= 4;
    if (elapsedTime > 0.25) {
      elapsedTime = 0;
      return true;
    }
    elapsedTime += dt;
    return false;
  }

  void _dodgeEnd(double dt) {
    sprite.x -= unit.owner == Owner.p1 ? 4 : -4;
    sprite.y += 4;
    if (elapsedTime > 0.25) {
      elapsedTime = 0;
      animationState = UnitAniState.exitChallenge;
      return;
    }
    elapsedTime += dt;
  }

  void _counter() {
    sprite.angle += pi * ((unit.owner == Owner.p1) ? 0.5 : -0.5);
    if (sprite.angle > 2 * pi || sprite.angle < -2 * pi) {
      sprite.angle = 0;
      sprite.y = 820;
      fireCharge(
          sprite.position -
              (unit.owner == Owner.p1 ? Vector2.all(60) : Vector2(-60, 60)),
          unit.incomingCharge);
      animationState = UnitAniState.exitChallenge;
    }
  }

  void _block(double dt) {
    sprite.x -= (elapsedTime > 0.5)
        ? 0
        : (unit.owner == Owner.p1)
            ? 4
            : -4;

    if (elapsedTime > 1.0) {
      elapsedTime = 0;
      if (unit.incomingDamage > 0) {
        fireDamage(
            sprite.position -
                (unit.owner == Owner.p1 ? Vector2(0, 25) : Vector2(0, 25)),
            unit.incomingDamage);
      }
      fireCharge(
          sprite.position -
              (unit.owner == Owner.p1 ? Vector2.all(60) : Vector2(-60, 60)),
          unit.incomingCharge);
      animationState = UnitAniState.exitChallenge;
      return;
    }
    elapsedTime += dt;
  }

  void _hit() {
    if (hitCounter < 2) {
      if (hitCounter % 2.0 == 0.0) {
        sprite.scale.x += (unit.owner == Owner.p1) ? 0.5 : -0.5;
      } else {
        sprite.scale.x -= (unit.owner == Owner.p1) ? 0.5 : -0.5;
      }

      if (sprite.scale.x >= 1.0) {
        sprite.scale.x = 1.0;
        hitCounter += 1;
      } else if (sprite.scale.x <= -1.0) {
        sprite.scale.x = -1.0;
        hitCounter += 1;
      }
    } else {
      hitCounter = 0;
      fireDamage(
          sprite.position -
              (unit.owner == Owner.p1 ? Vector2(0, 25) : Vector2(0, 25)),
          unit.incomingDamage);
      animationState = UnitAniState.exitChallenge;
    }
  }

  void _critStart() {
    sprite.x -= (unit.owner == Owner.p1) ? 8 : -8;
    sprite.y -= 10;
    if ((unit.owner == Owner.p1 && sprite.x < 860) ||
        unit.owner == Owner.p2 && sprite.x > 1040) {
      animationState = UnitAniState.critEnd;
    }
  }

  void _critEnd(double dt) {
    if (sprite.y < 820) {
      sprite.x -= (unit.owner == Owner.p1) ? 8 : -8;
      sprite.y += 10;
    }

    if (unit.owner == Owner.p1 && sprite.angle > -pi * 0.5) {
      sprite.angle -= (pi * 0.125);
    } else if (unit.owner == Owner.p2 && sprite.angle < pi * 0.5) {
      sprite.angle += (pi * 0.125);
    }

    if (sprite.y >= 820) {
      if (elapsedTime >= 1) {
        sprite.angle = 0;
        elapsedTime = 0;
        fireDamage(
            sprite.position -
                (unit.owner == Owner.p1 ? Vector2(0, 25) : Vector2(0, 25)),
            unit.incomingDamage);
        animationState = UnitAniState.exitChallenge;
        return;
      }
    }
    elapsedTime += dt;
  }

  void _missedAttack(double dt) {
    sprite.x += (unit.owner == Owner.p1) ? 2 : -2;
    if (elapsedTime > 0.5) {
      elapsedTime = 0;
      animationState = UnitAniState.counteredAttack;
      return;
    }
    elapsedTime += dt;
  }

  void _counteredAttack(double dt) {
    sprite.angle = pi * ((unit.owner == Owner.p1) ? 0.5 : -0.5);
    sprite.y = 860;
    if (elapsedTime > 0.5) {
      elapsedTime = 0;
      sprite.angle = 0;
      sprite.y = 820;
      fireDamage(
          sprite.position -
              (unit.owner == Owner.p1 ? Vector2(0, 25) : Vector2(0, 25)),
          unit.incomingDamage);
      animationState = UnitAniState.exitChallenge;
      return;
    }
    elapsedTime += dt;
  }

  void _lethal(double dt) {
    sprite.x -= (unit.owner == Owner.p1) ? 35 : -35;
    sprite.y -= 12;
    sprite.angle -= pi * (unit.owner == Owner.p1 ? 0.25 : -0.25);
    if (elapsedTime > 2) {
      sprite.angle = 0;
      fireDamage(
          sprite.position -
              (unit.owner == Owner.p1 ? Vector2(0, 25) : Vector2(0, 25)),
          unit.incomingDamage);
      animationState = UnitAniState.exitChallenge;
      return;
    }
    elapsedTime += dt;
  }

  void _staggeredAttack(double dt) {
    if (unit.owner == Owner.p1) {
      sprite.x -= 4;
      if (sprite.angle > -pi * 2) {
        sprite.angle -= pi * 0.25;
      }
    } else {
      sprite.x += 4;
      if (sprite.angle < pi * 2) {
        sprite.angle += pi * 0.25;
      }
    }
    if (elapsedTime > 0.5) {
      sprite.angle = 0;
      elapsedTime = 0;
      fireCharge(
          sprite.position -
              (unit.owner == Owner.p1 ? Vector2.all(60) : Vector2(-60, 60)),
          unit.incomingCharge);
      animationState = UnitAniState.exitChallenge;
      return;
    }
    elapsedTime += dt;
  }

  void _knockback(double dt) {
    sprite.x -= (elapsedTime > 0.5) ? 0 : ((unit.owner == Owner.p1) ? 4 : -4);
    sprite.angle = -pi * ((unit.owner == Owner.p1) ? 0.25 : -0.25);
    if (elapsedTime > 1.0) {
      sprite.angle = 0;
      elapsedTime = 0;
      fireDamage(
          sprite.position -
              (unit.owner == Owner.p1 ? Vector2(0, 25) : Vector2(0, 25)),
          unit.incomingDamage);
      fireCharge(
          sprite.position -
              (unit.owner == Owner.p1 ? Vector2.all(60) : Vector2(-60, 60)),
          unit.incomingCharge);
      animationState = UnitAniState.exitChallenge;
      return;
    }
    elapsedTime += dt;
  }

  void animateAttack(double dt) {
    switch (animationState) {
      case UnitAniState.enterCombat:
        _enterCombat();
        break;
      case UnitAniState.challenge:
        if (_challenge()) {
          animationState = UnitAniState.attack;
        }
        break;
      case UnitAniState.attack:
        _attack(dt);
        break;
      case UnitAniState.exitChallenge:
        _exitChallenge();
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
    switch (animationState) {
      case UnitAniState.enterCombat:
        _enterCombat();
        break;
      case UnitAniState.challenge:
        if (_challenge()) {
          animationState = UnitAniState.dodgeStart;
        }
        break;
      case UnitAniState.dodgeStart:
        if (_dodge(dt)) {
          animationState = UnitAniState.dodgeEnd;
        }
        break;
      case UnitAniState.dodgeEnd:
        _dodgeEnd(dt);
        break;
      case UnitAniState.exitChallenge:
        _exitChallenge();
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
    switch (animationState) {
      case UnitAniState.enterCombat:
        _enterCombat();
        break;
      case UnitAniState.challenge:
        if (_challenge()) {
          animationState = UnitAniState.block;
        }
        break;
      case UnitAniState.block:
        _block(dt);
        break;
      case UnitAniState.exitChallenge:
        _exitChallenge();
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
    switch (animationState) {
      case UnitAniState.enterCombat:
        _enterCombat();
        break;
      case UnitAniState.challenge:
        if (_challenge()) {
          animationState = UnitAniState.hit;
        }
        break;
      case UnitAniState.hit:
        _hit();
        break;
      case UnitAniState.exitChallenge:
        _exitChallenge();
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
    switch (animationState) {
      case UnitAniState.enterCombat:
        _enterCombat();
        break;
      case UnitAniState.challenge:
        if (_challenge()) {
          animationState = UnitAniState.critStart;
        }
        break;
      case UnitAniState.critStart:
        _critStart();
        break;
      case UnitAniState.critEnd:
        _critEnd(dt);
        break;
      case UnitAniState.exitChallenge:
        _exitChallenge();
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
    switch (animationState) {
      case UnitAniState.enterCombat:
        _enterCombat();
        break;
      case UnitAniState.challenge:
        if (_challenge()) {
          animationState = UnitAniState.dodgeStart;
        }
        break;
      case UnitAniState.dodgeStart:
        if (_dodge(dt)) {
          animationState = UnitAniState.counter;
        }
        break;
      case UnitAniState.counter:
        _counter();
        break;
      case UnitAniState.exitChallenge:
        _exitChallenge();
        break;
      case UnitAniState.exitCombat:
        _exitCombat(unit.position);
        break;
      default:
        _idle(unit.position);
    }
  }

  void animateCounteredAttack(double dt) {
    switch (animationState) {
      case UnitAniState.enterCombat:
        _enterCombat();
        break;
      case UnitAniState.challenge:
        if (_challenge()) {
          animationState = UnitAniState.attack;
        }
        break;
      case UnitAniState.attack:
        _missedAttack(dt);
        break;
      case UnitAniState.counteredAttack:
        _counteredAttack(dt);

        break;
      case UnitAniState.exitChallenge:
        _exitChallenge();
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
    switch (animationState) {
      case UnitAniState.enterCombat:
        _enterCombat();
        break;
      case UnitAniState.challenge:
        if (_challenge()) {
          animationState = UnitAniState.lethal;
        }
        break;
      case UnitAniState.lethal:
        _lethal(dt);
        break;
      case UnitAniState.exitChallenge:
        _exitChallenge();
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
    switch (animationState) {
      case UnitAniState.enterCombat:
        _enterCombat();
        break;
      case UnitAniState.challenge:
        if (_challenge()) {
          animationState = UnitAniState.staggeredAttack;
        }
        break;
      case UnitAniState.staggeredAttack:
        _staggeredAttack(dt);
        break;
      case UnitAniState.exitChallenge:
        _exitChallenge();
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
    switch (animationState) {
      case UnitAniState.enterCombat:
        _enterCombat();
        break;
      case UnitAniState.challenge:
        if (_challenge()) {
          animationState = UnitAniState.knockback;
        }
        break;
      case UnitAniState.knockback:
        _knockback(dt);

        break;

      case UnitAniState.exitChallenge:
        _exitChallenge();
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
