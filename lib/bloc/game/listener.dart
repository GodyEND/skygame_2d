import 'package:bloc/bloc.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:skygame_2d/bloc/events.dart';
import 'package:skygame_2d/bloc/game/bloc.dart';
import 'package:skygame_2d/bloc/game/state.dart';
import 'package:skygame_2d/bloc/key_input/bloc.dart';
import 'package:skygame_2d/game/skygame_ext/scene_setup_ext.dart';
import 'package:skygame_2d/main.dart';
import 'package:skygame_2d/scenes/managed_scene.dart';
import 'package:skygame_2d/scenes/team_builder.dart';
import 'package:skygame_2d/utils.dart/enums.dart';
import 'package:skygame_2d/utils.dart/extensions.dart';

extension SkyGame2DBlocListenerExt on SkyGame2D {
  FlameBlocListener gameBlocListener() {
    return FlameBlocListener<GameBloc, GameBlocState>(
      onNewState: (state) async {
        if (state.event is GameSceneChangeEvent) {
          switch (state.sceneState) {
            case SceneState.load:
              await setupPlayerCollection();
              bloc.add(GameSceneChangeCompleteEvent(
                  nextScene: SceneState.teamBuilder));
              break;
            case SceneState.teamBuilder:
              await setupTeamBuilder(List<int>.from(
                  playerBlocs.map<int>((e) => e.state.player.ownerID)));

              keyBloc.add(UpdateKeyInputsEvent(
                sceneState: state.sceneState,
              ));
              bloc.add(GameSceneChangeCompleteEvent());
              break;
            default:
              break;
          }
        } else if (state.event is GameSceneChangeCompleteEvent) {
          final nextScene =
              (state.event as GameSceneChangeCompleteEvent).nextScene;
          if (nextScene != null) {
            bloc.add(GameSceneChangeEvent(scene: nextScene));
          }
        }

        switch (state.sceneState) {
          case SceneState.load:
            break;
          case SceneState.teamBuilder:
            break;
          default:
            break;
        }
      },
      bloc: bloc,
    );
  }
}
