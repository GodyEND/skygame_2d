import 'dart:async';

import 'package:flame/components.dart';
import 'package:skygame_2d/models/match_unit/unit.dart';
import 'package:skygame_2d/scenes/managed_scene.dart';
import 'package:skygame_2d/utils.dart/constants.dart';

class TeamBuilderScene extends ManagedScene {
  @override
  FutureOr<void> onLoad() {
    for (int i = 0; i < Units.all.length; i++) {
      final yPos = (i ~/ Constants.TEAM_BUILDER_UNITS_PER_ROW) * 250 + 250;

      addToScene(SpriteComponent(
        size: Vector2(150, 250),
        position: Vector2(i % Constants.TEAM_BUILDER_UNITS_PER_ROW * 150 + 200,
            yPos.toDouble()),
        sprite: Sprite(Units.all[i].select),
      ));

      addToScene(SpriteComponent(
        size: Vector2(150, 250),
        position: Vector2(
            i % Constants.TEAM_BUILDER_UNITS_PER_ROW * 150 +
                200 +
                Constants.SCREEN_CENTER.x,
            yPos.toDouble()),
        sprite: Sprite(Units.all[i].select),
      ));
    }
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}
