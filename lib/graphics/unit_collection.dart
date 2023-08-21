import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:skygame_2d/graphics/component_grid.dart';
import 'package:skygame_2d/graphics/unit_team_component.dart';
import 'package:skygame_2d/models/match_unit/unit.dart';
import 'package:skygame_2d/utils.dart/constants.dart';
import 'package:skygame_2d/utils.dart/extensions.dart';

class UnitCollectionComponent extends SpriteComponent {
  ValueNotifier<List<Unit?>> units;
  bool isVisible;
  bool _unitWasUpdated = true;
  final List<SelectableUnitTeamComponentItem> selectableChildren = [];

  UnitCollectionComponent({
    required List<Unit?> units,
    this.isVisible = false,
    required super.size,
    Vector2? position,
  })  : units = ValueNotifier<List<Unit?>>(units),
        super(
          sprite: Sprite(Constants.images.unitTeamBG!),
          position: position,
        );

  @override
  void onRemove() {
    super.onRemove();
    units.removeListener(unitsNotifier());
  }

  void Function() unitsNotifier() => () {
        _unitWasUpdated = true;
      };

  @override
  Future<void> onLoad() async {
    super.onLoad();
    units.addListener(unitsNotifier());
    await refresh();
    if (selectableChildren.isNotEmpty) {
      selectableChildren.first.isSelected = true;
    }
  }

  Future<void> refresh() async {
    if (!_unitWasUpdated) return;
    // get current selectedIndex
    final currentSelectedIndex =
        selectableChildren.firstWhereOrNull((e) => e.isSelected);
    removeAll(children);
    selectableChildren.clear();
    final childWidth = (size.x - 30 - 11 * 3) / 10;

    final colLength = (units.value.length / 10).ceil() * 10;

    for (int i = 0; i < colLength; i++) {
      final newItem = SelectableUnitTeamComponentItem(
        (i < units.value.length && units.value[i] != null)
            ? units.value[i]!
            : null,
        index: i,
        size: Vector2(childWidth, childWidth),
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
      position: Vector2(9, 3.0),
      itemsPerSet: 10,
      padding: Vector2(3, 3),
      priority: 99,
    ));

    _unitWasUpdated = false;
  }

  @override
  void render(Canvas canvas) async {
    super.render(canvas);
    await refresh();
  }
}
