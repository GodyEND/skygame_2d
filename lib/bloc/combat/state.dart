import 'package:equatable/equatable.dart';
import 'package:skygame_2d/bloc/events.dart';
import 'package:skygame_2d/bloc/player/state.dart';
import 'package:skygame_2d/game/helper.dart';
import 'package:skygame_2d/game/stage.dart';
import 'package:skygame_2d/game/trackers.dart';
import 'package:skygame_2d/game/unit.dart';
import 'package:skygame_2d/models/player.dart';
import 'package:skygame_2d/utils.dart/enums.dart';

class CombatBlocState extends Equatable {
  final CombatState combatState; // Based of active unit actionQ
  final MatchUnit? attacker;
  final MatchUnit? defender;
// Combat
  final int turn;
  final List<MatchUnit> exeQ;
  final CombatEventResult combatEvent;
  // Management
  final Stage stage;
  final List<Player> players;
  final Map<int, Map<MatchPosition, MatchUnit?>> field;
  final List<FXNotation> fxTracker;
  final BlocEvent? event;

  const CombatBlocState({
    required this.combatState,
    required this.combatEvent,
    required this.turn,
    required this.exeQ,
    this.attacker,
    this.defender,
    required this.stage,
    required this.players,
    required this.field,
    required this.fxTracker,
    this.event,
  });

  CombatBlocState copyWith({
    CombatState? cCombatState,
    CombatEventResult? cCombatEvent,
    int? cTurn,
    MatchUnit? cAttacker,
    MatchUnit? cDefender,
    bool clearAttacker = false,
    bool clearDefender = false,
    Map<int, Map<MatchPosition, MatchUnit?>>? cField,
    List<MatchUnit>? cExeQ,
    List<FXNotation>? cFXTracker,
    BlocEvent? cEvent,
  }) {
    return CombatBlocState(
      combatState: cCombatState ?? combatState,
      combatEvent: cCombatEvent ?? combatEvent,
      turn: cTurn ?? turn,
      exeQ: cExeQ ?? exeQ,
      attacker: cAttacker ?? ((clearAttacker) ? null : attacker),
      defender: cDefender ?? ((clearDefender) ? null : defender),
      stage: stage,
      players: players,
      field: cField ?? field,
      fxTracker: cFXTracker ?? fxTracker,
      event: cEvent,
    );
  }

  @override
  List<Object?> get props => [
        combatState,
        turn,
        exeQ,
        attacker,
        defender,
        stage,
        players,
        field,
        fxTracker,
        event,
      ];

  List<MatchUnit> get allUnits {
    List<MatchUnit> results = [];
    for (var player in players) {
      results.addAll(MatchHelper.getUnits(player.ownerID, this));
    }
    return results;
  }
}

class InitialCombatBlocState extends CombatBlocState {
  InitialCombatBlocState({
    required List<Player> players,
    required List<PlayerBlocState> playerStates,
    required Stage stage,
  }) : super(
          turn: 1,
          combatState: CombatState.attack,
          combatEvent: CombatEventResult.none,
          exeQ: generateExeQ(players),
          players: players,
          stage: stage,
          field: generateField(players, playerStates),
          fxTracker: const [],
        );
}

Map<int, Map<MatchPosition, MatchUnit?>> generateField(
  List<Player> players,
  List<PlayerBlocState> playerStates,
) {
  Map<int, Map<MatchPosition, MatchUnit?>> fieldMap = {};

  for (var player in players) {
    fieldMap[player.ownerID] = playerStates
        .firstWhere((e) => e.player.ownerID == player.ownerID)
        .roster;
  }
  return fieldMap;
}

List<MatchUnit> generateExeQ(
  List<Player> players,
) {
  List<MatchUnit> result = [];
  for (var player in players) {
    result.addAll(List<MatchUnit>.from((player.matchFormation
        .where((e) =>
            MatchHelper.isFrontrow(e?.position ?? MatchPosition.defeated))
        .toList())));
  }
  result.sort((a, b) => b.current.stats[StatType.execution]
      .compareTo(a.current.stats[StatType.execution]));
  return result;
}
