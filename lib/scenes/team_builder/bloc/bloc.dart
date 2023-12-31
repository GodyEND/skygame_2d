import 'package:bloc/bloc.dart';
import 'package:skygame_2d/bloc/events.dart';
import 'package:skygame_2d/scenes/team_builder/bloc/state.dart';
import 'package:skygame_2d/models/match_unit/unit.dart';
import 'package:skygame_2d/models/match_unit/unit_team.dart';
import 'package:skygame_2d/models/player.dart';
import 'package:skygame_2d/utils.dart/enums.dart';
import 'package:skygame_2d/utils.dart/extensions.dart';

class TeamBuilderBloc extends Cubit<TeamBuilderBlocState> {
  TeamBuilderBloc(TeamBuilderBlocState initialState) : super(initialState);

  void initialise() {
    emit(state.copyWith(cViewState: TeamBuilderViewState.team));
  }

  void refresh() {
    emit(state.copyWith(event: EmptyEvent()));
  }

  void clear() {
    emit(state.copyWith());
  }

  void addTeam() {
    emit(state.copyWith(cViewState: TeamBuilderViewState.builder));
  }

  void removeTeam(int index) {
    state.teams.removeAt(index);
    final updated = List<UnitTeam>.from(state.teams);
    emit(state.copyWith(cTeams: updated));
  }

  void editNewTeam() {
    emit(EditNewTeamBuilderBlocState(state));
  }

  void editTeam(UnitTeam team) {
    emit(EditTeamBuilderBlocState(state, team));
  }

  void confirmIndex(int index) {
    emit(state.copyWith(
      cViewState: TeamBuilderViewState.characterSelect,
      cSelectedIndex: index,
    ));
  }

  void confirmCharacter(Unit unit) {
    final updatedUnits =
        UnitTeam(state.selectedUnits.id, list: state.selectedUnits.toList());
    updatedUnits[state.selectedIndex] = unit;
    emit(state.copyWith(
      cSelectedUnits: updatedUnits,
      cViewState: TeamBuilderViewState.builder,
    ));
  }

  void removeCharacter() {
    final updatedUnits =
        UnitTeam(state.selectedUnits.id, list: state.selectedUnits.toList());
    updatedUnits[state.selectedIndex] = null;
    emit(state.copyWith(
      cSelectedUnits: updatedUnits,
      cViewState: TeamBuilderViewState.builder,
    ));
  }

  void confirmTeam() {
    final updatedTeam =
        state.teams.firstWhereOrNull((e) => e.id == state.selectedUnits.id);

    final updatedTeams = List<UnitTeam>.from(state.teams);
    if (updatedTeam == null) {
      updatedTeams.add(state.selectedUnits);
    } else {
      final index = updatedTeams.indexOf(updatedTeam);
      updatedTeams[index] = state.selectedUnits;
    }
    emit(state.copyWith(
      cViewState: TeamBuilderViewState.teamName,
      cTeams: updatedTeams,
    ));
  }

  void saveTeam() {
    final updated = state.selectedUnits;
    if (updated.id > state.teams.length) {
      state.teams.add(updated);
    } else {
      final old = state.teams.firstWhere((e) => e.id == updated.id);
      final index = state.teams.indexOf(old);
      state.teams[index] = updated;
    }
    emit(state.copyWith(
      cTeams: List<UnitTeam>.from(state.teams),
      cViewState: TeamBuilderViewState.team,
    ));
  }

  void setActiveTeam(Player player) {
    emit(state.copyWith(
      cPlayer: player,
      cViewState: TeamBuilderViewState.wait,
    ));
  }

  void changeView(TeamBuilderViewState viewState) {
    emit(state.copyWith(cViewState: viewState));
  }

  void back(TeamBuilderViewState viewState) {
    emit(state.copyWith(cViewState: viewState));
  }
}
