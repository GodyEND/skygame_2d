import 'dart:math';
import 'package:skygame_2d/game/unit.dart';
import 'package:skygame_2d/game/game.dart';
import 'package:skygame_2d/models/enums.dart';
import 'package:skygame_2d/utils.dart/constants.dart';

class Simulator {
  static double elementalFactor(Element attacker, Element defender) {
    if ((attacker == Element.white && defender == Element.black) ||
        (attacker == Element.black && defender == Element.white) ||
        (attacker == Element.red && defender == Element.green) ||
        (attacker == Element.green && defender == Element.blue) ||
        (attacker == Element.green && defender == Element.brown) ||
        (attacker == Element.blue && defender == Element.red) ||
        (attacker == Element.blue && defender == Element.brown) ||
        (attacker == Element.brown && defender == Element.purple) ||
        (attacker == Element.brown && defender == Element.yellow) ||
        (attacker == Element.purple && defender == Element.green) ||
        (attacker == Element.yellow && defender == Element.blue)) {
      return 1.5;
    }
    if ((attacker == defender && attacker != Element.grey) ||
        (attacker == Element.red && defender == Element.blue) ||
        (attacker == Element.green && defender == Element.red) ||
        (attacker == Element.green && defender == Element.purple) ||
        (attacker == Element.blue && defender == Element.green) ||
        (attacker == Element.blue && defender == Element.yellow) ||
        (attacker == Element.brown && defender == Element.green) ||
        (attacker == Element.brown && defender == Element.blue) ||
        (attacker == Element.purple && defender == Element.brown) ||
        (attacker == Element.yellow && defender == Element.brown)) {
      return 1 / 1.5;
    }
    return 1.0;
  }

  static CombatEventResult combatEventResult(GameManager game) {
    final attacker = game.active;
    final defender = game.field[attacker.target]!;
    CombatEventResult result = CombatEventResult.hit;
    // Check for Hit
    double hitChance = attacker.current.bes.values[BESType.hit]! -
        defender.current.bes.values[BESType.evasion]!;
    if (hitChance <= 0) {
      result = CombatEventResult.dodge;
    } else if (hitChance < 100) {
      // Check for Dodge
      final rng = Random().nextInt(100);
      if (rng > hitChance) {
        result = CombatEventResult.dodge;
      }
    }
    // Check for Counter
    if (result == CombatEventResult.dodge) {
      final counterChance = defender.current.bes.values[BESType.counter]!;
      final rng = Random().nextInt(100);
      if (rng <= counterChance) {
        return CombatEventResult.counter;
      }
    }
    // Check for Crit
    final critChance = attacker.current.bes.values[BESType.crit]! -
        defender.current.bes.values[BESType.critResist]!;
    if (critChance > 0) {
      final rng = Random().nextInt(100);
      if (rng <= critChance) {
        result = CombatEventResult.crit;
      }
    }

// Check Lethality
    final lethality = attacker.current.bes.values[BESType.lethality]!;
    if (result == CombatEventResult.crit && lethality > 10) {
      final lethalChance = log(lethality) * 0.1;
      final rng = Random().nextDouble() * 100;
      if (rng <= lethalChance) {
        return CombatEventResult.lethal;
      }
    }

    // Check for Block
    final blockChance = defender.current.bes.values[BESType.block]! -
        defender.current.bes.values[BESType.force]!;
    if (blockChance > 0) {
      final rng = Random().nextInt(100);
      if (rng < blockChance) {
        result = CombatEventResult.block;
      }
    }
    // Check for Stagger
    final blockMastery = defender.current.bes.values[BESType.blockMastery]!;
    if (result == CombatEventResult.block && blockMastery > 0) {
      final rng = Random().nextDouble() * 100;
      final staggerChance =
          max(0, blockMastery - attacker.current.bes[BESType.force]);
      if (rng <= staggerChance) {
        return CombatEventResult.stagger;
      }
    }

    // Check for Knockback
    final knockback = attacker.current.bes.values[BESType.force]!;
    if (result == CombatEventResult.block && knockback > 0) {
      final rng = Random().nextDouble() * 100;
      final knockbackChance =
          max(0, knockback - attacker.current.bes[BESType.blockMastery]);

      if (rng <= knockbackChance) {
        return CombatEventResult.overwhelm;
      }
    }
    return result;
  }

