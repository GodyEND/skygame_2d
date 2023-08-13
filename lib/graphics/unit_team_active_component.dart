import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:skygame_2d/graphics/component_grid.dart';
import 'package:skygame_2d/graphics/unit_team_component.dart';
import 'package:skygame_2d/models/match_unit/unit_team.dart';
import 'package:skygame_2d/utils.dart/constants.dart';

class ActiveUnitTeamComponent extends SpriteComponent {
  UnitTeam team;
  bool isVisible;

  ActiveUnitTeamComponent({
    required this.team,
    this.isVisible = false,
    required super.size,
    Vector2? position,
  }) : super(
          sprite: Sprite(Constants.images.unitTeamBG!),
          position: position,
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await refresh();
  }

  Future<void> refresh() async {
    removeAll(children);

    final childWidth = (size.x - 30 - 6 * 10) / 5;
    final childHeight = (size.y - 30 - 3 * 10) / 2;

    final List<PositionComponent> _children = [];

    for (int i = 0; i < team!.toList().length; i++) {
      if (team[i] != null) {
        _children.add(UnitTeamComponentItem(
          team[i],
          size: Vector2(childWidth, childHeight),
        ));
      } else {
        // Unused slot
        // TODO: change with placeholder graphic
        _children.add(RectangleComponent(
          size: Vector2(childWidth, childHeight),
          paint: Paint()..color = Colors.blueGrey,
          priority: 99,
        ));
      }
    }

    await add(ComponentGrid(
      children: _children,
      scrollDirection: Axis.vertical,
      size: size,
      position: Vector2(7, 7.0),
      itemsPerSet: 5,
      padding: Vector2(10, 10),
      priority: 99,
    ));
  }
}
