import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:skygame_2d/game/unit.dart';
import 'package:skygame_2d/utils.dart/enums.dart';

class CombatBlocState extends Equatable {
  final CombatState combatState; // Based of active unit actionQ
  final MatchUnit? attacker;
  final MatchUnit? defender;
// Combat
  final int turn;
  final List<MatchUnit> exeQ;
  final ValueNotifier<List<MatchUnit>> prevExeQ;
  final CombatEventResult combatEvent;

  const CombatBlocState({
    required this.combatState,
    required this.combatEvent,
    required this.turn,
    required this.exeQ,
    required this.prevExeQ,
    this.attacker,
    this.defender,
  });

  CombatBlocState copyWith({
    CombatState? cCombatState,
    CombatEventResult? cCombatEvent,
    int? cTurn,
    MatchUnit? cAttacker,
    MatchUnit? cDefender,
    bool clearAttacker = false,
    bool clearDefender = false,
  }) {
    return CombatBlocState(
      combatState: cCombatState ?? combatState,
      combatEvent: cCombatEvent ?? combatEvent,
      turn: cTurn ?? turn,
      exeQ: exeQ,
      prevExeQ: prevExeQ,
      attacker: cAttacker ?? ((clearAttacker) ? null : attacker),
      defender: cDefender ?? ((clearDefender) ? null : defender),
    );
  }

  @override
  List<Object?> get props => [
        combatState,
        turn,
        exeQ,
        prevExeQ,
      ];
}

class InitialCombatBlocState extends CombatBlocState {
  InitialCombatBlocState()
      : super(
          turn: 1,
          combatState: CombatState.attack,
          combatEvent: CombatEventResult.none,
          exeQ: const [],
          prevExeQ: ValueNotifier([]),
        );
}
