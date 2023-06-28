import 'package:equatable/equatable.dart';
import 'package:skygame_2d/models/player.dart';
import 'package:skygame_2d/utils.dart/enums.dart';
import 'package:skygame_2d/models/match_unit/unit.dart';
import 'package:skygame_2d/utils.dart/constants.dart';

class TeamBuilderBlocState extends Equatable {
  final Player player;
  final List<UnitTeam> teams;
  final UnitTeam selectedUnits;
  final List<Unit> collection;
  final TeamBuilderViewState viewState;
  final int selectedIndex;

  const TeamBuilderBlocState({
    required this.player,
    required this.teams,
    required this.selectedUnits,
    required this.collection,
    required this.viewState,
    required this.selectedIndex,
  });

  TeamBuilderBlocState copyWith({
    List<UnitTeam>? cTeams,
    UnitTeam? cSelectedUnits,
    List<Unit>? cCollection,
    TeamBuilderViewState? cViewState,
    int? cSelectedIndex,
  }) {
    return TeamBuilderBlocState(
      player: player,
      teams: cTeams ?? teams,
      selectedUnits: cSelectedUnits ?? selectedUnits,
      collection: cCollection ?? collection,
      viewState: cViewState ?? viewState,
      selectedIndex: cSelectedIndex ?? selectedIndex,
    );
  }

  @override
  List<Object?> get props => [
        player,
        teams,
        selectedUnits,
        collection,
        viewState,
        selectedIndex,
      ];
}

class InitialTeamBuilderBlocState extends TeamBuilderBlocState {
  InitialTeamBuilderBlocState(Player player)
      : super(
          player: player,
          teams: player.teams,
          selectedUnits:
              UnitTeam(player.teams.length + 1), // TODO: get unused id
          collection: player.collection,
          viewState: TeamBuilderViewState.team,
          selectedIndex: 0,
        );
}

class EditNewTeamBuilderBlocState extends TeamBuilderBlocState {
  EditNewTeamBuilderBlocState(TeamBuilderBlocState state)
      : super(
          player: state.player,
          teams: state.teams,
          selectedUnits: UnitTeam(state.teams.length + 1),
          collection: state.collection,
          viewState: TeamBuilderViewState.builder,
          selectedIndex: 0,
        );
}

class EditTeamBuilderBlocState extends TeamBuilderBlocState {
  EditTeamBuilderBlocState(TeamBuilderBlocState state, UnitTeam team)
      : super(
          player: state.player,
          teams: state.teams,
          selectedUnits: UnitTeam(team.id, list: team.toList()),
          collection: state.collection,
          viewState: TeamBuilderViewState.builder,
          selectedIndex: 0,
        );
}
