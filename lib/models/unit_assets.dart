import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:skygame_2d/game/unit.dart';
import 'package:skygame_2d/graphics/unit_animations.dart';
import 'package:skygame_2d/models/unit_hud.dart';

class UnitAssets {
  late MatchUnit unit;
  // Combat Asset
  final SpriteComponent sprite;
// Hud asset
  final UnitHUDComponent hud;

  final Map<String, Component> infoList;
  ValueNotifier<UnitAniState> animationState = ValueNotifier(UnitAniState.idle);
  ValueNotifier<Function()> animationListener = ValueNotifier(() {});
  Function() prevListener = () {};

  UnitAssets({
    required this.sprite,
    required this.hud,
    required this.infoList,
  }) {
    animationListener.addListener(manageAnimationStateListener);
  }

  manageAnimationStateListener() {
    for (var child in sprite.children) {
      sprite.remove(child);
    }
    animationState.removeListener(prevListener);
    prevListener = animationListener.value;
    animationState.addListener(animationListener.value);
  }
}
