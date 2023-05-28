import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:skygame_2d/game/game.dart';
import 'package:skygame_2d/game/unit.dart';
import 'package:skygame_2d/graphics/graphics.dart';
import 'package:skygame_2d/graphics/unit_animations.dart';
import 'package:skygame_2d/models/enums.dart';

class AnimationsManager {
  static void resetEventText(CombatEventResult event) {
    final sprite = GameManager.spriteList[EVENT_TEXT]! as TextComponent;
    sprite.text = event.name.toUpperCase();
    sprite.scale = Vector2.all(0.0);
    sprite.position = Vector2(960, 750);
  }

  static void animateEventText(double dt, UnitAniState combatantState) {
    final sprite = GameManager.spriteList[EVENT_TEXT]! as TextComponent;

    if (combatantState != UnitAniState.idle &&
        combatantState != UnitAniState.enterCombat &&
        combatantState != UnitAniState.challenge) {
      if (sprite.scale.x < 1) {
        final scaleUpdate = min(1.0, sprite.scale.x + 2 * dt);
        sprite.scale = Vector2.all(scaleUpdate);
        if (sprite.position.y > 700) {
          sprite.position.y -= 3;
        }
      }
    } else {
      sprite.scale = Vector2.all(0);
    }
  }

  static prepareCombat(MatchUnit attacker, MatchUnit defender) {
    attacker.asset.animationState = UnitAniState.enterCombat;
    attacker.asset.sprite.priority = 2;
    defender.asset.animationState = UnitAniState.enterCombat;
    defender.asset.sprite.priority = 1;
  }

  static prepareSwap(MatchUnit user, MatchUnit swapped) {
    final userTargetPos = swapped.asset.sprite.position;
    final swappedTargetPos = user.asset.sprite.position;

    // TODO: set ani state to rundown / up
    final controller = EffectController(
        duration: 1.5); // TODO: on complete listener triger swap HUD
    final userAni = MoveEffect.to(userTargetPos, controller);
    user.asset.sprite.add(userAni);
    final swappedAni = MoveEffect.to(swappedTargetPos, controller);
    swapped.asset.sprite.add(swappedAni);
  }

  static prepareRetreat(MatchUnit user, MatchUnit swapped) {}

  static void animateCombat(CombatEventResult event, MatchUnit attacker,
      MatchUnit defender, double dt) {
    switch (event) {
      case CombatEventResult.hit:
        attacker.asset.animateAttack(dt);
        defender.asset.animateHit(dt);
        break;
      case CombatEventResult.dodge:
        attacker.asset.animateAttack(dt);
        defender.asset.animateDodge(dt);
        break;
      case CombatEventResult.counter:
        attacker.asset.animateCounteredAttack(dt);
        defender.asset.animateCounter(dt);
        break;
      case CombatEventResult.crit:
        attacker.asset.animateAttack(dt);
        defender.asset.animateCriticalHit(dt);
        break;
      case CombatEventResult.lethal:
        attacker.asset.animateAttack(dt);
        defender.asset.animateLethalHit(dt);

        break;
      case CombatEventResult.block:
        attacker.asset.animateAttack(dt);
        defender.asset.animateBlock(dt);

        break;
      case CombatEventResult.stagger:
        attacker.asset.animateStaggeredAttack(dt);
        defender.asset.animateBlock(dt);

        break;
      case CombatEventResult.knockback:
        attacker.asset.animateBlock(dt);
        defender.asset.animatePushback(dt);
        break;
      default:
        break;
    }
  }
}
