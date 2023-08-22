import 'package:bloc/bloc.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:skygame_2d/bloc/key_input/bloc.dart';
import 'package:skygame_2d/bloc/key_input/state.dart';
import 'package:skygame_2d/bloc/team_builder/bloc.dart';
import 'package:skygame_2d/main.dart';
import 'package:skygame_2d/models/match_unit/unit.dart';
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
            _teamBuilderInputs(sceneBloc, state);
            break;
          default:
            break;
        }
      },
      bloc: keyBloc,
    );
  }

  _teamBuilderInputs(TeamBuilderBloc sceneBloc, KeyInputBlocState state) {
    switch (sceneBloc.state.viewState) {
      case TeamBuilderViewState.team:
        if (state.event is KeyInputConfirmEvent) {
          // Switch input layout to builder
          keyBloc.add(UpdatedTBBuilderViewInputsEvent());
          if (keyBloc.state.colIndex >= keyBloc.state.options) {
            sceneBloc.editNewTeam();
          } else {
            sceneBloc.editTeam(sceneBloc.state.teams[keyBloc.state.colIndex]);
          }
        } else {
          sceneBloc.refresh();
        }
        break;
      case TeamBuilderViewState.builder:
        if (state.event is KeyInputCancelEvent) {
          keyBloc.add(UpdatedTBTeamViewInputsEvent(
            options: bloc
                .state.playerStates[keyBloc.state.ownerID].player.teams.length,
          ));
          sceneBloc.back(TeamBuilderViewState.team);
        } else if (state.event is KeyInputConfirmEvent) {
          final currentIndex = keyBloc.state.currentIndex;
          Unit? current = sceneBloc.state.selectedUnits[currentIndex];
          int? startIndex;
          if (current != null) {
            final colUnit = sceneBloc.state.collection
                .firstWhere((e) => e.name == current.name);
            startIndex = sceneBloc.state.collection.indexOf(colUnit);
          }
          // Switch input layout to char select
          // find matching unit in collection
          keyBloc.add(UpdatedTBCharacterViewInputsEvent(
            index: startIndex,
            options: bloc.state.playerStates[keyBloc.state.ownerID].player
                .collection.length,
          ));
          sceneBloc.confirmIndex(currentIndex);
        } else if (state.event is KeyInputSaveEvent) {
          sceneBloc.saveTeam();
          keyBloc.add(UpdatedTBTeamViewInputsEvent(
              options: sceneBloc.state.teams.length));
        } else {
          sceneBloc.refresh();
        }
        break;
      case TeamBuilderViewState.characterSelect:
        if (state.event is KeyInputConfirmEvent) {
          if (keyBloc.state.currentIndex < keyBloc.state.options) {
            sceneBloc.confirmCharacter(
                sceneBloc.state.collection[keyBloc.state.currentIndex]);
            keyBloc.add(UpdatedTBBuilderViewInputsEvent());
          }
        } else if (state.event is KeyInputCancelEvent) {
          // Switch input layout to builder
          keyBloc.add(UpdatedTBBuilderViewInputsEvent());
          sceneBloc.back(TeamBuilderViewState.builder);
        } else {
          sceneBloc.refresh();
        }
        break;
      default:
        break;
    }
  }
}
