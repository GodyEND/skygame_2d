import 'package:bloc/bloc.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:skygame_2d/bloc/key_input/bloc.dart';
import 'package:skygame_2d/bloc/key_input/state.dart';
import 'package:skygame_2d/bloc/player/bloc.dart';
import 'package:skygame_2d/main.dart';
import 'package:skygame_2d/scenes/team_builder/bloc/bloc.dart';
import 'package:skygame_2d/scenes/team_formation/inputs.dart';
import 'package:skygame_2d/scenes/team_formation/bloc/bloc.dart';
import 'package:skygame_2d/scenes/team_builder/inputs.dart';
import 'package:skygame_2d/utils.dart/enums.dart';

extension KeyInputBlocListenerExt on SkyGame2D {
  FlameBlocListener keyBlocListener(
      KeyInputBloc keyBloc, PlayerBloc playerBloc, BlocBase iSceneBloc) {
    return FlameBlocListener<KeyInputBloc, KeyInputBlocState>(
      onNewState: (state) {
        switch (bloc.state.sceneState) {
          case SceneState.load:
            break;
          case SceneState.teamBuilder:
            if (iSceneBloc is! TeamBuilderBloc) return;
            manageTeamBuilderInputs(keyBloc, iSceneBloc, playerBloc, state);
            break;
          case SceneState.teamFormation:
            if (iSceneBloc is! TeamFormationBloc) return;
            manageTeamFormationInputs(keyBloc, iSceneBloc, playerBloc, state);
            break;
          default:
            break;
        }
      },
      bloc: keyBloc,
    );
  }
}
