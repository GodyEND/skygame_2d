import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:skygame_2d/bloc/player/state.dart';
import 'package:skygame_2d/game/unit.dart';
import 'package:skygame_2d/models/enums.dart';

class GameBlocState extends Equatable {
  final List<PlayerBlocState> playerStates;
  final GameState gameState; // Based of active unit actionQ
  final List<MatchUnit> units;

// Combat
  final int turn;
  final List<MatchUnit> exeQ;
  final ValueNotifier<List<MatchUnit>> prevExeQ;

  const GameBlocState({
    required this.playerStates,
    required this.gameState,
    required this.units,
    required this.turn,
    required this.exeQ,
    required this.prevExeQ,
  });

  GameBlocState copyWith({
    GameState? cGameState,
    int? cTurn,
  }) {
    return GameBlocState(
      playerStates: playerStates,
      gameState: cGameState ?? gameState,
      units: units,
      turn: cTurn ?? turn,
      exeQ: exeQ,
      prevExeQ: prevExeQ,
    );
  }

  @override
  List<Object?> get props => [
        playerStates,
        gameState,
        turn,
        units,
        exeQ,
        prevExeQ,
      ];
}

class InitialGameBlocState extends GameBlocState {
  InitialGameBlocState(List<PlayerBlocState> playerStates)
      : super(
          playerStates: playerStates,
          turn: 1,
          units: const [],
          gameState: GameState.setup,
          exeQ: const [],
          prevExeQ: ValueNotifier([]),
        );
}
