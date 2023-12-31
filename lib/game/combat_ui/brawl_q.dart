import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:skygame_2d/game/helper.dart';
import 'package:skygame_2d/game/unit.dart';
import 'package:skygame_2d/graphics/graphics.dart';
import 'package:skygame_2d/utils.dart/constants.dart';
import 'package:skygame_2d/utils.dart/enums.dart';

class UnitQComponent extends PositionComponent with HasVisibility {
  ValueNotifier<MatchUnit> unit;
  int index;
  late SpriteComponent icon;
  late RectangleComponent badge;

  UnitQComponent(this.index, MatchUnit unit, {ComponentKey? key})
      : unit = ValueNotifier(unit),
        super(key: key) {
    icon = GraphicsManager.createUnitProfile(this.unit.value.ownerID,
        this.unit.value.position, this.unit.value.character.profile);
    icon.position = Vector2.all(0.0);
    icon.anchor = Anchor.center;
    icon.size = Vector2.all(55);
    add(icon);

    badge = RectangleComponent(
      anchor: Anchor.center,
      size: Vector2.all(16),
      position: Vector2(0, 45),
      paint: Paint()
        ..color =
            MatchHelper.isLeftTeam(this.unit.value) ? Colors.blue : Colors.red,
    );
    add(badge);

    position = Vector2(index * 80 + 40, 40.0);
  }

  @override
  FutureOr<void> onLoad() {
    unit.addListener(unitChanged);
    return super.onLoad();
  }

  @override
  void onRemove() {
    unit.removeListener(unitChanged);
    super.onRemove();
  }

  Future<void> unitChanged() async {
    icon.sprite = Sprite(unit.value.character.profile);
    icon.scale = Vector2(
        (unit.value.ownerID == Constants.SECOND_PLAYER) ? 1.0 : -1.0, 1.0);
    badge.paint.color =
        MatchHelper.isLeftTeam(unit.value) ? Colors.blue : Colors.red;
  }
}

class BrawlQComponent extends PositionComponent {
  final ValueNotifier<List<MatchUnit>> animatedQ;
  List<MatchUnit> units = [];
  List<UnitQComponent> iconQ = [];

  BrawlQComponent(List<MatchUnit> aniQ, {ComponentKey? key})
      : animatedQ = ValueNotifier(aniQ),
        units = aniQ,
        super(key: key) {
    add(main);
    add(RectangleComponent(
      anchor: Anchor.center,
      size: Vector2(500, 12),
      paint: Paint()..color = Colors.white,
    ));
    position = Vector2(Constants.SCREEN_CENTER.x, 200);

    final renderedUnits = _getRenderedUnits;
    for (int i = 0; i < renderedUnits.length; i++) {
      final newIconComp = UnitQComponent(i, renderedUnits[i]);
      iconQ.add(newIconComp);
      main.add(newIconComp);
    }
    onQueueChange();
  }

  final ClipComponent main = ClipComponent(
    builder: (region) {
      return Rectangle.fromRect(const Rect.fromLTWH(0, 0, 500, 120));
    },
    anchor: Anchor.center,
    priority: 5,
    size: Vector2(500, 100),
  );

  @override
  FutureOr<void> onLoad() {
    animatedQ.addListener(onQueueChange);
    return super.onLoad();
  }

  @override
  void onRemove() {
    animatedQ.removeListener(onQueueChange);
    super.onRemove();
  }

  List<MatchUnit> get _getRenderedUnits {
    final List<MatchUnit> result = animatedQ.value
        .where((e) => MatchHelper.isFrontrow(e.position))
        .toList();
    units.sort((a, b) => b.current.stats[StatType.execution]
        .compareTo(a.current.stats[StatType.execution]));
    while (result.length < 7) {
      result.addAll(units);
    }
    return result;
  }

  final Map<int, SpriteComponent> reusable = {};

  Future<void> onQueueChange() async {
    var renderedUnits = _getRenderedUnits;
    for (int i = 0; i < renderedUnits.length; i++) {
      final double startPos = i * 80 + 40;
      final double goal = i * 80 - 40;
      final eff =
          MoveEffect.to(Vector2(goal, 40.0), EffectController(duration: 1));
      if (i < iconQ.length) {
        iconQ[i].unit.value = renderedUnits[i];
        iconQ[i].position = Vector2(startPos, iconQ[i].position.y);
        iconQ[i].add(eff);
      } else {
        final newIconComp = UnitQComponent(i, renderedUnits[i]);
        iconQ.add(newIconComp);
        main.add(newIconComp);
        newIconComp.add(eff);
      }
    }
  }
}
