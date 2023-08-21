import 'package:bloc/bloc.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:skygame_2d/bloc/key_input/bloc.dart';
import 'package:skygame_2d/bloc/key_input/state.dart';
import 'package:skygame_2d/bloc/team_builder/bloc.dart';
import 'package:skygame_2d/main.dart';
import 'package:skygame_2d/utils.dart/enums.dart';

extension KeyInputBlocListenerExt on SkyGame2D {
  FlameBlocListener keyBlocListener(BlocBase iSceneBloc) {
    return FlameBlocListener<KeyInputBloc, KeyInputBlocState>(
      onNewState: (state) {
        switch (bloc.state.sceneState) {
          case SceneState.load:
            break;
          case SceneState.teamBuilder:
            final sceneBloc = iSceneBloc as TeamBuilderBloc;
            switch (sceneBloc.state.viewState) {
              case TeamBuilderViewState.team:
                if (state.event is KeyInputConfirmEvent) {
                  // Switch input layout to builder
                  keyBloc.add(UpdatedKeyInputsParamsEvent(
                      rowIndex: 0, colIndex: 0, rowLength: 5, options: 10));
                  if (keyBloc.state.colIndex >= keyBloc.state.options) {
                    sceneBloc.editNewTeam();
                  } else {
                    sceneBloc.editTeam(
                        sceneBloc.state.teams[keyBloc.state.colIndex]);
                  }
                } else {
                  sceneBloc.refresh();
                }
                break;
              case TeamBuilderViewState.builder:
                if (state.event is KeyInputCancelEvent) {
                  keyBloc.add(UpdatedKeyInputsParamsEvent(
                    rowIndex: 0,
                    colIndex: 0,
                    rowLength: 1,
                    options: bloc.state.playerStates[keyBloc.state.ownerID]
                        .player.teams.length,
                  ));
                  sceneBloc.back(TeamBuilderViewState.team);
                } else if (state.event is KeyInputConfirmEvent) {
                  final currentIndex = keyBloc.state.currentIndex;
                  // Switch input layout to char select
                  keyBloc.add(UpdatedKeyInputsParamsEvent(
                    rowIndex: 0,
                    colIndex: 0,
                    rowLength: 10,
                    options: bloc.state.playerStates[keyBloc.state.ownerID]
                        .player.collection.length,
                  ));
                  sceneBloc.confirmIndex(currentIndex);
                } else {
                  sceneBloc.refresh();
                }
                break;
              case TeamBuilderViewState.characterSelect:
                if (state.event is KeyInputConfirmEvent) {
                  if (keyBloc.state.colIndex >= keyBloc.state.options) {}
                } else if (state.event is KeyInputCancelEvent) {
                  // Switch input layout to builder
                  keyBloc.add(UpdatedKeyInputsParamsEvent(
                    rowIndex: 0,
                    colIndex: 0,
                    rowLength: 5,
                    options: 10,
                  ));
                  sceneBloc.back(TeamBuilderViewState.builder);
                } else {
                  sceneBloc.refresh();
                }
                break;
              default:
                break;
            }
            break;
          default:
            break;
        }
      },
      bloc: keyBloc,
    );
  }
}
