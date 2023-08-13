import 'dart:async';

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
import 'package:skygame_2d/game/skygame_ext/key_input_ext.dart';
import 'package:skygame_2d/models/player.dart';
import 'package:skygame_2d/utils.dart/enums.dart';
import 'package:skygame_2d/models/fx.dart';
import 'package:skygame_2d/models/match_unit/unit.dart';
import 'package:skygame_2d/models/release.dart';
import 'package:skygame_2d/setup.dart';
import 'package:skygame_2d/utils.dart/constants.dart';
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
  late KeyInputBloc keyBloc;

  SkyGame2D({Camera? camera}) : super(camera: camera);

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
        for (var playerBloc in playerBlocs) {
          handledEvents.add(teamBuilderInput(
            event,
            keysPressed,
            playerBloc.state.player.ownerID,
          ));
        }

        if (handledEvents.contains(true)) {
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;

      default:
        break;
    }
    return KeyEventResult.ignored;
  }

  Future<void> _setupBlocProviders() async {
    List<FlameBlocProvider> playerBlocProviders = [];
    List<PlayerBlocState> playerBlocStates = [];
    // List<KeyInputBlocState> playerKeyInputStates = [];
    for (int i = 1; i <= Constants.PLAYER_COUNT; i++) {
      final playerState = InitialPlayerBlocState(
          Player(i, teams: const [], collection: Units.all));
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
    }
    bloc = GameBloc(InitialGameBlocState(playerBlocStates));
    keyBloc = KeyInputBloc(InitialKeyInputBlocState(
      ownerID: Constants.FIRST_PLAYER,
      sceneState: SceneState.load,
      sceneBloc: null,
      rowLength: 1,
      options: Units.all.length * 4,
    ));

    await add(FlameMultiBlocProvider(providers: [
      FlameBlocProvider(create: () => bloc),
      ...playerBlocProviders,
      FlameBlocProvider(create: () => keyBloc),
    ]));

    for (var playerBloc in playerBlocs) {
      await add(playerBlocListener(playerBloc));
    }
    await add(gameBlocListener());
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (bloc.state.sceneState == SceneState.load) {
      bloc.add(GameSceneChangeEvent(scene: SceneState.load));
    }
  }
}
