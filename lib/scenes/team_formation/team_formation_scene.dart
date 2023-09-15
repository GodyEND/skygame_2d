import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:skygame_2d/bloc/key_input/bloc.dart';
import 'package:skygame_2d/bloc/key_input/listener.dart';
import 'package:skygame_2d/bloc/player/bloc.dart';
import 'package:skygame_2d/graphics/formation_component.dart';
import 'package:skygame_2d/graphics/unit_team_active_component.dart';
import 'package:skygame_2d/models/match_unit/unit_team.dart';
import 'package:skygame_2d/scenes/managed_scene.dart';
import 'package:skygame_2d/scenes/team_builder/team_builder.dart';
import 'package:skygame_2d/scenes/team_formation/bloc/bloc.dart';
import 'package:skygame_2d/scenes/team_formation/bloc/listener.dart';
import 'package:skygame_2d/scenes/team_formation/bloc/state.dart';
import 'package:skygame_2d/utils.dart/constants.dart';
import 'package:skygame_2d/utils.dart/enums.dart';

class TeamFormationScene extends ManagedScene {
  final int ownerID;
  late TeamFormationBloc teamFormationBloc;
  final KeyInputBloc keyBloc;
  final PlayerBloc playerBloc;
  late ActiveUnitTeamComponent teamComp;
  late TextComponent waitingComponent;
  final List<FormationComponent> formationComponents = [];

  TeamFormationScene(
    this.ownerID, {
    required this.keyBloc,
    required this.playerBloc,
    required super.position,
    required super.size,
  });

  @override
  Future<void> onLoad() async {
    final playerBloc =
        game.playerBlocs.firstWhere((e) => e.state.player.ownerID == ownerID);
    final playerState = playerBloc.state;

    teamFormationBloc =
        TeamFormationBloc(InitialTeamFormationBlocState(playerState.player));
    managedBloc = teamFormationBloc;

    final options = playerBloc.state.player.activeTeam!
        .toList()
        .where((e) => e != null)
        .toList();
    final unitTeam =
        UnitTeam(playerBloc.state.player.activeTeam!.id, list: options);
    teamComp = ActiveUnitTeamComponent(
      team: unitTeam,
      size: Vector2(size.x, 300),
      position: Vector2(0.0, size.y * 0.65),
      ownerID: ownerID,
    );

    waitingComponent = TextComponent(
      text: 'Waiting...',
      textRenderer:
          TextPaint(style: const TextStyle(color: Colors.white, fontSize: 128)),
      position: Vector2(size.x * 0.3, size.y * 0.45),
    );

    SceneManager.scenes.add(this);
    final widthDiffPer = size.x / Constants.SCREEN_WIDTH;
    final aspect = Constants.images.formationBG!.size.x /
        Constants.images.formationBG!.size.y;
    await addToScene(
      ClipComponent(
          builder: (region) {
            return Rectangle.fromRect(Rect.fromLTWH(0, 0, size.x, size.y));
          },
          children: [
            SpriteComponent(
                sprite: Sprite(Constants.images.formationBG!,
                    srcPosition: Vector2(
                        (Constants.images.formationBG!.size.x -
                                Constants.images.formationBG!.size.x *
                                    widthDiffPer) *
                            0.5,
                        0.0),
                    srcSize: Vector2(
                        Constants.images.formationBG!.size.x * widthDiffPer,
                        Constants.images.formationBG!.size.y)),
                position: Vector2(
                    -(Constants.images.formationBG!.size.x -
                            Constants.images.formationBG!.size.x *
                                widthDiffPer) *
                        0.5,
                    0.0),
                size: Vector2(size.y * aspect, size.y)),
          ]),
    );

    await addToScene(teamFormationBlocListener());
    await addToScene(
        game.keyBlocListener(keyBloc, playerBloc, teamFormationBloc));
    keyBloc.add(UpdatedFormationInputsEvent());

    await addToScene(teamComp);

    for (int i = 0; i < 5; i++) {
      final formationComponent = FormationComponent(
        index: i,
        ownerID: ownerID,
        size: Vector2(size.x * 0.15, size.x * 0.15),
        position: formationPosition(size)[i],
        selectedIndex: 0,
        unit: teamFormationBloc.state.formation[i],
      );
      formationComponents.add(formationComponent);
      await addToScene(formationComponent);
    }
    await addToScene(waitingComponent);
  }

  @override
  void update(double dt) async {
    super.update(dt);
    if (teamFormationBloc.state.viewState == TeamFormationViewState.load) {
      // TODO: set animations to move menu components into positions below
      teamFormationBloc.initialise();
    }
    if (teamFormationBloc.state.viewState == TeamFormationViewState.wait &&
        !children.contains(waitingComponent)) {
      await addToScene(waitingComponent);
    } else if (children.contains(waitingComponent) &&
        teamFormationBloc.state.viewState != TeamFormationViewState.wait) {
      waitingComponent.removeFromParent();
      sceneComponents.remove(waitingComponent);
    }
  }

  Map<int, Vector2> formationPosition(Vector2 size) {
    return {
      0: Vector2(size.x * 0.5 - 0.075 * size.x, size.y * 0.15),
      1: Vector2(size.x * 0.25 - 0.075 * size.x, size.y * 0.3),
      2: Vector2(size.x * 0.75 - 0.075 * size.x, size.y * 0.3),
      3: Vector2(size.x * 0.375 - 0.075 * size.x, size.y * 0.45),
      4: Vector2(size.x * 0.625 - 0.075 * size.x, size.y * 0.45),
    };
  }
}
