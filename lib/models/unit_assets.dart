import 'package:flame/components.dart';
import 'package:skygame_2d/game/unit.dart';
import 'package:skygame_2d/graphics/unit_animations.dart';

class UnitAssets {
  late MatchUnit unit;
  final SpriteComponent sprite;
  final SpriteComponent profile;
  final ShapeComponent healthbar;
  final ShapeComponent healthbarBG;
  final ShapeComponent chargebar;
  final List<ShapeComponent> chargeSeparator = [];
  final Map<String, Component> infoList;
  UnitAniState animationState = UnitAniState.idle;
  double elapsedTime = 0.0;
  double hitCounter = 0.0;

  UnitAssets({
    required this.sprite,
    required this.profile,
    required this.healthbar,
    required this.healthbarBG,
    required this.chargebar,
    required this.infoList,
  });
}
