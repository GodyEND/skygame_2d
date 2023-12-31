import 'package:flame/game.dart';
import 'package:skygame_2d/game/helper.dart';
import 'package:skygame_2d/game/stage.dart';
import 'package:skygame_2d/main.dart';
import 'package:skygame_2d/models/match_unit/unit_assets.dart';

extension UnitAssetsExt on MatchUnitAssets {
  void refresh() {
    hud.refresh(parent.position);
    sprite.position =
        Stage.positions(parent.ownerID)[parent.position] ?? Vector2(0, 0);
    if (MatchHelper.isFrontrow(parent.position)) {
      sprite.setOpacity(1);
    } else {
      sprite.setOpacity(0);
    }
  }

  void removeFromGame(SkyGame2D gameContext) {
    animationListener.removeListener(parent.asset.manageAnimationStateListener);
  }

  void removeAnimationListener() {}
}
