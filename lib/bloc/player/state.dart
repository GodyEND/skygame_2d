import 'package:equatable/equatable.dart';
import 'package:skygame_2d/bloc/events.dart';
import 'package:skygame_2d/game/unit.dart';
import 'package:skygame_2d/utils.dart/enums.dart';

class PlayerBlocState extends Equatable {
  final int ownerID;
  final PlayerState state;
  final int points;
  final List<MatchUnit> units;
  final Map<MatchPosition, MatchUnit> roster;
  final List<MatchPosition> toBeReplaced;
  final BlocEvent? event;

  const PlayerBlocState({
    required this.ownerID,
    required this.state,
    required this.points,
    required this.units,
    required this.roster,
    required this.toBeReplaced,
    required this.event,
  });

  PlayerBlocState copyWith({
    PlayerState? cState,
    int? cPoints,
    Map<MatchPosition, MatchUnit>? cRoster,
    BlocEvent? cEvent,
  }) {
    return PlayerBlocState(
      ownerID: ownerID,
      state: cState ?? state,
      points: cPoints ?? points,
      units: units,
      roster: cRoster ?? roster,
      toBeReplaced: toBeReplaced,
      event: cEvent,
    );
  }

  @override
  List<Object?> get props => [
        ownerID,
        state,
        points,
        units,
        roster,
        toBeReplaced,
        event,
      ];
}

class InitialPlayerBlocState extends PlayerBlocState {
  const InitialPlayerBlocState(int ownerID)
      : super(
          ownerID: ownerID,
          state: PlayerState.waiting,
          points: 0,
          units: const [],
          roster: const {},
          toBeReplaced: const [],
          event: null,
        );
}

class PlayerReadyBlocState extends PlayerBlocState {
  PlayerReadyBlocState({
    required Map<MatchPosition, MatchUnit> roster,
    required int ownerID,
  }) : super(
          ownerID: ownerID,
          state: (roster.values.length > 9)
              ? PlayerState.ready
              : PlayerState.waiting,
          points: 0,
          units: const [],
          roster: Map.from(roster),
          toBeReplaced: const [],
          event: (roster.values.length > 9) ? PlayerTeamReadyEvent() : null,
        );
}
