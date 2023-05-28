import 'dart:ui' as ui;
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:skygame_2d/game/game.dart';
import 'package:skygame_2d/game/helper.dart';
import 'package:skygame_2d/game/stage.dart';
import 'package:skygame_2d/models/enums.dart';
import 'package:skygame_2d/setup.dart';

// Keys
const String SCORE_TEXT = 'score_text';
const String DAMAGE_TEXT = 'damage_text';
const String CHARGE_TEXT = 'charge_text';
const String EVENT_TEXT = 'event_text';
const String EXEC_ICON = 'exec_icon';

const String PF_BG = '_bg';
const String PF_SPRITE = '_sprite';
const String PF_PROFILE = '_profile';
// const String MATCH_ACTIONS_PF = '_actions';

class GraphicsManager {
// extension GameManagerExt on GameManager {
  static void get prepareStageAssets {
    // Load BGs
    for (int i = 0; i < Sprites.gMaps.length; i++) {
      final newComp = SpriteComponent(
          size: Vector2(1920, 1080), position: Vector2(0.0, 0.0));
      newComp.sprite = Sprite(Sprites.gMaps[i]);
      GameManager.spriteList['$i$PF_BG'] = newComp;
    }

    // Load Texts
    GameManager.spriteList[EVENT_TEXT] = TextComponent(
      text: '',
      position: Vector2(960, 750),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 45,
            inherit: true,
            color: Colors.white,
            shadows: _stroke(Colors.black, 3)),
      ),
    );

    GameManager.spriteList[SCORE_TEXT] = createScoreHUDText();
  }

  static SpriteComponent createUnitSprite(
      MatchPosition unitPos, ui.Image image) {
    final owner = MatchHelper.getOwner(unitPos);
    final scale = Vector2((owner == Owner.p2) ? 1.0 : -1.0, 1.0);
    return SpriteComponent(
        size: Vector2(80, 80),
        scale: scale,
        position: Stage.positions[unitPos],
        sprite: Sprite(image),
        anchor: Anchor.center);
  }

  static SpriteComponent createUnitProfile(
      MatchPosition unitPos, ui.Image image,
      {Vector2? overrideSize}) {
    var size = Vector2(100, 100);
    final owner = MatchHelper.getOwner(unitPos);
    final fieldPos = MatchHelper.getBrawlType(unitPos);
    if (fieldPos == BrawlType.leftLink || fieldPos == BrawlType.rightLink) {
      size = Vector2(70, 70);
    }
    final scale = Vector2((owner == Owner.p2) ? 1.0 : -1.0, 1.0);
    return SpriteComponent(
      size: overrideSize ?? size,
      scale: scale,
      position: Stage.hudPositions[unitPos],
      sprite: Sprite(image),
      anchor: Anchor.center,
    );
  }

  static TextComponent createHPHUDText(MatchPosition unitPos) {
    final sprite = createHUDText;
    final owner = MatchHelper.getOwner(unitPos);
    sprite.position = Stage.hudPositions[unitPos] ?? Vector2(0, 0);
    sprite.position += owner == Owner.p1 ? Vector2(210, 12) : Vector2(-210, 12);
    return sprite;
  }

  static TextComponent createChargeHUDText(MatchPosition unitPos) {
    final sprite = createHUDText;
    final owner = MatchHelper.getOwner(unitPos);
    sprite.position = Stage.hudPositions[unitPos] ?? Vector2(0, 0);
    sprite.position += owner == Owner.p1 ? Vector2(210, 43) : Vector2(-210, 43);
    return sprite;
  }

  static TextComponent createScoreHUDText() {
    return TextComponent(
      anchor: Anchor.center,
      priority: 5,
      position: Vector2(950, 100),
      textRenderer: TextPaint(
        style: TextStyle(
            fontWeight: FontWeight.w900,
            inherit: true,
            fontSize: 64,
            color: Colors.white,
            shadows: _stroke(Colors.black, 3)),
      ),
    );
  }

  static TextComponent get createHUDText {
    return TextComponent(
      anchor: Anchor.center,
      priority: 5,
      textRenderer: TextPaint(
        style: TextStyle(
            fontWeight: FontWeight.w900,
            inherit: true,
            fontSize: 16,
            color: Colors.white,
            shadows: _stroke(Colors.black, 1)),
      ),
    );
  }

  static TextComponent get createDamageText {
    return TextComponent(
      scale: Vector2(0, 0),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: TextStyle(
            fontWeight: FontWeight.w900,
            inherit: true,
            fontSize: 28,
            color: Colors.red,
            shadows: _stroke(Colors.white, 1)),
      ),
    );
  }

  static TextComponent get createChargeText {
    return TextComponent(
      text: '',
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 20,
            inherit: true,
            color: Colors.blue,
            shadows: _stroke(Colors.white, 1)),
      ),
    );
  }

  static RectangleComponent createHealthBar(MatchPosition unitPos) {
    final sprite = RectangleComponent(size: Vector2(300, 25));
    sprite.setColor(Colors.green);
    sprite.priority = 2;
    final fieldPos = MatchHelper.getBrawlType(unitPos);

    if (fieldPos != BrawlType.lead &&
        fieldPos != BrawlType.leftAce &&
        fieldPos != BrawlType.rightAce) {
      return sprite;
    }

    final owner = MatchHelper.getOwner(unitPos);
    if (owner == Owner.p1) {
      sprite.position = Stage.hudPositions[unitPos]! + Vector2(60, 0);
    } else {
      sprite.anchor = Anchor.topRight;
      sprite.position = Stage.hudPositions[unitPos]! - Vector2(60, 0);
    }
    return sprite;
  }

  static RectangleComponent createHealthBarBG(MatchPosition unitPos) {
    final sprite = RectangleComponent(size: Vector2(300, 25));
    sprite.setColor(Colors.black);
    sprite.priority = 1;
    final fieldPos = MatchHelper.getBrawlType(unitPos);

    if (fieldPos != BrawlType.lead &&
        fieldPos != BrawlType.leftAce &&
        fieldPos != BrawlType.rightAce) {
      return sprite;
    }

    final owner = MatchHelper.getOwner(unitPos);
    if (owner == Owner.p1) {
      sprite.position = Stage.hudPositions[unitPos]! + Vector2(60, 0);
    } else {
      sprite.anchor = Anchor.topRight;
      sprite.position = Stage.hudPositions[unitPos]! - Vector2(60, 0);
    }
    return sprite;
  }

  static RectangleComponent createChargeBar(MatchPosition unitPos) {
    final sprite = RectangleComponent(size: Vector2(0, 12));
    sprite.setColor(Colors.blue);
    sprite.priority = 1;

    final fieldPos = MatchHelper.getBrawlType(unitPos);

    if (fieldPos != BrawlType.lead &&
        fieldPos != BrawlType.leftAce &&
        fieldPos != BrawlType.rightAce) {
      return sprite;
    }

    final owner = MatchHelper.getOwner(unitPos);
    if (owner == Owner.p1) {
      sprite.position = Stage.hudPositions[unitPos]! + Vector2(60, 37);
    } else {
      sprite.anchor = Anchor.topRight;
      sprite.position = Stage.hudPositions[unitPos]! - Vector2(60, -37);
    }
    return sprite;
  }

  static RectangleComponent createChargeSeparator(MatchPosition unitPos) {
    final sprite = RectangleComponent(size: Vector2(3, 12));
    sprite.setColor(Colors.black);
    sprite.priority = 2;

    final owner = MatchHelper.getOwner(unitPos);
    if (owner == Owner.p1) {
      sprite.position = Stage.hudPositions[unitPos]! + Vector2(60, 37);
    } else {
      sprite.anchor = Anchor.topRight;
      sprite.position = Stage.hudPositions[unitPos]! - Vector2(60, -37);
    }
    return sprite;
  }

  static List<Shadow> _stroke(Color c, double thickness) {
    return [
      Shadow(
          // bottomLeft
          offset: Offset(-thickness, -thickness),
          color: c),
      Shadow(
          // bottomRight
          offset: Offset(thickness, -thickness),
          color: c),
      Shadow(
          // topRight
          offset: Offset(thickness, thickness),
          color: c),
      Shadow(
          // topLeft
          offset: Offset(-thickness, thickness),
          color: c),
    ];
  }
}
