import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:skygame_2d/graphics/component_grid.dart';
import 'package:skygame_2d/graphics/unit_team_component.dart';
import 'package:skygame_2d/models/components/selectable.dart';
import 'package:skygame_2d/models/match_unit/unit.dart';
import 'package:skygame_2d/utils.dart/constants.dart';

class UnitCollectionComponent extends SpriteComponent with SelectableSprite {
  final List<Unit?> units;

  UnitCollectionComponent({
    required this.units,
    required super.size,
    Vector2? position,
  }) : super(
          sprite: Sprite(Constants.images.unitTeamBG!),
          position: position,
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final childWidth = (size.x - 30 - 11 * 3) / 10;

    final List<PositionComponent> _children = [];

    final colLength = (units.length / 10).ceil() * 10;

    for (int i = 0; i < colLength; i++) {
      if (i < units.length && units[i] != null) {
        _children.add(UnitTeamComponentItem(
          units[i]!,
          size: Vector2(childWidth, childWidth),
        ));
      } else {
        // Unused slot
        // TODO: change with placeholder graphic
        _children.add(RectangleComponent(
          size: Vector2(childWidth, childWidth),
          paint: Paint()..color = Colors.blueGrey,
          priority: 99,
        ));
      }
    }

    await add(ComponentGrid(
      children: _children,
      scrollDirection: Axis.vertical,
      size: size,
      position: Vector2(9, 3.0),
      itemsPerSet: 10,
      padding: Vector2(3, 3),
      priority: 99,
    ));
  }
}
