import 'package:bloc/bloc.dart';
import 'package:skygame_2d/bloc/events.dart';
import 'package:skygame_2d/bloc/game/state.dart';

class GameBloc extends Bloc<BlocEvent, GameBlocState> {
  GameBloc(GameBlocState initialState) : super(initialState) {
    on<GameSceneChangeEvent>((event, emit) =>
        emit(state.copyWith(event: event, cSceneState: event.scene)));
    on<GameSceneChangeCompleteEvent>((event, emit) {
      emit(state.copyWith(event: event));
    });
  }
}
