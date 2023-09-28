import 'package:flame_bloc/flame_bloc.dart';
import 'package:skygame_2d/bloc/events.dart';
import 'package:skygame_2d/bloc/game/bloc.dart';
import 'package:skygame_2d/bloc/game/state.dart';
import 'package:skygame_2d/bloc/key_input/bloc.dart';
import 'package:skygame_2d/game_ext/scene_setup_ext.dart';
import 'package:skygame_2d/main.dart';
import 'package:skygame_2d/models/match_unit/unit_team.dart';
import 'package:skygame_2d/utils.dart/enums.dart';

extension SkyGame2DBlocListenerExt on SkyGame2D {
  FlameBlocListener gameBlocListener() {
    return FlameBlocListener<GameBloc, GameBlocState>(
      onNewState: (state) async {
        if (state.event is GameSceneChangeEvent) {
          switch (state.sceneState) {
            case SceneState.load:
              bloc.add(GameSceneChangeCompleteEvent(
                  nextScene: SceneState.teamBuilder));
              break;
            case SceneState.teamBuilder:
              await setupTeamBuilder(List<int>.from(
                  playerBlocs.map<int>((e) => e.state.player.ownerID)));
              for (var playerBloc in playerBlocs) {
                playerBloc.state.keyBloc.add(UpdateKeyInputsEvent(
                  sceneState: state.sceneState,
                ));
              }
              bloc.add(GameSceneChangeCompleteEvent());
              break;
            case SceneState.teamFormation:
              final keys = List<int>.from(
                  playerBlocs.map<int>((e) => e.state.player.ownerID));
              final values = List<UnitTeam>.from(
                  playerBlocs.map((e) => e.state.player.activeTeam));
              final map = <int, UnitTeam>{};
              for (int i = 0; i < keys.length; i++) {
                map[keys[i]] = values[i];
              }
              await setupTeamFormation(map);
              for (var playerBloc in playerBlocs) {
                playerBloc.state.keyBloc.add(UpdateKeyInputsEvent(
                  sceneState: state.sceneState,
                ));
              }
              bloc.add(GameSceneChangeCompleteEvent());
              break;
            case SceneState.combat:
              await setupCombat();
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
