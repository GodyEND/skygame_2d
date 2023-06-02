import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:skygame_2d/game/helper.dart';
import 'package:skygame_2d/game/stage.dart';
import 'package:skygame_2d/game/trackers.dart';
import 'package:skygame_2d/game/unit.dart';
import 'package:skygame_2d/graphics/graphics.dart';
import 'package:skygame_2d/main.dart';
import 'package:skygame_2d/models/enums.dart';
import 'package:skygame_2d/models/player.dart';
import 'package:skygame_2d/models/unit.dart';
import 'package:skygame_2d/models/unit_assets_ext.dart';
import 'package:skygame_2d/setup.dart';

class GameManager {
  final Player player1 = Player(Owner.p1);
  final Player player2 = Player(Owner.p2);
  late Stage stage;
  static Map<String, Component> spriteList = {};
  final SkyGame2D gameContext;
  GameState state = GameState.setup;
  CombatState combatState = CombatState.attack;
  GameManager(this.gameContext);
  final List<Command> _commandQ = [];

  List<MatchUnit> units = [];
  final List<MatchUnit> brawlQ = [];
  // MatchUnit? prevActive;
  ValueNotifier<List<MatchUnit>> prevBrawlQ = ValueNotifier([]);

  Map<MatchPosition, MatchUnit?> field = {};

  int turn = 1;
  CombatEventResult currentEvent = CombatEventResult.none;
  List<FXNotation> fxTracker = [];
  List<EventNotation> eventTracker = [];

  void addToCommandQ(Command command) {
    if (!_commandQ.contains(command)) {
      _commandQ.add(command);
    }
  }

  void setup() {
    player1.setUnit(this, BrawlType.lead, Unit.fromRAND());
    player1.setUnit(this, BrawlType.leftAce, Unit.fromRAND());
    player1.setUnit(this, BrawlType.rightAce, Unit.fromRAND());
    player1.setUnit(this, BrawlType.leftLink, Unit.fromRAND());
    player1.setUnit(this, BrawlType.rightLink, Unit.fromRAND());
    player1.setUnit(this, BrawlType.reserve1, Unit.fromRAND());
    player1.setUnit(this, BrawlType.reserve2, Unit.fromRAND());
    player1.setUnit(this, BrawlType.reserve3, Unit.fromRAND());

    player2.setUnit(this, BrawlType.lead, Unit.fromRAND());
    player2.setUnit(this, BrawlType.leftAce, Unit.fromRAND());
    player2.setUnit(this, BrawlType.rightAce, Unit.fromRAND());
    player2.setUnit(this, BrawlType.leftLink, Unit.fromRAND());
    player2.setUnit(this, BrawlType.rightLink, Unit.fromRAND());
    player2.setUnit(this, BrawlType.reserve1, Unit.fromRAND());
    player2.setUnit(this, BrawlType.reserve2, Unit.fromRAND());
    player2.setUnit(this, BrawlType.reserve3, Unit.fromRAND());

    stage = Stage('Arcanelle', Sprites.gMaps[0]);
    _prepareUnits();
    (spriteList[SCORE_TEXT]! as TextComponent).text =
        '${player1.points} : ${player2.points}';
    setBrawlQ;
    state = GameState.combat;
  }

  void _prepareUnits() {
    final p1Lead = player1.matchUnits[BrawlType.lead]!;
    p1Lead.asset.addToGame(gameContext);
    field[MatchPosition.p1Lead] = p1Lead;
    final p1LeftAce = player1.matchUnits[BrawlType.leftAce]!;
    p1LeftAce.asset.addToGame(gameContext);
    field[MatchPosition.p1LeftAce] = p1LeftAce;
    final p1RightAce = player1.matchUnits[BrawlType.rightAce]!;
    p1RightAce.asset.addToGame(gameContext);
    field[MatchPosition.p1RightAce] = p1RightAce;
    final p1LeftLink = player1.matchUnits[BrawlType.leftLink]!;
    p1LeftLink.asset.addToGame(gameContext);
    field[MatchPosition.p1LeftLink] = p1LeftLink;
    final p1RightLink = player1.matchUnits[BrawlType.rightLink]!;
    p1RightLink.asset.addToGame(gameContext);
    field[MatchPosition.p1RightLink] = p1RightLink;

    final p2Lead = player2.matchUnits[BrawlType.lead]!;
    p2Lead.asset.addToGame(gameContext);
    field[MatchPosition.p2Lead] = p2Lead;
    final p2LeftAce = player2.matchUnits[BrawlType.leftAce]!;
    p2LeftAce.asset.addToGame(gameContext);
    field[MatchPosition.p2LeftAce] = p2LeftAce;
    final p2RightAce = player2.matchUnits[BrawlType.rightAce]!;
    p2RightAce.asset.addToGame(gameContext);
    field[MatchPosition.p2RightAce] = p2RightAce;
    final p2LeftLink = player2.matchUnits[BrawlType.leftLink]!;
    p2LeftLink.asset.addToGame(gameContext);
    field[MatchPosition.p2LeftLink] = p2LeftLink;
    final p2RightLink = player2.matchUnits[BrawlType.rightLink]!;
    p2RightLink.asset.addToGame(gameContext);
    field[MatchPosition.p2RightLink] = p2RightLink;
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
    if (!MatchHelper.isFrontrow(brawlQ[1].type)) {
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
    brawlQ.sort((a, b) => b.currentStats[StatType.execution]
        .compareTo(a.currentStats[StatType.execution]));
    MatchUnit? lastFrontrow;
    if (lastActiveID != null) {
      while (active.id != lastActiveID) {
        if (MatchHelper.isFrontrow(active.type)) {
          lastFrontrow = active;
        }
        brawlQ.removeAt(0);
      }
    }
    brawlQ.removeWhere((e) => !MatchHelper.isFrontrow(e.type));

    final prevList = [
      lastFrontrow ?? brawlQ.lastWhere((e) => MatchHelper.isFrontrow(e.type))
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
        .where((e) => MatchHelper.isFrontrow(e.type))
        .toList();
    result.sort((a, b) => b.currentStats[StatType.execution]
        .compareTo(a.currentStats[StatType.execution]));
    return result;
  }

  void updateField(double dt) {
    for (var unit in units) {
      if (unit.position == MatchPosition.defeated) continue;
      if (unit.currentStats[StatType.hp] == 0 &&
          unit.position != MatchPosition.defeated) {
        // Updated Points
        if (player1.owner == unit.owner) {
          player2.points += MatchHelper.getUnitPoints(unit.type);
        } else {
          player1.points += MatchHelper.getUnitPoints(unit.type);
        }

        if (player1.points >= 9 || player2.points >= 9) {
          state = GameState.end;
          return;
        }

        // Replacement Selection Menu
        if (unit.owner == player1.owner) {
          player1.toBeReplaced = unit;
          player1.state = PlayerState.waiting;
        } else {
          player2.toBeReplaced = unit;
          player2.state = PlayerState.waiting;
        }
        state = GameState.replace;
      }
      unit.resetLiveStatus;
    }
  }

  void updateFieldForSwap(double dt, MatchUnit user, MatchUnit secondary) {
    final MatchPosition temp = secondary.position;

    field[user.position] = null;
    field[secondary.position] = null;

    secondary.position = user.position;
    user.position = temp;

    field[secondary.position] = secondary;
    field[user.position] = user;

    // update assets
  }

  void cleanup(double dt) {
    (spriteList[SCORE_TEXT]! as TextComponent).text =
        '${player1.points} : ${player2.points}';
    for (var unit in units) {
      unit.asset.refresh();
    }
  }
}
