import 'package:flame/game.dart';
import 'package:skygame_2d/game/helper.dart';
import 'package:skygame_2d/game/stage.dart';
import 'package:skygame_2d/main.dart';
import 'package:skygame_2d/models/unit_assets.dart';

extension UnitAssetsExt on UnitAssets {
  void addToGame(SkyGame2D gameContext) {
    gameContext.add(sprite);
    gameContext.add(hud);
  }

  void refresh() {
    hud.refresh(unit.position);
    sprite.position = Stage.positions[unit.position] ?? Vector2(0, 0);
    if (MatchHelper.isFrontrow(unit.type)) {
      sprite.setOpacity(1);
    } else {
      sprite.setOpacity(0);
    }
  }

  void removeFromGame(SkyGame2D gameContext) {
    MatchHelper.remove(gameContext, sprite);
    MatchHelper.remove(gameContext, hud);
    animationListener.removeListener(unit.asset.manageAnimationStateListener);
  }

  void removeAnimationListener() {}
}
