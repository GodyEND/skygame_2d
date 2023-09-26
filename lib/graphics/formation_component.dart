import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:skygame_2d/models/components/selectable.dart';
import 'package:skygame_2d/models/match_unit/unit.dart';
import 'package:skygame_2d/utils.dart/constants.dart';

class FormationComponent extends SpriteComponent
    with SelectableSprite, HasVisibility {
  final int ownerID;
  final int _index;
  bool _wasUpdated = true;
  final ValueNotifier<int> selectedIndex;
  final ValueNotifier<Unit?> unit;

  FormationComponent({
    ComponentKey? key,
    required int index,
    required this.ownerID,
    required super.size,
    required int selectedIndex,
    Unit? unit,
    Vector2? position,
  })  : _index = index,
        selectedIndex = ValueNotifier(0),
        unit = ValueNotifier(unit),
        super(
          key: key,
          sprite: Sprite(unit?.select ?? Constants.images.unitTeamBG!),
          position: position,
        ) {
    isVisible = false;
  }

  @override
  int get index => _index;

  @override
  void onRemove() {
    super.onRemove();
    unit.removeListener(unitNotifier());
    selectedIndex.removeListener(unitNotifier());
  }

  void Function() unitNotifier() => () {
        _wasUpdated = true;
      };

  @override
  Future<void> onLoad() async {
    super.onLoad();
    unit.addListener(unitNotifier());
    selectedIndex.addListener(unitNotifier());
    await refresh();
  }

  Future<void> refresh() async {
    if (!_wasUpdated) return;
    isSelected = (selectedIndex.value == _index);
    sprite = Sprite(unit.value?.select ?? Constants.images.unitTeamBG!);
    _wasUpdated = false;
  }

  @override
  void render(Canvas canvas) async {
    super.render(canvas);
    await refresh();
  }
}
