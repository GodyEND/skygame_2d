import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:skygame_2d/bloc/key_input/bloc.dart';
import 'package:skygame_2d/bloc/key_input/listener.dart';
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
}

class TeamBuilderScene extends ManagedScene {
  final int ownerID;
  late TeamBuilderBloc teamBuilderBloc;
  final KeyInputBloc keyBloc;

  late TeamsCollectionComponent teamsCollComp;
  late ActiveUnitTeamComponent activeTeamComp;
  final UnitCollectionComponent collectionComp = UnitCollectionComponent(
    units: [],
    size: Vector2(Constants.SCREEN_WIDTH, Constants.SCREEN_HEIGHT - 60 - 300),
    position: Vector2(
        0,
        Constants.SCREEN_HEIGHT +
            50 +
            200 +
            50 +
            Constants.SCREEN_HEIGHT * 0.5),
  );
  late TextComponent waitingComponent;

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
    activeTeamComp = ActiveUnitTeamComponent(
        team: UnitTeam(-1), size: Vector2(size.x, 300), ownerID: ownerID);
    managedBloc = teamBuilderBloc;
    waitingComponent = TextComponent(
      text: 'Waiting...',
      textRenderer:
          TextPaint(style: const TextStyle(color: Colors.white, fontSize: 128)),
      position: Vector2(size.x * 0.3, size.y * 0.45),
    );
    SceneManager.scenes.add(this);

    await addToScene(teamBuilderBlocListener());
    await addToScene(
        game.keyBlocListener(keyBloc, playerBloc, teamBuilderBloc));

    teamsCollComp = TeamsCollectionComponent(
      teams: teamBuilderBloc.state.teams,
      ownerID: ownerID,
    );
    for (var comp in teamsCollComp.menuItemList) {
      registerSceneComponent(comp);
    }
    await addToScene(teamsCollComp);
    await addToScene(activeTeamComp);
    activeTeamComp.selectableChildren.first.isHovered = true;
    collectionComp.size = Vector2(size.x, size.y * 0.5);
    await addToScene(collectionComp);
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
      teamsCollComp.position.y = 0.0;
    } else if (teamBuilderBloc.state.viewState ==
        TeamBuilderViewState.builder) {
      teamsCollComp.position.y = Constants.SCREEN_HEIGHT * 0.25 -
          180 * teamsCollComp.menuItemList.length;
      activeTeamComp.position.y =
          Constants.SCREEN_HEIGHT * 0.5 - activeTeamComp.size.y * 0.5;
      collectionComp.position.y = Constants.SCREEN_HEIGHT * 0.75;
    } else if (teamBuilderBloc.state.viewState ==
        TeamBuilderViewState.characterSelect) {
      activeTeamComp.position.y = 30.0;
      collectionComp.position.y =
          (activeTeamComp.position.y) + (activeTeamComp.size.y) + 30.0;
    }

    // MARK: Hide elements
    if (!teamsCollComp.isVisible) {
      teamsCollComp.position.y = -teamsCollComp.size.y;
    }
    if (!activeTeamComp.isVisible) {
      activeTeamComp.position.y = -activeTeamComp.size.y;
    }
    if (!collectionComp.isVisible) {
      collectionComp.position.y = -collectionComp.size.y;
    }
    if (teamBuilderBloc.state.viewState == TeamBuilderViewState.wait &&
        !children.contains(waitingComponent)) {
      await addToScene(waitingComponent);
    } else if (children.contains(waitingComponent) &&
        teamBuilderBloc.state.viewState != TeamBuilderViewState.wait) {
      waitingComponent.removeFromParent();
      sceneComponents.remove(waitingComponent);
    }
  }
}
