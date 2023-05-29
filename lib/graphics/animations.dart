import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:skygame_2d/game/game.dart';
import 'package:skygame_2d/game/unit.dart';
import 'package:skygame_2d/graphics/graphics.dart';
import 'package:skygame_2d/graphics/unit_animations.dart';
import 'package:skygame_2d/models/enums.dart';
import 'package:skygame_2d/utils.dart/constants.dart';

class AnimationsManager {
  static void animateEventText(double dt, CombatEventResult event) {
    // Setup Animation
    final sprite = GameManager.spriteList[EVENT_TEXT]! as TextComponent;
    sprite.text = event.name.toUpperCase();
    sprite.scale = Vector2.all(0.0);
    sprite.position = Constants.SCREEN_CENTER + Vector2(0, 50);
    // Fire animation
    final scaleEff = ScaleEffect.to(
        Vector2.all(1),
        DelayedEffectController(EffectController(duration: 1 / (32 * dt)),
            delay: dt * 5));
    final moveEff = MoveEffect.by(
        Vector2(0, -28),
        DelayedEffectController(EffectController(duration: 1 / (32 * dt)),
            delay: dt * 5));
    sprite.add(scaleEff);
    sprite.add(moveEff);
  }

  static Future<void> fireDamage(
    double dt, {
    required MatchUnit unit,
    required Vector2 startPos,
    required int damage,
  }) async {
    final sprite = GraphicsManager.createDamageText;
    sprite.text = '$damage DMG';
    sprite.position = startPos;
    unit.game.gameContext.add(sprite);

    final effectDuration = 0.04 / dt;
    final controller = EffectController(duration: effectDuration);
    sprite.add(ScaleEffect.to(Vector2.all(1), controller));
    sprite.add(MoveEffect.to(startPos + Vector2(0, -35), controller));
    sprite.add(RemoveEffect(delay: effectDuration));
  }

  static Future<void> fireCharge(
    double dt, {
    required MatchUnit unit,
    required Vector2 startPos,
    required int charge,
  }) async {
    final sprite = GraphicsManager.createChargeText;
    sprite.text = '$charge';
    sprite.position = startPos;
    unit.game.gameContext.add(sprite);

    final effectDuration = 0.04 / dt;
    final controller = EffectController(duration: effectDuration);
    sprite.add(ScaleEffect.to(Vector2.all(1), controller));
    sprite.add(MoveEffect.to(startPos + Vector2(0, -25), controller));
    sprite.add(RemoveEffect(delay: effectDuration));
  }

  static prepareCombat(MatchUnit attacker, MatchUnit defender) {
    attacker.asset.sprite.priority = 3;
    attacker.asset.animationState.value = UnitAniState.enterCombat;
    defender.asset.sprite.priority = 2;
    defender.asset.animationState.value = UnitAniState.enterCombat;
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

  static void animateCombat(double dt, CombatEventResult event, MatchUnit unit,
      {bool isAttacker = true}) {
    if (unit.asset.animationState.value == UnitAniState.end ||
        unit.asset.animationState.value == UnitAniState.idle) {
      return;
    }
    if (isAttacker) {
      switch (event) {
        case CombatEventResult.hit:
        case CombatEventResult.dodge:
        case CombatEventResult.crit:
        case CombatEventResult.lethal:
        case CombatEventResult.block:
        case CombatEventResult.overwhelm:
          unit.asset.animateAttack(dt);
          break;
        case CombatEventResult.counter:
          unit.asset.animateCounteredAttack(dt);
          break;
        case CombatEventResult.stagger:
          unit.asset.animateStaggeredAttack(dt);
          break;
        default:
          break;
      }
    } else {
      switch (event) {
        case CombatEventResult.hit:
          unit.asset.animateHit(dt);
          break;
        case CombatEventResult.dodge:
          unit.asset.animateDodge(dt);
          break;
        case CombatEventResult.counter:
          unit.asset.animateCounter(dt);
          break;
        case CombatEventResult.crit:
          unit.asset.animateCriticalHit(dt);
          break;
        case CombatEventResult.lethal:
          unit.asset.animateLethalHit(dt);

          break;
        case CombatEventResult.block:
        case CombatEventResult.stagger:
          unit.asset.animateBlock(dt);
          break;
        case CombatEventResult.overwhelm:
          unit.asset.animatePushback(dt);
          break;
        default:
          break;
      }
    }
  }
}
