import 'package:bloc/bloc.dart';
import 'package:skygame_2d/bloc/combat/events.dart';
import 'package:skygame_2d/bloc/combat/state.dart';
import 'package:skygame_2d/bloc/events.dart';

class CombatBloc extends Bloc<BlocEvent, CombatBlocState> {
  CombatBloc({required CombatBlocState initialState}) : super(initialState) {
    on<UpdateExeQEvent>((event, emit) {
      emit(state.copyWith(cExeQ: event.exeQ));
    });
  }
}
