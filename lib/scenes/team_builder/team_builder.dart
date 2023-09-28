import 'package:flame/components.dart';
import 'package:flame/layout.dart';
import 'package:flutter/material.dart';
import 'package:skygame_2d/bloc/key_input/bloc.dart';
import 'package:skygame_2d/bloc/key_input/listener.dart';
import 'package:skygame_2d/main.dart';
import 'package:skygame_2d/scenes/team_builder/bloc/bloc.dart';
import 'package:skygame_2d/scenes/team_builder/bloc/listener.dart';
import 'package:skygame_2d/scenes/team_builder/bloc/state.dart';
import 'package:skygame_2d/graphics/teams_collection.dart';
import 'package:skygame_2d/graphics/unit_collection.dart';
import 'package:skygame_2d/graphics/unit_team_active_component.dart';
import 'package:skygame_2d/models/match_unit/unit_team.dart';
import 'package:skygame_2d/scenes/managed_scene.dart';
import 'package:skygame_2d/utils.dart/constants.dart';
import 'package:skygame_2d/utils.dart/enums.dart';

class SceneManager {
  static List<ManagedScene> scenes = [];
  static SkyGame2D get game => scenes.firstWhere((e) => e.isMounted).game;
}

class VisibleWrapperComponent extends PositionComponent with HasVisibility {
  VisibleWrapperComponent({required Component child, ComponentKey? key})
      : super(
          children: [child],
          key: key,
        ) {
    isVisible = false;
  }
}

enum TBComponentKeys {
  teams,
  active,
  collection,
  waiting;

  String asKey(int ownerID) {
    return 'tb_${name}_$ownerID';
  }
}

class TeamBuilderScene extends ManagedScene {
  final int ownerID;
  late TeamBuilderBloc teamBuilderBloc;
  final KeyInputBloc keyBloc;

  TeamBuilderScene(
    this.ownerID, {
    required this.keyBloc,
    required super.position,
    required super.size,
  });
  @override
  Future<void> onLoad() async {
    final playerBloc =
        game.playerBlocs.firstWhere((e) => e.state.player.ownerID == ownerID);
    final playerState = playerBloc.state;
    teamBuilderBloc =
        TeamBuilderBloc(InitialTeamBuilderBlocState(playerState.player));

    managedBloc = teamBuilderBloc;

    SceneManager.scenes.add(this);

    await addToScene(teamBuilderBlocListener());
    await addToScene(
        game.keyBlocListener(keyBloc, playerBloc, teamBuilderBloc));

    await addToScene(ActiveUnitTeamComponent(
        key: ComponentKey.named(TBComponentKeys.active.asKey(ownerID)),
        team: UnitTeam(-1),
        size: Vector2(size.x, 300),
        ownerID: ownerID));

    await addToScene(TeamsCollectionComponent(
      key: ComponentKey.named(TBComponentKeys.teams.asKey(ownerID)),
      teams: teamBuilderBloc.state.teams,
      ownerID: ownerID,
    ));
    for (var comp in game
            .findByKey<TeamsCollectionComponent>(
                ComponentKey.named(TBComponentKeys.teams.asKey(ownerID)))
            ?.menuItemList ??
        []) {
      registerSceneComponent(comp);
    }
    await addToScene(UnitCollectionComponent(
      key: ComponentKey.named(TBComponentKeys.collection.asKey(ownerID)),
      units: [],
      size: Vector2(Constants.SCREEN_WIDTH, Constants.SCREEN_HEIGHT - 60 - 300),
      position: Vector2(
          0,
          Constants.SCREEN_HEIGHT +
              50 +
              200 +
              50 +
              Constants.SCREEN_HEIGHT * 0.5),
    )..size = Vector2(size.x, size.y * 0.5));
    await addToScene(AlignComponent(
        child: VisibleWrapperComponent(
          key: ComponentKey.named(TBComponentKeys.waiting.asKey(ownerID)),
          child: TextComponent(
            text: 'Waiting...',
            textRenderer: TextPaint(
                style: const TextStyle(color: Colors.white, fontSize: 128)),
            anchor: Anchor.center,
          ),
        ),
        alignment: Anchor.center)
      ..position.y += 100);
  }

  @override
  void onRemove() async {
    // TODO: implement onRemove
    super.onRemove();
    await clearScene();
  }

  @override
  void update(double dt) async {
    super.update(dt);

    if (teamBuilderBloc.state.viewState == TeamBuilderViewState.load) {
      // TODO: set animations to move menu components into positions below
      teamBuilderBloc.initialise();
    } else if (teamBuilderBloc.state.viewState == TeamBuilderViewState.team) {
      game
          .findByKey<TeamsCollectionComponent>(
              ComponentKey.named(TBComponentKeys.teams.asKey(ownerID)))
          ?.position
          .y = 0.0;
    } else if (teamBuilderBloc.state.viewState ==
        TeamBuilderViewState.builder) {
      final teamComp = game.findByKey<TeamsCollectionComponent>(
          ComponentKey.named(TBComponentKeys.teams.asKey(ownerID)));
      teamComp?.position.y =
          Constants.SCREEN_HEIGHT * 0.25 - 180 * teamComp.menuItemList.length;
      final activeComp = game.findByKey<ActiveUnitTeamComponent>(
          ComponentKey.named(TBComponentKeys.active.asKey(ownerID)));
      activeComp?.position.y =
          Constants.SCREEN_HEIGHT * 0.5 - activeComp.size.y * 0.5;
      final collectionComp = game.findByKey<UnitCollectionComponent>(
          ComponentKey.named(TBComponentKeys.collection.asKey(ownerID)));
      collectionComp?.position.y = Constants.SCREEN_HEIGHT * 0.75;
    } else if (teamBuilderBloc.state.viewState ==
        TeamBuilderViewState.characterSelect) {
      final activeComp = game.findByKey<ActiveUnitTeamComponent>(
          ComponentKey.named(TBComponentKeys.active.asKey(ownerID)));
      final collectionComp = game.findByKey<UnitCollectionComponent>(
          ComponentKey.named(TBComponentKeys.collection.asKey(ownerID)));
      activeComp?.position.y = 30.0;
      collectionComp?.position.y =
          (activeComp?.position.y ?? 0.0) + (activeComp?.size.y ?? 0.0) + 30.0;
    }
  }
}
