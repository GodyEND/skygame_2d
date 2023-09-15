import 'package:bloc/bloc.dart';
import 'package:skygame_2d/bloc/events.dart';
import 'package:skygame_2d/models/match_unit/unit.dart';
import 'package:skygame_2d/scenes/team_formation/bloc/state.dart';
import 'package:skygame_2d/utils.dart/enums.dart';

class TeamFormationBloc extends Cubit<TeamFormationBlocState> {
  TeamFormationBloc(TeamFormationBlocState initialState) : super(initialState);

  void initialise() {
    emit(state.copyWith(cViewState: TeamFormationViewState.formation));
  }

  void refresh() {
    emit(state.copyWith(event: EmptyEvent()));
  }

  void clear() {
    emit(state.copyWith());
  }

  void back(TeamFormationViewState viewState) {
    emit(state.copyWith(cViewState: viewState));
  }

  void editCharacter({required int index}) {
    emit(state.copyWith(
      cEditedPosIndex: index,
      cViewState: TeamFormationViewState.characterSelect,
    ));
  }

  void confirmCharacter(Unit unit) {
    if (state.editedPosIndex == null) return;
    state.formation[state.editedPosIndex!] = unit;
    final options = state.team.where((e) => e != null).toList();
    for (var u in state.formation.where((e) => e != null).toList()) {
      options.remove(u);
    }
    emit(ConfirmedCharacterTFState(
      oldState: state,
      formation: List.from(state.formation),
      characterOptions: (options.isEmpty) ? [] : List.from(options),
    ));
  }

  void playerReady() {
    emit(state.copyWith(cViewState: TeamFormationViewState.wait));
  }
}
