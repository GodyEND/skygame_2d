import 'package:bloc/bloc.dart';
import 'package:skygame_2d/bloc/events.dart';
import 'package:skygame_2d/bloc/key_input/state.dart';
import 'package:skygame_2d/scenes/team_builder/bloc/bloc.dart';
import 'package:skygame_2d/scenes/team_builder/team_builder.dart';
import 'package:skygame_2d/utils.dart/enums.dart';

class KeyInputBloc extends Bloc<BlocEvent, KeyInputBlocState> {
  KeyInputBloc(KeyInputBlocState initialState) : super(initialState) {
    on<KeyInputConfirmEvent>((event, emit) {
      switch (state.sceneState) {
        case SceneState.teamBuilder:
          final scene = SceneManager.scenes.firstWhere(
              (e) => e is TeamBuilderScene && e.ownerID == state.ownerID);
          if (event.ownerID != state.ownerID) return;
          switch ((scene.managedBloc as TeamBuilderBloc).state.viewState) {
            case TeamBuilderViewState.team:
            case TeamBuilderViewState.builder:
            case TeamBuilderViewState.characterSelect:
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
    on<KeyInputCancelEvent>(
      (event, emit) {
        switch (state.sceneState) {
          case SceneState.teamBuilder:
            final scene = SceneManager.scenes.firstWhere(
                (e) => e is TeamBuilderScene && e.ownerID == state.ownerID);
            if (event.ownerID != state.ownerID) return;
            switch ((scene.managedBloc as TeamBuilderBloc).state.viewState) {
              case TeamBuilderViewState.team:
              case TeamBuilderViewState.builder:
              case TeamBuilderViewState.characterSelect:
              case TeamBuilderViewState.wait:
                emit(state.copyWith(event: event));
                break;
              default:
                break;
            }
            break;
          default:
            break;
        }
      },
    );
    on<KeyInputSaveEvent>(
      (event, emit) {
        switch (state.sceneState) {
          case SceneState.teamBuilder:
            final scene = SceneManager.scenes.firstWhere(
                (e) => e is TeamBuilderScene && e.ownerID == state.ownerID);
            if (event.ownerID != state.ownerID) return;
            switch ((scene.managedBloc as TeamBuilderBloc).state.viewState) {
              case TeamBuilderViewState.team:
              case TeamBuilderViewState.builder:
                emit(state.copyWith(event: event));
                break;
              default:
                break;
            }
            break;
          default:
            break;
        }
      },
    );
    on<UpdateKeyInputsEvent>((event, emit) {
      emit(state.copyWith(
          cSceneState: event.sceneState,
          cSceneBloc: event.sceneBloc,
          event: event));
    });
    on<KeyInputUpEvent>((event, emit) {
      if (state.colIndex <= 0) return;
      if (event.ownerID != state.ownerID) return;
      emit(state.copyWith(cColIndex: state.colIndex - 1));
    });

    on<KeyInputDownEvent>((event, emit) {
      if (state.colIndex >= (state.options / state.rowLength).ceil() - 1) {
        return;
      }
      if (event.ownerID != state.ownerID) return;
      emit(state.copyWith(cColIndex: state.colIndex + 1));
    });

    on<KeyInputLeftEvent>((event, emit) {
      if (event.ownerID != state.ownerID) return;
      if (state.rowIndex == 0) {
        emit(state.copyWith(cRowIndex: state.rowLength - 1));
      } else {
        emit(state.copyWith(cRowIndex: state.rowIndex - 1));
      }
    });
    on<KeyInputRightEvent>((event, emit) {
      if (event.ownerID != state.ownerID) return;
      if (state.rowIndex < state.rowLength - 1) {
        emit(state.copyWith(cRowIndex: state.rowIndex + 1));
      } else {
        emit(state.copyWith(cRowIndex: 0));
      }
    });
    on<UpdatedKeyInputsParamsEvent>(
      (event, emit) {
        emit(state.copyWith(
          cRowIndex: event.rowIndex,
          cColIndex: event.colIndex,
          cRowLength: event.rowLength,
          cOptions: event.options,
        ));
      },
    );
  }
}

/// Events

class KeyInputUpEvent extends BlocEvent {
  final int ownerID;
  KeyInputUpEvent(this.ownerID);
}

class KeyInputDownEvent extends BlocEvent {
  final int ownerID;
  KeyInputDownEvent(this.ownerID);
}

class KeyInputLeftEvent extends BlocEvent {
  final int ownerID;
  KeyInputLeftEvent(this.ownerID);
}

class KeyInputRightEvent extends BlocEvent {
  final int ownerID;
  KeyInputRightEvent(this.ownerID);
}

class KeyInputConfirmEvent extends BlocEvent {
  final int ownerID;
  KeyInputConfirmEvent(this.ownerID);
}

class KeyInputCancelEvent extends BlocEvent {
  final int ownerID;
  KeyInputCancelEvent(this.ownerID);
}

class KeyInputRemoveEvent extends BlocEvent {
  final int ownerID;
  KeyInputRemoveEvent(this.ownerID);
}

class KeyInputSaveEvent extends BlocEvent {
  final int ownerID;
  KeyInputSaveEvent(this.ownerID);
}

class UpdateKeyInputsEvent extends BlocEvent {
  final SceneState sceneState;
  final BlocBase? sceneBloc;
  UpdateKeyInputsEvent({required this.sceneState, this.sceneBloc});
}

class UpdatedKeyInputsParamsEvent extends BlocEvent {
  final int rowIndex;
  final int colIndex;
  final int rowLength;
  final int options;
  UpdatedKeyInputsParamsEvent({
    required this.rowIndex,
    required this.colIndex,
    required this.rowLength,
    required this.options,
  });
}

class UpdatedTBTeamViewInputsEvent extends UpdatedKeyInputsParamsEvent {
  UpdatedTBTeamViewInputsEvent({required int options})
      : super(
          rowIndex: 0,
          colIndex: 0,
          rowLength: 1,
          options: options,
        );
}

class UpdatedTBBuilderViewInputsEvent extends UpdatedKeyInputsParamsEvent {
  UpdatedTBBuilderViewInputsEvent()
      : super(
          rowIndex: 0,
          colIndex: 0,
          rowLength: 5,
          options: 10,
        );
}

class UpdatedTBCharacterViewInputsEvent extends UpdatedKeyInputsParamsEvent {
  UpdatedTBCharacterViewInputsEvent({int? index, required int options})
      : super(
          rowIndex: index == null ? 0 : index % 10,
          colIndex: index == null ? 0 : (index / 10).floor(),
          rowLength: 10,
          options: options,
        );
}
