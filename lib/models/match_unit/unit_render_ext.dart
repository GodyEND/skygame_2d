import 'dart:math';

import 'package:flame/components.dart';
import 'package:skygame_2d/game/stage.dart';
import 'package:skygame_2d/game/unit.dart';
import 'package:skygame_2d/graphics/graphics.dart';
import 'package:skygame_2d/utils.dart/enums.dart';
import 'package:skygame_2d/models/match_unit/unit_assets.dart';
import 'package:skygame_2d/models/match_unit/unit_hud.dart';
import 'package:skygame_2d/utils.dart/constants.dart';

extension UnitAssetManageExt on MatchUnit {
  bool addMatchAssets() {
    if (protectedAsset != null) return false;
    protectedAsset = MatchUnitAssets(
      sprite: SpriteComponent(),
      // GraphicsManager.createUnitSprite(ownerID, position, character.image),
      hud: UnitHUDComponent(
        ownerID: ownerID,
        profileImage: character.profile,
        matchPosition: position,
        size: Stage.hudResolution,
      ),
      infoList: {
        // EXEC_ICON: GraphicsManager.createUnitProfile(
        //     ownerID, position, character.profile),
      },
      parent: this,
    );
    return true;
  }
}

extension UnitRenderExt on MatchUnit {
  void updateHealthBar(double dt) {
    asset.hud.healthbar.width = asset.hud.healthbarBG.width *
        max(0, current.stats[StatType.hp] / initial.stats[StatType.hp]);
  }

  void updateChargeBar(double dt) {
    asset.hud.chargebar.width = asset.hud.chargebarBG.width *
        min(1,
            current.stats[StatType.storage] / initial.stats[StatType.storage]);
  }

  void updateChargeBarSeparator(double dt) {
    double divisions = max(
        0, (current.stats[StatType.storage] / initial.stats[StatType.storage]));
    if (divisions <= 1) {
      divisions = 0;
    }
    var separators = divisions.floor();
    if (divisions.floor() == divisions) separators = max(0, separators - 1);
    if (asset.hud.chargeSeparator.length > separators) {
      final diff = asset.hud.chargeSeparator.length - separators;
      for (int i = 0; i < diff; i++) {
        asset.hud.remove(asset.hud.chargeSeparator.last);
      }
    } else if (asset.hud.chargeSeparator.length < separators) {
      final diff = separators - asset.hud.chargeSeparator.length;
      for (int i = 0; i < diff; i++) {
        // asset.hud.chargeSeparator.add(GraphicsManager.createChargeSeparator());
        asset.hud.add(asset.hud.chargeSeparator.last);
      }
    }

    for (int i = 0; i < asset.hud.chargeSeparator.length; i++) {
      final offset = (asset.hud.chargebarBG.width / divisions) *
          (divisions - divisions.floor());
      final divBar =
          ((asset.hud.chargebarBG.width - offset) / divisions.floor());
      asset.hud.chargeSeparator[i].position = asset.hud.chargebarBG.position +
          Vector2(
              (i + 1) *
                  ((ownerID == Constants.FIRST_PLAYER) ? divBar : -divBar),
              0);
    }
  }
}
