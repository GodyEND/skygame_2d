import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:skygame_2d/graphics/component_grid.dart';
import 'package:skygame_2d/graphics/unit_team_component.dart';
import 'package:skygame_2d/models/match_unit/unit_team.dart';
import 'package:skygame_2d/utils.dart/constants.dart';
import 'package:skygame_2d/utils.dart/extensions.dart';

class TeamsCollectionComponent extends PositionComponent {
  ValueNotifier<List<UnitTeam>> teams;
  final List<UnitTeamComponent> menuItemList = [];
  final int ownerID;
  bool isVisible;
  bool _teamWasUpdated = true;

  TeamsCollectionComponent({
    required List<UnitTeam> teams,
    required this.ownerID,
    this.isVisible = false,
  })  : teams = ValueNotifier<List<UnitTeam>>(teams),
        super(anchor: Anchor.topLeft);

  @override
  void onRemove() {
    super.onRemove();
    teams.removeListener(teamNotifier());
  }

  void Function() teamNotifier() => () {
        _teamWasUpdated = true;
      };

  @override
  Future<void> onLoad() async {
    super.onLoad();
    teams.addListener(teamNotifier());

    await refresh();
    if (menuItemList.isNotEmpty) {
      menuItemList.first.isHovered = true;
    }
  }

  Future<void> refresh() async {
    if (!_teamWasUpdated) return;
    // Set component dimensions
    final positionedParent = parent as PositionComponent;
    size = positionedParent.size;
    // get current selectedIndex
    final currentSelectedIndex =
        menuItemList.firstWhereOrNull((e) => e.isHovered);
    final currentActiveIndex =
        menuItemList.firstWhereOrNull((e) => e.isSelected);
    removeAll(children);
    menuItemList.clear();

    for (int i = 0; i < teams.value.length; i++) {
      final menuItem = UnitTeamComponent(
        index: i,
        team: teams.value[i],
        size: Vector2(size.x * 0.8, size.y * 180 / Constants.SCREEN_HEIGHT),
        ownerID: ownerID,
      );
      if (currentSelectedIndex != null && i == currentSelectedIndex.index) {
        menuItem.isHovered = true;
      }
      if (currentActiveIndex != null && i == currentActiveIndex.index) {
        menuItem.isSelected = true;
      }
      menuItemList.add(menuItem);
    }

    await add(ComponentGrid(
        children: menuItemList,
        scrollDirection: Axis.vertical,
        size: Vector2(size.x,
            menuItemList.length * size.y * 180 / Constants.SCREEN_HEIGHT),
        position: Vector2(0, 0),
        itemsPerSet: 1));
    _teamWasUpdated = false;
  }

  @override
  void render(Canvas canvas) async {
    super.render(canvas);
    await refresh();
  }
}
