import 'dart:math';

import 'package:flame/components.dart';
import 'package:skygame_2d/game/unit.dart';
import 'package:skygame_2d/graphics/graphics.dart';
import 'package:skygame_2d/models/enums.dart';

extension UnitRenderExt on MatchUnit {
  TextComponent? textInfo(String key) {
    if (asset.infoList[key] is TextComponent) {
      return asset.infoList[key] as TextComponent;
    }
    return null;
  }

  SpriteComponent? iconInfo(String key) {
    if (asset.infoList[key] is SpriteComponent) {
      return asset.infoList[key] as SpriteComponent;
    }
    return null;
  }

  void updateAssetVisibility(double dt) {
    if (type != BrawlType.lead &&
        type != BrawlType.leftAce &&
        type != BrawlType.rightAce) {
      asset.healthbar.setOpacity(0);
      asset.healthbarBG.setOpacity(0);
      asset.chargebar.setOpacity(0);
      textInfo(DAMAGE_TEXT)!.text = '';
      textInfo(CHARGE_TEXT)!.text = '';
    } else {
      asset.healthbar.setOpacity(1);
      asset.healthbarBG.setOpacity(1);
      asset.chargebar.setOpacity(1);
      textInfo(DAMAGE_TEXT)!.text =
          '${currentStats[StatType.hp]} / ${iStats[StatType.hp]}';
      textInfo(CHARGE_TEXT)!.text = '${currentStats[StatType.storage]}';
      updateHealthBar(dt);
      updateChargeBar(dt);
    }
  }

  void updateHealthBar(double dt) {
    asset.healthbar.width =
        300 * max(0, currentStats[StatType.hp] / iStats[StatType.hp]);
  }

  void updateChargeBar(double dt) {
    asset.chargebar.width =
        300 * min(1, currentStats[StatType.storage] / iStats[StatType.storage]);
  }

  void updateChargeBarSeparator(double dt) {
    double divisions =
        max(0, (currentStats[StatType.storage] / iStats[StatType.storage]));
    if (divisions <= 1) {
      divisions = 0;
    }
    var separators = divisions.floor();
    if (divisions.floor() == divisions) separators = max(0, separators - 1);
    if (asset.chargeSeparator.length > separators) {
      final diff = asset.chargeSeparator.length - separators;
      for (int i = 0; i < diff; i++) {
        game.gameContext.remove(asset.chargeSeparator.last);
      }
    } else if (asset.chargeSeparator.length < separators) {
      final diff = separators - asset.chargeSeparator.length;
      for (int i = 0; i < diff; i++) {
        asset.chargeSeparator
            .add(GraphicsManager.createChargeSeparator(position));
        game.gameContext.add(asset.chargeSeparator.last);
      }
    }

    for (int i = 0; i < asset.chargeSeparator.length; i++) {
      final offset = (300 / divisions) * (divisions - divisions.floor());
      final divBar = ((300 - offset) / divisions.floor());
      asset.chargeSeparator[i].x = asset.chargebar.position.x +
          (i + 1) * ((owner == Owner.p1) ? divBar : -divBar);
    }
  }
}
