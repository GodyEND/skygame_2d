// ignore_for_file: constant_identifier_names

import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:skygame_2d/game/stage.dart';
import 'package:skygame_2d/utils.dart/constants.dart';
import 'package:skygame_2d/utils.dart/enums.dart';

// Keys
const String SCORE_TEXT = 'score_text';
const String EVENT_TEXT = 'event_text';
const String EXEC_ICON = 'exec_icon';

const String PF_BG = '_bg';
const String PF_SPRITE = '_sprite';
const String PF_PROFILE = '_profile';
const String PF_SELECT = '_select';
// const String MATCH_ACTIONS_PF = '_actions';

class GraphicsManager {
// extension GameManagerExt on GameManager {
  // static void get prepareStageAssets {
  //   // Load BGs
  //   for (int i = 0; i < Sprites.gMaps.length; i++) {
  //     final newComp = SpriteComponent(
  //         size: Vector2(Constants.SCREEN_WIDTH, Constants.SCREEN_HEIGHT),
  //         position: Vector2(
  //           Constants.SCREEN_WIDTH * 0.5,
  //           Constants.SCREEN_HEIGHT * 0.5,
  //         ),
  //         anchor: Anchor.center);
  //     newComp.sprite = Sprite(Sprites.gMaps[i]);
  //     GameManager.spriteList['$i$PF_BG'] = newComp;
  //   }

  // Load Texts
  static TextComponent get createEventText {
    return TextComponent(
      text: '',
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 40,
            inherit: true,
            color: Colors.white,
            shadows: _stroke(Colors.black, 3)),
      ),
    );
  }

  // GameManager.spriteList[SCORE_TEXT] = createScoreHUDText();
  // }

  static SpriteComponent createUnitSprite(
      int ownerID, MatchPosition unitPos, ui.Image image) {
    final scale =
        Vector2((ownerID != Constants.FIRST_PLAYER) ? 1.0 : -1.0, 1.0);
    return SpriteComponent(
        size: Vector2(80, 80),
        scale: scale,
        position: Stage.positions(ownerID)[unitPos],
        sprite: Sprite(image),
        anchor: Anchor.center);
  }

  static SpriteComponent createUnitProfile(
      int ownerID, MatchPosition unitPos, ui.Image image,
      {Vector2? overrideSize}) {
    var size = Vector2(100, 100);

    if (unitPos == MatchPosition.leftLink ||
        unitPos == MatchPosition.rightLink) {
      size = Vector2(70, 70);
    }
    final scale =
        Vector2((ownerID == Constants.SECOND_PLAYER) ? 1.0 : -1.0, 1.0);
    return SpriteComponent(
      size: overrideSize ?? size,
      scale: scale,
      position: Stage.hudPositions(ownerID)[unitPos],
      sprite: Sprite(image),
    );
  }

  static TextComponent createScoreHUDText() {
    return TextComponent(
      anchor: Anchor.center,
      priority: Constants.HUD_TEXT_PRIORITY,
      position: Vector2(Constants.SCREEN_CENTER.x, 100),
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
      priority: Constants.HUD_TEXT_PRIORITY,
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

  static SpriteComponent createStage(ui.Image image) {
    return SpriteComponent(
      size: Vector2(Constants.SCREEN_WIDTH, Constants.SCREEN_HEIGHT),
      position: Vector2(
        Constants.SCREEN_WIDTH * 0.5,
        Constants.SCREEN_HEIGHT * 0.5,
      ),
      anchor: Anchor.center,
      sprite: Sprite(image),
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

  static RectangleComponent createHealthBar() {
    final sprite = RectangleComponent(size: Vector2(300, 25));
    sprite.setColor(Colors.green);
    sprite.priority = 2;
    return sprite;
  }

  static RectangleComponent createHealthBarBG() {
    final sprite = RectangleComponent(size: Vector2(300, 25));
    sprite.setColor(Colors.black);
    sprite.priority = 1;
    return sprite;
  }

  static RectangleComponent createChargeBar() {
    final sprite = RectangleComponent(size: Vector2(0, 12));
    sprite.setColor(Colors.blue);
    sprite.priority = 2;
    return sprite;
  }

  static RectangleComponent createChargeBarBG() {
    final sprite = RectangleComponent(size: Vector2(300, 12));
    sprite.setColor(Colors.grey.shade500);
    sprite.priority = 1;
    return sprite;
  }

  static RectangleComponent createChargeSeparator() {
    final sprite = RectangleComponent(size: Vector2(3, 12));
    sprite.setColor(Colors.black);
    sprite.priority = 3;
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
