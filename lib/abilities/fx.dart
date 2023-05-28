import 'dart:math';

import 'package:skygame_2d/game/helper.dart';
import 'package:skygame_2d/game/unit.dart';
import 'package:skygame_2d/game/game.dart';
import 'package:skygame_2d/game/trackers.dart';
import 'package:skygame_2d/models/enums.dart';
import 'package:skygame_2d/models/fx.dart';
import 'package:skygame_2d/utils.dart/extensions.dart';

class FX1 extends FX {
  FX1()
      : super(
          'Body of Water',
          text: 'Once per game, if this character would be'
              ' defeated reduce the incoming damage to 0.',
          type: FXType.finale,
        );

  @override
  void action(MatchUnit user, GameManager game) {
    final notation = game.fxTracker.firstWhereOrNull(
        (e) => e.fx == this && e.userID == user.id && e.targetID == -1);
    if (notation != null) return;
    user.incomingDamage = 0;
    game.fxTracker.add(FXNotation(this, user.id, -1, game.turn));
  }
}

class FX2 extends FX {
  FX2()
      : super(
          'Chaos Zone',
          text: 'Guard & Evasion decreases.',
          type: FXType.aura,
        );

  @override
  void action(MatchUnit user, GameManager game) {
    final targets = game.units;
    final notation = game.fxTracker.firstWhereOrNull(
        (e) => e.fx == this && e.userID == user.id && e.targetID == -1);
    if (notation != null) return;
    for (var target in targets) {
      target.currentBES.values[BESType.block] =
          target.currentBES.values[BESType.block]! - 25;
      target.currentBES.values[BESType.evasion] =
          target.currentBES.values[BESType.evasion]! - 25;
    }
    game.fxTracker.add(FXNotation(this, user.id, -1, game.turn));
  }
}

class FX3 extends FX {
  FX3()
      : super(
          'Pressure',
          text: 'Decrease opposing Units Power by 50.',
          type: FXType.entry,
        );

  @override
  void action(MatchUnit user, GameManager game) {
    // NOTE: Do not know if this needs to be tracked
    final targets = MatchHelper.getOpposingUnits(game.field, user.owner);
    for (var target in targets) {
      target.currentStats.values[StatType.storage] =
          max(0.0, target.currentStats[StatType.storage] - 50);
    }
  }
}

class FX4 extends FX {
  FX4()
      : super(
          'Secure',
          text: 'Every 2 Turns restore 30 Vit and Charge.',
          type: FXType.link,
        );

  @override
  void action(MatchUnit user, GameManager game) {
    final targets = game.field[user.position]?.links;
    if (targets == null) return;
    if (targets.isEmpty) return;
    for (var link in targets) {
      final target = game.field[link]!;
      final notation = game.fxTracker.firstWhereOrNull((e) =>
          e.fx == this && e.userID == user.id && e.targetID == target.id);
      if (notation != null && notation.turn + 2 < game.turn) {
        continue;
      } else if (notation != null) {
        game.fxTracker.remove(notation);
      }
      target.currentStats.values[StatType.hp] = min(
          target.currentStats[StatType.hp] + 30,
          target.iStats[StatType.hp] + 30);
      target.currentStats.values[StatType.storage] =
          target.currentStats[StatType.storage] + 30;
      game.fxTracker.add(FXNotation(this, user.id, target.id, game.turn));
    }
  }
}

class FX5 extends FX {
  FX5()
      : super(
          'Motorise',
          text: 'Execution increase by 50.',
          type: FXType.link,
        );

  @override
  void action(MatchUnit user, GameManager game) {
    final targets = game.field[user.position]?.links;
    if (targets == null) return;
    if (targets.isEmpty) return;
    for (var link in targets) {
      final target = game.field[link]!;
      final notation = game.fxTracker.firstWhereOrNull((e) =>
          e.fx == this && e.userID == user.id && e.targetID == target.id);
      if (notation != null) continue;
      target.currentStats.values[StatType.execution] =
          target.currentStats[StatType.execution] + 50.0;
      game.fxTracker.add(FXNotation(this, user.id, target.id, game.turn));
    }
  }
}
