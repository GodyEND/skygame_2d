import 'package:bloc/bloc.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:skygame_2d/bloc/key_input/bloc.dart';
import 'package:skygame_2d/bloc/key_input/state.dart';
import 'package:skygame_2d/bloc/player/bloc.dart';
import 'package:skygame_2d/main.dart';
import 'package:skygame_2d/scenes/team_builder/bloc/bloc.dart';
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
            final sceneBloc = iSceneBloc as TeamBuilderBloc;
            manageTeamBuilderInputs(keyBloc, sceneBloc, playerBloc, state);
            break;
          case SceneState.teamFormation:
            final sceneBloc = iSceneBloc as TeamBuilderBloc; // TODO:
            manageTeamFormationInputs(keyBloc, sceneBloc, playerBloc, state);
            break;
          default:
            break;
        }
      },
      bloc: keyBloc,
    );
  }
}
