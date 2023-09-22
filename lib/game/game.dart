import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:skygame_2d/game/helper.dart';
import 'package:skygame_2d/game/trackers.dart';
import 'package:skygame_2d/game/unit.dart';
import 'package:skygame_2d/models/match_unit/unit_assets_ext.dart';
import 'package:skygame_2d/utils.dart/constants.dart';
// import 'package:skygame_2d/main.dart';
import 'package:skygame_2d/utils.dart/enums.dart';

class GameManager {
  static Map<String, Component> spriteList = {};
  // static late SkyGame2D context;
  GameManager();
  // final List<Command> _commandQ = [];

  List<MatchUnit> units = [];
  final List<MatchUnit> brawlQ = [];
  // MatchUnit? prevActive;
  ValueNotifier<List<MatchUnit>> prevBrawlQ = ValueNotifier([]);

  static final Map<MatchPosition, MatchUnit?> _leftField = {};
  static final Map<MatchPosition, MatchUnit?> _rightField = {};
  static Map<MatchPosition, MatchUnit?> field(int ownerID) {
    if (ownerID == Constants.FIRST_PLAYER) {
      return _leftField;
    }
    return _rightField;
  }

  static void setField(int ownerID, MatchPosition position, MatchUnit? unit) {
    if (ownerID == Constants.FIRST_PLAYER) {
      _leftField[position] = unit;
    } else {
      _rightField[position] = unit;
    }
  }

  int turn = 1;
  CombatEventResult currentEvent = CombatEventResult.none;
  List<FXNotation> fxTracker = [];
  List<EventNotation> eventTracker = [];

  // void addToCommandQ(Command command) {
  //   if (!_commandQ.contains(command)) {
  //     _commandQ.add(command);
  //   }
  // }

  void setup() {
    setBrawlQ;
    // state = SceneState.combat;
  }

  MatchUnit get active {
    if (brawlQ.isEmpty) setBrawlQ;
    return brawlQ.first;
  }

  void get _resetBrawlQ {
    brawlQ.addAll(GameManager.executionOrder(units));
    turn += 1;
  }

  void get _updateBrawlQ {
    if (!MatchHelper.isFrontrow(brawlQ[1].position)) {
      brawlQ.removeAt(0);
      updateActive;
    } else {
      prevBrawlQ.value = List.from(brawlQ);
      brawlQ.removeAt(0);
    }
  }

  void get setBrawlQ {
    int? lastActiveID;
    if (brawlQ.isNotEmpty) {
      lastActiveID = active.id;
    }
    brawlQ.clear();
    brawlQ.addAll(units);
    brawlQ.sort((a, b) => b.current.stats[StatType.execution]
        .compareTo(a.current.stats[StatType.execution]));
    MatchUnit? lastFrontrow;
    if (lastActiveID != null) {
      while (active.id != lastActiveID) {
        if (MatchHelper.isFrontrow(active.position)) {
          lastFrontrow = active;
        }
        brawlQ.removeAt(0);
      }
    }
    brawlQ.removeWhere((e) => !MatchHelper.isFrontrow(e.position));

    final prevList = [
      lastFrontrow ??
          brawlQ.lastWhere((e) => MatchHelper.isFrontrow(e.position))
    ];
    prevList.addAll(brawlQ);
    prevBrawlQ.value = prevList;
  }

  void get updateActive {
    if (brawlQ.length > 1) {
      _updateBrawlQ;
    } else {
      _resetBrawlQ;
      _updateBrawlQ;
    }
  }

  static List<MatchUnit> executionOrder(List<MatchUnit> evaluatedList) {
    final result = List<MatchUnit>.from(evaluatedList)
        .where((e) => MatchHelper.isFrontrow(e.position))
        .toList();
    result.sort((a, b) => b.current.stats[StatType.execution]
        .compareTo(a.current.stats[StatType.execution]));
    return result;
  }

  void updateField(double dt) {
    for (var unit in units) {
      if (unit.position == MatchPosition.defeated) continue;
      if (unit.current.stats[StatType.hp] == 0 &&
          unit.position != MatchPosition.defeated) {
        // Updated Points
        // if (player1.owner == unit.owner) {
        //   player2.points += MatchHelper.getUnitPoints(unit.type);
        // } else {
        //   player1.points += MatchHelper.getUnitPoints(unit.type);
        // }

        // if (player1.points >= 9 || player2.points >= 9) {
        //   state = SceneState.end;
        //   return;
        // }

        // // Replacement Selection Menu
        // if (unit.owner == player1.owner) {
        //   player1.toBeReplaced = unit;
        //   player1.state = PlayerState.waiting;
        // } else {
        //   player2.toBeReplaced = unit;
        //   player2.state = PlayerState.waiting;
        // }
        // state = SceneState.replace;
      }
      unit.resetLiveStatus;
    }
  }

  void updateFieldForSwap(double dt, MatchUnit user, MatchUnit secondary) {
    final MatchPosition temp = secondary.position;

    setField(user.ownerID, user.position, null);
    setField(user.ownerID, secondary.position, null);

    secondary.position = user.position;
    user.position = temp;

    setField(user.ownerID, secondary.position, secondary);
    setField(user.ownerID, user.position, user);

    // update assets
  }

  void cleanup(double dt) {
    for (var unit in units) {
      unit.asset.refresh();
    }
  }
}
