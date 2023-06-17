import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:skygame_2d/game/helper.dart';
import 'package:skygame_2d/game/stage.dart';
import 'package:skygame_2d/graphics/graphics.dart';
import 'package:skygame_2d/models/enums.dart';

class UnitHUDComponent extends PositionComponent {
  late SpriteComponent profile;
  final ui.Image profileImage;
  MatchPosition matchPosition;
  late ShapeComponent healthbar;
  late ShapeComponent healthbarBG;
  late ShapeComponent chargebar;
  late ShapeComponent chargebarBG;
  late TextComponent hpText;
  late TextComponent chargeText;
  late List<ShapeComponent> chargeSeparator = [];

  UnitHUDComponent({
    required this.profileImage,
    required this.matchPosition,
    required Vector2 size,
  }) : super(size: size) {
    anchor = Anchor.topLeft;
    position = Stage.hudPositions[matchPosition] ?? Vector2(0, 0);

    // Create Sprites
    profile = GraphicsManager.createUnitProfile(matchPosition, profileImage);
    healthbar = GraphicsManager.createHealthBar();
    healthbarBG = GraphicsManager.createHealthBarBG();
    chargebar = GraphicsManager.createChargeBar();
    chargebarBG = GraphicsManager.createChargeBarBG();
    // Text
    hpText = GraphicsManager.createHUDText;
    chargeText = GraphicsManager.createHUDText;
    // Set sprite positions
    add(profile);
    add(healthbarBG);
    add(healthbar);
    add(chargebarBG);
    add(chargebar);
    add(hpText);
    add(chargeText);
    _setHUDPosition;
  }

  void refresh(MatchPosition pos) {
    matchPosition = pos;
    _setHUDPosition;
  }

  void get _setHUDPosition {
    final fieldPos = MatchHelper.getBrawlType(matchPosition);
    if (fieldPos.index > BrawlType.rightLink.index) return;
    final hudPos = Stage.hudPositions[matchPosition]!;
    final isP1 = MatchHelper.getOwner(matchPosition) == Owner.p1;
    position = hudPos;
    final childAnchor = (isP1) ? Anchor.topLeft : Anchor.topRight;

    profile.anchor = anchor;
    profile.position = Vector2(0, 0);

    if (MatchHelper.isFrontrow(fieldPos)) {
      profile.size = Vector2(100, 100);
      healthbarBG.anchor = childAnchor;
      healthbarBG.position = Vector2(isP1 ? 15 : profile.position.x - 15, 35);
      healthbar.anchor = childAnchor;
      healthbar.position = Vector2(isP1 ? 15 : profile.position.x - 15, 35);
      chargebarBG.anchor = childAnchor;
      chargebarBG.position = Vector2(isP1 ? 15 : profile.position.x - 15, 65);
      chargebar.anchor = childAnchor;
      chargebar.position = Vector2(isP1 ? 15 : profile.position.x - 15, 65);
      hpText.anchor = Anchor.center;
      hpText.position = healthbarBG.position +
          Vector2(healthbarBG.width * (isP1 ? 0.5 : -0.5), 13);
      chargeText.anchor = Anchor.center;
      chargeText.position = chargebarBG.position +
          Vector2(healthbarBG.width * (isP1 ? 0.5 : -0.5), 6);
    } else {
      profile.size = Vector2(70, 70);
    }
    setOpacity();
  }

  void setOpacity() {
    final fieldPos = MatchHelper.getBrawlType(matchPosition);
    if (MatchHelper.isFrontrow(fieldPos)) {
      profile.setOpacity(1);
      healthbarBG.setOpacity(1);
      healthbar.setOpacity(1);
      chargebarBG.setOpacity(1);
      chargebar.setOpacity(1);
    } else {
      profile.setOpacity(0);
      healthbarBG.setOpacity(0);
      healthbar.setOpacity(0);
      chargebarBG.setOpacity(0);
      chargebar.setOpacity(0);
      chargeSeparator.clear();
      hpText.text = '';
      chargeText.text = '';
    }
  }
}