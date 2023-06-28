import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:skygame_2d/bloc/events.dart';
import 'package:skygame_2d/bloc/player/state.dart';
import 'package:skygame_2d/game/unit.dart';
import 'package:skygame_2d/utils.dart/enums.dart';

class GameBlocState extends Equatable {
  final List<PlayerBlocState> playerStates;
  final SceneState sceneState; // Based of active unit actionQ
  final List<MatchUnit> units;
  final BlocEvent? event;

// Combat
  final int turn;
  final List<MatchUnit> exeQ;
  final ValueNotifier<List<MatchUnit>> prevExeQ;

  const GameBlocState({
    required this.playerStates,
    required this.sceneState,
    required this.units,
    required this.turn,
    required this.exeQ,
    required this.prevExeQ,
    this.event,
  });

  GameBlocState copyWith({
    SceneState? cSceneState,
    int? cTurn,
    BlocEvent? event,
  }) {
    return GameBlocState(
      playerStates: playerStates,
      sceneState: cSceneState ?? sceneState,
      units: units,
      turn: cTurn ?? turn,
      exeQ: exeQ,
      prevExeQ: prevExeQ,
      event: event,
    );
  }

  @override
  List<Object?> get props => [
        playerStates,
        sceneState,
        turn,
        units,
        exeQ,
        prevExeQ,
        event,
      ];
}

class InitialGameBlocState extends GameBlocState {
  InitialGameBlocState(List<PlayerBlocState> playerStates)
      : super(
          playerStates: playerStates,
          turn: 1,
          units: const [],
          sceneState: SceneState.load,
          exeQ: const [],
          prevExeQ: ValueNotifier([]),
        );
}
