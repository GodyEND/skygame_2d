import 'package:equatable/equatable.dart';
import 'package:skygame_2d/bloc/events.dart';
import 'package:skygame_2d/bloc/key_input/bloc.dart';
import 'package:skygame_2d/game/unit.dart';
import 'package:skygame_2d/models/player.dart';
import 'package:skygame_2d/utils.dart/enums.dart';

class PlayerBlocState extends Equatable {
  final Player player;
  final BlocEvent? event;
  final PlayerState state;
  final int points;
  final Map<MatchPosition, MatchUnit?> roster;
  final KeyInputBloc keyBloc;

  const PlayerBlocState({
    required this.player,
    required this.state,
    required this.points,
    // required this.units,
    required this.roster,
    // required this.toBeReplaced,
    required this.keyBloc,
    required this.event,
  });

  PlayerBlocState copyWith({
    Player? cPlayer,
    PlayerState? cState,
    int? cPoints,
    Map<MatchPosition, MatchUnit?>? cRoster,
    KeyInputBloc? cKeyBloc,
    BlocEvent? cEvent,
  }) {
    return PlayerBlocState(
      player: cPlayer ?? player,
      // ownerID: ownerID,
      state: cState ?? state,
      points: cPoints ?? points,
      // units: units,
      roster: cRoster ?? roster,
      // toBeReplaced: toBeReplaced,
      keyBloc: cKeyBloc ?? keyBloc,
      event: cEvent,
    );
  }

  @override
  List<Object?> get props => [
        player,
        // ownerID,
        state,
        points,
        // units,
        roster,
        // toBeReplaced,
        keyBloc,
        event,
      ];
}

class InitialPlayerBlocState extends PlayerBlocState {
  const InitialPlayerBlocState(Player player, {required KeyInputBloc keyBloc})
      : super(
          player: player,
          // ownerID: ownerID,
          state: PlayerState.waiting,
          points: 0,
          // units: const [],
          roster: const {},
          // toBeReplaced: const [],
          keyBloc: keyBloc,
          event: null,
        );
}

class PlayerReadyBlocState extends PlayerBlocState {
  PlayerReadyBlocState({
    required Map<MatchPosition, MatchUnit?> roster,
    // required int ownerID,
    required Player player,
    required KeyInputBloc keyBloc,
  }) : super(
          player: player,
          // ownerID: ownerID,
          state: (roster.values.length > 9)
              ? PlayerState.ready
              : PlayerState.waiting,
          points: 0,
          // units: const [],
          roster: Map.from(roster),
          // toBeReplaced: const [],
          keyBloc: keyBloc,
          event: (roster.values.length > 9) ? PlayerTeamReadyEvent() : null,
        );
}
