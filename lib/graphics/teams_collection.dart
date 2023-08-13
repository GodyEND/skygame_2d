import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:skygame_2d/graphics/component_grid.dart';
import 'package:skygame_2d/graphics/unit_team_component.dart';
import 'package:skygame_2d/models/match_unit/unit_team.dart';
import 'package:skygame_2d/utils.dart/constants.dart';

class TeamsCollectionComponent extends PositionComponent {
  List<UnitTeam> teams;
  final List<UnitTeamComponent> menuItemList = [];
  bool isVisible;

  TeamsCollectionComponent({
    required this.teams,
    this.isVisible = false,
    Vector2? position,
  }) : super(
          size: Vector2(Constants.SCREEN_WIDTH, Constants.SCREEN_HEIGHT),
          position: position,
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await refresh();
  }

  Future<void> refresh() async {
    for (int i = 0; i < teams.length; i++) {
      final menuItem = UnitTeamComponent(
        index: i,
        team: teams[i],
        size: Vector2(1200, 180),
      );
      menuItemList.add(menuItem);
    }

    add(ComponentGrid(
        children: menuItemList,
        scrollDirection: Axis.vertical,
        size: Vector2(Constants.SCREEN_WIDTH, menuItemList.length * 180.0),
        position: Vector2(0, 0),
        itemsPerSet: 1));
  }
}
