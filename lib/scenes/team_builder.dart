import 'dart:async';

import 'package:flame/components.dart';
import 'package:skygame_2d/bloc/key_input/listener.dart';
import 'package:skygame_2d/bloc/team_builder/bloc.dart';
import 'package:skygame_2d/bloc/team_builder/listener.dart';
import 'package:skygame_2d/bloc/team_builder/state.dart';
import 'package:skygame_2d/models/match_unit/unit.dart';
import 'package:skygame_2d/scenes/managed_scene.dart';
import 'package:skygame_2d/utils.dart/constants.dart';

class SceneManager {
  static List<ManagedScene> scenes = [];
}

class TeamBuilderScene extends ManagedScene {
  final int ownerID;
  late TeamBuilderBloc teamBuilderBloc;
  TeamBuilderScene(this.ownerID);
  @override
  FutureOr<void> onLoad() async {
    teamBuilderBloc = TeamBuilderBloc(
        InitialTeamBuilderBlocState(game.playerBlocs.first.state.player));
    managedBloc = teamBuilderBloc;
    SceneManager.scenes.add(this);

    await addToScene(teamBuilderBlocListener());
    await addToScene(game.keyBlocListener(teamBuilderBloc));

    for (int i = 0; i < Units.all.length; i++) {
      final yPos = (i ~/ Constants.TEAM_BUILDER_UNITS_PER_ROW) * 250 + 250;

      addToScene(SpriteComponent(
        size: Vector2(150, 250),
        position: Vector2(i % Constants.TEAM_BUILDER_UNITS_PER_ROW * 150 + 200,
            yPos.toDouble()),
        sprite: Sprite(Units.all[i].select),
      ));

      addToScene(SpriteComponent(
        size: Vector2(150, 250),
        position: Vector2(
            i % Constants.TEAM_BUILDER_UNITS_PER_ROW * 150 +
                200 +
                Constants.SCREEN_CENTER.x,
            yPos.toDouble()),
        sprite: Sprite(Units.all[i].select),
      ));
    }
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}
