import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:skygame_2d/bloc/events.dart';
import 'package:skygame_2d/utils.dart/enums.dart';

class KeyInputBlocState extends Equatable {
  final SceneState sceneState;
  final BlocBase? sceneBloc;
  final int rowIndex;
  final int colIndex;
  final int rowLength;
  final int options;
  final BlocEvent? event;
  const KeyInputBlocState({
    required this.sceneState,
    required this.sceneBloc,
    required this.rowIndex,
    required this.colIndex,
    required this.rowLength,
    required this.options,
    this.event,
  });
  KeyInputBlocState copyWith({
    SceneState? cSceneState,
    BlocBase? cSceneBloc,
    int? cRowIndex,
    int? cColIndex,
    int? cRowLength,
    int? cOptions,
    BlocEvent? event,
  }) {
    return KeyInputBlocState(
      sceneState: cSceneState ?? sceneState,
      sceneBloc: cSceneBloc ?? sceneBloc,
      rowIndex: cRowIndex ?? rowIndex,
      colIndex: cColIndex ?? colIndex,
      rowLength: cRowLength ?? rowLength,
      options: cOptions ?? options,
      event: event,
    );
  }

  @override
  List<Object?> get props => [
        sceneState,
        sceneBloc,
        rowIndex,
        colIndex,
        rowLength,
        options,
        event,
      ];
}

class InitialKeyInputBlocState extends KeyInputBlocState {
  const InitialKeyInputBlocState({
    required SceneState sceneState,
    BlocBase? sceneBloc,
    required int rowLength,
    required int options,
  }) : super(
          sceneState: sceneState,
          sceneBloc: sceneBloc,
          rowIndex: 0,
          colIndex: 0,
          rowLength: rowLength,
          options: options,
        );
}