  static void calculateDamage(
      GameManager game, MatchUnit attacker, MatchUnit defender) {
    attacker.incomingDamage = 0;
    defender.incomingDamage = 0;
    switch (game.currentEvent) {
      case CombatEventResult.hit:
        final acc = attacker.current.bes.values[BESType.hit]!.toInt();
        final rng = Random().nextInt(acc);
        final eva = defender.current.bes.values[BESType.evasion]!.toInt();
        final evaRNG = Random().nextInt(eva);
        final evasiveness = 0.1 * evaRNG / 100;
        final double accuracyFactor =
            min(1.0, max(1 - evasiveness + evasiveness * rng / 100, 0.85));
        defender.incomingDamage =
            _damageFormula(attacker, defender, accuracyFactor: accuracyFactor);
        break;
      case CombatEventResult.crit:
        final critPow = attacker.current.bes.values[BESType.lethality]!.toInt();
        final rng = critPow > 0 ? Random().nextInt(critPow) : 0;
        final double critFactor = 1.2 + rng / 100;
        defender.incomingDamage =
            _damageFormula(attacker, defender, critFactor: critFactor);
        break;
      case CombatEventResult.lethal:
        defender.incomingDamage =
            defender.current.stats.values[StatType.hp]!.toInt();
        break;
      case CombatEventResult.counter:
        final acc = defender.current.bes.values[BESType.hit]!.toInt();
        final rng = Random().nextInt(acc);
        final eva = attacker.current.bes.values[BESType.evasion]!.toInt();
        final evaRNG = Random().nextInt(eva);
        final evasiveness = 0.5 * evaRNG / 100;
        final double accuracyFactor =
            min(1.0, max(1 - evasiveness + evasiveness * rng / 100, 0.9));
        attacker.incomingDamage =
            _damageFormula(defender, attacker, accuracyFactor: accuracyFactor);
        break;
      case CombatEventResult.block:
      case CombatEventResult.stagger:
      case CombatEventResult.overwhelm:
        final blockMod = (game.currentEvent == CombatEventResult.stagger)
            ? 1.2
            : (game.currentEvent == CombatEventResult.overwhelm)
                ? 1 / 1.2
                : 1;
        final blockPow =
            (attacker.current.bes.values[BESType.blockMastery]! * blockMod)
                .toInt();

        final rng = blockPow > 0 ? Random().nextInt(blockPow) : 0;
        final double blockFactor = 1 / (1.2 + rng / 100);
        defender.incomingDamage =
            _damageFormula(attacker, defender, blockFactor: blockFactor);
        break;
      default:
        break;
    }
  }

  static setCharge(GameManager game, MatchUnit attacker, MatchUnit defender) {
    attacker.incomingCharge = 0;
    defender.incomingCharge = 0;

    switch (game.currentEvent) {
      case CombatEventResult.hit:
        final charge = attacker.current.stats[StatType.charge].toInt();
        attacker.incomingCharge = charge;
        attacker.current.stats.values[StatType.storage] =
            (attacker.current.stats[StatType.storage].toInt() + charge)
                .toDouble();
        break;
      case CombatEventResult.counter:
        final charge = defender.current.stats[StatType.charge].toInt();
        defender.incomingCharge = charge;
        defender.current.stats.values[StatType.storage] =
            (defender.current.stats[StatType.storage].toInt() + charge)
                .toDouble();
        break;
      case CombatEventResult.crit:
      case CombatEventResult.lethal:
        final charge = (attacker.current.stats[StatType.charge] *
                ((game.currentEvent == CombatEventResult.crit) ? 1.5 : 2))
            .toInt();
        attacker.incomingCharge = charge;
        attacker.current.stats.values[StatType.storage] =
            (attacker.current.stats[StatType.storage].toInt() + charge)
                .toDouble();
        break;
      case CombatEventResult.block:
      case CombatEventResult.overwhelm:
      case CombatEventResult.stagger:
        final chargeA = (attacker.current.stats[StatType.charge] * 0.5).toInt();
        attacker.incomingCharge = chargeA;
        attacker.current.stats.values[StatType.storage] =
            (attacker.current.stats[StatType.storage].toInt() + chargeA)
                .toDouble();

        final chargeFactor = (game.currentEvent == CombatEventResult.block)
            ? 0.25
            : (game.currentEvent == CombatEventResult.stagger)
                ? 0.25 * 1.5
                : 0.25 / 1.5;
        final chargeD =
            (defender.current.stats[StatType.charge] * chargeFactor).toInt();
        if (game.currentEvent == CombatEventResult.stagger) {}
        defender.incomingCharge = chargeD;
        defender.current.stats.values[StatType.storage] =
            (defender.current.stats[StatType.storage].toInt() + chargeD)
                .toDouble();
        break;
      default:
        break;
    }
  }

  static int _damageFormula(MatchUnit attacker, MatchUnit defender,
      {double critFactor = 1.0,
      double blockFactor = 1.0,
      double accuracyFactor = 1.0,
      double mod = 1.0}) {
    final elementalFactor = Simulator.elementalFactor(
        attacker.character.element, defender.character.element);

    final attackerCS = attacker.current.stats[StatType.storage];
    final attackerS = attacker.initial.stats[StatType.storage];
    final double storageBonus = attackerCS > attackerS
        ? pow(1.1, attackerCS / attackerS).toDouble()
        : 1;
    final atk = attacker.current.stats[StatType.attack] * storageBonus;
    final dmg = ((Constants.BASE_DAMAGE *
                atk /
                defender.current.stats[StatType.defense]) *
            accuracyFactor *
            critFactor *
            blockFactor *
            elementalFactor *
            mod)
        .toInt();
    return max(dmg, 1);
  }

  static void applyEvent(
      CombatEventResult event, MatchUnit attacker, MatchUnit defender) {
    switch (event) {
      case CombatEventResult.stagger:
      case CombatEventResult.overwhelm:
      default:
        break;
    }
  }
}
