import 'package:flame/game.dart';
import 'package:skygame_2d/game/game.dart';
import 'package:skygame_2d/game/helper.dart';
import 'package:skygame_2d/game/stage.dart';
import 'package:skygame_2d/main.dart';
import 'package:skygame_2d/models/match_unit/unit_assets.dart';

extension UnitAssetsExt on MatchUnitAssets {
  void addToGame() {
    GameManager.context.add(sprite);
    GameManager.context.add(hud);
  }

  void refresh() {
    hud.refresh(parent.position);
    sprite.position = Stage.positions[parent.position] ?? Vector2(0, 0);
    if (MatchHelper.isFrontrow(parent.type)) {
      sprite.setOpacity(1);
    } else {
      sprite.setOpacity(0);
    }
  }

  void removeFromGame(SkyGame2D gameContext) {
    MatchHelper.remove(gameContext, sprite);
    MatchHelper.remove(gameContext, hud);
    animationListener.removeListener(parent.asset.manageAnimationStateListener);
  }

  void removeAnimationListener() {}
}
