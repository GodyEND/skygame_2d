import 'package:skygame_2d/main.dart';
import 'package:skygame_2d/scenes/managed_scene.dart';
import 'package:skygame_2d/scenes/player_collection.dart';
import 'package:skygame_2d/scenes/team_builder.dart';

extension SceneSetupExt on SkyGame2D {
  void _clearScene() {
    for (var child in children) {
      if (child is ManagedScene) {
        child.clearScene();
        remove(child);
      }
    }
  }

  bool setupPlayerCollection() {
    try {
      _clearScene();
      add(PlayerCollectionScene());
      return true;
    } catch (_) {
      return false;
    }
  }

  bool setupTeamBuilder() {
    try {
      _clearScene();
      add(TeamBuilderScene());
      return true;
    } catch (_) {
      return false;
    }
  }
}
