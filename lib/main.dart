import 'dart:async';
import 'dart:math';

import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skygame_2d/bloc/events.dart';
import 'package:skygame_2d/bloc/game/bloc.dart';
import 'package:skygame_2d/bloc/game/listener.dart';
import 'package:skygame_2d/bloc/game/state.dart';
import 'package:skygame_2d/bloc/key_input/bloc.dart';
import 'package:skygame_2d/bloc/key_input/state.dart';
import 'package:skygame_2d/bloc/player/bloc.dart';
import 'package:skygame_2d/bloc/player/listener.dart';
import 'package:skygame_2d/bloc/player/state.dart';
import 'package:skygame_2d/game_ext/key_input_ext.dart';
import 'package:skygame_2d/game_ext/scene_setup_ext.dart';
import 'package:skygame_2d/models/fx.dart';
import 'package:skygame_2d/models/match_unit/unit.dart';
import 'package:skygame_2d/models/match_unit/unit_team.dart';
import 'package:skygame_2d/models/player.dart';
import 'package:skygame_2d/models/release.dart';
import 'package:skygame_2d/setup.dart';
import 'package:skygame_2d/utils.dart/constants.dart';
import 'package:skygame_2d/utils.dart/enums.dart';
import 'package:skygame_2d/utils.dart/shader_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final camera = Camera();
  camera.viewport = FixedResolutionViewport(
      Vector2(Constants.SCREEN_WIDTH, Constants.SCREEN_HEIGHT));
  await Constants.images.init();
  await ShaderManager.loadShaders();
  runApp(GameWidget(game: SkyGame2D(camera: camera)));
}

class SkyGame2D extends FlameGame with KeyboardEvents {
  List<PlayerBloc> playerBlocs = [];
  late GameBloc bloc;

  SkyGame2D({Camera? camera}) : super(oldCamera: camera);

  @override
  bool get debugMode => true;

  @override
  Future<void> onLoad() async {
    await _loadGameData();
    await _setupBlocProviders();
  }

  Future<bool> _loadGameData() async {
    try {
      await Sprites.loadImages();
      Releases.load;
      FXs.load;
      Units.load;
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  KeyEventResult onKeyEvent(
      RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final List<bool> handledEvents = [];
    switch (bloc.state.sceneState) {
      case SceneState.teamBuilder:
      case SceneState.teamFormation:
        for (var playerBloc in playerBlocs) {
          handledEvents.add(menuInput(
            event,
            keysPressed,
            playerBloc.state.player.ownerID,
          ));
        }
      default:
        break;
    }

    if (handledEvents.contains(true)) {
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  Future<void> _setupBlocProviders() async {
    List<FlameBlocProvider> playerBlocProviders = [];
    List<FlameBlocProvider> playerKeyInputBlocProviders = [];
    List<PlayerBlocState> playerBlocStates = [];
    // List<KeyInputBlocState> playerKeyInputStates = [];

    for (int i = 1; i <= Constants.PLAYER_COUNT; i++) {
      final teams = <UnitTeam>[];
      for (int i = 0; i < Random().nextInt(10) + 1; i++) {
        teams.add(UnitTeam.random(i + 1));
      }

      final keyBloc = KeyInputBloc(InitialKeyInputBlocState(
        ownerID: i,
        sceneState: SceneState.load,
        sceneBloc: null,
        rowLength: 1,
        options: teams.length,
      ));
      final playerState = InitialPlayerBlocState(
        Player(
          i,
          teams: teams,
          collection: Units.all,
          formation: const [],
          matchFormation: const [],
          matchReserve: const [],
        ),
        keyBloc: keyBloc,
      );
      final playerBloc = PlayerBloc(playerState);
      playerBlocs.add(playerBloc);
      playerBlocStates.add(playerState);
      // playerKeyInputStates.add(InitialKeyInputBlocState(

      //   sceneState: SceneState.load,
      //   sceneBloc: null,
      //   rowLength: Constants.TEAM_BUILDER_UNITS_PER_ROW,
      //   options: Units.all.length,
      // ));

      playerBlocProviders.add(FlameBlocProvider(create: () => playerBloc));
      playerKeyInputBlocProviders.add(FlameBlocProvider(create: () => keyBloc));
    }
    bloc = GameBloc(InitialGameBlocState(playerBlocStates));

    await add(FlameMultiBlocProvider(providers: [
      FlameBlocProvider(create: () => bloc),
      ...playerBlocProviders,
      ...playerKeyInputBlocProviders,
    ]));

    for (var playerBloc in playerBlocs) {
      await add(playerBlocListener(playerBloc));
    }
    await add(gameBlocListener());
  }

  @override
  void update(double dt) {
    super.update(dt);
    switch (bloc.state.sceneState) {
      case SceneState.load:
        bloc.add(GameSceneChangeEvent(scene: SceneState.load));
        break;
      case SceneState.teamBuilder:
        if (validateTeamBuilderPlayersReady()) {
          bloc.add(GameSceneChangeEvent(scene: SceneState.teamFormation));
        }
        break;
      case SceneState.teamFormation:
        if (validateFormationPlayersReady()) {
          bloc.add(GameSceneChangeEvent(scene: SceneState.combat));
        }
        break;
      case SceneState.combat:
        break;
      default:
        break;
    }
  }
}
