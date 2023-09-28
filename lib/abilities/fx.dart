import 'dart:math';

import 'package:skygame_2d/bloc/combat/state.dart';
import 'package:skygame_2d/game/helper.dart';
import 'package:skygame_2d/game/trackers.dart';
import 'package:skygame_2d/game/unit.dart';
import 'package:skygame_2d/models/fx.dart';
import 'package:skygame_2d/utils.dart/enums.dart';
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
  void action(MatchUnit user, CombatBlocState state) {
    final notation = state.fxTracker.firstWhereOrNull(
        (e) => e.fx == this && e.userID == user.id && e.targetID == -1);
    if (notation != null) return;
    user.incomingDamage = 0;
    state.fxTracker.add(FXNotation(this, user.id, -1, state.turn));
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
  void action(MatchUnit user, CombatBlocState state) {
    final targets = state.allUnits;
    final notation = state.fxTracker.firstWhereOrNull(
        (e) => e.fx == this && e.userID == user.id && e.targetID == -1);
    if (notation != null) return;
    for (var target in targets) {
      target.current.bes.values[BESType.block] =
          target.current.bes.values[BESType.block]! - 25;
      target.current.bes.values[BESType.evasion] =
          target.current.bes.values[BESType.evasion]! - 25;
    }
    state.fxTracker.add(FXNotation(this, user.id, -1, state.turn));
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
  void action(MatchUnit user, CombatBlocState state) {
    // NOTE: Do not know if this needs to be tracked
    final targets = MatchHelper.getOpposingUnits(user.ownerID, state);
    for (var target in targets) {
      target.current.stats.values[StatType.storage] =
          max(0.0, target.current.stats[StatType.storage] - 50);
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
  void action(MatchUnit user, CombatBlocState state) {
    final targets = state.field[user.ownerID]?[user.position]?.links;
    if (targets == null) return;
    if (targets.isEmpty) return;
    for (var link in targets) {
      final opponentID = MatchHelper.getOpponent(user.ownerID);
      final target = state.field[opponentID]?[link]!;
      final notation = state.fxTracker.firstWhereOrNull((e) =>
          e.fx == this && e.userID == user.id && e.targetID == target?.id);
      if (notation != null && notation.turn + 2 < state.turn) {
        continue;
      } else if (notation != null) {
        state.fxTracker.remove(notation);
      }
      target?.current.stats.values[StatType.hp] = min(
          target.current.stats[StatType.hp] + 30,
          target.initial.stats[StatType.hp] + 30);
      target?.current.stats.values[StatType.storage] =
          target.current.stats[StatType.storage] + 30;
      state.fxTracker.add(FXNotation(this, user.id, target!.id, state.turn));
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
  void action(MatchUnit user, CombatBlocState state) {
    final targets = state.field[user.ownerID]?[user.position]?.links;

    if (targets == null) return;
    if (targets.isEmpty) return;
    for (var link in targets) {
      final opponentID = MatchHelper.getOpponent(user.ownerID);
      final target = state.field[opponentID]![link]!;
      final notation = state.fxTracker.firstWhereOrNull((e) =>
          e.fx == this && e.userID == user.id && e.targetID == target.id);
      if (notation != null) continue;
      target.current.stats.values[StatType.execution] =
          target.current.stats[StatType.execution] + 50.0;
      state.fxTracker.add(FXNotation(this, user.id, target.id, state.turn));
    }
  }
}
