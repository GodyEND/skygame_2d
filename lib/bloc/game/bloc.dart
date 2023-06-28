import 'package:bloc/bloc.dart';
import 'package:skygame_2d/bloc/events.dart';
import 'package:skygame_2d/bloc/game/state.dart';
import 'package:skygame_2d/utils.dart/enums.dart';

class GameBloc extends Bloc<BlocEvent, GameBlocState> {
  GameBloc(GameBlocState initialState) : super(initialState) {
    on<PlayerTeamReadyEvent>((event, emit) {
      bool playersReady = true;
      for (var playerState in state.playerStates) {
        if (playerState.state != PlayerState.ready) {
          playersReady = false;
          break;
        }
      }
      if (playersReady) {
        emit(state.copyWith(cSceneState: SceneState.combat));
      }
    });
    on<CombatTurnEnd>((event, emit) => emit(
        state.copyWith(cSceneState: state.sceneState, cTurn: state.turn + 1)));
    on<GameSceneChangeEvent>((event, emit) =>
        emit(state.copyWith(event: event, cSceneState: event.scene)));
    on<GameSceneChangeCompleteEvent>((event, emit) {
      print('Scene setup complete');
      emit(state.copyWith(event: event));
    });
  }
}
