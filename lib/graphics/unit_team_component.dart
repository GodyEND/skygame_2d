import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:skygame_2d/scenes/team_builder/bloc/bloc.dart';
import 'package:skygame_2d/graphics/component_grid.dart';
import 'package:skygame_2d/models/components/selectable.dart';
import 'package:skygame_2d/models/match_unit/unit.dart';
import 'package:skygame_2d/models/match_unit/unit_team.dart';
import 'package:skygame_2d/scenes/team_builder/team_builder.dart';
import 'package:skygame_2d/utils.dart/constants.dart';
import 'package:skygame_2d/utils.dart/enums.dart';

class UnitTeamComponentItem extends SpriteComponent {
  final Unit unit;
  UnitTeamComponentItem(
    this.unit, {
    required Vector2 size,
  }) : super(
          sprite: Sprite(unit.select),
          size: size,
          scale: Vector2.all((size.x - 6) / size.x),
        );
}

class SelectableUnitTeamComponentItem extends SpriteComponent
    with SelectableSprite {
  final Unit? unit;
  final int _index;

  SelectableUnitTeamComponentItem(
    this.unit, {
    required int index,
    required Vector2 size,
    Vector2? position,
  })  : _index = index,
        super(
          sprite: Sprite(unit?.select ?? Constants.images.unitTeamBG!),
          size: size,
          scale: Vector2.all((size.x - 6) / size.x),
          position: position,
        );

  @override
  int get index => _index;
}

class UnitTeamComponent extends SpriteComponent with SelectableSprite {
  final int _index;
  final UnitTeam team;
  final int ownerID;

  UnitTeamComponent({
    required int index,
    required this.team,
    required super.size,
    required this.ownerID,
    Vector2? position,
  })  : _index = index,
        super(
          sprite: Sprite(Constants.images.unitTeamBG!),
          position: position,
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final childWidth = (size.x - 30 - 11 * 3) / 10;
    final childHeight = (size.y - 6 - 2 * 3);

    final List<PositionComponent> _children = [];

    for (int i = 0; i < team.toList().length; i++) {
      if (team[i] != null) {
        _children.add(UnitTeamComponentItem(
          team[i],
          size: Vector2(childWidth, childHeight),
        ));
      } else {
        // Unused slot
        // TODO: change with placeholder graphic
        _children.add(RectangleComponent(
          size: Vector2(childWidth, childHeight * 0.93),
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
      itemsPerSet: team.toList().length,
      padding: Vector2(3, 3),
      priority: 99,
    ));
  }

  @override
  int get index => _index;
  TextPaint options =
      TextPaint(style: const TextStyle(fontSize: 22.0, color: Colors.white));
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final scene = SceneManager.scenes
            .firstWhere((e) => e is TeamBuilderScene && e.ownerID == ownerID)
        as TeamBuilderScene;
    if (isHovered &&
        (scene.managedBloc as TeamBuilderBloc).state.viewState ==
            TeamBuilderViewState.team) {
      options.render(
          canvas, 'Edit (Space)    Select (1)', Vector2(size.x * 0.6, size.y));
    }
  }
}
