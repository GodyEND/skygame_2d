import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:skygame_2d/game/unit.dart';
import 'package:skygame_2d/graphics/unit_animations.dart';

class UnitStatusHUDComponent {
  // final SpriteComponent profile;
  // final ShapeComponent healthbar;
  // final ShapeComponent healthbarBG;
  // final ShapeComponent chargebar;
  // final ShapeComponent chargebarBG;
  final List<ShapeComponent> chargeSeparator = [];
}

class UnitAssets {
  late MatchUnit unit;
  // Combat Asset
  final SpriteComponent sprite;
// Hud asset
  // final UnitStatusHUDComponent hud;

  final Map<String, Component> infoList;
  ValueNotifier<UnitAniState> animationState = ValueNotifier(UnitAniState.idle);
  // double elapsedTime = 0.0;
  // double hitCounter = 0.0;
  ValueNotifier<Function()> animationListener = ValueNotifier(() {});
  Function() prevListener = () {};

  UnitAssets({
    required this.sprite,
    // required this.profile,
    // required this.healthbar,
    // required this.healthbarBG,
    // required this.chargebar,
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
