import 'package:bloc/bloc.dart';
import 'package:skygame_2d/bloc/events.dart';
import 'package:skygame_2d/bloc/key_input/state.dart';
import 'package:skygame_2d/bloc/team_builder/bloc.dart';
import 'package:skygame_2d/scenes/team_builder.dart';
import 'package:skygame_2d/utils.dart/enums.dart';
import 'package:skygame_2d/utils.dart/constants.dart';

class KeyInputUpEvent extends BlocEvent {
  final int ownerID;
  KeyInputUpEvent(this.ownerID);
}

class KeyInputConfirmEvent extends BlocEvent {
  final int ownerID;
  KeyInputConfirmEvent(this.ownerID);
}

class UpdateKeyInputsEvent extends BlocEvent {
  final SceneState sceneState;
  final BlocBase? sceneBloc;
  UpdateKeyInputsEvent({required this.sceneState, this.sceneBloc});
}

class KeyInputBloc extends Bloc<BlocEvent, KeyInputBlocState> {
  KeyInputBloc(KeyInputBlocState initialState) : super(initialState) {
    on<KeyInputUpEvent>((event, emit) {
      switch (state.sceneState) {
        case SceneState.teamBuilder:
          emit(state.copyWith(event: event));
          break;
        default:
          break;
      }
    });
    on<KeyInputConfirmEvent>((event, emit) {
      switch (state.sceneState) {
        case SceneState.teamBuilder:
          final scene = SceneManager.scenes.firstWhere((e) =>
              e is TeamBuilderScene && e.ownerID == Constants.FIRST_PLAYER);
          switch ((scene.managedBloc as TeamBuilderBloc).state.viewState) {
            case TeamBuilderViewState.team:
              emit(state.copyWith(event: event));
              break;
            default:
              break;
          }
          break;
        default:
          break;
      }
    });
    on<UpdateKeyInputsEvent>((event, emit) {
      emit(state.copyWith(
          cSceneState: event.sceneState,
          cSceneBloc: event.sceneBloc,
          event: event));
    });
  }
  void nextUnit(int ownerID) {
    // final activeState = state.playerInputStates[ownerID - 1];
    // if (activeState.rowIndex + activeState.colIndex * activeState.rowLength >=
    //     activeState.options) {
    //   return;
    // }
    // final increaseRow = (activeState.rowIndex + 1 > activeState.rowLength - 1);
    // final updatedPlayerInput = increaseRow
    //     ? activeState.copyWith(cRowIndex: activeState.rowIndex + 1)
    //     : activeState.copyWith(
    //         cRowIndex: 0,
    //         cColIndex: activeState.colIndex + 1,
    //       );
    // state.playerInputStates.remove(state.playerInputStates[ownerID - 1]);
    // final updated = List<PlayerKeyInputBlocState>.from(state.playerInputStates);
    // updated.insert(ownerID - 1, updatedPlayerInput);
    // emit(state.copyWith(cPlayerInputStates: updated));
  }

  void prevUnit(int ownerID) {
    // final activeState = state.playerInputStates[ownerID - 1];

    // if (activeState.currentUnit <= 0) return;
    // final updated =
    //     activeState.copyWith(cCurrentUnit: activeState.currentUnit - 1);
  }

  void nextRowUnit(int ownerID) {
    // final activeState = state.playerInputStates[ownerID - 1];

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
    // final activeState = state.playerInputStates[ownerID - 1];

    // if (activeState.currentUnit - Constants.TEAM_BUILDER_UNITS_PER_ROW < 0) {
    //   return;
    // }
    // final updated = activeState.copyWith(
    //     cCurrentUnit:
    //         activeState.currentUnit - Constants.TEAM_BUILDER_UNITS_PER_ROW);
  }

  void nextRosterPos(int ownerID) {
    // final activeState = state.playerInputStates[ownerID - 1];

    // if (activeState.currentPosition >= MatchPosition.reserve5.index) {
    //   return;
    // }
    // final updated =
    //     activeState.copyWith(cCurrentUnit: activeState.currentPosition + 1);
  }

  void prevRosterPos(int ownerID) {
    // final activeState = state.playerInputStates[ownerID - 1];

    // if (activeState.currentPosition <= 0) return;
    // final updated =
    //     activeState.copyWith(cCurrentUnit: activeState.currentPosition - 1);
  }
}
