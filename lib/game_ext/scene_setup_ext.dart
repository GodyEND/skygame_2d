import 'package:flame/components.dart';
import 'package:skygame_2d/scenes/combat.dart';
import 'package:skygame_2d/scenes/team_builder/bloc/bloc.dart';
import 'package:skygame_2d/main.dart';
import 'package:skygame_2d/models/match_unit/unit_team.dart';
import 'package:skygame_2d/scenes/managed_scene.dart';
import 'package:skygame_2d/scenes/team_builder/team_builder.dart';
import 'package:skygame_2d/scenes/team_formation/bloc/bloc.dart';
import 'package:skygame_2d/scenes/team_formation/team_formation_scene.dart';
import 'package:skygame_2d/utils.dart/constants.dart';
import 'package:skygame_2d/utils.dart/enums.dart';

extension SceneSetupExt on SkyGame2D {
  Future<void> _clearScene() async {
    for (var child in children) {
      if (child is ManagedScene) {
        await child.clearScene();
        remove(child);
      }
    }
  }

  Future<bool> setupTeamBuilder(List<int> ownerIDs) async {
    try {
      await _clearScene();
      for (int i = 0; i < ownerIDs.length; i++) {
        final sceneWidth = Constants.SCREEN_WIDTH / ownerIDs.length;
        await add(TeamBuilderScene(ownerIDs[i],
            keyBloc: playerBlocs
                .firstWhere((e) => e.state.player.ownerID == ownerIDs[i])
                .state
                .keyBloc,
            position: Vector2(0 + i * sceneWidth, 0),
            size: Vector2(sceneWidth, Constants.SCREEN_HEIGHT)));
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> setupTeamFormation(Map<int, UnitTeam> map) async {
    // List playerTeam per player
    try {
      await _clearScene();
      final ownerIDs = map.keys.toList();
      for (int i = 0; i < ownerIDs.length; i++) {
        final sceneWidth = Constants.SCREEN_WIDTH / ownerIDs.length;
        final playerBloc = playerBlocs
            .firstWhere((e) => e.state.player.ownerID == ownerIDs[i]);
        await add(TeamFormationScene(map.keys.toList()[i],
            keyBloc: playerBloc.state.keyBloc,
            playerBloc: playerBloc,
            position: Vector2(0 + i * sceneWidth, 0),
            size: Vector2(sceneWidth, Constants.SCREEN_HEIGHT)));
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> setupCombat() async {
    // List playerTeam per player
    try {
      await _clearScene();
      await add(CombatScene());
      return true;
    } catch (_) {
      return false;
    }
  }

  bool validateTeamBuilderPlayersReady() {
    bool playersReady = true;
    for (var playerState in bloc.state.playerStates) {
      final sceneBloc = SceneManager.scenes
          .firstWhere((e) =>
              e is TeamBuilderScene && e.ownerID == playerState.player.ownerID)
          .managedBloc as TeamBuilderBloc;
      if (sceneBloc.state.viewState != TeamBuilderViewState.wait) {
        playersReady = false;
        break;
      }
    }
    return playersReady;
  }

  bool validateFormationPlayersReady() {
    bool playersReady = true;
    for (var playerState in bloc.state.playerStates) {
      final sceneBloc = SceneManager.scenes
          .firstWhere((e) =>
              e is TeamFormationScene &&
              e.ownerID == playerState.player.ownerID)
          .managedBloc as TeamFormationBloc;
      if (sceneBloc.state.viewState != TeamFormationViewState.wait) {
        playersReady = false;
        break;
      }
    }

    return playersReady;
  }
}
