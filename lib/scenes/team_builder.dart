import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:skygame_2d/bloc/key_input/listener.dart';
import 'package:skygame_2d/bloc/team_builder/bloc.dart';
import 'package:skygame_2d/bloc/team_builder/listener.dart';
import 'package:skygame_2d/bloc/team_builder/state.dart';
import 'package:skygame_2d/graphics/component_grid.dart';
import 'package:skygame_2d/graphics/unit_collection.dart';
import 'package:skygame_2d/graphics/unit_team_component.dart';
import 'package:skygame_2d/models/components/selectable.dart';
import 'package:skygame_2d/models/match_unit/unit.dart';
import 'package:skygame_2d/models/match_unit/unit_team.dart';
import 'package:skygame_2d/scenes/managed_scene.dart';
import 'package:skygame_2d/utils.dart/constants.dart';
import 'package:skygame_2d/utils.dart/enums.dart';
import 'package:skygame_2d/utils.dart/extensions.dart';

class SceneManager {
  static List<ManagedScene> scenes = [];
}

class MenuItem extends SpriteComponent with SelectableSprite {
  // final Image? background;
  final int _index;
  final Sprite foreground;
  MenuItem({
    required int index,
    required this.foreground,
    required super.position,
    required super.size,
  })  : _index = index,
        super(sprite: foreground);

  @override
  int get index => _index;
}

class TeamBuilderScene extends ManagedScene {
  final int ownerID;
  late TeamBuilderBloc teamBuilderBloc;
  TeamBuilderScene(this.ownerID);
  @override
  Future<void> onLoad() async {
    teamBuilderBloc = TeamBuilderBloc(
        InitialTeamBuilderBlocState(game.playerBlocs.first.state.player));
    managedBloc = teamBuilderBloc;
    SceneManager.scenes.add(this);

    await addToScene(teamBuilderBlocListener());
    await addToScene(game.keyBlocListener(teamBuilderBloc));

    List<SelectableSprite> menuItemList = [];
    for (int i = 0; i < Units.all.length * 4; i++) {
      final menuItem = UnitTeamComponent(
        index: i,
        team: UnitTeam.random(i),
        size: Vector2(1200, 180),
      );
      menuItemList.add(menuItem);

      registerSceneComponent(menuItem);
    }

    await addToScene(ComponentGrid(
        children: menuItemList,
        scrollDirection: Axis.vertical,
        size: Vector2(Constants.SCREEN_WIDTH, Constants.SCREEN_HEIGHT),
        position: Vector2(0, 0),
        itemsPerSet: 1));

    final activeTeamComp = ActiveUnitTeamComponent(
      team: teamBuilderBloc.state.selectedUnits,
      size: Vector2(Constants.SCREEN_WIDTH, 300),
      position: Vector2(0, Constants.SCREEN_HEIGHT + 50),
    );
    await addToScene(activeTeamComp);

    await addToScene(UnitCollectionComponent(
      units: teamBuilderBloc.state.player.collection,
      size: Vector2(Constants.SCREEN_WIDTH,
          Constants.SCREEN_HEIGHT - 60 - activeTeamComp.size.y),
      position: Vector2(
          0,
          Constants.SCREEN_HEIGHT +
              50 +
              200 +
              50 +
              Constants.SCREEN_HEIGHT * 0.5),
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (teamBuilderBloc.state.viewState == TeamBuilderViewState.load) {
      // TODO: set Team options
      // TODO: set animations to move menu components into positions below
      teamBuilderBloc.initialise();
    } else if (teamBuilderBloc.state.viewState == TeamBuilderViewState.team) {
      final teamComp = sceneComponents
          .firstWhereOrNull((e) => e is ComponentGrid) as ComponentGrid?;
      teamComp?.position.y = 0.0;
    } else if (teamBuilderBloc.state.viewState ==
        TeamBuilderViewState.builder) {
      final teamComp = sceneComponents
          .firstWhereOrNull((e) => e is ComponentGrid) as ComponentGrid?;
      teamComp?.position.y = Constants.SCREEN_HEIGHT * 0.25 - teamComp.size.y;

      final activeTeamComp =
          sceneComponents.firstWhereOrNull((e) => e is ActiveUnitTeamComponent)
              as ActiveUnitTeamComponent?;
      activeTeamComp?.position.y =
          Constants.SCREEN_HEIGHT * 0.5 - activeTeamComp.size.y * 0.5;

      final collectionComp =
          sceneComponents.firstWhereOrNull((e) => e is UnitCollectionComponent)
              as UnitCollectionComponent?;
      collectionComp?.position.y = Constants.SCREEN_HEIGHT * 0.75;
    } else if (teamBuilderBloc.state.viewState ==
        TeamBuilderViewState.characterSelect) {
      final teamComp = sceneComponents
          .firstWhereOrNull((e) => e is ComponentGrid) as ComponentGrid?;
      teamComp?.position.y = -teamComp.size.y;

      final activeTeamComp =
          sceneComponents.firstWhereOrNull((e) => e is ActiveUnitTeamComponent)
              as ActiveUnitTeamComponent?;
      activeTeamComp?.position.y = 30.0;

      final collectionComp =
          sceneComponents.firstWhereOrNull((e) => e is UnitCollectionComponent)
              as UnitCollectionComponent?;
      collectionComp?.position.y = (activeTeamComp?.position.y ?? 0) +
          (activeTeamComp?.size.y ?? 0) +
          30.0;
    }
  }
}
