import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:skygame_2d/bloc/key_input/listener.dart';
import 'package:skygame_2d/bloc/team_builder/bloc.dart';
import 'package:skygame_2d/bloc/team_builder/listener.dart';
import 'package:skygame_2d/bloc/team_builder/state.dart';
import 'package:skygame_2d/models/components/selectable.dart';
import 'package:skygame_2d/models/match_unit/unit.dart';
import 'package:skygame_2d/scenes/managed_scene.dart';
import 'package:skygame_2d/utils.dart/constants.dart';

class SceneManager {
  static List<ManagedScene> scenes = [];
}

class MenuItem extends SpriteComponent with SelectableSprite {
  // final Image? background;
  final Sprite foreground;
  MenuItem({
    required this.foreground,
    required super.position,
    required super.size,
  }) : super(sprite: foreground);
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
      final item = MenuItem(
          foreground: Sprite(Units.all[i].select),
          position: Vector2(
              i % Constants.TEAM_BUILDER_UNITS_PER_ROW * 150 + 200,
              yPos.toDouble()),
          size: Vector2(150, 250));
      if (i == 0 || i == 4) {
        item.isSelected = true;
        if (i == 4) {
          item.isSelectable = false;
        }
      } else if (i > 2) {
        item.isSelectable = false;
      }
      addToScene(item);

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
