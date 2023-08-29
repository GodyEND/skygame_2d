import 'package:skygame_2d/bloc/key_input/bloc.dart';
import 'package:skygame_2d/bloc/key_input/state.dart';
import 'package:skygame_2d/bloc/player/bloc.dart';
import 'package:skygame_2d/bloc/player/events.dart';
import 'package:skygame_2d/main.dart';
import 'package:skygame_2d/models/match_unit/unit.dart';
import 'package:skygame_2d/scenes/team_builder/bloc/bloc.dart';
import 'package:skygame_2d/utils.dart/enums.dart';

extension TeamBuilderKeyInputExt on SkyGame2D {
  void manageTeamBuilderInputs(KeyInputBloc keyBloc, TeamBuilderBloc sceneBloc,
      PlayerBloc playerBloc, KeyInputBlocState state) {
    final playerState = bloc.state.playerStates[keyBloc.state.ownerID - 1];
    switch (sceneBloc.state.viewState) {
      case TeamBuilderViewState.team:
        if (state.event is KeyInputConfirmEvent) {
          if (keyBloc.state.colIndex >= keyBloc.state.options) {
            sceneBloc.editNewTeam();
          } else {
            // Switch input layout to builder
            keyBloc.add(UpdatedTBBuilderViewInputsEvent());
            sceneBloc.editTeam(sceneBloc.state.teams[keyBloc.state.colIndex]);
          }
        } else if (state.event is KeyInputSaveEvent) {
          final updatedPlayer = sceneBloc.state.player.copyWith(
              cActiveTeam: sceneBloc.state.teams[keyBloc.state.currentIndex]);
          playerBloc.add(UpdatePlayerEvent(updatedPlayer));
          sceneBloc.setActiveTeam(updatedPlayer);
        } else {
          sceneBloc.refresh();
        }
        break;
      case TeamBuilderViewState.builder:
        if (state.event is KeyInputCancelEvent) {
          keyBloc.add(UpdatedTBTeamViewInputsEvent(
            options: playerState.player.teams.length,
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
            options: playerState.player.collection.length,
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
      case TeamBuilderViewState.wait:
        if (state.event is KeyInputCancelEvent) {
          sceneBloc.back(TeamBuilderViewState.team);
        } else {
          sceneBloc.refresh();
        }
      default:
        break;
    }
  }
}
