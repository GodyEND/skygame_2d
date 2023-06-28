import 'package:bloc/bloc.dart';
import 'package:skygame_2d/bloc/key_input/state.dart';
import 'package:skygame_2d/utils.dart/enums.dart';
import 'package:skygame_2d/models/match_unit/unit.dart';
import 'package:skygame_2d/utils.dart/constants.dart';

class KeyInputBloc extends Cubit<KeyInputBlocState> {
  KeyInputBloc(KeyInputBlocState initialState) : super(initialState);
  void nextUnit(int ownerID) {
    final activeState = state.playerInputStates[ownerID - 1];
    if (activeState.rowIndex + activeState.colIndex * activeState.rowLength >=
        activeState.options) {
      return;
    }
    final increaseRow = (activeState.rowIndex + 1 > activeState.rowLength - 1);
    final updatedPlayerInput = increaseRow
        ? activeState.copyWith(cRowIndex: activeState.rowIndex + 1)
        : activeState.copyWith(
            cRowIndex: 0,
            cColIndex: activeState.colIndex + 1,
          );
    state.playerInputStates.remove(state.playerInputStates[ownerID - 1]);
    final updated = List<PlayerKeyInputBlocState>.from(state.playerInputStates);
    updated.insert(ownerID - 1, updatedPlayerInput);
    emit(state.copyWith(cPlayerInputStates: updated));
  }

  void prevUnit(int ownerID) {
    final activeState = state.playerInputStates[ownerID - 1];

    // if (activeState.currentUnit <= 0) return;
    // final updated =
    //     activeState.copyWith(cCurrentUnit: activeState.currentUnit - 1);
  }

  void nextRowUnit(int ownerID) {
    final activeState = state.playerInputStates[ownerID - 1];

    // if (activeState.currentUnit + Constants.TEAM_BUILDER_UNITS_PER_ROW >
    //     Units.all.length - 1) {
    //   // Set cursor to last
    //   final updated = activeState.copyWith(cCurrentUnit: Units.all.length - 1);
    // } else {
    //   final updated = activeState.copyWith(
    //       cCurrentUnit:
    //           activeState.currentUnit + Constants.TEAM_BUILDER_UNITS_PER_ROW);
    // }
  }

  void prevRowUnit(int ownerID) {
    final activeState = state.playerInputStates[ownerID - 1];

    // if (activeState.currentUnit - Constants.TEAM_BUILDER_UNITS_PER_ROW < 0) {
    //   return;
    // }
    // final updated = activeState.copyWith(
    //     cCurrentUnit:
    //         activeState.currentUnit - Constants.TEAM_BUILDER_UNITS_PER_ROW);
  }

  void nextRosterPos(int ownerID) {
    final activeState = state.playerInputStates[ownerID - 1];

    // if (activeState.currentPosition >= MatchPosition.reserve5.index) {
    //   return;
    // }
    // final updated =
    //     activeState.copyWith(cCurrentUnit: activeState.currentPosition + 1);
  }

  void prevRosterPos(int ownerID) {
    final activeState = state.playerInputStates[ownerID - 1];

    // if (activeState.currentPosition <= 0) return;
    // final updated =
    //     activeState.copyWith(cCurrentUnit: activeState.currentPosition - 1);
  }
}
