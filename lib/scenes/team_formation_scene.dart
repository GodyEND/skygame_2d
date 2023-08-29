import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:skygame_2d/bloc/key_input/bloc.dart';
import 'package:skygame_2d/scenes/managed_scene.dart';
import 'package:skygame_2d/scenes/team_builder/team_builder.dart';

class TeamFormationScene extends ManagedScene {
  final int ownerID;
  // late TeamFormationBloc teamFormationBloc;
  final KeyInputBloc keyBloc;

  TeamFormationScene(
    this.ownerID, {
    required this.keyBloc,
    required super.position,
    required super.size,
  });

  @override
  Future<void> onLoad() async {
    final a = TextComponent(
      text: 'TEAM FORMATION',
      textRenderer:
          TextPaint(style: const TextStyle(color: Colors.white, fontSize: 128)),
      position: Vector2(size.x * 0.3, size.y * 0.45),
    );
    SceneManager.scenes.add(this);
    await addToScene(a);
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}
