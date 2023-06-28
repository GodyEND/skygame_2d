import 'package:skygame_2d/main.dart';
import 'package:skygame_2d/scenes/managed_scene.dart';
import 'package:skygame_2d/scenes/player_collection.dart';
import 'package:skygame_2d/scenes/team_builder.dart';
import 'package:skygame_2d/utils.dart/constants.dart';

extension SceneSetupExt on SkyGame2D {
  Future<void> _clearScene() async {
    for (var child in children) {
      if (child is ManagedScene) {
        await child.clearScene();
        remove(child);
      }
    }
  }

  Future<bool> setupPlayerCollection() async {
    try {
      await _clearScene();
      await add(PlayerCollectionScene());
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> setupTeamBuilder(List<int> ownerIDs) async {
    try {
      await _clearScene();
      for (var ownerID in ownerIDs) {
        await add(TeamBuilderScene(ownerID));
      }
      return true;
    } catch (_) {
      return false;
    }
  }
}
