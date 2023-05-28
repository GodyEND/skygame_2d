import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:skygame_2d/game/helper.dart';
import 'package:skygame_2d/graphics/graphics.dart';
import 'package:skygame_2d/main.dart';
import 'package:skygame_2d/models/unit_assets.dart';
import 'package:skygame_2d/models/unit_render_ext.dart';

extension UnitAssetsExt on UnitAssets {
  void addToGame(SkyGame2D gameContext) {
    gameContext.add(profile);
    gameContext.add(sprite);
    gameContext.add(healthbar);
    gameContext.add(healthbarBG);
    gameContext.add(chargebar);
    gameContext.add(infoList[DAMAGE_TEXT]!);
    gameContext.add(infoList[CHARGE_TEXT]!);
  }

  void get prepCombatAssets {
    final profileCopy = GraphicsManager.createUnitProfile(
        unit.position, unit.character.profile);
    profile.size = profileCopy.size;
    profile.scale = profileCopy.scale;
    profile.position = profileCopy.position;
    profile.anchor = profileCopy.anchor;

    final spriteCopy =
        GraphicsManager.createUnitSprite(unit.position, unit.character.image);
    sprite.size = spriteCopy.size;
    sprite.scale = spriteCopy.scale;
    sprite.position = spriteCopy.position;
    sprite.anchor = spriteCopy.anchor;

    final healthCopy = GraphicsManager.createHealthBar(unit.position);
    healthbar.position = healthCopy.position;
    healthbar.anchor = healthCopy.anchor;
    healthbarBG.position = healthCopy.position;
    healthbarBG.anchor = healthCopy.anchor;

    final chargeCopy = GraphicsManager.createChargeBar(unit.position);
    chargebar.position = chargeCopy.position;
    chargebar.anchor = chargeCopy.anchor;

    final hpHUDCopy = GraphicsManager.createHPHUDText(unit.position);
    unit.textInfo(DAMAGE_TEXT)!.position = hpHUDCopy.position;
    final chargeHUDCopy = GraphicsManager.createChargeHUDText(unit.position);
    unit.textInfo(CHARGE_TEXT)!.position = chargeHUDCopy.position;
  }

  void clearAssets(SkyGame2D gameContext) {
    MatchHelper.remove(gameContext, healthbar);
    MatchHelper.remove(gameContext, healthbarBG);
    MatchHelper.remove(gameContext, chargebar);
    MatchHelper.remove(gameContext, profile);
    MatchHelper.remove(gameContext, sprite);
    MatchHelper.remove(gameContext, infoList[DAMAGE_TEXT]!);
    MatchHelper.remove(gameContext, infoList[CHARGE_TEXT]!);
    MatchHelper.removeAll(gameContext, chargeSeparator);
  }

  Future<void> fireDamage(Vector2 startPos, int damage) async {
    final sprite = GraphicsManager.createDamageText;
    sprite.text = '$damage DMG';
    sprite.position = startPos;
    unit.game.gameContext.add(sprite);

    final controller = EffectController(duration: 0.75);
    sprite.add(ScaleEffect.to(Vector2.all(1), controller));
    sprite.add(MoveEffect.to(startPos + Vector2(0, -35), controller));
    sprite.add(RemoveEffect(delay: 0.75));
  }

  Future<void> fireCharge(Vector2 startPos, int charge) async {
    final sprite = GraphicsManager.createChargeText;
    sprite.text = '$charge';
    sprite.position = startPos;
    unit.game.gameContext.add(sprite);

    final controller = EffectController(duration: 0.75);
    sprite.add(ScaleEffect.to(Vector2.all(1), controller));
    sprite.add(MoveEffect.to(startPos + Vector2(0, -30), controller));
    sprite.add(RemoveEffect(delay: 0.75));
  }
}
