import 'package:flame_bloc/flame_bloc.dart';
import 'package:skygame_2d/bloc/events.dart';
import 'package:skygame_2d/bloc/game/bloc.dart';
import 'package:skygame_2d/bloc/game/state.dart';
import 'package:skygame_2d/game/skygame_ext/scene_setup_ext.dart';
import 'package:skygame_2d/main.dart';
import 'package:skygame_2d/utils.dart/enums.dart';

extension SkyGame2DBlocListenerExt on SkyGame2D {
  FlameBlocListener gameBlocListener(GameBloc bloc) {
    return FlameBlocListener<GameBloc, GameBlocState>(
      onNewState: (state) {
        if (state.event is GameSceneChangeEvent) {
          switch (bloc.state.sceneState) {
            case SceneState.load:
              setupPlayerCollection();
              bloc.add(GameSceneChangeCompleteEvent(
                  nextScene: SceneState.teamBuilder));
              break;
            case SceneState.teamBuilder:
              setupTeamBuilder();
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
