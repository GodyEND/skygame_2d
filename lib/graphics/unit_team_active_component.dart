import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:skygame_2d/graphics/component_grid.dart';
import 'package:skygame_2d/graphics/unit_team_component.dart';
import 'package:skygame_2d/models/match_unit/unit_team.dart';
import 'package:skygame_2d/utils.dart/constants.dart';
import 'package:skygame_2d/utils.dart/extensions.dart';

class ActiveUnitTeamComponent extends SpriteComponent {
  ValueNotifier<UnitTeam> team;
  bool isVisible;
  bool _teamWasUpdated = true;
  final List<SelectableUnitTeamComponentItem> selectableChildren = [];

  ActiveUnitTeamComponent({
    required UnitTeam team,
    this.isVisible = false,
    required super.size,
    Vector2? position,
  })  : team = ValueNotifier<UnitTeam>(team),
        super(
          sprite: Sprite(Constants.images.unitTeamBG!),
          position: position,
        );

  @override
  void onRemove() {
    super.onRemove();
    team.removeListener(teamNotifier());
  }

  void Function() teamNotifier() => () {
        _teamWasUpdated = true;
      };

  @override
  Future<void> onLoad() async {
    super.onLoad();

    team.addListener(teamNotifier());
    await refresh();
    selectableChildren.first.isSelected = true;
  }

  Future<void> refresh() async {
    if (!_teamWasUpdated) return;
    // get current selectedIndex
    final currentSelectedIndex =
        selectableChildren.firstWhereOrNull((e) => e.isSelected);
    removeAll(children);
    selectableChildren.clear();

    final childWidth = (size.x - 30 - 6 * 10) / 5;
    final childHeight = (size.y - 30 - 3 * 10) / 2;

    for (int i = 0; i < team.value.toList().length; i++) {
      final newItem = SelectableUnitTeamComponentItem(
        (team.value[i] != null) ? team.value[i] : null,
        index: i,
        size: Vector2(childWidth, childHeight),
      );
      if (currentSelectedIndex != null && i == currentSelectedIndex.index) {
        newItem.isSelected = true;
      }
      selectableChildren.add(newItem);
    }

    await add(ComponentGrid(
      children: selectableChildren,
      scrollDirection: Axis.vertical,
      size: size,
      position: Vector2(7, 7.0),
      itemsPerSet: 5,
      padding: Vector2(10, 10),
      priority: 99,
    ));
    _teamWasUpdated = false;
  }

  @override
  void render(Canvas canvas) async {
    super.render(canvas);
    await refresh();
  }
}
