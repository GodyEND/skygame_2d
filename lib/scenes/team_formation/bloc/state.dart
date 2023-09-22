import 'package:equatable/equatable.dart';
import 'package:skygame_2d/bloc/events.dart';
import 'package:skygame_2d/models/match_unit/unit.dart';
import 'package:skygame_2d/models/player.dart';
import 'package:skygame_2d/scenes/team_formation/bloc/event.dart';
import 'package:skygame_2d/utils.dart/enums.dart';

class TeamFormationBlocState extends Equatable {
  final Player player;
  final List<Unit?> team;
  final TeamFormationViewState viewState;
  final BlocEvent? event;
  final List<Unit?> formation;
  final int? editedPosIndex;
  final List<Unit> characterOptions;

  const TeamFormationBlocState({
    required this.player,
    required this.team,
    required this.viewState,
    required this.formation,
    required this.editedPosIndex,
    required this.characterOptions,
    this.event,
  });

  TeamFormationBlocState copyWith({
    Player? cPlayer,
    List<Unit?>? cFormation,
    List<Unit>? cCharacterOptions,
    TeamFormationViewState? cViewState,
    int? cEditedPosIndex,
    BlocEvent? event,
  }) {
    return TeamFormationBlocState(
      player: cPlayer ?? player,
      team: team,
      formation: cFormation ?? formation,
      characterOptions: cCharacterOptions ?? characterOptions,
      viewState: cViewState ?? viewState,
      editedPosIndex: cEditedPosIndex ?? editedPosIndex,
      event: event,
    );
  }

  @override
  List<Object?> get props => [
        player,
        team,
        formation,
        characterOptions,
        viewState,
        editedPosIndex,
        event,
      ];
}

class InitialTeamFormationBlocState extends TeamFormationBlocState {
  InitialTeamFormationBlocState(Player player)
      : super(
          player: player,
          team: player.activeTeam?.toList() ?? [],
          formation: List.filled(5, null),
          characterOptions: List.from(
              player.activeTeam?.toList().where((e) => e != null).toList() ??
                  []),
          viewState: TeamFormationViewState.load,
          editedPosIndex: -1,
        );
}

class ConfirmedCharacterTFState extends TeamFormationBlocState {
  ConfirmedCharacterTFState({
    required TeamFormationBlocState oldState,
    required List<Unit?> formation,
    required List<Unit> characterOptions,
  }) : super(
          player: oldState.player,
          team: oldState.team,
          formation: formation,
          characterOptions: characterOptions,
          viewState: TeamFormationViewState.formation,
          editedPosIndex: null,
          event: ConfirmTFEvent(oldState.player.ownerID),
        );
}
