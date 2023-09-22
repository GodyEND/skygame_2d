import 'package:skygame_2d/bloc/key_input/bloc.dart';
import 'package:skygame_2d/bloc/key_input/state.dart';
import 'package:skygame_2d/bloc/player/bloc.dart';
import 'package:skygame_2d/main.dart';
import 'package:skygame_2d/scenes/team_formation/bloc/bloc.dart';
import 'package:skygame_2d/utils.dart/enums.dart';

extension TeamFormationKeyInputExt on SkyGame2D {
  void manageTeamFormationInputs(
      KeyInputBloc keyBloc,
      TeamFormationBloc sceneBloc,
      PlayerBloc playerBloc,
      KeyInputBlocState state) {
    switch (sceneBloc.state.viewState) {
      case TeamFormationViewState.formation:
        if (state.event is KeyInputConfirmEvent) {
          if (keyBloc.state.currentIndex < keyBloc.state.options) {
            sceneBloc.editCharacter(index: keyBloc.state.currentIndex);
            keyBloc.add(UpdatedTBBuilderViewInputsEvent());
          }
        } else {
          sceneBloc.refresh();
        }
        break;

      case TeamFormationViewState.characterSelect:
        if (state.event is KeyInputConfirmEvent) {
          if (keyBloc.state.currentIndex <
              sceneBloc.state.characterOptions.length) {
            final unit =
                sceneBloc.state.characterOptions[keyBloc.state.currentIndex];
            sceneBloc.confirmCharacter(unit);
            keyBloc.add(UpdatedFormationInputsEvent());
          }
        } else if (state.event is KeyInputCancelEvent) {
          // Switch input layout to builder
          keyBloc.add(UpdatedTBBuilderViewInputsEvent());
          sceneBloc.back(TeamFormationViewState.formation);
        } else {
          sceneBloc.refresh();
        }
        break;
      case TeamFormationViewState.wait:
        if (state.event is KeyInputCancelEvent) {
          sceneBloc.back(TeamFormationViewState.formation);
        } else {
          sceneBloc.refresh();
        }
      default:
        break;
    }
  }
}
