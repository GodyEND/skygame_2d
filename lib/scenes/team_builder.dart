import 'package:flame/components.dart';
import 'package:skygame_2d/bloc/key_input/listener.dart';
import 'package:skygame_2d/bloc/team_builder/bloc.dart';
import 'package:skygame_2d/bloc/team_builder/listener.dart';
import 'package:skygame_2d/bloc/team_builder/state.dart';
import 'package:skygame_2d/graphics/teams_collection.dart';
import 'package:skygame_2d/graphics/unit_collection.dart';
import 'package:skygame_2d/graphics/unit_team_active_component.dart';
import 'package:skygame_2d/models/components/selectable.dart';
import 'package:skygame_2d/models/match_unit/unit_team.dart';
import 'package:skygame_2d/scenes/managed_scene.dart';
import 'package:skygame_2d/utils.dart/constants.dart';
import 'package:skygame_2d/utils.dart/enums.dart';

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

  late TeamsCollectionComponent teamsCollComp;
  final ActiveUnitTeamComponent activeTeamComp = ActiveUnitTeamComponent(
      team: UnitTeam(-1), size: Vector2(Constants.SCREEN_WIDTH, 300));
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

  TeamBuilderScene(this.ownerID);
  @override
  Future<void> onLoad() async {
    teamBuilderBloc = TeamBuilderBloc(
        InitialTeamBuilderBlocState(game.playerBlocs.first.state.player));
    managedBloc = teamBuilderBloc;
    SceneManager.scenes.add(this);

    await addToScene(teamBuilderBlocListener());
    await addToScene(game.keyBlocListener(teamBuilderBloc));

    teamsCollComp = TeamsCollectionComponent(
      teams: teamBuilderBloc.state.teams,
      position: Vector2.all(0.0),
    );
    for (var comp in teamsCollComp.menuItemList) {
      registerSceneComponent(comp);
    }
    await addToScene(teamsCollComp);

    activeTeamComp.team = teamBuilderBloc.state.selectedUnits;
    await addToScene(activeTeamComp);

    collectionComp.units = teamBuilderBloc.state.player.collection;
    await addToScene(collectionComp);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (teamBuilderBloc.state.viewState == TeamBuilderViewState.load) {
      // TODO: set Team options
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
  }
}
