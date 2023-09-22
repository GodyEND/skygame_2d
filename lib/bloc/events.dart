import 'package:skygame_2d/utils.dart/enums.dart';

abstract class BlocEvent {}

class EmptyEvent extends BlocEvent {}

class ClearEvent extends BlocEvent {}

class PlayerTeamReadyEvent extends BlocEvent {}

class GameSceneChangeEvent extends BlocEvent {
  final SceneState scene;
  GameSceneChangeEvent({required this.scene});
}

class GameSceneChangeCompleteEvent extends BlocEvent {
  final SceneState? nextScene;
  GameSceneChangeCompleteEvent({this.nextScene});
}
