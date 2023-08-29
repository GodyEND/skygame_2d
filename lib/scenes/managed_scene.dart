import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flame/components.dart';
import 'package:skygame_2d/main.dart';
import 'package:skygame_2d/scenes/team_builder/team_builder.dart';

/// NOTE: Do not forget to set managedBloc
abstract class ManagedScene extends PositionComponent
    with HasGameRef<SkyGame2D> {
  final List<Component> sceneComponents = [];
  BlocBase? managedBloc;
  ManagedScene({Vector2? position, Vector2? size})
      : super(position: position, size: size, anchor: Anchor.topLeft);

  Future<void> addToScene(Component component) async {
    sceneComponents.add(component);
    await add(component);
  }

  void registerSceneComponent(Component component) {
    sceneComponents.add(component);
  }

  Future<void> clearScene() async {
    for (var component in sceneComponents) {
      component.removeFromParent();
    }
    SceneManager.scenes.remove(this);
  }
}
